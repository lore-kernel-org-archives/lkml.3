Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab3BLUCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:02:38 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:43878 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932369Ab3BLUCh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:02:37 -0500
From: Loic PALLARDY <loic.pallardy@st.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Suman Anna <s-anna@ti.com>, Greg Kroah-Hartman <greg@linuxfoundation.org>,
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
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 12 Feb 2013 21:01:05 +0100
Subject: Re: [PATCH v2 10/13] mailbox: create dbx500 mailbox driver
Thread-Topic: [PATCH v2 10/13] mailbox: create dbx500 mailbox driver
Thread-Index: Ac4JW7Ko7wBE32FwQqGWtDfuuQ2Jvw==
Message-ID: <511A9F81.1040608@st.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
 <1360645032-9668-11-git-send-email-s-anna@ti.com>
 <20130212103949.GA826@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130212103949.GA826@e106331-lin.cambridge.arm.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for your comments.

On 02/12/2013 11:39 AM, Mark Rutland wrote:
> Hello,
>
> I have a few comments on the devicetree binding and the way it's parsed.
>
>> +static const struct of_device_id dbx500_mailbox_match[] = {
>> +       { .compatible = "stericsson,db8500-mailbox",
>> +               .data = (void *)db8500_mboxes,
>> +       },
>> +       { .compatible = "stericsson,db9540-mailbox",
>> +               .data = (void *)dbx540_mboxes,
>> +       },
>> +       { /* sentinel */}
>> +};
>> +
>
> The binding for the compatible strings above and property parsing below should
> be documented.
>
Yes you're right. I will add a description in 
Documentation/devicetree/bindings/mailbox/...

>> +static int dbx500_mbox_probe(struct platform_device *pdev)
>> +{
>> +       const struct platform_device_id *platid = platform_get_device_id(pdev);
>> +       struct resource *mem;
>> +       int ret, i, legacy_offset = 0, upap_offset;
>> +       struct mailbox **list;
>> +       int irq;
>> +       struct dbx500_plat_data *pdata = dev_get_platdata(&pdev->dev);
>> +       struct device_node *np = pdev->dev.of_node;
>> +
>> +       if (!pdata) {
>> +               if (np) {
>> +                       of_property_read_u32(np, "legacy-offset",
>> +&legacy_offset);
>
> I see that legacy_offset is initialised to 0, and there's no check on the
> return value of of_property_read_u32. Does that mean this is an optional
> property? This needs to be documented.
>
Correct, I'll add a check. This offset must be compared to shared memory 
size.

>> +                       of_property_read_u32(np, "upap-offset",&upap_offset);
>
> However, upap_offset isn't initialised, but there's no check on the return
> value. If "upap-offset" isn't defined in the dt, upap_offset won't have been
> initialised.
Should be documented too. upap_offset is optional since not supported by 
all STE platforms.
Anyway, value must be checked when used.
>
> Is there no basic sanity checking that could be done here? I assume there's a
> maximum offset we expect that's less than 4GB?
>
> Additionally, of_property_read_u32 takes a *u32, not *int. It would be nice to
> be consistent with the interface.
OK
>
> I'm not familiar with the hardware. What's the difference between the legacy
> and upap cases?
Same HW, but different way to access and manage shared memory.
Link to coprocessor firmware version.
>
>> +                       list = (struct mailbox **)of_match_device(
>> +                                       dbx500_mailbox_match,&pdev->dev)->data;
>> +                       if (!list) {
>> +                               /* No mailbox configuration */
>> +                               dev_err(&pdev->dev, "No configuration found\n");
>> +                               return -ENODEV;
>> +                       }
>> +               } else {
>> +                       /* No mailbox configuration */
>> +                       dev_err(&pdev->dev, "No configuration found\n");
>> +                       return -ENODEV;
>> +               }
>> +       } else {
>> +               list = (struct mailbox **)platid->driver_data;
>> +               legacy_offset = pdata->legacy_offset;
>> +               upap_offset = pdata->upap_offset;
>> +       }
>> +
>> +       mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, "prcm_reg");
>
> Does this work for dt? I wasn't aware we got anything more than anonymous
> memory and interrupts.
>
Yes this is working with and without dt.
dt declaration will be the following
mailbox {
	compatible = "stericsson,db8500-mailbox";
	reg = <0x80157000 0x1000>, <0x801B8000 0x2000>;
	reg-names = "prcm-reg", "prcmu-tcdm";
	interrupts = <0 47 0x4>;
	interrupt-names = "irq";
	legacy-offset = <0xdd4>;
};

>> +       mbox_base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
>> +       if (!mbox_base) {
>> +               ret = -ENOMEM;
>> +               goto out;
>> +       }
>> +
>> +       mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, "prcmu_tcdm");
>
> Same here.
>
> Thanks,
> Mark.
>
Regards,
Loic