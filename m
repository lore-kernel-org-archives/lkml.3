Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaLDPW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:22:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:8621 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbaLDPW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:22:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,516,1413270000"; 
   d="scan'208";a="648282558"
Message-ID: <54807C31.7060709@intel.com>
Date: Thu, 04 Dec 2014 07:22:25 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Dave Jones <davej@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141201230339.GA20487@ret.masoncoding.com>	<1417529606.3924.26.camel@maggy.simpson.net>	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>	<1417540493.21136.3@mail.thefacebook.com>	<20141203184111.GA32005@redhat.com>	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>	<20141203190045.GB32005@redhat.com>	<CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>	<CANcMJZA1NXUMLEveA2k5njFnWc1pCSwSeAOQH7VQCOR-QtiR8g@mail.gmail.com>	<alpine.DEB.2.11.1412032137210.16275@nanos>	<20141204031553.GA20193@ret.masoncoding.com> <CA+55aFz-QhQOQuFPKbxBDAOjJ+fR02m3-unA4iD9kLwhWS38cA@mail.gmail.com>
In-Reply-To: <CA+55aFz-QhQOQuFPKbxBDAOjJ+fR02m3-unA4iD9kLwhWS38cA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 09:49 PM, Linus Torvalds wrote:
> On Wed, Dec 3, 2014 at 7:15 PM, Chris Mason <clm@fb.com> wrote:
>>
>> One guess is that trinity is generating a huge number of tlb
>> invalidations over sparse and horrible ranges.  Perhaps the old code was
>> falling back to full tlb flushes before Dave Hansen's string of fixes?
> 
> Hmm. I agree that we've had some of the backtraces look like TLB
> flushing might be involved. Not all, though. And I'm not seeing where
> a loop over up to 33 pages should matter over doing a full TLB flush.
> 
> What *might* matter is if we somehow get that number wrong, and the loops like
> 
>                         addr = f->flush_start;
>                         while (addr < f->flush_end) {
>                                 __flush_tlb_single(addr);
>                                 addr += PAGE_SIZE;
>                         }
> 
> ends up looping a *lot* due to some bug, and then the IPI itself would
> take so long that the watchdog could trigger.
> 
> But I do not see how that could actually happen. As far as I can tell,
> either the number of pages is limited to less than 33, or we have that
>  TLB_FLUSH_ALL case.
> 
> Do  you see something I don't?

The one thing I _do_ see now is a missed TLB flush is we're flushing one
page at the end of the address space.  We'd overflow flush_end back so
flush_end=0:

        if (!f->flush_end)	
                f->flush_end = f->flush_start + PAGE_SIZE; <-- overflow

and we'll never enter the while loop where we actually do the flush:

                        while (addr < f->flush_end) {
                                __flush_tlb_single(addr);
                                addr += PAGE_SIZE;
                        }

But we have a hole up there on x86_64, so this will never happen in
practice there.  It might theoretically apply to 32-bit, but this still
doesn't help with the bug.

Oh, and the tracepoint is spitting out bogus numbers because we need
some parenthesis around the 'nr_pages' calculation.
