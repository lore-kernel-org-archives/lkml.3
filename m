Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbaDIWtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 18:49:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58964 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbaDIWtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 18:49:42 -0400
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
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<874n3n7czm.fsf_-_@xmission.com>
	<87wqezl5df.fsf_-_@x220.int.ebiederm.org>
	<20140409023027.GX18016@ZenIV.linux.org.uk>
	<20140409023947.GY18016@ZenIV.linux.org.uk>
	<87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
Date: Wed, 09 Apr 2014 15:49:09 -0700
In-Reply-To: <20140409182830.GA18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 9 Apr 2014 19:28:32 +0100")
Message-ID: <87txa286fu.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+ch6em2WMkHgAFR8Ee++iQmueklBXRBEc=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4273]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      []
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 XMSexyCombo_01 Sexy words in both body/subject
X-Spam-DCC: ; 
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

> On Wed, Apr 09, 2014 at 06:53:23PM +0100, Al Viro wrote:
>
>> For starters, put that ext4 on top of dm-raid or dm-multipath.  That alone
>> will very likely push you over the top.
>> 
>> Keep in mind, BTW, that you do not have full 8K to play with - there's
>> struct thread_info that should not be stepped upon.  Not particulary large
>> (IIRC, restart_block is the largest piece in amd64 one), but it eats about
>> 100 bytes.
>> 
>> I'd probably use renameat(2) in testing - i.e. trigger the shite when
>> resolving a deeply nested symlink in renameat() arguments.  That brings
>> extra struct nameidata into the game, i.e. extra 152 bytes chewed off the
>> stack.
>
> Come to think of that, some extra nastiness could be had by mixing it with
> execve().  You can have up to 4 levels of #! resolution there, each eating
> up at least 128 bytes (more, actually).  Compiler _might_ turn that
> tail call of search_binary_handler() into a jump, but it's not guaranteed
> at all.
>
> FWIW, it probably makes sense to turn load_script() into
> static int load_script(struct linux_binprm *bprm)
> {
> 	int err = __load_script(bprm);
> 	if (err)
> 		return err;
> 	return search_binary_handler(bprm);
> }
>
> regardless of that issue; we don't need interp[] after the call of
> open_exec(), so it makes sense to reduce the footprint in mutual
> recursion loop.
>
> For extra pain, consider s/ext4/xfs/, possibly with iscsi thrown under the
> bus^Wdm-multipath.
>
> The thing is, we are already too close to stack overflow limit.  Adding
> several kilobytes more is not survivable, and since you are taking
> somebody in a userns DoSing the system into consideration, you can't
> say "it takes malicious root to set up, so it's not serious" - the
> DoS you mentioned requires the same thing...

Thank you for the comments this makes it clear that the problem is with
mntput (and the filesystem I/O that can be triggered) not particularly
with detach_mounts.  As I read the code all of these nasty cases we are
concern with today can be triggered with pathput/mntput already with an
appropriate race against umount, which means my detach_mounts code
doesn't introduce a stack space usage regression, but seems to be the
messenger that we have such problems in the VFS.

There is a also a big difference between what can be triggered using
filesystems we allow unprivileged users to mount, devpts, proc, ramfs,
sysfs, mqueue, shmem (none of which have backing store) and filesystems
with a long I/O path. 

So it looks like it still requires global root to trigger this, although
I still think it is serious. 

One of the more interesting aspects of this userns work is running into
code that semantically should be safe for unprivileged users to use but
as we haven't historically allowed unprivileged users to use the code
there are silly assumptions and untested code paths.

> BTW, another thing to test would be this:
> 	mount nfs on /mnt
> 	mount a filesystem on /mnt/path that can be invalidated
> 	cd to /mnt/path/foo
> 	bind /mnt on /mnt/path/foo/bar
> 	shoot /mnt/path (on server)
> 	stat bar/path/foo
> That should rip the fs you are in out of the tree; it should work, but
> it's definitely a case worth testing.

Agreed that is a case worth test.  I wasn't looking at that case in
particular as that is not the worst case stack usage or even an
approximation of it.

Eric

