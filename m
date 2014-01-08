Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbaAHUJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:09:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63257 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098AbaAHUJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:09:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] driver-core: platform: Resolve DT interrupt references late
Date: Wed, 08 Jan 2014 21:09:17 +0100
Message-ID: <14122609.M29raBct1E@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140108195909.GB1298@ulmo.nvidia.com>
References: <20140108011957.GK5074@atomide.com> <201401081725.17876.arnd@arndb.de> <20140108195909.GB1298@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HHc8/BBtGU8DjmMN/5wDY0AzYwYrDqghmJobaaRjgxm
 e/mikTdKMecVWLfh/t74Y3reDiBmvwUbqepViQEGvLctSEq8ai
 0rrs0xtw5/GuWS0V6EyFk535fN0IW8vQOEFszucZf8HUNXQ85Y
 +q6qJTCI/W6HtQdAXyhHD62UYRRivuuvwGxvhqGcyakOCG4Y66
 qV/IOnaxwe8+0kdbDiX/FfhxN7SrnkWSCtiG9pS0hcJkzf5wy/
 aWGS1zcOyyhvYfMx8aZ9ZmXHsq6IsxlasembpSkwixNKXZWi1D
 syb9Bz8d4SOd24ObCijKaGZu8SyzJ3DtgK7qm30ACZnSoC6kKO
 iFgioPa20qAm9KU/UGTY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 20:59:10 Thierry Reding wrote:
> On Wed, Jan 08, 2014 at 05:25:17PM +0100, Arnd Bergmann wrote:
> > On Wednesday 08 January 2014, Thierry Reding wrote:
> > > On Wed, Jan 08, 2014 at 04:11:08PM +0100, Arnd Bergmann wrote:
> > The more I think about the iommu case, the more I am convinced that it
> > does belong into the core, in whatever form we can find. As far as I
> > can tell from the little reliable information I have on the topic, I
> > would assume that we can keep it in the DT probing code, as there won't
> > be a need for multiple arbitrary IOMMUs with ACPI or with board files.
> 
> I think part of the problem is that we don't have any DT probing code
> yet. of_platform_probe() would have been that code. Perhaps if you weigh
> in Grant and Greg will reconsider.

For all I know, we don't even have a binding proposal, but I may
have missed that.

> > Good point, I forgot about the special case for i2c_client->irq.
> > I looked now and noticed that very few i2c devices actually use this
> > field, but larger number uses platform_data, which has a similar
> > problem.
> 
> Yeah. It's kind of messy. The more I think about it, the more I begin to
> like the lookup table option. One big advantage of that is that we could
> actually unify much of the lookup code, much like we do for other types
> of resources. It's a pattern that has worked fairly well in a number of
> cases, so it seems natural to use it for interrupts as well.
> 
> An even more extreme option would be to go all the way and introduce
> struct irq, along the same lines of the new struct gpiod. That would
> allow nice things such as storing trigger types and such within the IRQ
> handle and propagate them automatically.

We already have struct irq_desc, and I believe everybody who works
with interrupts supports migrating from irq number interfaces to
irq descriptors as soon as we can find someone willing to do that
work.
 
> > No trivial solution that I can see. I think we can deal with the case
> > where platform code uses platform_device->resources, and everything else
> > comes down to having multiple code branches in the driver, as we already
> > have to deal with platform_data and DT properties describing stuff that
> > doesn't fit in the resources.
> 
> That would be another argument in favour of the lookup table. It would
> provide a unified mechanism to define static interrupts if no firmware
> interface is available *independent* of the device type. You could have
> something like:
> 
> 	static const struct irq_lookup board_irq_lookup[] = {
> 		IRQ_LOOKUP("gpio", 0, "0-0040", NULL), /* I2C client via GPIO expander */
> 		IRQ_LOOKUP("intc", 0, "ehci.1", NULL), /* platform device via INTC */
> 	};
> 
> Along with:
> 
> 	struct irq *irq_get(struct device *dev, const char *con_id);
> 
> To look it up via DT, ACPI, lookup table. That obviously means a more or
> less complete change in how interrupts are handled in the kernel, and it
> may not be worth it in the end.

It would certainly need a long migration period, and a plan for how to
get there without breaking things in the meantime. Rather than a lookup
table like the kind we have for clocks, I'd prefer a general way to
attach named properties to devices. My feeling is that building upon
devres would be a good plan, since it already provides a way to attach
arbitrary data to a device.

	Arnd

