Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbbAIDHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:07:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:43607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbbAIDHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:07:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,727,1413270000"; 
   d="scan'208";a="634674812"
Message-ID: <54AF45E0.2080803@linux.intel.com>
Date: Fri, 09 Jan 2015 11:07:12 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] genirq: Make irqchip flags work with stacked irq
 domains
References: <1420738365-22063-1-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1420738365-22063-1-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/9 1:32, Marc Zyngier wrote:
> With the landing of stacked irq domains in 3.19, we have ended up in a
> situation where we have a stack of IRQ controllers, each with their
> set of flags, but the core code is only able to look at the top-most,
> which is not very helpful. This small series is trying to fix this.
> 
> The first patch converts all access to desc->irq_data.chip->flags to
> using an accessor, without changing anything else. The second patch
> adds some logic to combine these flags as we allocate the interrupts,
> ultimately storing the resulting set as part of the irq_desc
> structure.
> 
> We end-up with a configuration where the flags can either be located
> in the irq_chip structure (non stacked case), or in the irq_desc
> (stacked case). While this isn't really ideal, this gives at least the
> right level of information to the rest of the IRQ framework.
Hi Mark,
	By this way, we need to aggregate irq_chip flags for every
irq. How about changing irq_desc_get_chip_flags(struct irq_desc *desc)
to irq_desc_check_chip_flags(struct irq_desc *desc, unsigned int flags)
which dynamically walks the stacked irqchips?
Thanks!
Gerry

> 
> Based on 3.19-rc3, and available at:
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/stacked-irqchip-flags
> 
> Marc Zyngier (2):
>   genirq: Abstract access to irq_chip flags
>   genirq: Allow irq_desc to carry the union of stacked irq_chip flags
> 
>  include/linux/irq.h     |  4 ++++
>  include/linux/irqdesc.h | 12 ++++++++++++
>  kernel/irq/chip.c       | 10 +++++-----
>  kernel/irq/irqdesc.c    |  3 +++
>  kernel/irq/irqdomain.c  | 20 +++++++++++++++++++-
>  kernel/irq/manage.c     |  6 +++---
>  kernel/irq/pm.c         |  2 +-
>  7 files changed, 47 insertions(+), 10 deletions(-)
> 
