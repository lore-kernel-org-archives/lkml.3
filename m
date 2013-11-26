Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3KZEsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:48:50 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:33260 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3KZEsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:48:46 -0500
Message-ID: <529427F1.2080409@synopsys.com>
Date: Tue, 26 Nov 2013 10:17:45 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "Noam Camus" <noamc@ezchip.com>, David Daney <david.daney@cavium.com>,
        James Hogan <james.hogan@imgtec.com>,
        thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Richard Kuo <rkuo@codeaurora.org>
Subject: Re: Preventing IPI sending races in arch code
References: <52932BE2.5010201@synopsys.com>	 <20131125110006.GU3866@twins.programming.kicks-ass.net>	 <529334CA.1000401@synopsys.com>	 <20131125122726.GZ10022@twins.programming.kicks-ass.net>	 <C2D7FE5348E1B147BCA15975FBA2307515715C@IN01WEMBXA.internal.synopsys.com> <1385409103.9218.15.camel@pasglop>
In-Reply-To: <1385409103.9218.15.camel@pasglop>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 01:21 AM, Benjamin Herrenschmidt wrote:
> On Mon, 2013-11-25 at 13:35 +0000, Vineet Gupta wrote:
> 
>> Before reading ur email I was coding something like below:
>>
>> void arch_send_ipi(int cpu, int type)
>> {
>>   u32 *pending_ptr = per_cpu_ptr(ipi_bits, cpu);
>>
>>   while (cmpxchg(pending_ptr, 0, 1 << type) != 0)
>> 	cpu_relax();
>>
>>   raise_ipi(cpu);
>> }
> 
> So you would have blocked the sender while there was already
> a pending IPI on the target ? Why ?

A simplistic (but non optimal) way to cater to the race where 2 senders try to
send the exact same msg to same receiver. Upon first IPI, receiver "consumes" the
msg (using xchg with 0) so the 2nd IPI seems "empty" i.e. no msg.


> The optimization proposed by Peter is actually the only interesting
> change here, without it the existing set_bit was perfectly fine.

I'm not sure, see below.

> Remember that set_bit is atomic.

Right, but the issue per-se is not clobbering of msg holder, but from POV of
receiver, seeming coalescing of 2 set_bit writes to msg holder.

core0		core1		core2

set_bit 1	
kick IPI-2	set_bit 1	IPI-0 received
		kick IPI-2	read+clear bit
				IPI-1 received
				no msg

-Vineet

