Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbaD3HKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:10:40 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:42717
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757415AbaD3HKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:10:31 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Markus Pargmann <mpa@pengutronix.de>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv3 2/2] regmap: add DT endianness binding support.
Thread-Topic: [PATCHv3 2/2] regmap: add DT endianness binding support.
Thread-Index: AQHPZDUIduQ41PzzDEClXEtdmSvNR5spulSAgAAA2XA=
Date: Wed, 30 Apr 2014 07:10:28 +0000
Message-ID: <6ff132f3b9964beaa6cd2ec0d177d85e@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398833029-29546-1-git-send-email-Li.Xiubo@freescale.com>
 <1398833029-29546-3-git-send-email-Li.Xiubo@freescale.com>
 <20140430065655.GE15179@pengutronix.de>
In-Reply-To: <20140430065655.GE15179@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(85852003)(74662001)(46102001)(19580395003)(54356999)(80976001)(81542001)(74502001)(86362001)(15975445006)(15202345003)(79102001)(81342001)(80022001)(83322001)(76176999)(99286001)(20776003)(83072002)(87936001)(2656002)(77096999)(50986999)(99396002)(76576001)(31966008)(76482001)(74316001)(33646001)(92566001)(77982001)(101416001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:C2F3D1A6.9412E522.B9D39A77.46D5FA31.20366;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3U7AkxA005454

> > + * of_regmap_endian_by_type() - Parse and lookup the endian referenced
> > + * by a device node
> > + * @np: pointer to clock consumer node
> 
> This is not the clock consumer, right?
> 

Yes, you are right.

I will fix it.


> > + * @type: type of consumer's endian input
> > + *
> > + * This function parses the device endian property, and uses them to
> > + * determine the endian of the registers and values.
> > + */
> > +static int of_regmap_endian_by_type(struct device_node *np,
> > +					enum regmap_endian_type type,
> > +					enum regmap_endian *endian)
> > +{
> > +	if (!endian)
> > +		return -EINVAL;
> > +
> > +	switch (type) {
> > +	case REGMAP_ENDIAN_REG:
> > +		if (of_property_read_bool(np, "big-endian-reg"))
> > +			*endian = REGMAP_ENDIAN_BIG;
> > +		else if (of_property_read_bool(np, "little-endian-reg"))
> > +			*endian = REGMAP_ENDIAN_LITTLE;
> > +		else
> > +			*endian = REGMAP_ENDIAN_NATIVE;
> 
> You could also return an error code here as there was no DT property
> found. This doesn't change to much in the code, just an idea.
> 

The properties are all Boolean ones, and returning an error code here
is not proper. Isn't it ?

Returning _NATIVE here means to indicate that the the CPU and DEV are in
the same endianness mode...


Thanks very much,

BRs
Xiubo



> Regards,
> 
> Markus
> 
> > +		break;
> > +	case REGMAP_ENDIAN_VAL:
> > +		if (of_property_read_bool(np, "big-endian-val"))
> > +			*endian = REGMAP_ENDIAN_BIG;
> > +		else if (of_property_read_bool(np, "little-endian-val"))
> > +			*endian = REGMAP_ENDIAN_LITTLE;
> > +		else
> > +			*endian = REGMAP_ENDIAN_NATIVE;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int of_regmap_get_endian(struct device *dev,
> > +				const struct regmap_bus *bus,
> > +				const struct regmap_config *config,
> > +				enum regmap_endian_type type,
> > +				enum regmap_endian *endian)
> > +{
> > +	int ret;
> > +
> > +	if (!endian || !config)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Firstly, try to parse the endian from driver's config,
> > +	 * this is to be compatible with the none DT or the old drivers.
> > +	 * From the driver's config the endian value maybe:
> > +	 *   REGMAP_ENDIAN_BIG,
> > +	 *   REGMAP_ENDIAN_LITTLE,
> > +	 *   REGMAP_ENDIAN_NATIVE,
> > +	 *   REGMAP_ENDIAN_DEFAULT.
> > +	 */
> > +	switch (type) {
> > +	case REGMAP_ENDIAN_REG:
> > +		*endian = config->reg_format_endian;
> > +		break;
> > +	case REGMAP_ENDIAN_VAL:
> > +		*endian = config->val_format_endian;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * If the endian parsing from driver's config is REGMAP_ENDIAN_DEFAULT,
> > +	 * that means maybe we are using the DT node to specify the endianness.
> > +	 */
> > +	if (*endian != REGMAP_ENDIAN_DEFAULT)
> > +		return 0;
> > +
> > +	/*
> > +	 * Secondly, try to parse the endian from DT node if the
> > +	 * driver config does not specify it.
> > +	 * From the DT node the endian value maybe:
> > +	 *   REGMAP_ENDIAN_BIG,
> > +	 *   REGMAP_ENDIAN_LITTLE,
> > +	 *   REGMAP_ENDIAN_NATIVE,
> > +	 */
> > +	if (dev) {
> > +		ret = of_regmap_endian_by_type(dev->of_node, type, endian);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	/*
> > +	 * If the endian parsing from DT node is REGMAP_ENDIAN_NATIVE, that
> > +	 * maybe means the DT does not care the endianness or it should use
> > +	 * the regmap bus's default endianness, then we should try to check
> > +	 * whether the regmap bus has specified the default endianess.
> > +	 */
> > +	if (*endian != REGMAP_ENDIAN_NATIVE)
> > +		return 0;
> > +
> > +	/*
> > +	 * Finally, try to parse the endian from regmap bus config
> > +	 * if in device's DT node the endian property is absent.
> > +	 */
> > +	switch (type) {
> > +	case REGMAP_ENDIAN_REG:
> > +		if (bus && bus->reg_format_endian_default)
> > +			*endian = bus->reg_format_endian_default;
> > +		break;
> > +	case REGMAP_ENDIAN_VAL:
> > +		if (bus && bus->val_format_endian_default)
> > +			*endian = bus->val_format_endian_default;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /**
> >   * regmap_init(): Initialise register map
> >   *
> > @@ -518,17 +645,15 @@ struct regmap *regmap_init(struct device *dev,
> >  		map->reg_read  = _regmap_bus_read;
> >  	}
> >
> > -	reg_endian = config->reg_format_endian;
> > -	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
> > -		reg_endian = bus->reg_format_endian_default;
> > -	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
> > -		reg_endian = REGMAP_ENDIAN_BIG;
> > -
> > -	val_endian = config->val_format_endian;
> > -	if (val_endian == REGMAP_ENDIAN_DEFAULT)
> > -		val_endian = bus->val_format_endian_default;
> > -	if (val_endian == REGMAP_ENDIAN_DEFAULT)
> > -		val_endian = REGMAP_ENDIAN_BIG;
> > +	ret = of_regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_REG,
> > +				   &reg_endian);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> > +
> > +	ret = of_regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_VAL,
> > +				   &val_endian);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> >
> >  	switch (config->reg_bits + map->reg_shift) {
> >  	case 2:
> > --
> > 1.8.4
> >
> >
> 
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
