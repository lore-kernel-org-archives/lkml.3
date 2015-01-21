Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbbAUS44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:56:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48166 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbbAUS4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:56:47 -0500
Message-ID: <54BFF66D.4000409@codeaurora.org>
Date: Wed, 21 Jan 2015 10:56:45 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Gilad Avidov <gavidov@codeaurora.org>, sdharia@codeaurora.org,
        mlocke@codeaurora.org, linux-arm-msm@vger.kernel.org,
        gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, iivanov@mm-sol.com, galak@codeaurora.org,
        agross@codeaurora.org
Subject: Re: [PATCH] spmi: pmic_arb: add support for hw version 2
References: <1421716210-14805-1-git-send-email-gavidov@codeaurora.org>
In-Reply-To: <1421716210-14805-1-git-send-email-gavidov@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 05:10 PM, Gilad Avidov wrote:
> Qualcomm PMIC Arbiter version-2 changes from version-1 are:
>
> - Some diffrent register offsets.

s/diffrent/different/



> - New channel register space, one per PMIC peripheral (ppid).
>   All tx tarffic uses these channels.

s/tarffic/traffic/

> - New observer register space. All rx trafic uses this space.

s/trafic/traffic/

> - Diffrent command format for spmi command registers.

s/Diffrent/Different/

Please run spell check.

>
> Signed-off-by: Gilad Avidov <gavidov@codeaurora.org>
> Acked-by: Sagar Dharia <sdharia@codeaurora.org>
> ---
>  .../bindings/spmi/qcom,spmi-pmic-arb.txt           |  11 +-
>  drivers/spmi/spmi-pmic-arb.c                       | 295 ++++++++++++++++++---
>  2 files changed, 263 insertions(+), 43 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> index 715d099..827bd21 100644
> --- a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> +++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> @@ -1,11 +1,11 @@
>  Qualcomm SPMI Controller (PMIC Arbiter)
>  
> -The SPMI PMIC Arbiter is found on the Snapdragon 800 Series.  It is an SPMI
> +The SPMI PMIC Arbiter is found on Snapdragon chipsets.  It is an SPMI
>  controller with wrapping arbitration logic to allow for multiple on-chip
>  devices to control a single SPMI master.
>  
> -The PMIC Arbiter can also act as an interrupt controller, providing interrupts
> -to slave devices.
> +The PMIC Arbiter is also an interrupt controller, interrupting the Snapdragon
> +on dtection of a sequence initiated by a request-capable-slave to the master.

s/dtection/detection/

Honestly I don't see why this part needs to change either. Please drop
this hunk.

>  
>  See spmi.txt for the generic SPMI controller binding requirements for child
>  nodes.
> @@ -38,6 +38,11 @@ Required properties:
>      cell 4: interrupt flags indicating level-sense information, as defined in
>              dt-bindings/interrupt-controller/irq.h
>  
> +Optional properties:
> +- reg-names  : may have "chnls", "obsrvr"
> +     "chnls"  - tx-channel per virtual slave registers.
> +     "obsrvr" - rx-channel (called observer) per virtual slave registers.
> +

There's already a reg-names in this document and it's not optional.
Please merge the two.

>  Example:
>  
>  	spmi {
> diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
> index 246e03a..d12979a 100644
> --- a/drivers/spmi/spmi-pmic-arb.c
> +++ b/drivers/spmi/spmi-pmic-arb.c
> @@ -25,16 +25,18 @@
>  
>  /* PMIC Arbiter configuration registers */
>  #define PMIC_ARB_VERSION		0x0000
> +#define PMIC_ARB_VERSION_V2_MIN		(0x20010000)
>  #define PMIC_ARB_INT_EN			0x0004
>  
> -/* PMIC Arbiter channel registers */
> -#define PMIC_ARB_CMD(N)			(0x0800 + (0x80 * (N)))
> -#define PMIC_ARB_CONFIG(N)		(0x0804 + (0x80 * (N)))
> -#define PMIC_ARB_STATUS(N)		(0x0808 + (0x80 * (N)))
> -#define PMIC_ARB_WDATA0(N)		(0x0810 + (0x80 * (N)))
> -#define PMIC_ARB_WDATA1(N)		(0x0814 + (0x80 * (N)))
> -#define PMIC_ARB_RDATA0(N)		(0x0818 + (0x80 * (N)))
> -#define PMIC_ARB_RDATA1(N)		(0x081C + (0x80 * (N)))
> +/* PMIC Arbiter channel registers offsets */
> +#define PMIC_ARB_CMD			(0x00)
> +#define PMIC_ARB_CONFIG			(0x04)
> +#define PMIC_ARB_STATUS			(0x08)
> +#define PMIC_ARB_WDATA0			(0x10)
> +#define PMIC_ARB_WDATA1			(0x14)
> +#define PMIC_ARB_RDATA0			(0x18)
> +#define PMIC_ARB_RDATA1			(0x1C)
> +#define PMIC_ARB_REG_CHNL(N)		(0x800 + 0x4 * (N))
>  
>  /* Interrupt Controller */
>  #define SPMI_PIC_OWNER_ACC_STATUS(M, N)	(0x0000 + ((32 * (M)) + (4 * (N))))

It looks like these macros would change too, but nothing has been done
here. Interrupts haven't been tested?

> @@ -52,6 +54,7 @@
>  
>  #define SPMI_MAPPING_TABLE_LEN		255
>  #define SPMI_MAPPING_TABLE_TREE_DEPTH	16	/* Maximum of 16-bits */
> +#define PPID_TO_CHAN_TABLE_SZ 		BIT(12)	/* PPID is 12bit chan is 1byte*/
>  
>  /* Ownership Table */
>  #define SPMI_OWNERSHIP_TABLE_REG(N)	(0x0700 + (4 * (N)))
> @@ -88,6 +91,7 @@ enum pmic_arb_cmd_op_code {
>  
>  /* Maximum number of support PMIC peripherals */
>  #define PMIC_ARB_MAX_PERIPHS		256
> +#define PMIC_ARB_MAX_CHNL		128
>  #define PMIC_ARB_PERIPH_ID_VALID	(1 << 15)
>  #define PMIC_ARB_TIMEOUT_US		100
>  #define PMIC_ARB_MAX_TRANS_BYTES	(8)
> @@ -98,14 +102,17 @@ enum pmic_arb_cmd_op_code {
>  /* interrupt enable bit */
>  #define SPMI_PIC_ACC_ENABLE_BIT		BIT(0)
>  
> +struct pmic_arb_ver;
> +
>  /**
>   * spmi_pmic_arb_dev - SPMI PMIC Arbiter object
>   *
> - * @base:		address of the PMIC Arbiter core registers.
> + * @rd_base:		on v1 "core", on v2 "observer" register base off DT.
> + * @rd_base:		on v1 "core", on v2 "chnls"    register base off DT.
>   * @intr:		address of the SPMI interrupt control registers.
>   * @cnfg:		address of the PMIC Arbiter configuration registers.
>   * @lock:		lock to synchronize accesses.
> - * @channel:		which channel to use for accesses.
> + * @channel:		which ee channel to use for accesses.

Looks like an unnecessary change.

>   * @irq:		PMIC ARB interrupt.
>   * @ee:			the current Execution Environment
>   * @min_apid:		minimum APID (used for bounding IRQ search)
> @@ -114,9 +121,11 @@ enum pmic_arb_cmd_op_code {
>   * @domain:		irq domain object for PMIC IRQ domain
>   * @spmic:		SPMI controller object
>   * @apid_to_ppid:	cached mapping from APID to PPID
> + * @ppid_to_chan	cached mapping from APID to channel number, v2 only.
>   */
>  struct spmi_pmic_arb_dev {
> -	void __iomem		*base;
> +	void __iomem		*rd_base;
> +	void __iomem		*wr_base;
>  	void __iomem		*intr;
>  	void __iomem		*cnfg;
>  	raw_spinlock_t		lock;
> @@ -129,17 +138,61 @@ struct spmi_pmic_arb_dev {
>  	struct irq_domain	*domain;
>  	struct spmi_controller	*spmic;
>  	u16			apid_to_ppid[256];
> +	const struct pmic_arb_ver *ver;
> +	u8			*ppid_to_chan;
> +};
> +
> +/**
> + * pmic_arb_ver: version dependent functionality and values.
> + *
> + * @non_data_cmd:	on v1 issues an spmi non-data command.
> + * 			on v2 no HW support, returns -EOPNOTSUPP.
> + * @offset:		on v1 offset of per-ee channel.
> + * 			on v2 offset of per-ee and per-ppid channel.
> + * @fmt_cmd:		formats a GENI/SPMI command.
> + * @owner_acc_status:	on v1 offset of PMIC_ARB_SPMI_PIC_OWNERm_ACC_STATUSn
> + * 			on v2 offset of SPMI_PIC_OWNERm_ACC_STATUSn.
> + * @acc_enable:		on v1 offset of PMIC_ARB_SPMI_PIC_ACC_ENABLEn
> + * 			on v2 offset of SPMI_PIC_ACC_ENABLEn.
> + * @irq_status:		on v1 offset of PMIC_ARB_SPMI_PIC_IRQ_STATUSn
> + * 			on v2 offset of SPMI_PIC_IRQ_STATUSn.
> + * @irq_clear:		on v1 offset of PMIC_ARB_SPMI_PIC_IRQ_CLEARn
> + * 			on v2 offset of SPMI_PIC_IRQ_CLEARn.
> + * @geni_ctrl:		PMIC_ARB_GENI_CTRL offset.
> + * @geni_status:	PMIC_ARB_GENI_STATUS offset.
> + * @protocol_irq_status: PMIC_ARB_PROTOCOL_IRQ_STATUS offset.
> + */
> +struct pmic_arb_ver {
> +	int	(*non_data_cmd)(struct spmi_controller *ctrl, u8 opc, u8 sid);
> +	/* SPMI commands (including data) related functionality */
> +	off_t	(*offset)(struct spmi_pmic_arb_dev *dev, u8 sid, u16 addr);

Isn't off_t for file offsets? It doesn't seem right to use it for
register offsets. Please use u32 or something similar.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

