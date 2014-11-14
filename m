Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbaKNPPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:15:41 -0500
Received: from mail-bn1on0065.outbound.protection.outlook.com ([157.56.110.65]:29157
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964875AbaKNPPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:15:39 -0500
Date: Fri, 14 Nov 2014 07:15:33 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <monstr@monstr.eu>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] ARM: zynq: Extend SLCR driver to read OCM
 configuration
References: <cover.1415962281.git.michal.simek@xilinx.com>
 <1b945376f9979a3b3e7c1231ea7ecead78026b07.1415962281.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b945376f9979a3b3e7c1231ea7ecead78026b07.1415962281.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21104.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <f384b384e767499cafe62fed371f7ddd@BN1AFFO11FD052.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(199003)(377424004)(189002)(51704005)(77096003)(50986999)(4396001)(76176999)(54356999)(21056001)(83506001)(64706001)(575784001)(19580405001)(77156002)(19580395003)(6806004)(44976005)(62966003)(85182001)(92566001)(47776003)(85202003)(107046002)(99396003)(120916001)(106466001)(110136001)(108616004)(74316001)(87936001)(53416004)(95666004)(20776003)(102836001)(33646002)(50466002)(104016003)(86362001)(46102003)(31966008)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB026;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB026;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB026;
X-Forefront-PRVS: 03950F25EC
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB026;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 11:52AM +0100, Michal Simek wrote:
> Get OCM configuration from SLCR.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
> Changes in v4:
> - slcr.h has moved to soc/include/ folder. Move definition there too.
> 
> Changes in v3: None
> Changes in v2: None
> 
>  arch/arm/mach-zynq/slcr.c | 15 +++++++++++++++
>  include/soc/zynq/slcr.h   |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
> index b77e42d999c8..f7c606e57525 100644
> --- a/arch/arm/mach-zynq/slcr.c
> +++ b/arch/arm/mach-zynq/slcr.c
> @@ -29,6 +29,7 @@
>  #define SLCR_A9_CPU_RST_CTRL_OFFSET	0x244 /* CPU Software Reset Control */
>  #define SLCR_REBOOT_STATUS_OFFSET	0x258 /* PS Reboot Status */
>  #define SLCR_PSS_IDCODE			0x530 /* PS IDCODE */
> +#define SLCR_OCM_CFG_OFFSET		0x910 /* OCM Address Mapping */
> 
>  #define SLCR_UNLOCK_MAGIC		0xDF0D
>  #define SLCR_A9_CPU_CLKSTOP		0x10
> @@ -128,6 +129,20 @@ void zynq_slcr_system_reset(void)
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
> +
> +/**
>   * zynq_slcr_cpu_start - Start cpu
>   * @cpu:	cpu number
>   */
> diff --git a/include/soc/zynq/slcr.h b/include/soc/zynq/slcr.h
> index 7b4edab666ee..639723c4f90c 100644
> --- a/include/soc/zynq/slcr.h
> +++ b/include/soc/zynq/slcr.h
> @@ -25,5 +25,6 @@ extern void zynq_slcr_cpu_start(int cpu);
>  extern bool zynq_slcr_cpu_state_read(int cpu);
>  extern void zynq_slcr_cpu_state_write(int cpu, bool die);
>  extern u32 zynq_slcr_get_device_id(void);
> +extern u32 zynq_slcr_get_ocm_config(void);

I still believe we should consolidate this somehow instead of adding
another function for each and every register that might have to be read
by something else.

Usage of syscon/regmap might be an option. Or probably something like:
enum zynq_slcr_reg {
	zynq_slcr_ocm_cfg,
	zynq_slcr_device_id,
	...
};
u32 zyn_slcr_read(enum zynq_slcr_reg id)
{
	switch (id) {
	case ...
}

	Sören
