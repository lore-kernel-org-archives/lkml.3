Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577AbaDJBgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 21:36:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56016 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaDJBgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 21:36:38 -0400
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
References: <87ob28kqks.fsf_-_@xmission.com> <874n3n7czm.fsf_-_@xmission.com>
	<87wqezl5df.fsf_-_@x220.int.ebiederm.org>
	<20140409023027.GX18016@ZenIV.linux.org.uk>
	<20140409023947.GY18016@ZenIV.linux.org.uk>
	<87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
	<87txa286fu.fsf@x220.int.ebiederm.org>
	<87fvlm860e.fsf_-_@x220.int.ebiederm.org>
	<20140409232423.GB18016@ZenIV.linux.org.uk>
Date: Wed, 09 Apr 2014 18:36:12 -0700
In-Reply-To: <20140409232423.GB18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 10 Apr 2014 00:24:23 +0100")
Message-ID: <874n226k4z.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18XZGb0yss80cRVQdm4XgK/tq3rTQGHgb4=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4490]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] vfs: In mntput run deactivate_super on a shallow stack.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Wed, Apr 09, 2014 at 03:58:25PM -0700, Eric W. Biederman wrote:
>> 
>> mntput as part of pathput is called from all over the vfs sometimes as
>> in the case of symlink chasing from some rather deep call chains.
>> During filesystem unmount with the right set of races those innocuous
>> little mntput calls that take very little stack space can become calls
>> become mosters calling deactivate_super that can take up 3k or more of
>> stack space as syncrhonous filesystem I/O is performed, through
>> multiple levels of the I/O stack.
>> 
>> Avoid deactivate_super being called from a deep stack by converting
>> mntput to use task_work_add when the mnt_count goes to 0.  The
>> filesystem is still unmounted synchronously preserving the semantics
>> that system calls like umount require.
>
> Careful.  For one thing, you've just introduced a massive leak in knfsd
> and any other kernel thread that might do mntput().  task_work_add()
> makes no sense there - there is no userland to return to.  For another,
> in things like cleanup of failing modprobe we might end up delaying fs
> shutdown too much.  So it's not that simple, unfortunately.

Unfortunately.

> I agree that fs shutdown is better dealt with on mostly empty stack, of
> course - moreover, done right that has a potential to make mntput()
> safe in atomic contexts (there's also acct_auto_close_mnt() to deal
> with; that might take some work to get right, but I think it's not
> fatal).

I am slowly digging into this.

With this patch I was was able to do an A/B comparison of what the stack
cost on my unmounting my minimal ext4 filesystem from d_invalidate
called with in a context with maximum symlink recursion depth, without
and without a changed mntput.

I used sysfs instead of nfs to mount my minimal ext4 filesystem on as I
was a lazy bum and didn't have a nfs server setup handy.

With just my detach_mounts branched merged into 3.15-rc0
I saw 4880 stack bytes left before calling detach_mounts from d_invalidate
I saw 3904 stack bytes left after calling detach_mounts from d_invalidate

Which means in practice unmounting my mininal ext4 filesystem image only
used 976 additional bytes of stack.

With the same kernel plus my change to mntput
I saw 4880 stack bytes left before calling detach_mounts from d_invalidate
I saw 4880 stack bytes left after calling detach_mounts from d_invalidate

Which at least confirms that a change to mntput is enough to make deep
stacks safe.

With 3904 bytes of headroom from ext4 I may have to measure some of the
nastier cases just to be certain there actually is a problem here.

Eric

