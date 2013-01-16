Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3APUL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 15:11:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49302 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3APUL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 15:11:28 -0500
Message-ID: <50F7096C.7020803@wwwdotorg.org>
Date: Wed, 16 Jan 2013 13:11:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com><1357890387-23245-3-git-send-email-pgaikwad@nvidia.com> <20130116.171242.2189136612266237422.hdoyu@nvidia.com>
In-Reply-To: <20130116.171242.2189136612266237422.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 08:12 AM, Hiroshi Doyu wrote:
> Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Fri, 11 Jan 2013 08:46:20 +0100:
> 
> ....
>> diff --git a/drivers/clk/tegra/clk-audio-sync.c b/drivers/clk/tegra/clk-audio-sync.c

>> +#define to_clk_sync_source(_hw)                                        \
>> +       container_of(_hw, struct tegra_clk_sync_source, hw)
> 
> Can we define "struct tegra_clk_sync_source" here if there's no need
> to expose this structure out?

In some cases, yes. However, some of the clock structs and ops variables
are re-used by multiple clock types in different files. For example,
struct tegra_clk_periph aggregates a struct tegra_clk_frac_div and a
struct tegra_clk_periph_gate. That means that at least some of the types
and ops variables must be declared in clk.h (or some header anyway). As
such, I'd rather just have all the types and ops variables declared
there for consistency.

>> +static int clk_frac_div_set_rate(struct clk_hw *hw, unsigned long rate,
>> +                               unsigned long parent_rate)
>> +{
>> +       struct tegra_clk_frac_div *divider = to_clk_frac_div(hw);
>> +       int div;
>> +       unsigned long flags = 0;
> 
> nit, is "flags" not needed to initialize here?

It avoids a compiler warning; the compiler doesn't that the if condition
that guards the path that uses flags is the same condition as the path
that initializes it. Or, it may be related to the fact that
spin_lock_irqsave() writes to the value through a pointer parameter, and
the compiler doesn't know it's an out-only parameter.

>> diff --git a/drivers/clk/tegra/clk-periph-gate.c b/drivers/clk/tegra/clk-periph-gate.c

>> diff --git a/drivers/clk/tegra/clk-periph-gate.c b/drivers/clk/tegra/clk-periph-gate.c

>> +#define to_clk_periph_gate(_hw)                                        \
>> +       container_of(_hw, struct tegra_clk_periph_gate, hw)
> 
> For consistency, put "to_clk_periph_gate(_hw)" in "clk.h", then this
> can be used in clk-periph.c as well.

Sure. I moved all "to_clk_*()" macros to clk.h for consistency, since
the types are all there anyway.

>> +struct clk *tegra_clk_periph_gate(const char *name, const char *parent_name,
...
>> +       gate = kzalloc(sizeof(struct tegra_clk_periph_gate), GFP_KERNEL);
> 
>        gate = kzalloc(sizeof(*gate), GFP_KERNEL) ?

I've already fixed all those up locally.

>> diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c

>> +struct clk *tegra_clk_periph(const char *name, const char **parent_names,
>> +                            int num_parents, struct tegra_clk_periph *periph,
>> +                            void __iomem *clk_base, u32 offset)
>> +{
>> +       struct clk *clk;
>> +       struct clk_init_data init;
>> +
>> +       init.name = name;
>> +       init.ops = &tegra_clk_periph_ops;
>> +       init.flags = 0;
> 
> struct members in stack are expected to initialize 0.

Stack variables aren't initialized in C. In this case, since the
individual fields are being assigned via statements rather than an
initializer, everything has to be done explicitly.

>> diff --git a/drivers/clk/tegra/clk-pll-out.c b/drivers/clk/tegra/clk-pll-out.c

>> +#define pll_out_enb(p) (BIT(p->enb_bit_idx))
>> +#define pll_out_rst(p) (BIT(p->rst_bit_idx))
> 
> I don't see much benefit from the above macros.

Meh. Do you feel strongly about this? I'm not really inclined to got
through and change these; there are a bunch of similar things in other
files, and it feels like it'd just be churn.

Anything I didn't explicitly say no to, I have implemented.

A /lot/ more of the original patch was quoted that was really necessary
to make your comments; it made wading through the email a little tiresome.
