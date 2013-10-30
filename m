Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3J3WAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:00:16 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48453 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3J3WAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:00:13 -0400
Date: Wed, 30 Oct 2013 18:00:04 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: move assignment to be under lock in
 sysfs_remove_dir()
Message-ID: <20131030220004.GC26375@mtj.dyndns.org>
References: <20131029220939.GA23060@kroah.com>
 <8761sflhi1.fsf@tw-ebiederman.twitter.com>
 <CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
 <87sivj9vi0.fsf@xmission.com>
 <20131030132831.GB27632@htj.dyndns.org>
 <8738ni308z.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738ni308z.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Eric.

On Wed, Oct 30, 2013 at 02:41:16PM -0700, Eric W. Biederman wrote:
> Being nice here has resulted in buggy semantics exported to userspace,
> and buggy kernel code being written.  In a generalized version of sysfs
> we don't want to be nice to avoid the existing mess that sysfs sees.

Hmm... given that the generalized version always does recursive
deletion, I don't think the problem you described is too relevant.  It
really is something which can be either way.  Given that other
interfaces including sysfs_put() allow for NULL input, I think
flipping the behavior is likely more churn than worthwhile.

> Which given how sysfs is used is really insane. If we don't support
> something we need to warn about it, not 

Add the warning then?  Given that sysfs_remove() ends up putting the
base reference, it's something ultimately pointless tho.

> > Maybe we should rename the lock to sysfs_symlink_target_lock and add
> > fat comments on both sides?  Or we can make it a mutex and exclude the
> > entire removal and symlinking, which would probably easier to follow.
> 
> Agreed.  A mutex to excluse the entire removal and symlinking does sound
> easier to follow.  Why don't we call that mutex sysfs_mutex?

Well, we can merge any locking but that's likely to lead to some ugly
code.  sysfs core has always been somewhat isolated from kobject
integration and what you're suggesting would violate such isolation.
With the pending sysfs core separation, I don't think it's gonna work
at all.  kobj->sd association is something which is specific to kobj
<-> sysfs interaction.  If you wanna make behavior in that layer more
strictly synchronized, please go ahead but let's please not mix the
two layers.

Thanks.

-- 
tejun
