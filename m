Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaICIh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:37:28 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33267 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbaICIhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:37:23 -0400
MIME-Version: 1.0
In-Reply-To: <1409159852-7249-8-git-send-email-mathieu.poirier@linaro.org>
References: <1409159852-7249-1-git-send-email-mathieu.poirier@linaro.org>
	<1409159852-7249-8-git-send-email-mathieu.poirier@linaro.org>
Date: Wed, 3 Sep 2014 10:37:22 +0200
Message-ID: <CACRpkdZO7Mo_JaecjypR_kXKwaatgU+4oLLKheQ22OcNMG_-nQ@mail.gmail.com>
Subject: Re: [PATCH 07/11 v5] coresight-etm: add CoreSight ETM/PTM driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>, r.sengupta@samsung.com,
        Robert Marklund <robbelibobban@gmail.com>, Tony.Armitstead@arm.com,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 7:17 PM,  <mathieu.poirier@linaro.org> wrote:

> From: Pratik Patel <pratikp@codeaurora.org>
>
> This driver manages CoreSight ETM (Embedded Trace Macrocell) that
> supports processor tracing. Currently supported version are ARM
> ETMv3.x and PTM1.x.
>
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

(...)
> +/* Accessors for CP14 registers */
> +#define dbg_read(reg)                  RCP14_##reg()
> +#define dbg_write(val, reg)            WCP14_##reg(val)
> +#define etm_read(reg)                  RCP14_##reg()
> +#define etm_write(val, reg)            WCP14_##reg(val)
> +
> +/* MRC14 and MCR14 */
> +#define MRC14(op1, crn, crm, op2)                                      \
> +({                                                                     \
> +u32 val;                                                               \
> +asm volatile("mrc p14, "#op1", %0, "#crn", "#crm", "#op2 : "=r" (val));        \
> +val;                                                                   \
> +})
> +
> +#define MCR14(val, op1, crn, crm, op2)                                 \
> +({                                                                     \
> +asm volatile("mcr p14, "#op1", %0, "#crn", "#crm", "#op2 : : "r" (val));\
> +})

OK... some ARMish funny assembly...

(...)

But this:

> +static unsigned int etm_read_reg(u32 reg)
> +{
> +       switch (reg) {
> +       case ETMCR:
> +               return etm_read(ETMCR);
> +       case ETMCCR:
> +               return etm_read(ETMCCR);
(...)

And this:

> +static void etm_write_reg(u32 val, u32 reg)
> +{
> +       switch (reg) {
> +       case ETMCR:
> +               etm_write(val, ETMCR);
> +               return;
> +       case ETMTRIGGER:
> +               etm_write(val, ETMTRIGGER);
> +               return;

And then this:

> +unsigned int etm_readl_cp14(u32 off)
> +{
> +       return etm_read_reg(off);
> +}
> +
> +void etm_writel_cp14(u32 val, u32 off)
> +{
> +       etm_write_reg(val, off);
> +}

And then this:

+static inline void etm_writel(struct etm_drvdata *drvdata,
+                             u32 val, u32 off)
+{
+       if (drvdata->use_cp14)
+               etm_writel_cp14(val, off);
+       else
+               writel_relaxed(val, drvdata->base + off);
+}
+
+static inline unsigned int etm_readl(struct etm_drvdata *drvdata, u32 off)
+{
+       u32 val;
+
+       if (drvdata->use_cp14)
+               val = etm_readl_cp14(off);
+       else
+               val = readl_relaxed(drvdata->base + off);
+       return val;
+}

Just looks like an extra layer or two or three of indirection of
absolutely no use or value. It seems to be done because someone
doesn't know how to get parameters to assembly inlines and
added all the switch statements for get #defined enumerators
from variables.

The code actually using these layered accessors look like this:

etmcr = etm_readl(drvdata, ETMCR);

I would rewrite the last function like this:

static inline unsigned int etm_readl(struct etm_drvdata *drvdata, u32 off)
{
       u32 val;

       if (drvdata->use_cp14)
               asm_volatile()...
       else
               val = readl_relaxed(drvdata->base + off);
       return val;
}

The asm_volatile() and parametrizing it is the trick. Just figure it out ;)
http://www.ethernut.de/en/documents/arm-inline-asm.html

> diff --git a/drivers/coresight/coresight-etm.h b/drivers/coresight/coresight-etm.h
(...)
> +struct etm_drvdata {
> +       void __iomem                    *base;
> +       struct device                   *dev;
> +       struct coresight_device         *csdev;
> +       struct clk                      *clk;
> +       spinlock_t                      spinlock;
> +       int                             cpu;
> +       int                             port_size;
> +       u8                              arch;
> +       bool                            use_cp14;
> +       bool                            enable;
> +       bool                            sticky_enable;
> +       bool                            boot_enable;
> +       bool                            os_unlock;
> +       u8                              nr_addr_cmp;
> +       u8                              nr_cntr;
> +       u8                              nr_ext_inp;
> +       u8                              nr_ext_out;
> +       u8                              nr_ctxid_cmp;
> +       u8                              reset;
> +       u32                             etmccr;
> +       u32                             etmccer;
> +       u32                             traceid;
> +       u32                             mode;
> +       u32                             ctrl;
> +       u32                             trigger_event;
> +       u32                             startstop_ctrl;
> +       u32                             enable_event;
> +       u32                             enable_ctrl1;
> +       u32                             fifofull_level;
> +       u8                              addr_idx;
> +       u32                             addr_val[ETM_MAX_ADDR_CMP];
> +       u32                             addr_acctype[ETM_MAX_ADDR_CMP];
> +       u32                             addr_type[ETM_MAX_ADDR_CMP];
> +       u8                              cntr_idx;
> +       u32                             cntr_rld_val[ETM_MAX_CNTR];
> +       u32                             cntr_event[ETM_MAX_CNTR];
> +       u32                             cntr_rld_event[ETM_MAX_CNTR];
> +       u32                             cntr_val[ETM_MAX_CNTR];
> +       u32                             seq_12_event;
> +       u32                             seq_21_event;
> +       u32                             seq_23_event;
> +       u32                             seq_31_event;
> +       u32                             seq_32_event;
> +       u32                             seq_13_event;
> +       u32                             seq_curr_state;
> +       u8                              ctxid_idx;
> +       u32                             ctxid_val[ETM_MAX_CTXID_CMP];
> +       u32                             ctxid_mask;
> +       u32                             sync_freq;
> +       u32                             timestamp_event;
> +};

Unless all of this is self-evident I would kerneldoc it. If I don't
understand something of this, and if you don't, who's going to
understand it in a few years...

Apart from this it looks OK. Albeit big. But that may be unavoidable.

Yours,
Linus Walleij
