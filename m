Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaAGJtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:49:22 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:36952 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaAGJtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:49:17 -0500
X-Greylist: delayed 2781 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 04:49:17 EST
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Tue, 07 Jan 2014 17:48:44 +0800
From: Rongjun Ying <Rongjun.Ying@csr.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, RongJun Ying <rjying@gmail.com>
CC: MyungJoo Ham <myungjoo.ham@samsung.com>, Barry Song <Barry.Song@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <DL-SHA-WorkGroupLinux@internal.csr.com>
Subject: RE: [PATCH v3] extcon: gpio: Add power resume support
Thread-Topic: [PATCH v3] extcon: gpio: Add power resume support
Thread-Index: AQHPC2TkU7ruPkVVDUCHKYgL3zVs/pp4QHqAgADDjHA=
Date: Tue, 7 Jan 2014 09:48:43 +0000
Message-ID: <86130EF012BDF348AA0D464A4F449478012AC8692C@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1389070590-3139-1-git-send-email-rongjun.ying@csr.com>
 <52CB9989.9010609@samsung.com>
In-Reply-To: <52CB9989.9010609@samsung.com>
Accept-Language: zh-CN, en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.5.123]
MIME-Version: 1.0
Content-Language: zh-CN
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Chanwoo Choi [mailto:cw00.choi@samsung.com]
> Sent: Tuesday, January 07, 2014 2:07 PM
> To: RongJun Ying
> Cc: MyungJoo Ham; Barry Song; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; DL-SHA-WorkGroupLinux; Rongjun Ying
> Subject: Re: [PATCH v3] extcon: gpio: Add power resume support
> 
> This patch has conflict as following:
> You have to implement extcon patch based mainline extcon-next branch.
> 
> Applying: extcon: gpio: Add power resume support
> error: patch failed: drivers/extcon/extcon-gpio.c:103
> error: drivers/extcon/extcon-gpio.c: patch does not apply Patch failed
> at 0001 extcon: gpio: Add power resume support The copy of the patch
> that failed is found in:
>    /home/cwchoi00/kernel/git.kernel/extcon/.git/rebase-apply/patch
> When you have resolved this problem, run "git am --resolved".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> 
> This time, I will manually apply this patch on extcon branch.
> 
> Thanks,
> Chanwoo Choi
> 
Thank you.

RongJun Ying

> On 01/07/2014 01:56 PM, RongJun Ying wrote:
> > From: Rongjun Ying <rongjun.ying@csr.com>
> >
> > When system on the suspend state, Some SoC can't get gpio interrupt.
> > After system resume, need send extcon uevent to userspace.
> >
> > Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> > Reviewed-by: Barry Song <Baohua.Song@csr.com>
> > ---
> >  -v3:
> >  'check_on_resume' instead of 'load_sleep_irq' as Chanwoo Choi's
> proposal.
> >
> >  drivers/extcon/extcon-gpio.c       |   20 ++++++++++++++++++++
> >  include/linux/extcon/extcon-gpio.h |    1 +
> >  2 files changed, 21 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/extcon/extcon-gpio.c
> > b/drivers/extcon/extcon-gpio.c index 7e0dff5..fde52c1 100644
> > --- a/drivers/extcon/extcon-gpio.c
> > +++ b/drivers/extcon/extcon-gpio.c
> > @@ -40,6 +40,7 @@ struct gpio_extcon_data {
> >  	int irq;
> >  	struct delayed_work work;
> >  	unsigned long debounce_jiffies;
> > +	bool check_on_resume;
> >  };
> >
> >  static void gpio_extcon_work(struct work_struct *work) @@ -103,6
> > +104,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
> >  	extcon_data->gpio_active_low = pdata->gpio_active_low;
> >  	extcon_data->state_on = pdata->state_on;
> >  	extcon_data->state_off = pdata->state_off;
> > +	extcon_data->check_on_resume = pdata->check_on_resume;
> >  	if (pdata->state_on && pdata->state_off)
> >  		extcon_data->edev.print_state = extcon_gpio_print_state;
> >  	if (pdata->debounce) {
> > @@ -159,12 +161,30 @@ static int gpio_extcon_remove(struct
> platform_device *pdev)
> >  	return 0;
> >  }
> >
> > +#ifdef CONFIG_PM_SLEEP
> > +static int gpio_extcon_resume(struct device *dev) {
> > +	struct gpio_extcon_data *extcon_data;
> > +
> > +	extcon_data = dev_get_drvdata(dev);
> > +	if (extcon_data->check_on_resume)
> > +		queue_delayed_work(system_power_efficient_wq,
> > +			&extcon_data->work, extcon_data->debounce_jiffies);
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static const struct dev_pm_ops gpio_extcon_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume) };
> > +
> >  static struct platform_driver gpio_extcon_driver = {
> >  	.probe		= gpio_extcon_probe,
> >  	.remove		= gpio_extcon_remove,
> >  	.driver		= {
> >  		.name	= "extcon-gpio",
> >  		.owner	= THIS_MODULE,
> > +		.pm = &gpio_extcon_pm_ops,
> >  	},
> >  };
> >
> > diff --git a/include/linux/extcon/extcon-gpio.h
> > b/include/linux/extcon/extcon-gpio.h
> > index 4195810..c7f0c3e 100644
> > --- a/include/linux/extcon/extcon-gpio.h
> > +++ b/include/linux/extcon/extcon-gpio.h
> > @@ -51,6 +51,7 @@ struct gpio_extcon_platform_data {
> >  	/* if NULL, "0" or "1" will be printed */
> >  	const char *state_on;
> >  	const char *state_off;
> > +	bool check_on_resume;
> >  };
> >
> >  #endif /* __EXTCON_GPIO_H__ */
> > --
> > 1.7.5.4
> >
> >
> 
> 
> 
>  To report this email as spam click
> https://www.mailcontrol.com/sr/MZbqvYs5QwJvpeaetUwhCQ==
> BhEym36W00netVd8YYrcUQrAnqreWejYcysfmF8UmgH1OQ== .


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Keep up to date with CSR on our technical blog, www.csr.com/blog, CSR people blog, www.csr.com/people, YouTube, www.youtube.com/user/CSRplc, Facebook, www.facebook.com/pages/CSR/191038434253534, or follow us on Twitter at www.twitter.com/CSR_plc.
New for 2014, you can now access the wide range of products powered by aptX at www.aptx.com.
