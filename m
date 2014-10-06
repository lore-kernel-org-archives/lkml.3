Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaJFP7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:59:42 -0400
Received: from mail-bn1on0084.outbound.protection.outlook.com ([157.56.110.84]:10544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751658AbaJFP7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:59:41 -0400
Date: Mon, 6 Oct 2014 08:59:27 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <monstr@monstr.eu>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: zynq: Extend SLCR driver to read OCM
 configuration
References: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com>
 <586ef67a22005316fd65cebbbd4019a8a2094e07.1412595859.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <586ef67a22005316fd65cebbbd4019a8a2094e07.1412595859.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20998.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <30d758b569504e88a9b4a999f08be17b@BN1AFFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(24454002)(51704005)(199003)(377424004)(164054003)(108616004)(80022003)(44976005)(19580405001)(46102003)(21056001)(83506001)(19580395003)(85306004)(76482002)(99396003)(47776003)(33646002)(10300001)(6806004)(74316001)(20776003)(4396001)(120916001)(64706001)(104016003)(50466002)(106466001)(54356999)(76176999)(107046002)(86362001)(110136001)(77096002)(85202003)(53416004)(95666004)(85182001)(102836001)(575784001)(50986999)(85852003)(87936001)(23676002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB016;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB016;
X-Forefront-PRVS: 03569407CC
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Mon, 2014-10-06 at 01:44PM +0200, Michal Simek wrote:
> Get OCM configuration from SLCR.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
>  arch/arm/mach-zynq/slcr.c | 15 +++++++++++++++
>  include/soc/zynq/common.h |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
> index cb7c46165728..0c3e45090c09 100644
> --- a/arch/arm/mach-zynq/slcr.c
> +++ b/arch/arm/mach-zynq/slcr.c
> @@ -27,6 +27,7 @@
>  #define SLCR_A9_CPU_RST_CTRL_OFFSET	0x244 /* CPU Software Reset Control */
>  #define SLCR_REBOOT_STATUS_OFFSET	0x258 /* PS Reboot Status */
>  #define SLCR_PSS_IDCODE			0x530 /* PS IDCODE */
> +#define SLCR_OCM_CFG_OFFSET		0x910 /* OCM Address Mapping */
> 
>  #define SLCR_UNLOCK_MAGIC		0xDF0D
>  #define SLCR_A9_CPU_CLKSTOP		0x10
> @@ -126,6 +127,20 @@ void zynq_slcr_system_reset(void)
>  }
> 
>  /**
> + * zynq_slcr_get_ocm_config - Get SLCR OCM config
> + *
> + * Return:	OCM config bits
> + */
> +u32 zynq_slcr_get_ocm_config(void)
> +{
> +	u32 val;
> +
> +	zynq_slcr_read(&val, SLCR_OCM_CFG_OFFSET);
> +
> +	return val;
> +}

a different idea would be, instead of creating this specific API call
for the OCMC to let the OCMC driver use regmap and making git a subnode
of the SLCR.
In the long run that might be a better option otherwise we'll end up
with a whole bunch of zynq_slcr_get_foo() calls for each driver that
needs to read an SLCR register.

	Thanks,
	Sören
