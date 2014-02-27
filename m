Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaB0CFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:05:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57906 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaB0CFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:05:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>
References: <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<87eh34jbsl.fsf_-_@xmission.com>
	<20140218174053.GE4026@tucsk.piliscsaba.szeredi.hu>
	<87y510dpra.fsf@xmission.com> <20140225151349.GA19981@fieldses.org>
	<87mwhe26kn.fsf@xmission.com> <20140226193740.GA24456@fieldses.org>
Date: Wed, 26 Feb 2014 18:05:17 -0800
In-Reply-To: <20140226193740.GA24456@fieldses.org> (J. Bruce Fields's message
	of "Wed, 26 Feb 2014 14:37:40 -0500")
Message-ID: <87vbw1xqci.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+G2FGEBIKQAzdsQpJcuBcrNCGOqfixLcE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.1 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2203]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;"J. Bruce Fields" <bfields@fieldses.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 08/11] vfs: Merge check_submounts_and_drop and d_invalidate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Tue, Feb 25, 2014 at 02:03:36PM -0800, Eric W. Biederman wrote:
>> "J. Bruce Fields" <bfields@fieldses.org> writes:
>> 
>> > On Mon, Feb 24, 2014 at 04:01:29PM -0800, Eric W. Biederman wrote:
>> >> Miklos Szeredi <miklos@szeredi.hu> writes:
>> >> 
>> >> >
>> >> > You can optimize this by including the negative check within the above d_locked
>> >> > region and calling __d_drop() instead.
>> >> 
>> >> For this patch just moving the code and not changing it is the corret
>> >> thing to do because it helps with review and understanding the code.
>> >> 
>> >> There are two ways I could see going with optimizing the preamble.
>> >> Simply dropping the d_lock from around the d_unhashed test as a pointer
>> >> dereference should be atomic, and the test is racy against
>> >> d_materialise_unique.
>> >
>> > Could you explain?  What's the race, and what are the consequences?
>
> Actually I was just confused as to whether the above was "is racy" was
> claiming the existance of some bug.
>
> I believe I should have read the above as more like "the test is already
> racy against d_materialise_unique, but it's a harmless race, and
> dropping the d_lock wouldn't make it any worse".
>
>> >> (We don't always hold the parent directories inode mutex when d_invalidate is called).
>> 
>> d_unhashed is not a permanent condition because of d_materialise_unique,
>> and d_splice_alias.
>> 
>> d_invalidate can be called on an unhashed dentry in one of two ways
>> (either d_revalidate dropped the dentry or another routine that drops
>> the dentry beat the current invocation of d_invalidate to the job).
>> 
>> 
>> There are 3 places d_revalidate is called.
>> 
>> Once on the rcu path with with the appropriate flag set.
>> 
>> Once without out the parent i_mutex held, just off of the rcu path,
>> on that path d_invalidate is when d_revalidate fails.
>> 
>> Once during lookup with the parent directory i_mutex held.
>> 
>> 
>> Because the parent direcories i_mutex is not always held accross
>> d_revalidate and the following d_invalidate it happens that d_invalidate
>> is not always an atomic operation.
>> 
>> 
>> At worst the race results in a dentry that is dropped when it could be
>> hashed,
>
> Because somebody not holding the i_mutex calls d_invalidate based on old
> information and unhashes something that
> d_materialise_unique/d_splice_alias just hashed?

More likely today somebody not holding i_mutex and not in rcu context
calls d_revalidate.  d_revalidate drops the dentry and before we
d_invalidate d_materialise_unique/d_splice_alias rehashes it.

After my changes it looks like it takes 3 processes two instances
of d_invalidate and a instance of d_materialise_unique/d_spliace_alias
to trigger this case.

In either case the window is very small and the outcome is effectively
harmless.  So I don't see this as a problem.

>> that we will resurrect next time someone attempts to look it
>> up and d_materialise_unique/d_splice_alias is called.
>
> OK.
>
>> None of that really matters for optimizing d_invalidate, but it is part
>> of the background in which d_invalidate lives. All that is significant
>> in d_invalidate is knowing that d_materialise_unique, and possibly
>> d_splice_alias may run concurrently with d_invalidate.  It is unlikely
>> and essentially harmless.
>> 
>> 
>> After my patchset (because I removed all of the d_drop's from
>> .d_revalidate) the only race that should remain is between two parallel
>> calls of d_invalidate.  Which probably means we can remove the test for
>> d_unhashed altogether.
>> 
>> Right now I just want to make this first big step and make certain the
>> code is solid.  After that optimization is easy.
>
> Thanks for the explanation!

Welcome.

Eric

