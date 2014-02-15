Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaBOXXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:23:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33461 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaBOXX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:23:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<87bny8kqik.fsf_-_@xmission.com>
	<CA+55aFz6feRh9+U7OY6C4CfNe68CqQZARCf_J9deJdsUUG_ryg@mail.gmail.com>
	<CA+55aFzfa3=ukGq=XJbxj-xqud32DvbF7AcroBKL6-GY32or7Q@mail.gmail.com>
Date: Sat, 15 Feb 2014 15:23:20 -0800
In-Reply-To: <CA+55aFzfa3=ukGq=XJbxj-xqud32DvbF7AcroBKL6-GY32or7Q@mail.gmail.com>
	(Linus Torvalds's message of "Sat, 15 Feb 2014 14:59:50 -0800")
Message-ID: <87a9ds55av.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18eQDl9RaWbsoIa0BVELtW00NTEPeR63vw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0096]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 02/11] vfs: More precise tests in d_invalidate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, Feb 15, 2014 at 2:51 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> the whole check_submounts_and_drop thing walks the parent chain and
>> locks each parent with the renamelock held for writing.
>
> Oops, my bad about the write lock, brainfart due to grepping and
> reading the wrong context...
>
> check_submounts_and_drop() doesn't do the parent walk with the rename
> lock held for writing, it just holds it for reading.
>
> But it does do that very complex "walk parents and check all siblings"
> and locks them, so the rest of the commentary was correct.

Except that today d_invalidate drops the dcache lock and
calls shrink_dcache_parent.  Which gets you into exactly the same
complex "walk parents and check all siblings" code.

The only difference between the shrink_dcache_parent and
check_submounts_and_drop (not counting the final drop)
is that check_submounts_and_drop aborts when it encounters a dentry
with d_mountpoint set.


So no I am not trying to hide something.  I called out that I changed
this logic in particular and this particular patch all I am doing is
killing the enforcing of 2.2 era logic.  Further I front loaded this
change so I bisect could point it's fingers at this before any other
substantial changes were made if this is indeed a problem.

Beyond that check_submounts_and_drop is what well maintained distributed
filesystems are calling from d_revalidate.


Now I would not be surprised if this change to d_invalidate is a
challenge to get your head around.  It took me a while of reading the
code to realize (a) how the code makes some degree of sense today,
and (b) that the change is semantically safe.


But when shrink_dcache_parent and check_submounts_and_drop are
effectiely the same function I can't possibly see how you can argue how
the locking has changed or that I am trying to hide things.

Eric
