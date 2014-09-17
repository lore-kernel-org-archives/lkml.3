Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbaIQU74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:59:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:51519 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbaIQU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:59:54 -0400
Date: Wed, 17 Sep 2014 13:58:55 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Part2 v1 02/21] genirq: Introduce helper functions to
 support stacked irq_chip
In-Reply-To: <5418FAE1.4030008@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409171244090.21313@nanos>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com> <1410444228-3134-3-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1409161044330.4247@nanos> <5418FAE1.4030008@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Jiang Liu wrote:
> On 2014/9/17 1:45, Thomas Gleixner wrote:
> > On Thu, 11 Sep 2014, Jiang Liu wrote:
> >> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> >> +void irq_chip_ack_parent(struct irq_data *data)
> >> +{
> >> +	data = data->parent_data;
> >> +	if (data && data->chip && data->chip->irq_ack)
> >> +		data->chip->irq_ack(data);
> > 
> > Why is this restricted to a single parent level and does not go down
> > the whole stack?
> Hi Thomas,
> 	It happens to work on x86, and we want to achieve a bit
> performance advantage by not walking down the whole stack.
> If preferred, I will change it to walk the whole stack.

Happens to work on my machine is always a bad argument :)

Now, I can see why you want to do that, but if we do an optimization
like that then we should really get rid of the conditional.

You surely need a conditional on data->chip and data->chip->callback
for a full stackq walk, but for an explicit request to use the parents
ack the parent better has a chip with an ack function, right?

void irq_chip_ack_parent(struct irq_data *data)
{
	data = data->parent_data;
	data->chip->irq_ack(data);
}

Thanks,

	tglx
