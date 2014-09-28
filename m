Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaI1JZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:25:10 -0400
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:55346
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751070AbaI1JZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:25:09 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "broonie@kernel.org" <broonie@kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing
 error.
Thread-Topic: [PATCH] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing
 error.
Thread-Index: AQHP2vwEQH8thzKh4E+SycHmmgvtd5wWQ1Kw
Date: Sun, 28 Sep 2014 09:25:06 +0000
Message-ID: <e0bb202c7b9c4384afa244f2f6165aa8@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411895394-25250-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1411895394-25250-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-forefront-prvs: 03484C0ABF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(164054003)(189002)(101416001)(85306004)(4396001)(10300001)(120916001)(76482002)(66066001)(97736003)(92566001)(86362001)(2501002)(74316001)(31966008)(83322001)(19580405001)(19580395003)(20776003)(77096002)(64706001)(90102001)(99396003)(33646002)(87936001)(74502003)(77982003)(46102003)(106356001)(81342003)(83072002)(21056001)(85852003)(74662003)(81542003)(106116001)(79102003)(80022003)(105586002)(2656002)(76176999)(54356999)(50986999)(108616004)(107046002)(2351001)(76576001)(95666004)(110136001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,


> Subject: [PATCH] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing
> error.
> 
> Since we cannot make sure the 'val_count' will always be none zero
> here, and then if it equals to zero, the kmemdup() will return
> ZERO_SIZE_PTR, which equals to ((void *)16).
> 
> So this patch fix this with just doing the zero check before calling
> kmemdup().
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/base/regmap/regmap.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 455a877..3d93e38 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -1716,6 +1716,9 @@ out:
>  	} else {
>  		void *wval;
> 
> +		if (!val_count)
> +			return -EINVAL;
> +

Should it return zero as success or just return -EINVAL for error here ?

If it allow zero of val_count in regmap_bulk_write(..., val_count) could do
Nothing and just return zero as success at the beginning of it.

I will respin this patch if return zero is better ...

Thanks,

BRs
Xiubo

>  		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
>  		if (!wval) {
>  			dev_err(map->dev, "Error in memory allocation\n");
> --
> 2.1.0.27.g96db324

