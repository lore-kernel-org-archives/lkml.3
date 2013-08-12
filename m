Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3HLSaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:30:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51088 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358Ab3HLSaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:30:22 -0400
Date: Mon, 12 Aug 2013 19:29:42 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 1/3] ARM: Introduce atomic MMIO clear/set
Message-ID: <20130812182942.GA28695@mudshark.cambridge.arm.com>
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1376138582-7550-2-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376138582-7550-2-git-send-email-ezequiel.garcia@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 01:43:00PM +0100, Ezequiel Garcia wrote:
> Some SoC have MMIO regions that are shared across orthogonal
> subsystems. This commit implements a possible solution for the
> thread-safe access of such regions through a spinlock-protected API
> with clear-set semantics.
> 
> Concurrent access is protected with a single spinlock for the
> entire MMIO address space. While this protects shared-registers,
> it also serializes access to unrelated/unshared registers.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

[...]

> +void atomic_io_clear_set(void __iomem *reg, u32 clear, u32 set)
> +{
> +	spin_lock(&__io_lock);
> +	writel((readl(reg) & ~clear) | set, reg);
> +	spin_unlock(&__io_lock);
> +}

I appreciate that you've lifted this code from a previous driver, but this
doesn't really make any sense to me. The spin_unlock operation is
essentially a store to normal, cacheable memory, whilst the writel is an
__iowmb followed by a store to device memory.

This means that you don't have ordering guarantees between the two accesses
outside of the CPU, potentially giving you:

	spin_lock(&__io_lock);
	spin_unlock(&__io_lock);
	writel((readl(reg) & ~clear) | set, reg);

which is probably not what you want.

I suggest adding an iowmb after the writel if you really need this ordering
to be enforced (but this may have a significant performance impact,
depending on your SoC).

Will
