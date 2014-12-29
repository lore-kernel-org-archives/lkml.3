Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaL2K7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:59:13 -0500
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:32627
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751114AbaL2K7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:59:11 -0500
From: Zidan Wang <B50113@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "ckeepax@opensource.wolfsonmicro.com" 
	<ckeepax@opensource.wolfsonmicro.com>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel][PATCH v4] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
Thread-Topic: [alsa-devel][PATCH v4] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
Thread-Index: AQHQE3NNKgR4im+Iykyw3AV5O2WHypyb/k+AgAp9MBA=
Date: Mon, 29 Dec 2014 10:59:08 +0000
Message-ID: <BN3PR0301MB125132692CD535B9AC1795A98D510@BN3PR0301MB1251.namprd03.prod.outlook.com>
References: <1418103916-31295-1-git-send-email-b50113@freescale.com>
 <20141222181045.GH17800@sirena.org.uk>
In-Reply-To: <20141222181045.GH17800@sirena.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=B50113@freescale.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0610;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0610;
x-forefront-prvs: 0440AC9990
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(24454002)(51704005)(377454003)(13464003)(66066001)(97736003)(64706001)(54356999)(74316001)(46102003)(19580395003)(19580405001)(92566001)(2900100001)(68736005)(54206007)(76176999)(87936001)(20776003)(21056001)(106116001)(77156002)(62966003)(107046002)(99396003)(101416001)(33656002)(122556002)(86362001)(110136001)(102836002)(54606007)(40100003)(99286002)(106356001)(2656002)(31966008)(2950100001)(50986999)(105586002)(120916001)(76576001)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0610;H:BN3PR0301MB1251.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2014 10:59:08.6904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0610
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I am so sorry for missing this letter. 
You are right. When PM is disabled, the codec will not work. But there are also some codecs enable mclk in PM, such as wm8962, cs42xx8.
And some codecs enable codec mclk in i2c probe(), startup() and set_bias_level(). It makes me confused.	
Can you tell me what's the general idiom to enable mclk. Thanks.


Best Regards,
Zidan

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Tuesday, December 23, 2014 2:11 AM
To: Wang Zidan-B50113
Cc: lgirdwood@gmail.com; perex@perex.cz; tiwai@suse.de; lars@metafoo.de; ckeepax@opensource.wolfsonmicro.com; Xiubo Li-B47053; patches@opensource.wolfsonmicro.com; alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH v4] ASoC: wm8960: Let wm8960 codec driver manage its own MCLK

On Tue, Dec 09, 2014 at 01:45:16PM +0800, Zidan Wang wrote:

> @@ -1002,6 +1005,13 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
>  	if (wm8960 == NULL)
>  		return -ENOMEM;
>  
> +	wm8960->mclk = devm_clk_get(&i2c->dev, "codec_mclk");
> +
> +	if (IS_ERR(wm8960->mclk)) {
> +		if (PTR_ERR(wm8960->mclk) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +	}
> +
>  	wm8960->regmap = devm_regmap_init_i2c(i2c, &wm8960_regmap);
>  	if (IS_ERR(wm8960->regmap))
>  		return PTR_ERR(wm8960->regmap);
> @@ -1041,6 +1051,9 @@ static int wm8960_i2c_probe(struct i2c_client 
> *i2c,
>  
>  	i2c_set_clientdata(i2c, wm8960);
>  
> +	pm_runtime_enable(&i2c->dev);
> +	pm_request_idle(&i2c->dev);
> +
>  	ret = snd_soc_register_codec(&i2c->dev,
>  			&soc_codec_dev_wm8960, &wm8960_dai, 1);
>  

This isn't going to work if PM is disabled (which is still a valid configuration).  The general idiom for this is that the driver should start up with everything powered up then let runtime idle turn things off if they're not required.  That way if runtime PM is disabled then the system will still work as everything will just stay powered on all the time.
