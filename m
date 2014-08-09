Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaHIJ7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 05:59:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45371 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaHIJ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 05:59:11 -0400
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
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
References: <87ppkl1xb7.fsf@x220.int.ebiederm.org>
	<20140413215242.GP18016@ZenIV.linux.org.uk>
	<87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
	<87ppkhc4pp.fsf@x220.int.ebiederm.org>
	<87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
	<20140417202237.GA18016@ZenIV.linux.org.uk>
	<87tx9rwsz4.fsf@x220.int.ebiederm.org>
	<20140417221203.GC18016@ZenIV.linux.org.uk>
	<20140420054108.GQ18016@ZenIV.linux.org.uk>
	<20140511164530.GB18016@ZenIV.linux.org.uk>
	<20140809093412.GA23108@ZenIV.linux.org.uk>
Date: Sat, 09 Aug 2014 02:55:10 -0700
In-Reply-To: <20140809093412.GA23108@ZenIV.linux.org.uk> (Al Viro's message of
	"Sat, 9 Aug 2014 10:34:12 +0100")
Message-ID: <87d2cam1hd.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18dlV1tN7QKv7r/QcuCZakIOlxaSPdzV1Q=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sun, May 11, 2014 at 05:45:30PM +0100, Al Viro wrote:
>> Sigh...  It's really messy.
>> 	All versions since lazy fput introduction have acct_auto_close()
>> doing the wrong thing on r/o remount of superblock; we want the damn file
>> closed *before* we go further than acct_auto_close().  Worse, we are
>> holding ->s_umount there, so any kind of waiting would have to be very
>> careful to avoid deadlocks.  What's more, prevention of open for write
>> hits acct_auto_close(), so even if we wait there, we still have a window
>> when new acct file could be opened and not auto-closed.
>> 	All versions have problems with acct_process() in the middle of
>> umount(); originally it was a blatant call of ->write() happening without
>> any regard for file getting closed, then it was file getting written to
>> and closed in the middle of fs shutdown, then - write/close capable of
>> pushing fs shutdown past the return from umount(2).
>> 	All versions have problems with acct(NULL) vs. umount - the latter
>> does not wait for the former.  Eric's patches plug that one, but there's
>> a serious deadlock potential.
>
> OK, I think I've sorted that one out.  Eric, could you take a look at
> vfs.git#for-eric?  That's for-next + fix that ought to go into -stable +
> delayed-mntput() thing.  The real PITA had been kernel/acct.c mess;
> that's dealt with in -next.
>
> I think it solves the problem with "mntput in deep call chain" cases
> added in your series.  Final mntput() does fs shutdown, etc. on a shallow
> stack, via task_work_add() if at all possible.  MNT_INTERNAL vfsmounts
> are dealt with synchronously, which solves the problem of failure exits
> halfway through module_init needing to tear down an internal vfsmount, etc.
> But those call sites are all on fairly shallow stack anyway.  And such
> vfsmounts are not mounted on anything, so it's not something your changes
> could possibly step into.  No extra context switches per syscall, at that...
>
> I hadn't added mntput_sync() - no visible use cases.  If one shows up,
> it wouldn't be hard to add such primitive.  And unlike fput() we do not
> try to support mntput() from interrupt, etc. - too much PITA with no
> obvious use cases.  We'd need to decide whether we want to disable IRQs
> on lock_mount_hash(), etc.  It's doable, but let's leave that until we
> get a serious reason to mess with all that.

I see the changes.  The accounting changes look especially interesting.
I don't now if we need a mntput_sync but I will double check as I review
the patches.

I will aim to start reading through the changes carefully first thing in
the morning.

Eric

