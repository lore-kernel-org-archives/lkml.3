Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaINHdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 03:33:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57198 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaINHdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 03:33:31 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] RFC: add function for localbus address
To: Stephen Boyd <sboyd@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Rob Herring <rob.herring@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>
In-Reply-To: <540E1014.8090102@codeaurora.org>
References: <20140729234522.E9FF1C40738@trevor.secretlab.ca>
	<1409672700-21697-1-git-send-email-svarbanov@mm-sol.com>
	<20140908145204.8ADC2C40AE5@trevor.secretlab.ca>
	<540E1014.8090102@codeaurora.org>
Date: Sat, 13 Sep 2014 21:46:10 -0700
Message-Id: <20140914044610.913E9C4102A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2014 13:22:44 -0700, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Adding Mark Brown who finished off introducing IORESOURCE_REG.
> 
> On 09/08/14 07:52, Grant Likely wrote:
> > On Tue,  2 Sep 2014 18:45:00 +0300, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
> >> +
> >>  unsigned long __weak pci_address_to_pio(phys_addr_t address)
> >>  {
> >>  	if (address > IO_SPACE_LIMIT)
> >> @@ -665,6 +691,29 @@ int of_address_to_resource(struct device_node *dev, int index,
> >>  }
> >>  EXPORT_SYMBOL_GPL(of_address_to_resource);
> >>  
> >> +int of_localbus_address_to_resource(struct device_node *dev, int index,
> >> +				    struct resource *r)
> >> +{
> >> +	const char *name = NULL;
> >> +	const __be32 *addrp;
> >> +	u64 size;
> >> +
> >> +	addrp = of_get_localbus_address(dev, index, &size);
> >> +	if (!addrp)
> >> +		return -EINVAL;
> >> +
> >> +	of_property_read_string_index(dev, "reg-names", index, &name);
> >> +
> >> +	memset(r, 0, sizeof(*r));
> >> +	r->start = be32_to_cpup(addrp);
> >> +	r->end = r->start + size - 1;
> >> +	r->flags = IORESOURCE_REG;
> > This is problematic. A resource is created, but there is absolutely no
> > indication that the resource represents a localbus address instead of a
> > CPU address. platform_device reg resources represent CPU addresses.
> > Trying to overload it will cause confusion in drivers.
> >
> >> +	r->name = name ? name : dev->full_name;
> >> +
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(of_localbus_address_to_resource);
> >> +
> >>  struct device_node *of_find_matching_node_by_address(struct device_node *from,
> >>  					const struct of_device_id *matches,
> >>  					u64 base_address)
> >> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> >> index 0197725..36dcbd7 100644
> >> --- a/drivers/of/platform.c
> >> +++ b/drivers/of/platform.c
> >> @@ -106,8 +106,9 @@ struct platform_device *of_device_alloc(struct device_node *np,
> >>  				  struct device *parent)
> >>  {
> >>  	struct platform_device *dev;
> >> -	int rc, i, num_reg = 0, num_irq;
> >> +	int rc, i, num_reg = 0, num_localbus_reg = 0, num_irq;
> >>  	struct resource *res, temp_res;
> >> +	int num_resources;
> >>  
> >>  	dev = platform_device_alloc("", -1);
> >>  	if (!dev)
> >> @@ -116,22 +117,33 @@ struct platform_device *of_device_alloc(struct device_node *np,
> >>  	/* count the io and irq resources */
> >>  	while (of_address_to_resource(np, num_reg, &temp_res) == 0)
> >>  		num_reg++;
> >> +
> >> +	while (of_localbus_address_to_resource(np,
> >> +					num_localbus_reg, &temp_res) == 0)
> >> +		num_localbus_reg++;
> >> +
> > No, I don't support doing this. The moment a platform_driver depends on
> > a local bus address it is doing something special. It needs to decode
> > its own address in that case, which it can easily do.
> >
> > Any platform_driver that interprets a IORESOURCE_REG as a localbus
> > address instead of a CPU address is *BROKEN*. It should be changed to
> > either decode the address itself, of a new bus type should be created
> > that can make its own decisions about what address resources mean.
> 
> Where is this described? From the commit text that introduces
> IORESOURCE_REG I see:
> 
> "Currently a bunch of I2C/SPI MFD drivers are using IORESOURCE_IO for
> register address ranges. Since this causes some confusion due to the
> primary use of this resource type for PCI/ISA I/O ports create a new
> resource type IORESOURCE_REG."

Sorry, I mistook IORESOURCE_REG or IORESOURCE_IO. You're right, this
isn't an issue.

I'm still concerned about the implications of automatically populating
platform_devices with this resource type. I'll talk to Mark about it
face to fact at Connect this week.

g.

