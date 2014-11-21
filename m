Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaKUUlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:41:46 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:49195 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaKUUlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:41:45 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411212110320.6439@nanos>
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
	<alpine.DEB.2.11.1411212049220.6439@nanos>
	<CA+55aFzvgxAMpP7kr9qrxyo82vSucQ5G+VByOgsgoyq6y5ExOA@mail.gmail.com>
	<alpine.DEB.2.11.1411212110320.6439@nanos>
Date: Fri, 21 Nov 2014 12:41:44 -0800
X-Google-Sender-Auth: HGaEzycGmV44x04EukQyXl8tbhc
Message-ID: <CA+55aFyt6q7Ed-SS9GeN8jeUZu6yNM14EGyH_8rn8AF2Vv37hg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
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

On Fri, Nov 21, 2014 at 12:16 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> I don't think that works on 32bit. See the magic in
> vmalloc_sync_one().

Heh. I guess we could just add a wrapper around this crap, and make it
very clear that the paravirt case is a horrible horrible hack.

Something like

   #define set_one_pgd_entry(entry,pgdp) (pgdp)->pgd = (entry)

for the regular case, and then for paravirt we do something very
explicitly horrid, like

   #ifdef CONFIG_PARAVIRT
   #ifdef CONFIG_X86_32
   // The pmd is the top-level page directory on non-PAE x86, nested
inside pgd/pud
   #define set_one_pgd_entry(entry,pgdp) set_pmd((pmd_t *)(pgdp),
(pmd_t) { entry } )
   #else
   #define set_one_pgd_entry(entry, pgdp) do { set_pgd(pgdp, (pgd_t) {
entry });  arch_flush_lazy_mmu_mode(); } while (0)
   #endif

because on x86-64, there seems to be that whole lazy_mode pv_ops
craziness (which I'm not at all convinced is needed here, but that's
what the current code does).

                Linus
