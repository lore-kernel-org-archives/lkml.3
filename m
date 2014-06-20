Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934802AbaFTQBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:01:15 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36663 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934166AbaFTQBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:01:14 -0400
Date: Fri, 20 Jun 2014 17:00:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, daniel.lezcano@linaro.org,
        tglx@linutronix.de, grant.likely@linaro.org, thierry.reding@gmail.com,
        florian.vaussard@epfl.ch, jic23@kernel.org, jason@lakedaemon.net,
        andrew@lunn.ch, silvio.fricke@gmail.com, heiko.stuebner@bq.com,
        olof@lixom.net, sebastian.hesselbarth@gmail.com, sboyd@codeaurora.org,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        shawn.guo@freescale.com, anders.berg@lsi.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9.1] of: Provide function to request and map memory
Message-ID: <20140620160022.GV32514@n2100.arm.linux.org.uk>
References: <1403264929-21325-2-git-send-email-matthias.bgg@gmail.com> <1403267328-23085-1-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403267328-23085-1-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:28:48PM +0200, Matthias Brugger wrote:
> +/*
> + * of_io_request_and_map - Requests a resource and maps the memory mapped IO
> + *			   for a given device_node
> + * @device:	the device whose io range will be mapped
> + * @index:	index of the io range
> + * @name:	name of the resource
> + *
> + * Returns a pointer to the requested and mapped memory
> + */
> +void __iomem *of_io_request_and_map(struct device_node *np, int index,
> +					char *name)
> +{
> +	struct resource res;
> +	void __iomem *mem;
> +
> +	if (of_address_to_resource(np, index, &res))
> +		return NULL;
> +
> +	if (!request_mem_region(res.start, resource_size(&res), name))
> +		return NULL;
> +
> +	mem = ioremap(res.start, resource_size(&res));
> +	if (!mem)
> +		release_mem_region(res.start, resource_size(&res));

We did this "return NULL" approach for devm_request_and_ioremap(), and
ended up not liking the number of drivers returning random error codes
on failure (despite the proper return code being documented.)  It's
worth reading the commit text for the commit introducing
devm_ioremap_resource() which replaces devm_request_and_ioremap():

commit 75096579c3ac39ddc2f8b0d9a8924eba31f4d920
Author: Thierry Reding <thierry.reding@avionic-design.de>
Date:   Mon Jan 21 11:08:54 2013 +0100

    lib: devres: Introduce devm_ioremap_resource()

which may help avoid repeating the same mistakes here.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
