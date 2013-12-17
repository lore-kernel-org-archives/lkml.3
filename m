Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3LQCxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:53:32 -0500
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:14907
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751329Ab3LQCxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:53:30 -0500
X-Greylist: delayed 872 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2013 21:53:30 EST
From: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regulator: anatop: add is_enabled interface
Thread-Topic: [PATCH] regulator: anatop: add is_enabled interface
Thread-Index: AQHO+pDIV/D3fG4A102vVTpa2+vRu5pXqSDw
Date: Tue, 17 Dec 2013 02:38:56 +0000
Message-ID: <c9e35710598c4a66823e67fd4f81c0d7@BY2PR03MB315.namprd03.prod.outlook.com>
References: <1387228827-933-1-git-send-email-b20788@freescale.com>
 <20131216185753.GN3185@sirena.org.uk>
In-Reply-To: <20131216185753.GN3185@sirena.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.215]
x-forefront-prvs: 006339698F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377454003)(189002)(199002)(13464003)(24454002)(51704005)(4396001)(69226001)(46102001)(87936001)(90146001)(76482001)(74876001)(74706001)(51856001)(53806001)(54356001)(56816005)(47446002)(74502001)(74662001)(31966008)(19580395003)(19580405001)(83322001)(87266001)(2656002)(76576001)(76786001)(76796001)(77982001)(59766001)(74366001)(83072002)(74316001)(85306002)(63696002)(80022001)(79102001)(66066001)(85852003)(65816001)(81542001)(33646001)(80976001)(54316002)(56776001)(81342001)(81686001)(81816001)(47736001)(49866001)(50986001)(47976001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB313;H:BY2PR03MB315.namprd03.prod.outlook.com;CLIP:192.88.158.215;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBH2s3BG030117

Hi, Mark
	Thanks for your quick reply, see below inline:

Best Regards.
Anson huang é»„å‹‡æ‰
Â 
Freescale Semiconductor Shanghai
ä¸Šæµ·æµ¦ä¸œæ–°åŒºäº®æ™¯è·¯192å·Aåº§2æ¥¼
201203
Tel:021-28937058


>-----Original Message-----
>From: Mark Brown [mailto:broonie@kernel.org]
>Sent: Tuesday, December 17, 2013 2:58 AM
>To: Huang Yongcai-B20788
>Cc: lgirdwood@gmail.com; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] regulator: anatop: add is_enabled interface
>
>On Mon, Dec 16, 2013 at 04:20:27PM -0500, Anson Huang wrote:
>
>> +{
>> +	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
>> +	u32 val;
>> +
>> +	if (!anatop_reg->control_reg)
>> +		return -ENOTSUPP;
>
>In what situation would this happen and why would the operation be provided in
>those situations?
[Anson] This condition check is to avoid the case that control_reg is not
Initialized correctly in the probe function.
>
>> +	regmap_read(anatop_reg->anatop, anatop_reg->control_reg, &val);
>> +
>> +	return (val >> anatop_reg->vol_bit_shift) &
>> +		((1 << anatop_reg->vol_bit_width) - 1) ? 1 : 0; }
>
>This isn't terribly legible but it looks like it's trying to read to see if a
>non-zero voltage has been written.  If that's the case it looks like enable
>and disable operations should be supported since presumably the register can
>be written as well.

[Anson]Yes, from the register description, we can see that if the bit field of
REGx_TARG is not 0, then the LDO is enabled and there is output available. Adding this
Interface is because some specific requirement of our i.MX6's freq/volt scaling, and
We will add the enable/disable interface later when we add the GPU/VPU driver, as only
VDDPU can be on/off according to GPU/VPU's behavior, and there is a complicated flow
We need to follow, current is_enabled interface is for the case of VDDPU is turned off
In uboot.

1. For cpufreq change, we need to scale VDDARM as well as VDDSOC/PU's voltage, each
setpoint has different VDDARM, VDDSOC/PU voltage;
2. VDDARM and VDDSOC will be always on but VDDPU can be off in uboot due to the big leakage
it has(as high as ~43mA on i.MX6Q), as it is only for GPU/VPU module, and we will have
dynamic VDDPU power management available, so VDDPU LDO's status is changing according to GPU/VPU's
behavior;
3. If VDDPU is off during cpufreq change, then there is no need to scaling VDDPU's voltage,
so we will check whether VDDPU is enabled before scaling it in cpufreq driver, this is done
in my other patch thread;

>
>Please try to avoid the ternery operator, especially in cases like this where
>it's not adding anything.
[Anson] Accepted, will send out V2 patch if you think adding this interface for
our cpufreq driver is acceptable.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
