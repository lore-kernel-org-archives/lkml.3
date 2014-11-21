Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaKUTeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:34:06 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:42433 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaKUTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:34:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141121142301.564f7eb7@gandalf.local.home>
References: <alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
	<20141120233920.GC25393@htj.dyndns.org>
	<CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
	<20141121162742.GB15461@htj.dyndns.org>
	<CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
	<CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
	<20141121170805.GD30603@home.goodmis.org>
	<CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
	<CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
	<CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
	<CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
	<20141121142301.564f7eb7@gandalf.local.home>
Date: Fri, 21 Nov 2014 11:34:03 -0800
X-Google-Sender-Auth: 9eY9goa9GpW8_966V1nEqA9-SZQ
Message-ID: <CA+55aFw6w+pkG7fs7tBVm7jV_TjsnEyG5XDdk+Ghf5Af+ELUeA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:23 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Should we at least check to see if it is present?
>
>         if (!(pgd_entry & 1))
>                 return -1;

Maybe. But what other entry could there be?

But yes, returning -1 is "safe", since it basically says "I'm not
doing a vmalloc thing, oops if this is a bad access". So that kind of
argues for being as aggressive as possible in returning 1.

So for the first one (!pgd_entry), instead of returning -1 only for a
completely empty entry, returning it for any non-present case is
probably right.

And for the second one (where we check whether there is anything at
all in the destination), returning -1 for "anything but zero" is
probably the right thing to do.

But in the end, if you have a corrupted top-level kernel page table,
it sounds to me like you're just royally screwed anyway. So I don't
think it matters *that* much.

So I kind of agree, but it wouldn't be my primary worry. My primary
worry is actually paravirt doing something insane.

                    Linus
