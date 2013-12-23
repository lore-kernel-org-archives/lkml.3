Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3LWOdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:33:50 -0500
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:13910
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757326Ab3LWOds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:33:48 -0500
From: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thermal: imx: correct suspend/resume flow
Thread-Topic: [PATCH] thermal: imx: correct suspend/resume flow
Thread-Index: AQHO/+s5if49m/8p3UadCBvO1u/L+pph2B83
Date: Mon, 23 Dec 2013 14:33:43 +0000
Message-ID: <C95204EE-D28A-4AB4-B60B-E7CAB8AC3B8E@freescale.com>
References: <1387831918-17028-1-git-send-email-b20788@freescale.com>,<20131223142931.GM26070@S2101-09.ap.freescale.net>
In-Reply-To: <20131223142931.GM26070@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [180.156.204.133]
x-forefront-prvs: 0069246B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(199002)(189002)(24454002)(51704005)(33656001)(87936001)(83716003)(85306002)(51856001)(63696002)(49866001)(46102001)(36756003)(76796001)(76786001)(87266001)(82746002)(90146001)(56816005)(81686001)(81816001)(19580405001)(19580395003)(83322001)(85852003)(83072002)(2656002)(80976001)(81342001)(69226001)(81542001)(74662001)(47446002)(79102001)(54316002)(56776001)(59766001)(77982001)(76482001)(74502001)(31966008)(53806001)(54356001)(4396001)(66066001)(74366001)(80022001)(50986001)(47976001)(47736001)(65816001)(74876001)(74706001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB313;H:BY2PR03MB315.namprd03.prod.outlook.com;CLIP:180.156.204.133;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBNEXtED026127



Sent from Anson's iPhone

> ÔÚ 2013Äê12ÔÂ23ÈÕ£¬22:28£¬"Shawn Guo" <shawn.guo@linaro.org> Ğ´µÀ£º
> 
>> On Mon, Dec 23, 2013 at 03:51:58PM -0500, Anson Huang wrote:
>> Current imx thermal sensor's suspend function will return fail if
>> thermal sensor is always enabled, but because alarm function is enabled,
>> thermal sensor will be always enabled as well, hence break system's suspend,
>> this patch will disable thermal sensor before suspend and re-enable it
>> after resume, it fixes the failure of suspend/resume caused by thermal driver.
> 
> We should probably make it clear in the commit log that it's a
> regression caused by commit 37713a1 (thermal: imx: implement thermal
> alarm interrupt handling).

agreed, will improve the commit log in V2.

> 
>> 
>> Signed-off-by: Anson Huang <b20788@freescale.com>
>> ---
>> drivers/thermal/imx_thermal.c |   31 +++++++++++++++++--------------
>> 1 file changed, 17 insertions(+), 14 deletions(-)
>> 
>> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
>> index cbb16f3..9a9a6c2 100644
>> --- a/drivers/thermal/imx_thermal.c
>> +++ b/drivers/thermal/imx_thermal.c
>> @@ -510,27 +510,30 @@ static int imx_thermal_suspend(struct device *dev)
>> {
>>    struct imx_thermal_data *data = dev_get_drvdata(dev);
>>    struct regmap *map = data->tempmon;
>> -    u32 val;
>> 
>> -    regmap_read(map, TEMPSENSE0, &val);
>> -    if ((val & TEMPSENSE0_POWER_DOWN) == 0) {
>> -        /*
>> -         * If a measurement is taking place, wait for a long enough
>> -         * time for it to finish, and then check again.  If it still
>> -         * does not finish, something must go wrong.
>> -         */
>> -        udelay(50);
>> -        regmap_read(map, TEMPSENSE0, &val);
>> -        if ((val & TEMPSENSE0_POWER_DOWN) == 0)
>> -            return -ETIMEDOUT;
>> -    }
>> +    /*
>> +     * Need to disable thermal sensor, otherwise, when thermal core
>> +     * try to get temperature before thermal sensor resume, a wrong
>> +     * temperature will be read as the thermal sensor is powered
>> +     * down.
>> +     */
>> +    regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_MEASURE_TEMP);
>> +    regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_POWER_DOWN);
>> +    data->mode = THERMAL_DEVICE_DISABLED;
> 
> Is it really necessary to update data->mode through suspend/resume
> cycle?

Yes, as the thermal core may try to get temperature before imx thermal sensor resume, if not setting its mode to disabled, thermal core will get a wrong temp and caused system power off by mistake, as the get_temp function will decide whether to power up thermal core according to its mode.

> 
> Shawn
> 
>> 
>>    return 0;
>> }
>> 
>> static int imx_thermal_resume(struct device *dev)
>> {
>> -    /* Nothing to do for now */
>> +    struct imx_thermal_data *data = dev_get_drvdata(dev);
>> +    struct regmap *map = data->tempmon;
>> +
>> +    /* Enabled thermal sensor after resume */
>> +    regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
>> +    regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP);
>> +    data->mode = THERMAL_DEVICE_ENABLED;
>> +
>>    return 0;
>> }
>> #endif
>> -- 
>> 1.7.9.5
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
