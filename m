Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3I0Nta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:49:30 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:63899 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3I0Nt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:49:28 -0400
Date: Fri, 27 Sep 2013 09:49:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, kay@vrfy.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] sysfs: implement sysfs_remove()
Message-ID: <20130927134924.GC3205@htj.dyndns.org>
References: <1379538938-5032-1-git-send-email-tj@kernel.org>
 <87pps5dr3f.fsf@tw-ebiederman.twitter.com>
 <20130919123812.GA4467@mtj.dyndns.org>
 <87six0922b.fsf@tw-ebiederman.twitter.com>
 <20130926234433.GA12549@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926234433.GA12549@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Sep 26, 2013 at 04:44:33PM -0700, Greg KH wrote:
> I seem to remember some issues here as well, probably with scsi devices,
> that kept us from doing this in this manner.  Can you test this on
> removing some scsi devices and see if everything still works properly
> with this patchset applied?

>From kobject side, it shouldn't really change as kobj holds an extra
ref on the associated sysfs_dirent.  While sysfs_dirents are
recursively unlinked, they'll still be there until the associated kobj
is released.  And, yeap, SCSI works fine.

> I'm really hesitant to apply this series, as it does change how sysfs
> works in this area, why do you need these changes?

Because the interface we now have is broken and I don't want spread
that to new users.  Our current semantics is somewhere between "rmdir"
and "rm -rf".  We remove files immediately below a directory but don't
recurse.

I think this was designed this way because of the tight coupling with
kobj.  As a directory always used to be represented by a kobj and a
kobj's lifetime is managed separately, chaining directory removal to
kobj lifetime was good enough; however, please note that this is no
longer true with the sysfs group, so now sysfs is in a weird place
where it doesn't require attribute removals right below the kobj
directory but does require group removals.  Even that is inconsistent
as group can be embedded in the parent kobj directory, and I'm
relatively sure we're already leaking sysfs_dirents by forgetting
group removals in some paths.

It's a broken interface and even for the existing users we should be
able to remove most of group group removal invocation afterwards,
which is a silly and error-prone requirement.

Thanks.

-- 
tejun
