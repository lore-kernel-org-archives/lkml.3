Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaIZBYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:24:40 -0400
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:26880
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753302AbaIZBYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:24:38 -0400
Date: Fri, 26 Sep 2014 09:24:11 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Robin Gong <b38343@freescale.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <a.zummo@towertech.it>, <grant.likely@linaro.org>,
        <kernel@pengutronix.de>, <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] rtc: snvs: add poweroff function
Message-ID: <20140926012410.GD21077@dragon>
References: <1411611233-29919-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411611233-29919-1-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(189002)(199003)(81156004)(110136001)(81342003)(90102001)(104016003)(23726002)(84676001)(21056001)(33716001)(106466001)(50466002)(20776003)(97736003)(85306004)(10300001)(120916001)(47776003)(99396003)(80022003)(95666004)(92566001)(46102003)(107046002)(74662003)(79102003)(64706001)(74502003)(76482002)(105606002)(68736004)(69596002)(77982003)(33656002)(46406003)(102836001)(44976005)(83506001)(87936001)(19580395003)(97756001)(57986006)(81542003)(92726001)(31966008)(76176999)(85852003)(19580405001)(4396001)(83072002)(83322001)(6806004)(54356999)(50986999)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN2PR03MB048;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:SN2PR03MB048;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 10:13:53AM +0800, Robin Gong wrote:
> On i.mx6 chips, PMIC_ON_REQ can be pulled by snvs LPCR. That can be
> used poweroff system if PMIC_ON_REQ connected with external PMIC or
> power control circuit.Power up again if PMIC_ON_REQ pulled high.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>

I'm not sure it's a good idea to plug poweroff support into RTC driver.
If RTC driver is built out, poweroff function is gone too.

Shawn

> ---
>  Documentation/devicetree/bindings/crypto/fsl-sec4.txt |  4 ++++
>  drivers/rtc/rtc-snvs.c                                | 18 ++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> index e402277..00d67f2 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> @@ -363,11 +363,15 @@ Secure Non-Volatile Storage (SNVS) Low Power (LP) RTC Node
>        Value type: <prop-encoded-array>
>        Definition: A standard property.  Specifies the physical
>            address and length of the SNVS LP configuration registers.
> +  - fsl,poweroff
> +      Usage: opertional, recommend if PMIC_ON_REQ connected with external
> +	PMIC or power control circuit.
>  
>  EXAMPLE
>  	sec_mon_rtc_lp@314000 {
>  		compatible = "fsl,sec-v4.0-mon-rtc-lp";
>  		reg = <0x34 0x58>;
> +		fsl,poweroff;
>  	};
>  
>  =====================================================================
> diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
> index fa384fe..ef32541 100644
> --- a/drivers/rtc/rtc-snvs.c
> +++ b/drivers/rtc/rtc-snvs.c
> @@ -29,6 +29,8 @@
>  #define SNVS_LPCR_SRTC_ENV	(1 << 0)
>  #define SNVS_LPCR_LPTA_EN	(1 << 1)
>  #define SNVS_LPCR_LPWUI_EN	(1 << 3)
> +#define SNVS_LPCR_DP		(1 << 5)
> +#define SNVS_LPCR_TOP		(1 << 6)
>  #define SNVS_LPSR_LPTA		(1 << 0)
>  
>  #define SNVS_LPPGDR_INIT	0x41736166
> @@ -41,6 +43,8 @@ struct snvs_rtc_data {
>  	spinlock_t lock;
>  };
>  
> +static void __iomem *snvs_base;
> +
>  static u32 rtc_read_lp_counter(void __iomem *ioaddr)
>  {
>  	u64 read1, read2;
> @@ -241,8 +245,17 @@ static irqreturn_t snvs_rtc_irq_handler(int irq, void *dev_id)
>  	return events ? IRQ_HANDLED : IRQ_NONE;
>  }
>  
> +static void snvs_poweroff(void)
> +{
> +	u32 value;
> +
> +	value = readl(snvs_base + SNVS_LPCR);
> +	writel(value | SNVS_LPCR_DP | SNVS_LPCR_TOP, snvs_base + SNVS_LPCR);
> +}
> +
>  static int snvs_rtc_probe(struct platform_device *pdev)
>  {
> +	struct device_node *np = pdev->dev.of_node;
>  	struct snvs_rtc_data *data;
>  	struct resource *res;
>  	int ret;
> @@ -260,6 +273,11 @@ static int snvs_rtc_probe(struct platform_device *pdev)
>  	if (data->irq < 0)
>  		return data->irq;
>  
> +	if (np && of_get_property(np, "fsl,poweroff", NULL)) {
> +		snvs_base = data->ioaddr;
> +		pm_power_off = snvs_poweroff;
> +	}
> +
>  	platform_set_drvdata(pdev, data);
>  
>  	spin_lock_init(&data->lock);
> -- 
> 1.9.1
> 
