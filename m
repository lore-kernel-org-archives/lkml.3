Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaDOImM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:42:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:27774 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaDOImE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="520997421"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Thierry Reding <thierry.reding@gmail.com>, Alan Cox <alan@linux.intel.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] pwm_lpss: Add support for PCI devices
Thread-Topic: [PATCH] pwm_lpss: Add support for PCI devices
Thread-Index: AQHPVhP1bci2OBKO+kqYMQwhKouSaZsQQdqAgAIV6mA=
Date: Tue, 15 Apr 2014 08:41:02 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA01570E28@PGSMSX103.gar.corp.intel.com>
References: <1397311131-13371-1-git-send-email-chiau.ee.chew@intel.com>
 <20140414081805.GI19349@intel.com>
In-Reply-To: <20140414081805.GI19349@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > +static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
> > +			struct resource *r, struct pwm_lpss_boardinfo *info)
> >  {
> >  	struct pwm_lpss_chip *lpwm;
> > -	struct resource *r;
> >  	int ret;
> >
> > -	lpwm = devm_kzalloc(&pdev->dev, sizeof(*lpwm), GFP_KERNEL);
> > +	lpwm = devm_kzalloc(dev, sizeof(*lpwm), GFP_KERNEL);
> >  	if (!lpwm)
> > -		return -ENOMEM;
> > -
> > -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +		return ERR_PTR(-ENOMEM);
> >
> > -	lpwm->regs = devm_ioremap_resource(&pdev->dev, r);
> > +	lpwm->regs = devm_ioremap_resource(dev, r);
> >  	if (IS_ERR(lpwm->regs))
> > -		return PTR_ERR(lpwm->regs);
> > -
> > -	lpwm->clk = devm_clk_get(&pdev->dev, NULL);
> > -	if (IS_ERR(lpwm->clk)) {
> > -		dev_err(&pdev->dev, "failed to get PWM clock\n");
> > -		return PTR_ERR(lpwm->clk);
> > +		return lpwm->regs;
> > +
> > +	if (info) {
> > +		lpwm->clk_rate = info->clk_rate;
> > +	} else {
> > +		lpwm->clk = devm_clk_get(dev, NULL);
> > +		if (IS_ERR(lpwm->clk)) {
> > +			dev_err(dev, "failed to get PWM clock\n");
> > +			return (void *)lpwm->clk;
> 
> Why the cast here?

Alan, please do correct me if I describe wrongly on the purpose that you add the cast here.

As you can see, pwm_lpss_probe() is expected to return a pointer of type struct pwm_lpss_chip.  On the other hand,   
the return of devm_clk_get() would be a pointer of type struct clk. So if were to use lpwm->clk as the return value of pwm_lpss_probe() , 
a cast would be needed since the pointer type is different from the expected one. The compiler would complain on " warning: return from incompatible pointer type"
if without the cast.

> > +
> > +static struct pci_device_id pwm_lpss_pci_ids[] = {
> > +	{ PCI_VDEVICE(INTEL, 0x0F08), (unsigned long)&byt_info},
> > +	{ PCI_VDEVICE(INTEL, 0x0F09), (unsigned long)&byt_info},
> 
> I think non-capital letters for hex numbers are more consistent. I.e 0x0f08.
> 

Ok. Noted.

> > +	{ 0,}
> 
> { },
> 
> as in the platform part looks better, IMO.

Ok. Noted.

> 
> > +};
> > +MODULE_DEVICE_TABLE(pci, pwm_lpss_pci_ids);
> > +
> > +static struct pci_driver pwm_lpss_driver_pci = {
> > +	.name	= "pwm-lpss",
> > +	.id_table	= pwm_lpss_pci_ids,
> 
> The platform part doesn't use tabs, so I think you should follow the style here.
> 

Ok. Noted

> >
> >  MODULE_DESCRIPTION("PWM driver for Intel LPSS");
> MODULE_AUTHOR("Mika
> > Westerberg <mika.westerberg@linux.intel.com>");
> >  MODULE_LICENSE("GPL v2");
> >  MODULE_ALIAS("platform:pwm-lpss");
> > +
> > +module_init(pwm_init);
> > +module_exit(pwm_exit);
> 
> Maybe move these to follow the function defitions, like:
> 
> pwm_init()
> {
> }
> module_init(pwm_init);
> 
> and so on.

Ok. Noted.
