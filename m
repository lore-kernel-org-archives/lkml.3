Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaHFQe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:34:59 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:65148 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaHFQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:34:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140806081441.GZ7393@tucnak.redhat.com>
References: <20140730014827.565626091@linuxfoundation.org>
	<20140730014829.344302554@linuxfoundation.org>
	<20140730065312.GA1652@laptop.redhat.com>
	<CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
	<CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
	<CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com>
	<CA+5PVA79a-BoMMAzryH0O3NFz6KY1f9REAmE=T00ErfcUfCGEg@mail.gmail.com>
	<20140805210728.GH13858@redhat.com>
	<CA+55aFwq72kDdRSWXKhyO1j=_PAKB960+RNOD6Cou0wZTa+5Hw@mail.gmail.com>
	<20140806081441.GZ7393@tucnak.redhat.com>
Date: Wed, 6 Aug 2014 09:34:56 -0700
Message-ID: <CAADnVQ+mtZ3=Qv5Mz_P0unhTqaaf0KsyKXCNez33dhyGiFk=Mw@mail.gmail.com>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of load_balance()
 in scheduler
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Josh Stone <jistone@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 1:14 AM, Jakub Jelinek <jakub@redhat.com> wrote:
> On Tue, Aug 05, 2014 at 03:36:39PM -0700, Linus Torvalds wrote:
d>> I don't understand how you guys can be so cavalier about a compiler
>> bug that has already resulted in actual real problems. You bring up
>
> I have no problem with a -fno-var-tracking-assignments workaround for
> compilers that have the PR61801 wrong-code bug.  What I have problem with
> is with disabling it even for compilers that have that bug fixed.
> That is in essence disabling a useful feature just because it could have
> other bugs.  If my memory serves me well, PR61801 is the only wrong-code
> I remember caused by -fvar-tracking-assignments during the 5 years since
> it has been introduced into gcc.  Sure, there have been several
> -fcompare-debug bugs, where we generated slightly different code between
> -g and -g0, and as you mentioned we have one still pending (Vladimir is
> working on it right now), but that is mainly relevant to the case where

I think gcc guys are taking a wrong lesson out of this. kernel doesn't
care too much whether gcc produces the same binary with -g and -g0.
kernel developers also don't care about amount debug info for variables,
but they care about hard to find compiler bugs. In this case sched2
mishap around debug_insn was a symptom. The root cause is lack
of attention to -mno-red-zone. Kernel is not another user space program
where data/control flow analysis is all compiler need to make things right.
-mno-red-zone lesson exposes lack of 'interrupt' concept in compiler.
I think there has to be some infra put in place to make sure that it's not
just a scheduling barrier. Otherwise next bug will pop much sooner
than 5 years and it will not be related to debug info at all.
In this sense Steven's perl script to detect red-zone violations did more
to re-enable var-tracking than -fcompare-debug fixes.
