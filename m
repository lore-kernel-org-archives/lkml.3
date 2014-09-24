Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbaIXCYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 22:24:20 -0400
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:19904
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751020AbaIXCYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 22:24:19 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] watchdog: imx2_wdt: Add power management support.
Thread-Topic: [PATCH v2] watchdog: imx2_wdt: Add power management support.
Thread-Index: AQHP1ypr7flBG7hiJEa34lAIPUAFJZwO406AgACe9EA=
Date: Wed, 24 Sep 2014 02:24:15 +0000
Message-ID: <2f682a54aa71439bb8e4d04ff10ce49d@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411475513-2576-1-git-send-email-Li.Xiubo@freescale.com>
 <20140923160957.GB20591@roeck-us.net>
In-Reply-To: <20140923160957.GB20591@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;UriScan:;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(164054003)(189002)(51704005)(79102003)(80022003)(92566001)(4396001)(77982003)(81542003)(81342003)(76576001)(83072002)(85852003)(46102003)(110136001)(2656002)(87936001)(33646002)(74316001)(74502003)(74662003)(85306004)(107046002)(31966008)(64706001)(20776003)(83322001)(101416001)(66066001)(86362001)(54356999)(76176999)(108616004)(50986999)(95666004)(106116001)(105586002)(97736003)(120916001)(106356001)(76482002)(90102001)(77096002)(21056001)(99396002)(10300001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0646;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


[...]
> > +#ifdef CONFIG_PM_SLEEP
> > +/* Disable watchdog if it is active or non-active but still running */
> > +static int imx2_wdt_suspend(struct device *dev)
> > +{
> > +	struct watchdog_device *wdog = dev_get_drvdata(dev);
> > +	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
> > +
> > +	imx2_wdt_set_timeout(wdog, IMX2_WDT_MAX_TIME);
> > +	imx2_wdt_ping(wdog);
> 
> I am a bit concerned about this one. Why ping the watchdog if it is
> not running ? Shouldn't this only be done if the watchdog is running ?
>

Since the IMX2 watchdog will be always alive once started until power down
it.

Even not running, these code doesn't make any sense actually, and When probe,
the clock has been enabled, so we can feel safe of doing this.


> > +
> > +	/* Watchdog has been stopped but IP block is still running */
> > +	if (!watchdog_active(wdog) && imx2_wdt_is_running(wdev))
> > +		del_timer_sync(&wdev->timer);
> > +
> > +	/* If PM will be supported using imx2_wdt, please
> > +	 * make sure that the wdev->clk could disable the
> > +	 * watchdog's counter input clock source or can mask
> > +	 * watchdog's reset request to the core.
> > +	 */
> 
> As far as I know, the watchdog subsystem uses standard multi-line comments.
> 
Okay, I will revise this.

> I am not sure if such a comment in the code will help. People don't usually
> read code to find out why the watchdog resets the board in suspend even
> if it should not.
> 
> Can you detect this condition programmatically (presumably that the clock
> was stopped if I understand correctly) to ensure that it is met ?
> 

IMO, all the SoCs using this watchdog didn't support PM for now through the
watchdog reference manual document and the current driver, because once started,
we couldn't stop the counter decreasing down to zero without disabling the counter
clock. 

What we actually care about is disabling the input clock source for counter, if
We cannot disable this, the watchdog will reset the core when sleeping. Or if we
can gate the reset signal to the cores is also one good choice.
But these cannot be programmatically to be ensured using one common way for all
SoCs.


> > +	clk_disable_unprepare(wdev->clk);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Enable watchdog and configure it if necessary */
> > +static int imx2_wdt_resume(struct device *dev)
> > +{
> > +	struct watchdog_device *wdog = dev_get_drvdata(dev);
> > +	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
> > +
> > +	clk_prepare_enable(wdev->clk);
> > +
> > +	if (watchdog_active(wdog) && !imx2_wdt_is_running(wdev)) {
> > +		/* If watchdog is still used by consumers and
> > +		 * resumes from deep sleep state, need to
> > +		 * restart the watchdog again.
> > +		 */
> > +		imx2_wdt_setup(wdog);
> > +		imx2_wdt_set_timeout(wdog, wdog->timeout);
> > +		imx2_wdt_ping(wdog);
> > +	} else if (imx2_wdt_is_running(wdev)) {
> > +		imx2_wdt_set_timeout(wdog, wdog->timeout);
> > +		imx2_wdt_ping(wdog);
> > +		/* If watchdog has started --> stopped by the
> > +		 * consumers and resumes from non-deep sleep state,
> > +		 * then start the timer again.
> > +		 */
> > +		if (!watchdog_active(wdog))
> > +			mod_timer(&wdev->timer,
> > +				  jiffies + wdog->timeout * HZ / 2);
> > +	} else {
> > +		/* If watchdog has been started --> stopped by
> > +		 * the consumers and resumes from deep sleep state,
> > +		 * will do nothing. The watchdog will be restarted
> > +		 * by consumers next time to be used.
> > +		 */
> 
> I really dislike the notion of an else case just for a comment.
> It should be obvious that nothing needs to be done here if the watchdog
> is not running.
> 
Yes, I will remove this.


Thanks,

BRs
Xiubo


> > +	}
> > +
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static SIMPLE_DEV_PM_OPS(imx2_wdt_pm_ops, imx2_wdt_suspend,
> > +			 imx2_wdt_resume);
> > +
> >  static const struct of_device_id imx2_wdt_dt_ids[] = {
> >  	{ .compatible = "fsl,imx21-wdt", },
> >  	{ /* sentinel */ }
> > @@ -307,6 +372,7 @@ static struct platform_driver imx2_wdt_driver = {
> >  	.driver		= {
> >  		.name	= DRIVER_NAME,
> >  		.owner	= THIS_MODULE,
> > +		.pm     = &imx2_wdt_pm_ops,
> >  		.of_match_table = imx2_wdt_dt_ids,
> >  	},
> >  };
> > --
> > 2.1.0.27.g96db324
> >
