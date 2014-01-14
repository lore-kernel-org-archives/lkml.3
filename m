Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaANXma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:42:30 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2451 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599AbaANXm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:42:26 -0500
Date: Tue, 14 Jan 2014 15:44:03 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Josh Cartwright <joshc@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH v4 4/6] spmi: pmic_arb: add support for interrupt handling
Message-ID: <20140114234402.GD23276@sonymobile.com>
References: <cover.1389738151.git.joshc@codeaurora.org>
 <0f3e257f098d5f1ec6e9f09ba4dbf055291f2d83.1389738151.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0f3e257f098d5f1ec6e9f09ba4dbf055291f2d83.1389738151.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 07:41:38PM +0100, Josh Cartwright wrote:
> The Qualcomm PMIC Arbiter, in addition to being a basic SPMI controller,
> also implements interrupt handling for slave devices.  Note, this is
> outside the scope of SPMI, as SPMI leaves interrupt handling completely
> unspecified.
> 
> Extend the driver to provide a irq_chip implementation and chained irq
> handling which allows for these interrupts to be used.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/spmi/spmi-pmic-arb.c | 393 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 391 insertions(+), 2 deletions(-)
> 

Yay! Good to see this series.

> diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
> index 16083cd..32bed54 100644
> --- a/drivers/spmi/spmi-pmic-arb.c
> +++ b/drivers/spmi/spmi-pmic-arb.c
> @@ -13,6 +13,9 @@
>  #include <linux/err.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> +#include <linux/irqchip/chained_irq.h>
> +#include <linux/irqdomain.h>
> +#include <linux/irq.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> @@ -103,6 +106,14 @@ enum pmic_arb_cmd_op_code {
>   * @cnfg:              address of the PMIC Arbiter configuration registers.
>   * @lock:              lock to synchronize accesses.
>   * @channel:           which channel to use for accesses.
> + * @irq:               PMIC ARB interrupt.
> + * @ee:                        the current Execution Environment
> + * @min_apid:          minimum APID (used for bounding IRQ search)
> + * @max_apid:          maximum APID
> + * @mapping_table:     in-memory copy of PPID -> APID mapping table.
> + * @domain:            irq domain object for PMIC IRQ domain
> + * @spmic:             SPMI controller object
> + * @apid_to_ppid:      cached mapping from APID to PPID
>   */
>  struct spmi_pmic_arb_dev {
>         void __iomem            *base;
> @@ -110,6 +121,14 @@ struct spmi_pmic_arb_dev {
>         void __iomem            *cnfg;
>         spinlock_t              lock;
>         u8                      channel;
> +       unsigned int            irq;
> +       u8                      ee;
> +       u8                      min_apid;
> +       u8                      max_apid;
> +       u32                     mapping_table[SPMI_MAPPING_TABLE_LEN];
> +       struct irq_domain       *domain;
> +       struct spmi_controller  *spmic;
> +       u16                     apid_to_ppid[256];
>  };
> 
>  static inline u32 pmic_arb_base_read(struct spmi_pmic_arb_dev *dev, u32 offset)
> @@ -314,12 +333,333 @@ static int pmic_arb_write_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
>         return rc;
>  }
> 
> +enum qpnpint_regs {
> +       QPNPINT_REG_RT_STS              = 0x10,
> +       QPNPINT_REG_SET_TYPE            = 0x11,
> +       QPNPINT_REG_POLARITY_HIGH       = 0x12,
> +       QPNPINT_REG_POLARITY_LOW        = 0x13,
> +       QPNPINT_REG_LATCHED_CLR         = 0x14,
> +       QPNPINT_REG_EN_SET              = 0x15,
> +       QPNPINT_REG_EN_CLR              = 0x16,
> +       QPNPINT_REG_LATCHED_STS         = 0x18,
> +};
> +
> +struct spmi_pmic_arb_qpnpint_type {
> +       u8 type; /* 1 -> edge */
> +       u8 polarity_high;
> +       u8 polarity_low;
> +} __packed;
> +

While the rest of this driver uses 'pmic' or 'spmi_pmic', this patch
adds 'qpnpint'.  Can we please just leave the software fabricated name
'qpnp' out of any changes, as it isn't in any hardware spec?  Perhaps
'pmic_int' or something along those lines?

> +/* Simplified accessor functions for irqchip callbacks */
> +static void qpnpint_spmi_write(struct irq_data *d, u8 reg, void *buf,
> +                              size_t len)
[...]

-Courtney
