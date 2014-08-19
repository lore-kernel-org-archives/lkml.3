Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaHSFoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:44:05 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:42487
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751624AbaHSFoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:44:02 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@kernel.org>, Thierry Reding <treding@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: RE: [PATCH] regmap: fix of_regmap_get_endian()
Thread-Topic: [PATCH] regmap: fix of_regmap_get_endian()
Thread-Index: AQHPuzGzfW+BtXONv0iIkXaRo5I+h5vXZIuAgAADLlA=
Date: Tue, 19 Aug 2014 05:43:57 +0000
Message-ID: <7374fedf5efa49edb3bc3f1d4f4e85d6@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1408400044-2560-1-git-send-email-swarren@wwwdotorg.org>
 <20140819052141.GA12859@ulmo>
In-Reply-To: <20140819052141.GA12859@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0308EE423E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019006)(6009001)(51704005)(52604005)(199003)(164054003)(24454002)(189002)(13464003)(377454003)(85852003)(64706001)(106116001)(80022001)(107046002)(76176999)(2656002)(108616004)(83072002)(85306004)(20776003)(66066001)(105586002)(95666004)(46102001)(99286002)(101416001)(106356001)(79102001)(31966008)(76576001)(50986999)(86362001)(99396002)(81342001)(74316001)(54356999)(77096002)(87936001)(81542001)(83322001)(77982001)(76482001)(92566001)(4396001)(74662001)(19580405001)(33646002)(74502001)(19580395003)(21056001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found this patch has some confliction with the Mark's newest Remgap-Tree's
origin/topic/dt-endian branch.

Javier Martinez has already fix some of these.

Thanks,

BRs
Xiubo



> -----Original Message-----
> From: Thierry Reding [mailto:thierry.reding@gmail.com]
> Sent: Tuesday, August 19, 2014 1:22 PM
> To: Stephen Warren
> Cc: Mark Brown; Thierry Reding; linux-kernel@vger.kernel.org; linux-
> next@vger.kernel.org; Stephen Warren; Xiubo Li-B47053
> Subject: Re: [PATCH] regmap: fix of_regmap_get_endian()
> 
> On Mon, Aug 18, 2014 at 04:14:04PM -0600, Stephen Warren wrote:
> > From: Stephen Warren <swarren@nvidia.com>
> >
> > Commit d647c199510c ("regmap: add DT endianness binding support") has
> > some issues. Specifically, if config->reg_format_endian is not explicitly
> > set, it will be zero, i.e. REGMAP_ENDIAN_DEFAULT. The switch statement
> > that looks up the *endian from DT for the type==REGMAP_ENDIAN_VAL case
> > doesn't change *endian in the type==REGMAP_ENDIAN_REG case. However, the
> > test immediately following, compares *endian against REGMAP_ENDIAN_NATIVE,
> > and if not equal, returns *endian as is. This ends up returning
> > REGMAP_ENDIAN_DEFAULT, which the calling code does not expect, eventually
> > leading to e.g.:
> >
> > Unable to handle kernel NULL pointer dereference at virtual address 00000024
> > ...
> > [<c02efd64>] (regcache_cache_only) from [<c0465fa8>]
> (tegra30_ahub_probe+0x1b8/0x430)
> > [<c0465fa8>] (tegra30_ahub_probe) from [<c02e196c>]
> (platform_drv_probe+0x2c/0x5c)
> > [<c02e196c>] (platform_drv_probe) from [<c02e0580>]
> (driver_probe_device+0x10c/0x22c)
> > [<c02e0580>] (driver_probe_device) from [<c02e072c>]
> (__driver_attach+0x8c/0x90)
> >
> > This patch solves this by:
> > * When looking up the endianness from DT, don't change *endian at all if
> >   there is no DT property; leave it set to REGMAP_ENDIAN_DEFAULT so the
> >   code falls through to other data sources in the same way as before.
> >   Now, the "unspecified" case acts the same for both REGMAP_ENDIAN_REG and
> >   REGMAP_ENDIAN_VAL.
> > * After potentially looking up the endianness from DT, check *endian
> >   against REGMAP_ENDIAN_DEFAULT instead of REGMAP_ENDIAN_NATIVE to avoid
> >   returning unexpected values.
> >
> > Also, clean up the code a bit:
> >
> > * Make the comments briefer, and only refer to the specific action taken
> >   at their location. This makes most of the comments independent of DT,
> >   and easier to follow.
> > * Restore the overall default of REGMAP_ENDIAN_BIG if none of the config,
> >   DT, or the bus specify any endianness. Since all busses specify an
> >   endianness now, this makes no difference, but I saw no justification in
> >   the patch description for changing the default default.
> > * s/of_regmap_get_endian/regmap_get_endian/ since the function isn't DT-
> >   specific, even if the reason it was originally added was to add some
> >   DT-specific features.
> >
> > Reported-by: Thierry Reding <treding@nvidia.com>
> > Fixes: d647c199510c ("regmap: add DT endianness binding support")
> > Cc: Xiubo Li <Li.Xiubo@freescale.com>
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> >  drivers/base/regmap/regmap.c | 58 ++++++++++++++---------------------------
> ---
> >  1 file changed, 18 insertions(+), 40 deletions(-)
> 
> Thanks for fixing this, Stephen.
> 
> Tested-by: Thierry Reding <treding@nvidia.com>
