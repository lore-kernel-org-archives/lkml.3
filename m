Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaCCDB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:01:56 -0500
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:23411
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751883AbaCCDBz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:01:55 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lars@metafoo.de" <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 1/3] ASoC: codec: Simplify ASoC probe code.
Thread-Topic: [PATCHv2 1/3] ASoC: codec: Simplify ASoC probe code.
Thread-Index: AQHPNG1ZE66RA7TcJUK0BpBMQvyaLprLpHwAgAMIdAA=
Date: Mon, 3 Mar 2014 03:01:52 +0000
Message-ID: <ea3da7fbf6564020b12bcd8b4878ae4a@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393578267-18255-1-git-send-email-Li.Xiubo@freescale.com>
 <1393578267-18255-2-git-send-email-Li.Xiubo@freescale.com>
 <20140301042818.GP29849@sirena.org.uk>
In-Reply-To: <20140301042818.GP29849@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(164054003)(189002)(199002)(2656002)(87266001)(74662001)(47976001)(50986001)(83322001)(74366001)(81686001)(81816001)(94946001)(80976001)(85306002)(4396001)(92566001)(31966008)(74502001)(87936001)(49866001)(93136001)(47736001)(47446002)(94316002)(83072002)(95416001)(56816005)(86362001)(90146001)(76576001)(76786001)(76796001)(59766001)(54316002)(56776001)(77982001)(74876001)(76482001)(95666003)(46102001)(69226001)(66066001)(51856001)(81342001)(93516002)(80022001)(65816001)(81542001)(79102001)(53806001)(33646001)(54356001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB427;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > "Just removing the set_cache_io() call will not work for all
> > drivers. There are some MFD child devices which use regmap from the parent
> > device. So dev_get_regmap() will return NULL for those."
> 
> This is the sort of thing that I was referring to when talking about
> doing the non-boring drivers separately.  As well as the warnings Lars
> mentioned there's a bisection issue here:
> 
> > -	codec->control_data = da7213->regmap;
> > -	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
> > -	if (ret < 0) {
> > -		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
> > -		return ret;
> > -	}
> > -
> >  	/* Default to using ALC auto offset calibration mode. */
> >  	snd_soc_update_bits(codec, DA7213_ALC_CTRL1,
> >  			    DA7213_ALC_CALIB_MODE_MAN, 0);
> 
> Unless the core sets up the I/O before calling probe() the above is
> going to mean that the snd_soc_update_bits() call fails since the I/O
> operations won't have been set up.  There is a defualt call to set a
> regmap up but it's only done after the probe.

Yes, like the SGTL5000 CODEC driver, which needs to read the chip information
in main probe. And then it must use the regmap core APIs directly.

And I have do another research early, all the CODEC drivers who are calling
set_cache_io() in ASoC probes, and before that they all are using the regmap core
APIs instead of ASoC ones if needed. 

I think we should move the set_cache_io() calling more earlier as we discussed
before, but need much more research and testing. Splitting them into another
separate patch later will be much better and easier to be reviewed.

Thanks,

--
Best Regards,
Xiubo
