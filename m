Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3KYLAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:00:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37225 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3KYLAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:00:21 -0500
Date: Mon, 25 Nov 2013 12:00:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Noam Camus <noamc@ezchip.com>,
        David Daney <david.daney@cavium.com>,
        James Hogan <james.hogan@imgtec.com>,
        thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Richard Kuo <rkuo@codeaurora.org>
Subject: Re: Preventing IPI sending races in arch code
Message-ID: <20131125110006.GU3866@twins.programming.kicks-ass.net>
References: <52932BE2.5010201@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52932BE2.5010201@synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 04:22:18PM +0530, Vineet Gupta wrote:
> Hi,
> 
> I've been looking into cleaning up bitrot in ARC SMP support. Unlike some other
> arches/platforms, we don't have per-msg-type IRQ, so the actual msg (say cross
> function call) corresponding to IPI needs to be encoded in a per-cpu word (1 bit
> per msg type) before kicking the IPI.
> 
> The current code (indicative below) is completely bonkers as it calls set_bit w/o
> any protection whatsoever, clearly racy in case of multiple senders, where
> receiver could end up NOT seeing one of the writes.
> 
> ipi_send_msg(cpu, msg-type)
> {
>    struct ipi_data *ipi_data = &per_cpu(ipi_data, cpu);
> 
>    local_irq_save();
>    set_bit(msg-type, &ipi_data->bits)
>    plat_smp_ops.ipi_send(cpumask)
>    local_irq_restore();
> }
> 
> Adding a spinlock here would serialize the sending part, but I still see issue in
> receiver. Upon receipt of First IPI, the msg holding word will be atomically
> exchanged with 0, so 2nd IPI will not see any msg in the word. Augmenting with an
> atomic counter would only help detect the issue - but I don't see how it will help
> elide the issue.
> 
> Does that mean w/o proper hardware assist (i.e. IRQ providing the msg id
> indication), the race, however small, remains ?

You can use cmpxchg to set the bit, and in case the previous value
wasn't 0 not send a second IPI.
