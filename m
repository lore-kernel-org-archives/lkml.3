Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaGKUxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:53:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55174 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaGKUxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:53:49 -0400
Message-ID: <53C04ED9.6030508@codeaurora.org>
Date: Fri, 11 Jul 2014 13:53:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1] clk: qcom: Add APQ8084 Multimedia Clock Controller
 (MMCC) support
References: <1402591302-12100-1-git-send-email-gdjakov@mm-sol.com>
In-Reply-To: <1402591302-12100-1-git-send-email-gdjakov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/14 09:41, Georgi Djakov wrote:
> Add support for the multimedia clock controller found on the APQ8084
> based platforms. This will allow the multimedia device drivers to
> control their clocks.
>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---

I started picking up the qcom clock patches from the list. I see that
this one has a small problem though:

drivers/clk/qcom/mmcc-apq8084.c:169:10: warning: Initializer entry
defined twice
drivers/clk/qcom/mmcc-apq8084.c:170:10:   also defined here
drivers/clk/qcom/mmcc-apq8084.c:185:10: warning: Initializer entry
defined twice
drivers/clk/qcom/mmcc-apq8084.c:187:10:   also defined here
drivers/clk/qcom/mmcc-apq8084.c:203:10: warning: Initializer entry
defined twice
drivers/clk/qcom/mmcc-apq8084.c:205:10:   also defined here

> diff --git a/drivers/clk/qcom/mmcc-apq8084.c b/drivers/clk/qcom/mmcc-apq8084.c
> new file mode 100644
> index 0000000..9cc956a
> --- /dev/null
> +++ b/drivers/clk/qcom/mmcc-apq8084.c
> @@ -0,0 +1,3352 @@
> +/*
> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/reset-controller.h>
> +
> +#include <dt-bindings/clock/qcom,mmcc-apq8084.h>
> +#include <dt-bindings/reset/qcom,mmcc-apq8084.h>
> +
> +#include "common.h"
> +#include "clk-regmap.h"
> +#include "clk-pll.h"
> +#include "clk-rcg.h"
> +#include "clk-branch.h"
> +#include "reset.h"
> +
> +#define P_XO		0
> +#define P_MMPLL0	1
> +#define P_EDPLINK	1
> +#define P_MMPLL1	2
> +#define P_HDMIPLL	2
> +#define P_GPLL0		3
> +#define P_EDPVCO	3
> +#define P_MMPLL4	3

Seems that these are shared in the same parent map table. I'm not sure
the best way to fix this yet because it's pretty annoying to come up
with an optimal order. Maybe the whole scheme should be thrown out and
we should just loop over the parent map looking for a particular enum
value, and then have that enum map to the actual register value. We lose
the direct indexing into the array, but it sure makes things a lot
easier and avoids this whole mess.

> +#define P_GPLL1		4
> +#define P_DSI0PLL	4
> +#define P_DSI0PLL_BYTE	4
> +#define P_MMPLL2	4
> +#define P_MMPLL3	4
> +#define P_DSI1PLL	5
> +#define P_DSI1PLL_BYTE	5
> +#define P_MMSLEEP	6
> +
> +static const u8 mmcc_xo_mmpll0_mmpll1_gpll0_map[] = {
> +	[P_XO]		= 0,
> +	[P_MMPLL0]	= 1,
> +	[P_MMPLL1]	= 2,
> +	[P_GPLL0]	= 5,
> +};
> +
> +static const char *mmcc_xo_mmpll0_mmpll1_gpll0[] = {
> +	"xo",
> +	"mmpll0_vote",
> +	"mmpll1_vote",
> +	"mmss_gpll0_vote",
> +};
> +
> +static const u8 mmcc_xo_mmpll0_dsi_hdmi_gpll0_map[] = {
> +	[P_XO]		= 0,
> +	[P_MMPLL0]	= 1,
> +	[P_HDMIPLL]	= 4,
> +	[P_GPLL0]	= 5,
> +	[P_DSI0PLL]	= 2,
> +	[P_DSI1PLL]	= 3,
> +};
> +
> +static const char *mmcc_xo_mmpll0_dsi_hdmi_gpll0[] = {
> +	"xo",
> +	"mmpll0_vote",
> +	"hdmipll",
> +	"mmss_gpll0_vote",
> +	"dsi0pll",
> +	"dsi1pll",
> +};
> +
> +static const u8 mmcc_xo_mmpll0_1_2_gpll0_map[] = {
> +	[P_XO]		= 0,
> +	[P_MMPLL0]	= 1,
> +	[P_MMPLL1]	= 2,
> +	[P_GPLL0]	= 5,
> +	[P_MMPLL2]	= 3,
> +};
> +
> +static const char *mmcc_xo_mmpll0_1_2_gpll0[] = {
> +	"xo",
> +	"mmpll0_vote",
> +	"mmpll1_vote",
> +	"mmss_gpll0_vote",
> +	"mmpll2",
> +};
> +
> +static const u8 mmcc_xo_mmpll0_1_3_gpll0_map[] = {
> +	[P_XO]		= 0,
> +	[P_MMPLL0]	= 1,
> +	[P_MMPLL1]	= 2,
> +	[P_GPLL0]	= 5,
> +	[P_MMPLL3]	= 3,
> +};
> +
> +static const char *mmcc_xo_mmpll0_1_3_gpll0[] = {
> +	"xo",
> +	"mmpll0_vote",
> +	"mmpll1_vote",
> +	"mmss_gpll0_vote",
> +	"mmpll3",
> +};
> +
> +static const u8 mmcc_xo_dsi_hdmi_edp_map[] = {
> +	[P_XO]		= 0,
> +	[P_EDPLINK]	= 4,
> +	[P_HDMIPLL]	= 3,
> +	[P_EDPVCO]	= 5,
> +	[P_DSI0PLL]	= 1,
> +	[P_DSI1PLL]	= 2,
> +};
> +
> +static const char *mmcc_xo_dsi_hdmi_edp[] = {
> +	"xo",
> +	"edp_link_clk",
> +	"hdmipll",
> +	"edp_vco_div",
> +	"dsi0pll",
> +	"dsi1pll",
> +};
> +
> +static const u8 mmcc_xo_dsi_hdmi_edp_gpll0_map[] = {
> +	[P_XO]		= 0,
> +	[P_EDPLINK]	= 4,
> +	[P_HDMIPLL]	= 3,
> +	[P_GPLL0]	= 5,
> +	[P_DSI0PLL]	= 1,
> +	[P_DSI1PLL]	= 2,
> +};
> +
> +static const char *mmcc_xo_dsi_hdmi_edp_gpll0[] = {
> +	"xo",
> +	"edp_link_clk",
> +	"hdmipll",
> +	"gpll0_vote",
> +	"dsi0pll",
> +	"dsi1pll",
> +};
> +
> +static const u8 mmcc_xo_dsibyte_hdmi_edp_gpll0_map[] = {
> +	[P_XO]			= 0,
> +	[P_EDPLINK]		= 4,
> +	[P_HDMIPLL]		= 3,
> +	[P_GPLL0]		= 5,
> +	[P_DSI0PLL_BYTE]	= 1,
> +	[P_DSI1PLL_BYTE]	= 2,
> +};
> +
> +static const char *mmcc_xo_dsibyte_hdmi_edp_gpll0[] = {
> +	"xo",
> +	"edp_link_clk",
> +	"hdmipll",
> +	"gpll0_vote",
> +	"dsi0pllbyte",
> +	"dsi1pllbyte",
> +};
> +
> +static const u8 mmcc_xo_mmpll0_1_4_gpll0_map[] = {
> +	[P_XO]		= 0,
> +	[P_MMPLL0]	= 1,
> +	[P_MMPLL1]	= 2,
> +	[P_MMPLL4]	= 3,
> +	[P_GPLL0]	= 5,
> +};
> +
> +static const char *mmcc_xo_mmpll0_1_4_gpll0[] = {
> +	"xo",
> +	"mmpll0",
> +	"mmpll1",
> +	"mmpll4",
> +	"gpll0",
> +};
> +
> +static const u8 mmcc_xo_mmpll0_1_4_gpll1_0_map[] = {
> +	[P_XO]		= 0,
> +	[P_MMPLL0]	= 1,
> +	[P_MMPLL1]	= 2,
> +	[P_MMPLL4]	= 3,
> +	[P_GPLL1]	= 4,
> +	[P_GPLL0]	= 5,
> +};
> +
> +static const char *mmcc_xo_mmpll0_1_4_gpll1_0[] = {
> +	"xo",
> +	"mmpll0",
> +	"mmpll1",
> +	"mmpll4",
> +	"gpll1",
> +	"gpll0",
> +};
> +
> +static const u8 mmcc_xo_mmpll0_1_4_gpll1_0_sleep_map[] = {
> +	[P_XO]		= 0,
> +	[P_MMPLL0]	= 1,
> +	[P_MMPLL1]	= 2,
> +	[P_MMPLL4]	= 3,
> +	[P_GPLL1]	= 4,
> +	[P_GPLL0]	= 5,
> +	[P_MMSLEEP]	= 6,
> +};
> +
> +static const char *mmcc_xo_mmpll0_1_4_gpll1_0_sleep[] = {
> +	"xo",
> +	"mmpll0",
> +	"mmpll1",
> +	"mmpll4",
> +	"gpll1",
> +	"gpll0",
> +	"sleep_clk_src",
> +};
> +
>


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

