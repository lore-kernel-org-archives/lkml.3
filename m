Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbaDIJCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:02:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34056 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaDIJCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:02:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<874n3n7czm.fsf_-_@xmission.com>
	<87wqezl5df.fsf_-_@x220.int.ebiederm.org>
	<20140409023027.GX18016@ZenIV.linux.org.uk>
	<20140409023947.GY18016@ZenIV.linux.org.uk>
Date: Wed, 09 Apr 2014 02:02:22 -0700
In-Reply-To: <20140409023947.GY18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 9 Apr 2014 03:39:47 +0100")
Message-ID: <87mwfueuzl.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+WrAHJbyHwfdUZPwEkN6CtaKx/3tdmL6M=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4331]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Wed, Apr 09, 2014 at 03:30:27AM +0100, Al Viro wrote:
>
>> > When renaming or unlinking directory entries that are not mountpoints
>> > no additional locks are taken so no performance differences can result,
>> > and my benchmark reflected that.
>> 
>> It also means that d_invalidate() now might trigger fs shutdown.  Which
>> has bloody huge stack footprint, for obvious reasons.  And d_invalidate()
>> can be called with pretty deep stack - walk into wrong dentry while
>> resolving a deeply nested symlink and there you go...
>
> PS: I thought I actually replied with that point back a month or so ago,
> but having checked sent-mail...  Looks like I had not.  My deep
> apologies.

If I had been aware of the concern I would have addressed this a month
ago.  Oh well that is water under the bridge now.

> FWIW, I think that overall this thing is a good idea, provided that we can
> live with semantics changes.  The implementation is too optimistic, though -
> at the very least, we want this work done upon namespace_unlock() held
> back until we are not too deep in stack.  task_work_add() fodder, perhaps?

Given where we are at in the merge window I need to make the argument
that it makes sense to pull this code now and address the deep
stack concerns before 3.15-final.

As I understand it your concern with d_invalidate is that there will be
a remote filesystem like nfs, and on a directory of that filesystem we
have mounted some other filesystem.  Someone on the nfs server deletes
the directory that is our mountpint.  Sometime later we traverse the
path that leads to the mountpoint in question and call d_invalidate.
The d_invalidate call drops performs a lazy unmount drops the last
filesystem reference and the filesystem umount potentially overflows
the kernel stack.

I would like to argue that because it is stupid to mount something on a
directory that someone else can delete this is not a particularly
likely scenario.  Unfortunately an evil user can mount filesystems
tagged with FS_USERNS_MOUNT and with care can trigger this at will. :(
So if we can overflow the stack this is problem that must be fixed.

The good news is that because it stupid to have a setup where someone
else can delete your mountpoint this won't really be a problem except in
setups with evil users which means merging these changes now, and fixing
this final issue in a few days when a tested patch is available should
not cause any problems.

Looking at the code there are two points where we could make this lazy,
walking the unmounted list in namespace unlock, and simply calling
detach_mount (As dropping a dentry and holid a reference is perfectly
legitimate).   I don't see any fundamental difficulties just some
painstaking detail work, to make certain the resulting implemention is
correct.

Linus would you please merge my branch.  In it's current state the code
fixes a lot of semantic and implementation bugs.  With only the
potential issue of overflowing that stack on a code path that most
people should never trigger.   Having the code merged for 3.15 will free
me to focus on the technical stack depth concerns and allow me to stop
worry about all of the other potential issues the patchset touches on.

Eric

p.s. Now I am off to sleep before I propose a patch to deal with the
potentail of very deep stacks.  I think I can reuse mnt_rcu in struct
mount for the work struct to pass to task_work_add but I need to look
closer at all of the details involved.









