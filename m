Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbbAGOkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:40:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:33935 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbbAGOkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:40:22 -0500
Message-ID: <1420641610.5830.29.camel@kernel.crashing.org>
Subject: Re: [RFC] PPC: MPIC: necessary readback after EOI?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Purcareata Bogdan <b43198@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Jan 2015 15:40:10 +0100
In-Reply-To: <54AA9C4D.3000001@freescale.com>
References: <54AA9C4D.3000001@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 16:14 +0200, Purcareata Bogdan wrote:
> Hello,
> 
> While doing some performance testing of a KVM guest on a PPC platform, I 
> noticed that there's a read of the CPU_WHOAMI register after each MPIC 
> EOI [1]. This has been present since the initial implementation of the 
> MPIC driver [2]. In a KVM virtualized environment, this results in an 
> additional kvm_exit.
> 
> Is the read back necessary? Is it used to provide some sort of 
> synchronization mechanism, making sure that nothing else is executed 
> until the EOI write is finished? I eliminated the mpic_cpu_read call and 
> run the kernel on hardware and noticed no anomaly, however I am not sure 
> of all the implications and race conditions it might lead to.

It was done to ensure that the store to the EOI has reached the MPIC and
been fully processed before re-enabling interrupts on the CPU. On some
implementations, the MPIC runs quite slowly (significantly slower than
the core) and the stores to it are asynchronous, so we had situation
where we would restore interrupts while the MPIC hasn't yet de-asserted
the output line.

One way to work around the performance loss for you would be to add some
DT property to indicate to the guest that the read isn't necessary.

> I was curious why the mpic_cpu_read(MPIC_INFO(CPU_WHOAMI)) was there in 
> the first place and if it's still needed. If it's still required, I 
> guess a better approach is to eliminate the call only if the kernel is 
> running on the KVM guest side, where the MPIC is emulated and no longer 
> requires a readback.
> 
> Thank you,
> Bogdan P.
> 
> [1] http://lxr.free-electrons.com/source/arch/powerpc/sysdev/mpic.c#L659
> [2] https://lkml.org/lkml/2004/10/22/483
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


