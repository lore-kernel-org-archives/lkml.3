Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaCUULX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:11:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:44541 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbaCUULT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,705,1389772800"; 
   d="scan'208";a="477597593"
Date: Fri, 21 Mar 2014 16:11:09 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: liaohengquan1986 <liaohengquan1986@163.com>
Cc: "Alexander Gordeev" <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        "Keith Busch" <keith.busch@intel.com>, linux-nvme@lists.infradead.org
Subject: Re: A question about NVMe's nvme-irq
Message-ID: <20140321201109.GC5705@linux.intel.com>
References: <cover.1390897693.git.agordeev@redhat.com>
 <20140311150841.GA25564@dhcp-26-207.brq.redhat.com>
 <196070e8.d690.144bb7e553f.Coremail.liaohengquan1986@163.com>
 <20140313192045.GD6091@linux.intel.com>
 <785daaf7.5696.144e2af49b0.Coremail.liaohengquan1986@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <785daaf7.5696.144e2af49b0.Coremail.liaohengquan1986@163.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 11:29:02AM +0800, liaohengquan1986 wrote:
> hello,
>          There is question confusing me recently. In the function of nvme-irq as belows:
>           static irqreturn_t nvme_irq(int irq, void *data)
>           {
>                  irqreturn_t result;
>                  struct nvme_queue *nvmeq = data;
>                  spin_lock(&nvmeq->q_lock);
>                  nvme_process_cq(nvmeq);
>                  result = nvmeq->cqe_seen ? IRQ_HANDLED : IRQ_NONE;
>                  nvmeq->cqe_seen = 0;
>                  spin_unlock(&nvmeq->q_lock);
>                  return result;
>        }
>        If there are two cqes which trigger two irqs, but they are so closed that the first nvme-irq() handles both the cqes( including the second cqe which triggers the second irq),
>       then the second nvme_process_cq() will find there is no cqe in the CQ and return nvmeq->cqe_seen = 0, and nvme-irq will return IRQ_NONE.
>       I think maybe this is a bug, because there actually are two irqs, it's not right to return IRQ_NONE, isn't it?

        /* If the controller ignores the cq head doorbell and continuously
         * writes to the queue, it is theoretically possible to wrap around
         * the queue twice and mistakenly return IRQ_NONE.  Linux only
         * requires that 0.1% of your interrupts are handled, so this isn't
         * a big problem.
         */

I should probably update & move that comment, but nevertheless, it
applies to your situation too.

> 
