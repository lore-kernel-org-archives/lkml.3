Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab3BLKkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:40:03 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44341 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932920Ab3BLKj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:39:57 -0500
Date: Tue, 12 Feb 2013 10:39:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Suman Anna <s-anna@ti.com>
Cc: Greg Kroah-Hartman <greg@linuxfoundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>, Tejun Heo <tj@kernel.org>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Loic Pallardy <loic.pallardy@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 10/13] mailbox: create dbx500 mailbox driver
Message-ID: <20130212103949.GA826@e106331-lin.cambridge.arm.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
 <1360645032-9668-11-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
In-Reply-To: <1360645032-9668-11-git-send-email-s-anna@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 Feb 2013 10:39:52.0788 (UTC) FILETIME=[4A680940:01CE090D]
X-MC-Unique: 113021210395501501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a few comments on the devicetree binding and the way it's parsed.

> +static const struct of_device_id dbx500_mailbox_match[] = {
> +       { .compatible = "stericsson,db8500-mailbox",
> +               .data = (void *)db8500_mboxes,
> +       },
> +       { .compatible = "stericsson,db9540-mailbox",
> +               .data = (void *)dbx540_mboxes,
> +       },
> +       { /* sentinel */}
> +};
> +

The binding for the compatible strings above and property parsing below should
be documented.

> +static int dbx500_mbox_probe(struct platform_device *pdev)
> +{
> +       const struct platform_device_id *platid = platform_get_device_id(pdev);
> +       struct resource *mem;
> +       int ret, i, legacy_offset = 0, upap_offset;
> +       struct mailbox **list;
> +       int irq;
> +       struct dbx500_plat_data *pdata = dev_get_platdata(&pdev->dev);
> +       struct device_node *np = pdev->dev.of_node;
> +
> +       if (!pdata) {
> +               if (np) {
> +                       of_property_read_u32(np, "legacy-offset",
> +                                                       &legacy_offset);

I see that legacy_offset is initialised to 0, and there's no check on the
return value of of_property_read_u32. Does that mean this is an optional
property? This needs to be documented.

> +                       of_property_read_u32(np, "upap-offset", &upap_offset);

However, upap_offset isn't initialised, but there's no check on the return
value. If "upap-offset" isn't defined in the dt, upap_offset won't have been
initialised. 

Is there no basic sanity checking that could be done here? I assume there's a
maximum offset we expect that's less than 4GB?

Additionally, of_property_read_u32 takes a *u32, not *int. It would be nice to
be consistent with the interface.

I'm not familiar with the hardware. What's the difference between the legacy
and upap cases?

> +                       list = (struct mailbox **)of_match_device(
> +                                       dbx500_mailbox_match, &pdev->dev)->data;
> +                       if (!list) {
> +                               /* No mailbox configuration */
> +                               dev_err(&pdev->dev, "No configuration found\n");
> +                               return -ENODEV;
> +                       }
> +               } else {
> +                       /* No mailbox configuration */
> +                       dev_err(&pdev->dev, "No configuration found\n");
> +                       return -ENODEV;
> +               }
> +       } else {
> +               list = (struct mailbox **)platid->driver_data;
> +               legacy_offset = pdata->legacy_offset;
> +               upap_offset = pdata->upap_offset;
> +       }
> +
> +       mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, "prcm_reg");

Does this work for dt? I wasn't aware we got anything more than anonymous
memory and interrupts.

> +       mbox_base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
> +       if (!mbox_base) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +
> +       mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, "prcmu_tcdm");

Same here.

Thanks,
Mark.

