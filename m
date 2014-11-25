Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaKYIK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:10:59 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24729 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaKYIK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:10:56 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a9-5474398c373d
Message-id: <1416903050.5023.28.camel@AMDC1943>
Subject: Re: [RFC 1/2] clk: Allow overriding generic ops for clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Date: Tue, 25 Nov 2014 09:10:50 +0100
In-reply-to: <20141125013450.12298.96117@quantum>
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
 <1416842312-4405-2-git-send-email-k.kozlowski@samsung.com>
 <20141125013450.12298.96117@quantum>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xq7o9liUhBhPn6Fu0XTnIbnH0d4FF
	/+PXzBZPNz9mstj0+BqrxeVdc9gsZpzfx2TxdMJFNovDb9pZLVbt+sPowOXx9/l1Fo+ds+6y
	e2xa1cnmcefaHjaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj1/t7TAUNyhV/z1k3
	MH6W7GLk5JAQMJHo+rSVEcIWk7hwbz1bFyMXh5DAUkaJ20dns0A4nxklvux7BVbFK6Avsen8
	AiYQW1jAWaJ13WZWEJtNwFhi8/IlbCC2iICWxLYDrWCTmAXeMEmcuPGfBSTBIqAqsb9jPpjN
	KWAoMW32S6gNqxglJlz9BpZgFlCXmDRvEXMXIwfQTcoSjf1uEIsFJX5MvgdVIi+xec1b5gmM
	ArOQdMxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFR8XUH49JjVocYBTgY
	lXh4KzSLQ4RYE8uKK3MPMUpwMCuJ8EbNAwrxpiRWVqUW5ccXleakFh9iZOLglGpgvLpAernb
	TRHj2ljjEun1IgHlspYXWJ8s3LjMPjvL/pmVTcGrk9OV50vZnNHNuHM19JOJZHzd1+kZvrdr
	t3sIzuadoF554PJF1VcSB+7VxEwJ6nf42z9p8kK3J3mcv61Xvdx8b8eHsJZNq+WZVzs+uTFz
	x51rbN1qjyfwmhZL9D26Ul2cpLf8phJLcUaioRZzUXEiAAo0ZsVoAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-11-24 at 17:34 -0800, Mike Turquette wrote:
> Quoting Krzysztof Kozlowski (2014-11-24 07:18:31)
> > For clocks depending on some other clock domain one may want to perform
> > specific ops before actual enable/disable of gate clock. Allow such case
> > by accepting supplied ops in new exported function:
> > clk_register_gate_ops().
> 
> If you are not going to use the gate_ops, why use the gate clock at all?
> You can create a platform-specific clock type which uses the ops you
> specify.

Actually I want to use gate_ops (and as much as possible from current
code) but I need to encapsulate gate_ops calls in other enable/disable
of other clock. In 2nd patch:
 
+static int audss_clk_gate_enable(struct clk_hw *hw)
+{
+       int ret;
+
+       if (!IS_ERR(pll_in))
+               clk_prepare_enable(pll_in);
+       ret = clk_gate_ops.enable(hw);
+       if (!IS_ERR(pll_in))
+               clk_disable_unprepare(pll_in);
+
+       return ret;
+}

Other idea is to add some kind of dependency between clocks... but
wait... there is already parent-child dependency. However these audss
clocks need two parents :) 

Best regards,
Krzysztof

> 
> Regards,
> Mike
> 
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/clk/clk-gate.c       | 16 +++++++++++++---
> >  include/linux/clk-provider.h |  5 +++++
> >  2 files changed, 18 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> > index 51fd87fb7ba6..51802af2d9e7 100644
> > --- a/drivers/clk/clk-gate.c
> > +++ b/drivers/clk/clk-gate.c
> > @@ -117,11 +117,12 @@ EXPORT_SYMBOL_GPL(clk_gate_ops);
> >   * @bit_idx: which bit in the register controls gating of this clock
> >   * @clk_gate_flags: gate-specific flags for this clock
> >   * @lock: shared register lock for this clock
> > + * @ops: clk_ops to use for this clock
> >   */
> > -struct clk *clk_register_gate(struct device *dev, const char *name,
> > +struct clk *clk_register_gate_ops(struct device *dev, const char *name,
> >                 const char *parent_name, unsigned long flags,
> >                 void __iomem *reg, u8 bit_idx,
> > -               u8 clk_gate_flags, spinlock_t *lock)
> > +               u8 clk_gate_flags, spinlock_t *lock, const struct clk_ops *ops)
> >  {
> >         struct clk_gate *gate;
> >         struct clk *clk;
> > @@ -142,7 +143,7 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
> >         }
> >  
> >         init.name = name;
> > -       init.ops = &clk_gate_ops;
> > +       init.ops = ops;
> >         init.flags = flags | CLK_IS_BASIC;
> >         init.parent_names = (parent_name ? &parent_name: NULL);
> >         init.num_parents = (parent_name ? 1 : 0);
> > @@ -161,4 +162,13 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
> >  
> >         return clk;
> >  }
> > +EXPORT_SYMBOL_GPL(clk_register_gate_ops);
> > +
> > +struct clk *clk_register_gate(struct device *dev, const char *name,
> > +               const char *parent_name, unsigned long flags,
> > +               void __iomem *reg, u8 bit_idx,
> > +               u8 clk_gate_flags, spinlock_t *lock)
> > +{
> > +       return clk_register_gate_ops(dev, name, parent_name, flags, reg, bit_idx, clk_gate_flags, lock, &clk_gate_ops);
> > +}
> >  EXPORT_SYMBOL_GPL(clk_register_gate);
> > diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> > index be21af149f11..6cfc77a9f339 100644
> > --- a/include/linux/clk-provider.h
> > +++ b/include/linux/clk-provider.h
> > @@ -290,11 +290,16 @@ struct clk_gate {
> >  #define CLK_GATE_HIWORD_MASK           BIT(1)
> >  
> >  extern const struct clk_ops clk_gate_ops;
> > +struct clk *clk_register_gate_ops(struct device *dev, const char *name,
> > +               const char *parent_name, unsigned long flags,
> > +               void __iomem *reg, u8 bit_idx,
> > +               u8 clk_gate_flags, spinlock_t *lock, const struct clk_ops *ops);
> >  struct clk *clk_register_gate(struct device *dev, const char *name,
> >                 const char *parent_name, unsigned long flags,
> >                 void __iomem *reg, u8 bit_idx,
> >                 u8 clk_gate_flags, spinlock_t *lock);
> >  
> > +
> >  struct clk_div_table {
> >         unsigned int    val;
> >         unsigned int    div;
> > -- 
> > 1.9.1
> > 

