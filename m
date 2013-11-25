Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3KYLan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:30:43 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:35831 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3KYLal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:30:41 -0500
Message-ID: <529334CA.1000401@synopsys.com>
Date: Mon, 25 Nov 2013 17:00:18 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Gilad Ben-Yossef" <gilad@benyossef.com>,
        Noam Camus <noamc@ezchip.com>, David Daney <david.daney@cavium.com>,
        James Hogan <james.hogan@imgtec.com>,
        "thomas Gleixner" <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Richard Kuo" <rkuo@codeaurora.org>
Subject: Re: Preventing IPI sending races in arch code
References: <52932BE2.5010201@synopsys.com> <20131125110006.GU3866@twins.programming.kicks-ass.net>
In-Reply-To: <20131125110006.GU3866@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:30 PM, Peter Zijlstra wrote:
> On Mon, Nov 25, 2013 at 04:22:18PM +0530, Vineet Gupta wrote:
>> Hi,
>>
>> I've been looking into cleaning up bitrot in ARC SMP support. Unlike some other
>> arches/platforms, we don't have per-msg-type IRQ, so the actual msg (say cross
>> function call) corresponding to IPI needs to be encoded in a per-cpu word (1 bit
>> per msg type) before kicking the IPI.
>>
>> The current code (indicative below) is completely bonkers as it calls set_bit w/o
>> any protection whatsoever, clearly racy in case of multiple senders, where
>> receiver could end up NOT seeing one of the writes.
>>
>> ipi_send_msg(cpu, msg-type)
>> {
>>    struct ipi_data *ipi_data = &per_cpu(ipi_data, cpu);
>>
>>    local_irq_save();
>>    set_bit(msg-type, &ipi_data->bits)
>>    plat_smp_ops.ipi_send(cpumask)
>>    local_irq_restore();
>> }
>>
>> Adding a spinlock here would serialize the sending part, but I still see issue in
>> receiver. Upon receipt of First IPI, the msg holding word will be atomically
>> exchanged with 0, so 2nd IPI will not see any msg in the word. Augmenting with an
>> atomic counter would only help detect the issue - but I don't see how it will help
>> elide the issue.
>>
>> Does that mean w/o proper hardware assist (i.e. IRQ providing the msg id
>> indication), the race, however small, remains ?
> 
> You can use cmpxchg to set the bit, and in case the previous value
> wasn't 0 not send a second IPI.
> 

Thx Peter, that'll do it.

While we are at it, I wanted to confirm another potential race (ARC/blackfin..)
The IPI handler clears the interrupt before atomically-read-n-clear the msg word.

do_IPI
   plat_smp_ops.ipi_clear(irq);
   while ((pending = xchg(&ipi_data->bits, 0) != 0)
      find_next_bit(....)
      switch(next-msg)

Depending on arch this could lead to an immediate IPI interrupt, and again
ipi_data->bits could get out of syn with IPI senders. IMO the while loop is
completely useless specially if IPIs are not coalesced in h/w. And we need to move
the xchg ahead of ACK'ing the IPI

do_IPI
   pending = xchg(&ipi_data->bits, 0);
   plat_smp_ops.ipi_clear(irq);
   while (ffs....)
      switch(next-msg)
      ...

Does that look sane to you.

Thx,
-Vineet
