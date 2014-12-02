Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbaLBHzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:55:32 -0500
Received: from mail-bn1bn0101.outbound.protection.outlook.com ([157.56.110.101]:36448
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932270AbaLBHza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:55:30 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] video: fsl-dcfb: Add dcfb framebuffer driver for
 LS1021A platform
Thread-Topic: [PATCH 1/4] video: fsl-dcfb: Add dcfb framebuffer driver for
 LS1021A platform
Thread-Index: AQHQB9CHwHs4YFm3dU2sxhJO0ktC2Jx6xgKAgAEjQbA=
Date: Tue, 2 Dec 2014 07:55:27 +0000
Message-ID: <BN1PR0301MB060987F8F09E3ABD7F534C5A9B7A0@BN1PR0301MB0609.namprd03.prod.outlook.com>
References: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
 <1416824454-28156-2-git-send-email-Li.Xiubo@freescale.com>
 <1645594.e2cfs6JOiv@ws-stein>
In-Reply-To: <1645594.e2cfs6JOiv@ws-stein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0611;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0611;
x-forefront-prvs: 0413C9F1ED
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(252514010)(199003)(164054003)(189002)(24454002)(87936001)(99286002)(95666004)(46102003)(2656002)(19580405001)(19580395003)(101416001)(54206007)(33656002)(74316001)(92726001)(86362001)(92566001)(110136001)(15974865002)(21056001)(76176999)(54356999)(4396001)(54606007)(50986999)(77096004)(107046002)(122556002)(68736005)(76576001)(31966008)(77156002)(62966003)(40100003)(97736003)(20776003)(120916001)(99396003)(106116001)(105586002)(106356001)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0611;H:BN1PR0301MB0609.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Thanks very much for your comments.

> On Monday 24 November 2014 18:20:51, Xiubo Li wrote:
> > [...]
> > +static int fsl_dcfb_init_fbinfo(struct fb_info *info)
> > +{
> > +	struct fsl_dcfb_mfb_info *mfbi = info->par;
> > +	struct fb_var_screeninfo *var = &info->var;
> > +	struct fsl_dcfb_fb_private *dcfb = mfbi->parent;
> > +	struct device_node *np = dcfb->dev->of_node;
> > +	struct device_node *dnp, *tnp;
> > +	struct display_timings *timings;
> > +	int i, ret;
> > +
> > +	dnp = of_parse_phandle(np, "display", 0);
> > +	if (!dnp) {
> > +		dev_err(dcfb->dev, "failed to find \"display\" phandle.\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	ret = of_property_read_u32(dnp, "bits-per-pixel",
> > +				   &var->bits_per_pixel);
> > +	if (ret < 0) {
> > +		dev_err(dcfb->dev, "failed to get \"bits-per-pixel\"
> property.\n");
> > +		goto put_dnp;
> > +	}
> > +
> > +	timings = of_get_display_timings(dnp);
> > +	if (!timings) {
> > +		dev_err(dcfb->dev, "failed to get display timings\n");
> > +		return -ENODEV;
> > +		goto put_dnp;
> > +	}
> > +
> > +	tnp = of_find_node_by_name(dnp, "display-timings");
> > +	if (!tnp) {
> > +		dev_err(dcfb->dev, "failed to find \"display-timings\" node\n");
> > +		return -ENODEV;
> > +		goto put_dnp;
> > +	}
> > +
> > +	for (i = 0; i < of_get_child_count(tnp); i++) {
> > +		struct videomode vm;
> > +		struct fb_videomode fb_vm;
> > +
> > +		ret = videomode_from_timings(timings, &vm, i);
> > +		if (ret < 0)
> > +			goto put_tnp;
> > +
> > +		ret = fb_videomode_from_videomode(&vm, &fb_vm);
> > +		if (ret < 0)
> > +			goto put_tnp;
> > +
> > +		fb_add_videomode(&fb_vm, &info->modelist);
> > +	}
> 
> Adding each display timing to the modelist here...
> 
> > [...]
> > +	ret = fsl_dcfb_init_fbinfo(info);
> > +	if (ret)
> > +		goto err_cmap;
> > +
> > +	modelist = list_first_entry(&info->modelist,
> > +			struct fb_modelist, list);
> > +	fb_videomode_to_var(&info->var, &modelist->mode);
> 
> ... and just picking the first here, essentially renders the "native-mode"
> property in device tree as useless, since only the first in that list is
> picked (which seems to be the last one inserted).
> 

Yes, right. So in the next version, I will try to enhance this. 

Thanks,

BRs
Xiubo

> Best regards,
> Alexander
> --
> Dipl.-Inf. Alexander Stein
> 
> SYS TEC electronic GmbH
> Am Windrad 2
> 08468 Heinsdorfergrund
> Tel.: 03765 38600-1156
> Fax: 03765 38600-4100
> Email: alexander.stein@systec-electronic.com
> Website: www.systec-electronic.com
> 
> Managing Director: Dipl.-Phys. Siegmar Schmidt
> Commercial registry: Amtsgericht Chemnitz, HRB 28082

