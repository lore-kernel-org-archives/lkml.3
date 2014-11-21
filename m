Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaKUXdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:33:12 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:39215 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaKUXdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:33:11 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrVGSQ6CTXAFkPTueb0FMJ8oBd2_R4zB5X9juDoun_kJvQ@mail.gmail.com>
References: <alpine.DEB.2.11.1411202204030.3950@nanos>
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
	<alpine.DEB.2.11.1411212049220.6439@nanos>
	<CA+55aFzvgxAMpP7kr9qrxyo82vSucQ5G+VByOgsgoyq6y5ExOA@mail.gmail.com>
	<alpine.DEB.2.11.1411212110320.6439@nanos>
	<CA+55aFyt6q7Ed-SS9GeN8jeUZu6yNM14EGyH_8rn8AF2Vv37hg@mail.gmail.com>
	<alpine.DEB.2.11.1411212207150.6439@nanos>
	<CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
	<CALCETrVGSQ6CTXAFkPTueb0FMJ8oBd2_R4zB5X9juDoun_kJvQ@mail.gmail.com>
Date: Fri, 21 Nov 2014 15:33:09 -0800
X-Google-Sender-Auth: 1yNk_Ueh4zR6eUIO7QQ3hG0NZSQ
Message-ID: <CA+55aFxSt2bg3LEj-5_kmne=C4jdr=0JzTAq8jGNuNaZ7k1phA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 3:03 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Nov 21, 2014 at 2:55 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Anyway, here's an actual patch. As usual, it has seen absolutely no
>> actual testing,

.. ok, it boots and works fine as far as I can tell on x86-64 with no
paravirt anywhere.

> At the risk of going deeper down the rabbit hole, I grepped for
> pgd_list.  I found:

Ugh.

> __set_pmd_pte in pageattr.c.  It appears to be completely incorrect.
> Unless I've misunderstood, other than the very first line, it will
> either do nothing at all or crash when it falls off the end of the
> page tables that it's pointlessly trying to update.

I think you found a rats nest.

I can't make heads nor tails of the logic. The !SHARED_KERNEL_PMD test
doesn't seem very sensible, since that's also the conditional for
adding anything to the list in the first place.

So I agree that the code doesn't make much sense. Although maybe it's
there just because that way the loop goes away at compile-time under
most circumstances. So maybe even that part does make sense.

And the "walk down to the pmd level" part actually looks ok. Remember:
this is on x86-32 only, and you have two cases: non-PAE where the
pmd/pud offset thing does nothing at all, and it just ends up
converting a "pgd_t *" to a "pmd_t *".  And for PAE, the top pud level
always exists, and the pmd is folded, so despite what looks like
walking two levels, it really just walks the one level - the
force-allocated PGD entries.

So it won't "fall off the end of the page tables" like you imply. It
will just walk to the pmd level. And there it will populate all the
page tables with the same pmd.

So I think it works.

                   Linus
