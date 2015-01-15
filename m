Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbbAOOH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:07:56 -0500
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:64832
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753950AbbAOOHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:07:55 -0500
X-Greylist: delayed 1136 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 09:07:55 EST
Date: Thu, 15 Jan 2015 21:34:40 +0800
From: Zidan Wang <b50113@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: Zidan Wang <zidan.wang@freescale.com>, <lgirdwood@gmail.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <lars@metafoo.de>,
        <ckeepax@opensource.wolfsonmicro.com>,
        <patches@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel][PATCH v2 2/2] ASoC: wm8960: Let wm8960 driver
 configure its bit clock and frame clock
Message-ID: <20150115133439.GA29323@b50113>
References: <1420615905-4078-1-git-send-email-zidan.wang@freescale.com>
 <1420615905-4078-2-git-send-email-zidan.wang@freescale.com>
 <20150114192703.GH3043@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150114192703.GH3043@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(51704005)(189002)(199003)(24454002)(76176999)(46406003)(23726002)(54356999)(50986999)(46102003)(33716001)(77096005)(83506001)(62966003)(77156002)(68736005)(69596002)(64706001)(47776003)(6806004)(104016003)(86362001)(97736003)(97756001)(105606002)(106466001)(81156004)(33656002)(85426001)(87936001)(92566002)(110136001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1264;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DM2PR0301MB1264;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB1264;
X-Forefront-PRVS: 0457F11EAF
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1264;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2015 13:33:40.2725
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB1264
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 07:27:03PM +0000, Mark Brown wrote:
> On Wed, Jan 07, 2015 at 03:31:45PM +0800, Zidan Wang wrote:
> 
> > +	for (i = 0; i < ARRAY_SIZE(dac_divs); ++i) {
> > +		if (wm8960->sysclk == lrclk * dac_divs[i]) {
> > +			for (j = 0; j < ARRAY_SIZE(bclk_divs); ++j) {
> > +				if (wm8960->sysclk ==  wm8960->bclk *
> > +						bclk_divs[j] / 10) {
> > +					goto config_clock;
> > +				}
> > +			}
> > +		}
> > +	}
> > +
> > +	dev_err(codec->dev, "Unsupported sysclk %d\n", wm8960->sysclk);
> > +	return;
> 
> It's a bit awkward using the goto like this.  A more common way of
> writing this is to change the above block to be
> 
> 	if (i == ARRAY_SIZE(dac_divs))
> 		/* return error */
> 
> rather than skipping over the error.  Otherwise this looks good.

Hi Mark,

I found it can't generate bclk for S20_3LE data format.

For 2 channel S20_3LE data format:

bclk = fs * 20 * 2
Sysclk = BCLKDIV * bclk = BCLKDIV * fs * 40
Sysclk = DACDIV * fs * 256

BCLKDIV/DACDIV = 256/40 = 32/5

But BCLKDIV/DACDIV can't be 32/5. So I want to support tdm slot.

bclk = fs * slot_width * slots * channal.

Do you think it make sense, or any other ideas?

Best Regards,
Zidan
