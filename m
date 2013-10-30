Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3J3VlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:41:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59941 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3J3VlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:41:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20131029220939.GA23060@kroah.com>
	<8761sflhi1.fsf@tw-ebiederman.twitter.com>
	<CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
	<87sivj9vi0.fsf@xmission.com> <20131030132831.GB27632@htj.dyndns.org>
Date: Wed, 30 Oct 2013 14:41:16 -0700
In-Reply-To: <20131030132831.GB27632@htj.dyndns.org> (Tejun Heo's message of
	"Wed, 30 Oct 2013 09:28:31 -0400")
Message-ID: <8738ni308z.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/COmFCvdhunvOitpJkOpFnE0/t8fpJf+M=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1458]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysfs: move assignment to be under lock in sysfs_remove_dir()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Tue, Oct 29, 2013 at 10:29:43PM -0700, Eric W. Biederman wrote:
>> I never actually looked deeply into it, and I was working from several
>> year old memory and a quick skim of the patch when I asked the question.
>> 
>> The protection we have previous to this patch is that syfs_remove_dir is
>> only sane to call once.
>> 
>> Which makes the code that does:
>> 	if (!dir_sd)
>>         	return;
>> in __sysfs_remove_dir very suspicious.   I expect we want a
>> WARN_ON(!dir_sd);
>
> It was always like that, probably in the same spirit as kfree() taking
> NULL so that it can be easier, for example, in init failure paths.

Which given that we are talking about sysfs either means that no one is
taking advantage of this case or there is some totally broken usage
created by accident and that we aren't warning about.

>> But the entire directory removal process and working on sysfs stopped
>> being fun before I managed to get that cleaned up.  And unless I missed
>> something go by Tejun is going to go generalize this thing before this
>> bit gets cleaned up.  Sigh.
>
> I kept the same behavior for kernfs_remove().  I don't think it's
> something we explicitly want to clean up tho?  It's an acceptable
> behavior.

It has been a long time since I looked but there are or at least were
problematic cases last time I looked.

The pci hotplug layer removes or removed kobjects from sysfs in the
wrong order with parent directories disappearing before their children.

There were leaks in this area.

I fixed the worst of it and everything I had energy to fix when I was
working on sysfs.  But it is a real problem.

One of the particularly problematic things that can happen with sysfs is
that we can get a hotplug event in userspace and then examine sysfs and
not find the attributes of the device because the kernel has not added
them yet.

Which is a particularly good reason to have a campaign against
independent usage of device_create_file and device_remove_file in the
device users.

At which point really the right thing to do when we delete a directory
is to WARN and be very grumpy if there are any attributes in the
directory we were removing.

Being nice here has resulted in buggy semantics exported to userspace,
and buggy kernel code being written.  In a generalized version of sysfs
we don't want to be nice to avoid the existing mess that sysfs sees.

>> On an equally bizarre note.  I don't understand why we have a separate
>> spinlock there.  Looks...  Sigh.  We use a different lock from
>> everything as a premature optimization so that sysfs_remove_dir could be
>> modified to just take a sysfs_dirent, and all of the kobject handling
>> could be removed.
>> 
>> Sigh. It was never in my way and while I was working on the code that
>> there was a good locking reason for doing that silly thing.
>
> Umm... you got it completely wrong.  It's there to address a race
> condition between removal and symlinking and has nothing to do with
> optimization.

No.  It totally is a premature optimization.  There is no reason to add
another lock to sysfs and make understanding of what locks are needed
sto protect data structures something that needs to be thought about.
sysfs_mutex can easily be expanded to cover this role, and in fact all
cases where we take sysfs_assoc_lock today just a few lines later we
take sysfs_mutex.

Furthermore explicitly you state in your original commit when
sysfs_assoc_lock was added that it was to aid in the separation of
kobjects and sysfs dirents.

commit aecdcedaab49ca40620dc7dd70f67ee7269a66c9
Author: Tejun Heo <htejun@gmail.com>
Date:   Thu Jun 14 03:45:15 2007 +0900

    sysfs: implement kobj_sysfs_assoc_lock
    
    kobj->dentry can go away anytime unless the user controls when the
    associated sysfs node is deleted.  This patch implements
    kobj_sysfs_assoc_lock which protects kobj->dentry.  This will be used
    to maintain kobj based API when converting sysfs to use sysfs_dirent
    tree instead of dentry/kobject.
    
    Note that this lock belongs to kobject/driver-model not sysfs.  Once
    sysfs is converted to not use kobject in its interface, this can be
    removed from sysfs.
    
    This is in preparation of object reference simplification.
    
    Signed-off-by: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

> The current odd looking locking on removal side serves a purpose in
> making it clear that it isn't synchronizing concurrent removal calls.

At the moment the only reason concurrent calls are not properly
synchronized is because the read is outside of the lock.

If you want to avoid concurrent calls WARN_ON(!kobject->sd) is a much
better approach.

But syfs_mutex a few lines later does synchronize concurrent removal
calls, and sysfs_assoc_lock

Which given how sysfs is used is really insane. If we don't support
something we need to warn about it, not 

> Maybe we should rename the lock to sysfs_symlink_target_lock and add
> fat comments on both sides?  Or we can make it a mutex and exclude the
> entire removal and symlinking, which would probably easier to follow.

Agreed.  A mutex to excluse the entire removal and symlinking does sound
easier to follow.  Why don't we call that mutex sysfs_mutex?

Eric

