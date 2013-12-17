Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3LQM7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:59:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55253 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3LQM7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:59:47 -0500
Date: Tue, 17 Dec 2013 12:58:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, mark.rutland@arm.com,
        s.hauer@pengutronix.de, galak@codeaurora.org, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, matt.porter@linaro.org,
        rob@landley.net, tomasz.figa@gmail.com, ian.campbell@citrix.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131217125832.GU4360@n2100.arm.linux.org.uk>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com> <1386925027-16288-2-git-send-email-Li.Xiubo@freescale.com> <20131217111020.GF13823@ulmo.nvidia.com> <20131217115136.GT4360@n2100.arm.linux.org.uk> <20131217122431.GA17210@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217122431.GA17210@ulmo.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 01:24:33PM +0100, Thierry Reding wrote:
> On Tue, Dec 17, 2013 at 11:51:36AM +0000, Russell King - ARM Linux wrote:
> > Same comments here - what memory operations is the wmb() trying to
> > serialise?  Does this PWM driver somehow end up doing DMA?
> 
> Not that I can see. But if my understanding is correct, not using the
> barriers would allow the compiler and CPU to reorder accesses, and by
> that cause the register accesses to potentially happen in the wrong
> order.

The compiler won't reorder them, but the CPU may if it meets certain
criteria.  The architecture guarantees that accesses to device memory
within a (minimum of) 1KB block will be ordered.

The ARM ARM is slightly ambiguous in how this is applied - in one
place it says that "Accesses must arrive at any particular memory-mapped
peripheral or block of memory in program order" and another part it
says "The size of a memory mapped peripheral, or a block of memory,
is IMPLEMENTATION DEFINED, but is not smaller than 1KByte.  Note
This implies that the maximum memory-mapped peripheral size for which
the architecture guarantees order for all implementations is 1KB."  See
page A3-148.

What this means (to me at least) is that on any SoC, the architecture
guarantees that accesses _within_ a 1KB device memory block will always
be ordered, but two accesses outside of a 1KB block _to the same device_
is implementation defined whether it is ordered or not.

The interesting point here though is that the "note" contradicts the
first definition if you have (eg) AMBA Primecell peripherals which are
generally 4KB in size, since if the architecture only guarantees 1KB,
then accesses _may_ _not_ arrive at one primecell in program order.
Hence, the note is a direct contradiction of the first definition.
