Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaLDFtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 00:49:07 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:54058 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaLDFtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 00:49:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141204031553.GA20193@ret.masoncoding.com>
References: <20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141203190045.GB32005@redhat.com>
	<CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
	<CANcMJZA1NXUMLEveA2k5njFnWc1pCSwSeAOQH7VQCOR-QtiR8g@mail.gmail.com>
	<alpine.DEB.2.11.1412032137210.16275@nanos>
	<20141204031553.GA20193@ret.masoncoding.com>
Date: Wed, 3 Dec 2014 21:49:04 -0800
X-Google-Sender-Auth: So2Rv9-0atJVAVz5v7tfexxytnU
Message-ID: <CA+55aFz-QhQOQuFPKbxBDAOjJ+fR02m3-unA4iD9kLwhWS38cA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 7:15 PM, Chris Mason <clm@fb.com> wrote:
>
> One guess is that trinity is generating a huge number of tlb
> invalidations over sparse and horrible ranges.  Perhaps the old code was
> falling back to full tlb flushes before Dave Hansen's string of fixes?

Hmm. I agree that we've had some of the backtraces look like TLB
flushing might be involved. Not all, though. And I'm not seeing where
a loop over up to 33 pages should matter over doing a full TLB flush.

What *might* matter is if we somehow get that number wrong, and the loops like

                        addr = f->flush_start;
                        while (addr < f->flush_end) {
                                __flush_tlb_single(addr);
                                addr += PAGE_SIZE;
                        }

ends up looping a *lot* due to some bug, and then the IPI itself would
take so long that the watchdog could trigger.

But I do not see how that could actually happen. As far as I can tell,
either the number of pages is limited to less than 33, or we have that
 TLB_FLUSH_ALL case.

Do  you see something I don't?

                  Linus
