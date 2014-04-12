Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbaDLWQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 18:16:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55085 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaDLWQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 18:16:07 -0400
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
Date: Sat, 12 Apr 2014 15:15:39 -0700
In-Reply-To: <20140409232423.GB18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 10 Apr 2014 00:24:23 +0100")
Message-ID: <87lhva5h4k.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+RRspAp5WstKMKh7zAsmWAHB9uZewuIts=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4258]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
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

Can you explain which scenario you are thinking about with respect to a
failed modprobe?

I don't see any problems on the mount path, and copy_module_from_fd
already uses struct file which does this.

So I am curious to know which scenario you were thinking of.  Outside of
mount (where we demand load the fs module) I can't think of a scenario
with modprobe where we would require immediate free semantics.

Unmout certainly needs to have the filesystem freed by the time we reach
userspace (in the normal case) but other than that I am drawing a blank.

> I agree that fs shutdown is better dealt with on mostly empty stack, of
> course - moreover, done right that has a potential to make mntput()
> safe in atomic contexts (there's also acct_auto_close_mnt() to deal
> with; that might take some work to get right, but I think it's not
> fatal).

I just about have a working version, and acct_auto_close_mnt wasn't
particularly difficult.  Just one more thing that had to be done.

Eric

