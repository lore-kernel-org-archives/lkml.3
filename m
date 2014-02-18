Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaBRA7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:59:35 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:34220 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaBRA7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:59:33 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1401222241100.24986@ionos.tec.linutronix.de>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
	<1388707565-16535-3-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1401222241100.24986@ionos.tec.linutronix.de>
Date: Mon, 17 Feb 2014 16:59:32 -0800
X-Google-Sender-Auth: Qm4j__CmYepYAFNBONR0xrmj2JE
Message-ID: <CAE9FiQUo9NGbjiZbMsf2yBFbn=iLJ-jc3QtZ8K6qwVuhmqzq=Q@mail.gmail.com>
Subject: Re: [PATCH v5 02/33] genirq: Add irq_alloc_reserved_desc()
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 4:03 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> There is a clear step by step approach to get this done proper:
>
>  1) Get rid of the existing misconception/misnomer of
>     irq_reserve_irqs().
>
>     Make it explicit that this is dealing with legacy irq spaces. It's
>     not that hard as there are only two users in tree which are both
>     trivial to fix.

Hi, Thomas,

While going through the code for kill irq_reserve_irqs(), I found that
there is irq_reserve_irq().

in include/linux/irq.h

static inline int irq_reserve_irq(unsigned int irq)
{
        return irq_reserve_irqs(irq, 1);
}

it is called via kernel/irq/chip.c::irq_set_chip().

        /*
         * For !CONFIG_SPARSE_IRQ make the irq show up in
         * allocated_irqs. For the CONFIG_SPARSE_IRQ case, it is
         * already marked, and this call is harmless.
         */
        irq_reserve_irq(irq);

There are tens of irq_set_chip... calling for arches that does not
support SPARSE_IRQ yet, and they does not use  irq_alloc_desc()
anywhere.

so how about change those irq_reserve_irq to irq_set_allocated_irqs() and
leave them there?

Thanks

Yinghai
