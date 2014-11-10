Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaKJLFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:05:40 -0500
Received: from mail-bn1on0118.outbound.protection.outlook.com ([157.56.110.118]:14706
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752703AbaKJLFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:05:34 -0500
X-Greylist: delayed 28890 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2014 06:05:34 EST
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dudley Du <dudley.dulixin@gmail.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v9 05/18] input: cyapa: add power management interfaces
 supported for the device
Thread-Topic: [PATCH v9 05/18] input: cyapa: add power management interfaces
 supported for the device
Thread-Index: AQHP90EgaU/9yUiFAU2YvDOwfCPzjpxZlMkAgAAXM8A=
Date: Mon, 10 Nov 2014 11:05:32 +0000
Message-ID: <aa6f4152f56041d0b3f010fb0cf21aa7@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
 <1415003590-30485-6-git-send-email-dudl@cypress.com>
 <20141110083806.GC39688@dtor-ws>
In-Reply-To: <20141110083806.GC39688@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
x-forefront-prvs: 039178EF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(13464003)(24454002)(51704005)(189002)(164054003)(51164003)(46102003)(87936001)(76576001)(2656002)(4396001)(21056001)(86362001)(54356999)(76176999)(50986999)(92566001)(31966008)(19580395003)(19580405001)(74316001)(108616004)(105586002)(106116001)(106356001)(95666004)(99286002)(97736003)(101416001)(33646002)(20776003)(64706001)(40100003)(66066001)(77096003)(77156002)(122556002)(62966003)(99396003)(120916001)(107046002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB069;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Dmity

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2014?11?10? 16:38
> To: Dudley Du
> Cc: rydberg@euromail.se; Dudley Du; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v9 05/18] input: cyapa: add power management interfaces
> supported for the device
>
> On Mon, Nov 03, 2014 at 04:32:57PM +0800, Dudley Du wrote:
> > Add suspend_scanrate_ms power management interfaces in device's
> > power group, so users or applications can control the power management
> > strategy of trackpad device as their requirements.
> > TEST=test on Chromebooks.
> >
> > Signed-off-by: Dudley Du <dudl@cypress.com>
> > ---
> >  drivers/input/mouse/cyapa.c | 112
> ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 112 insertions(+)
> >
> > diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> > index fac361a..420696d 100644
> > --- a/drivers/input/mouse/cyapa.c
> > +++ b/drivers/input/mouse/cyapa.c
> > @@ -505,6 +505,96 @@ u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode)
> >     : (encoded_time - 5) * 20;
> >  }
> >
> > +#ifdef CONFIG_PM_SLEEP
> > +static ssize_t cyapa_show_suspend_scanrate(struct device *dev,
> > +   struct device_attribute *attr,
> > +   char *buf)
> > +{
> > +struct cyapa *cyapa = dev_get_drvdata(dev);
> > +u8 pwr_cmd = cyapa->suspend_power_mode;
> > +u16 sleep_time;
> > +int len;
> > +int ret;
> > +
> > +ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
> > +if (ret)
> > +return ret;
> > +pwr_cmd = cyapa->suspend_power_mode;
> > +sleep_time = cyapa->suspend_sleep_time;
> > +mutex_unlock(&cyapa->state_sync_lock);
> > +
> > +if (pwr_cmd == PWR_MODE_BTN_ONLY)
> > +len = scnprintf(buf, PAGE_SIZE, "%s\n", BTN_ONLY_MODE_NAME);
> > +else if (pwr_cmd == PWR_MODE_OFF)
> > +len = scnprintf(buf, PAGE_SIZE, "%s\n", OFF_MODE_NAME);
> > +else {
> > +if (cyapa->gen == CYAPA_GEN3)
> > +sleep_time = cyapa_pwr_cmd_to_sleep_time(pwr_cmd);
> > +len = scnprintf(buf, PAGE_SIZE, "%u\n", sleep_time);
> > +}
> > +
> > +return len;
> > +}
> > +
> > +static u16 cyapa_clamp_sleep_time(u16 sleep_time)
> > +{
> > +if (sleep_time > 1000)
> > +sleep_time = 1000;
> > +return sleep_time;
> > +}
> > +
> > +static ssize_t cyapa_update_suspend_scanrate(struct device *dev,
> > +     struct device_attribute *attr,
> > +     const char *buf, size_t count)
> > +{
> > +struct cyapa *cyapa = dev_get_drvdata(dev);
> > +u16 sleep_time;
> > +int ret;
> > +
> > +ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
> > +if (ret)
> > +return ret;
> > +
> > +if (sysfs_streq(buf, BTN_ONLY_MODE_NAME))
> > +cyapa->suspend_power_mode = PWR_MODE_BTN_ONLY;
> > +else if (sysfs_streq(buf, OFF_MODE_NAME))
> > +cyapa->suspend_power_mode = PWR_MODE_OFF;
> > +else if (!kstrtou16(buf, 10, &sleep_time)) {
> > +cyapa->suspend_sleep_time = cyapa_clamp_sleep_time(sleep_time);
>
> I'd simply do
>
> cyapa->suspend_sleep_time = max_t(u16, sleep_time, 1000);
>
> here.

Thanks, applied.

>
> > +cyapa->suspend_power_mode =
> > +cyapa_sleep_time_to_pwr_cmd(cyapa->suspend_sleep_time);
> > +} else
> > +count = 0;
> > +
>
> If one branch uses curly braces then all branches shoudl use them, even
> if they contain only one statement.

Thanks, I will go through all code to follow this rule.

>
> > +mutex_unlock(&cyapa->state_sync_lock);
> > +if (!count)
> > +dev_err(dev, "invalid suspend scanrate ms parameters\n");
> > +return count ? count : -EINVAL;
> > +}
> > +
> > +static DEVICE_ATTR(suspend_scanrate_ms, S_IRUGO|S_IWUSR,
> > +   cyapa_show_suspend_scanrate,
> > +   cyapa_update_suspend_scanrate);
> > +
> > +static struct attribute *cyapa_power_wakeup_entries[] = {
> > +&dev_attr_suspend_scanrate_ms.attr,
> > +NULL,
> > +};
> > +
> > +static const struct attribute_group cyapa_power_wakeup_group = {
> > +.name = power_group_name,
> > +.attrs = cyapa_power_wakeup_entries,
> > +};
> > +
> > +static void cyapa_remove_power_wakeup_group(void *data)
> > +{
> > +struct cyapa *cyapa = data;
> > +
> > +sysfs_unmerge_group(&cyapa->client->dev.kobj,
> > +&cyapa_power_wakeup_group);
> > +}
> > +#endif /* CONFIG_PM_SLEEP */
> > +
> >  /*
> >   * Returns:
> >   *   0    Driver and device initialization successfully done.
> > @@ -588,6 +678,28 @@ static int cyapa_probe(struct i2c_client *client,
> >  return ret;
> >  }
> >
> > +#ifdef CONFIG_PM_SLEEP
> > +if (device_can_wakeup(dev)) {
> > +ret = sysfs_merge_group(&client->dev.kobj,
> > +&cyapa_power_wakeup_group);
> > +if (ret) {
> > +dev_err(dev, "failed to add power wakeup group, (%d)\n",
> > +ret);
> > +return ret;
> > +}
> > +
> > +ret = devm_add_action(dev,
> > +cyapa_remove_power_wakeup_group, cyapa);
> > +if (ret) {
> > +cyapa_remove_power_wakeup_group(cyapa);
> > +dev_err(dev,
> > +"failed to add power cleanup action, (%d)\n",
> > +ret);
> > +return ret;
> > +}
> > +}
> > +#endif /* CONFIG_PM_SLEEP */
> > +
> >  return 0;
> >  }
> >
> > --
> > 1.9.1
> >
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
