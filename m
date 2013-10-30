Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab3J3N2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:28:37 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58696 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3J3N2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:28:35 -0400
Date: Wed, 30 Oct 2013 09:28:31 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: move assignment to be under lock in
 sysfs_remove_dir()
Message-ID: <20131030132831.GB27632@htj.dyndns.org>
References: <20131029220939.GA23060@kroah.com>
 <8761sflhi1.fsf@tw-ebiederman.twitter.com>
 <CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
 <87sivj9vi0.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sivj9vi0.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 29, 2013 at 10:29:43PM -0700, Eric W. Biederman wrote:
> I never actually looked deeply into it, and I was working from several
> year old memory and a quick skim of the patch when I asked the question.
> 
> The protection we have previous to this patch is that syfs_remove_dir is
> only sane to call once.
> 
> Which makes the code that does:
> 	if (!dir_sd)
>         	return;
> in __sysfs_remove_dir very suspicious.   I expect we want a
> WARN_ON(!dir_sd);

It was always like that, probably in the same spirit as kfree() taking
NULL so that it can be easier, for example, in init failure paths.

> But the entire directory removal process and working on sysfs stopped
> being fun before I managed to get that cleaned up.  And unless I missed
> something go by Tejun is going to go generalize this thing before this
> bit gets cleaned up.  Sigh.

I kept the same behavior for kernfs_remove().  I don't think it's
something we explicitly want to clean up tho?  It's an acceptable
behavior.

> On an equally bizarre note.  I don't understand why we have a separate
> spinlock there.  Looks...  Sigh.  We use a different lock from
> everything as a premature optimization so that sysfs_remove_dir could be
> modified to just take a sysfs_dirent, and all of the kobject handling
> could be removed.
> 
> Sigh. It was never in my way and while I was working on the code that
> there was a good locking reason for doing that silly thing.

Umm... you got it completely wrong.  It's there to address a race
condition between removal and symlinking and has nothing to do with
optimization.

The current odd looking locking on removal side serves a purpose in
making it clear that it isn't synchronizing concurrent removal calls.
Maybe we should rename the lock to sysfs_symlink_target_lock and add
fat comments on both sides?  Or we can make it a mutex and exclude the
entire removal and symlinking, which would probably easier to follow.

Thanks.

-- 
tejun
