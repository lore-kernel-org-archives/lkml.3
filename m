Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbaDHPpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:45:24 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37108 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbaDHPpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:45:21 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-54-5344198e211d
Message-id: <5344198B.2030604@samsung.com>
Date: Tue, 08 Apr 2014 17:45:15 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com, airlied@linux.ie,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com,
        a.hajda@samsung.com, kishon@ti.com
Subject: Re: [PATCH 1/4] clk: propagate parent change up one level
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
 <1396623201-26000-2-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1396623201-26000-2-git-send-email-t.stanislaws@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e/4Vd0+SZdgg9sHRS1urTvHatF77iST
	xfwjQNaVr+/ZLCbdn8Bi0bvgKpvFhac9bBZnm96wW2x6fI3V4vKuOWwWM87vY7J4OuEim8Xh
	FQeYLGZMfslmMe/zTiaLee0vWR0EPBZ8vsLusXPWXXaPO9f2sHls//aA1eN+93Emj81L6j36
	tqxi9Dh+YzuTx+dNcgGcUVw2Kak5mWWpRfp2CVwZn34vYC3YJFSx6fs+xgbGS3xdjJwcEgIm
	EusfdTFC2GISF+6tZ+ti5OIQEljKKLH9yXd2kISQwGdGid5bViA2r4CWRNO7N2ANLAKqEt9u
	3mECsdkE1CQ+NzxiA7H5gWrWNF1nAbFFBSIk7jUeZoXoFZT4MfkeC8gCEYE7jBJLGz+BbWMW
	eMMo8Wb2R2aQKmEBJ4kbXRugzmhnlLj+ux2snVPAU6Ll4HewFcwC1hIrJ21jhLDlJTavecs8
	gVFwFpIts5CUzUJStoCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSAx+2cG4+JjVIUYB
	DkYlHt7KI07BQqyJZcWVuYcYJTiYlUR4//K5BAvxpiRWVqUW5ccXleakFh9iZOLglGpgXFHr
	77vCiJ2D6e+M5pDMOTvaH9SklE+8VJNxa+d9w7sLGw5pbig99nrXBNvK/ebuzkx3Lk04tWTB
	+/lzmuqru03bPvKu8vIRnPYv7c6bG6USn87btfueZ2Mxmiv+gI1FtUe3zXv6+dNL5P4Wnw+0
	lWZ8mPhYaWb29/Zz8x5Mks1eccbsG+eXF0osxRmJhlrMRcWJAL9mVPOfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04.04.2014 16:53, Tomasz Stanislawski wrote:
> This patch adds support for propagation of setup of clock's parent one level
> up.
>
> This feature is helpful when a driver changes topology of its clocks using
> clk_set_parent().  The problem occurs when on one platform/SoC driver's clock
> is located at MUX output but on the other platform/SoC there is a gated proxy
> clock between the MUX and driver's clock.  In such a case, driver's code has to
> be modified to use one clock for enabling and the other clock for setup of a
> parent.
>
> The code updates are avoided by propagating setup of a parent up one level.
>
> Additionally, this patch adds CLK_SET_PARENT_PARENT (sorry for naming) flag to
> inform clk-core that clk_set_parent() should be propagated.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>   drivers/clk/clk.c            |    6 ++++++
>   include/linux/clk-provider.h |    1 +
>   2 files changed, 7 insertions(+)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index dff0373..53bbfda 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1737,6 +1737,12 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>
>   	/* try finding the new parent index */
>   	if (parent) {
> +		if ((clk->flags & CLK_SET_PARENT_PARENT)
> +		    && clk->num_parents == 1) {
> +			ret = clk_set_parent(clk->parent, parent);
> +			goto out;
> +		}
> +
>   		p_index = clk_fetch_parent_index(clk, parent);
>   		p_rate = parent->rate;
>   		if (p_index < 0) {
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 5119174..daa0b03 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -30,6 +30,7 @@
>   #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
>   #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate change */
>   #define CLK_GET_ACCURACY_NOCACHE BIT(8) /* do not use the cached clk accuracy */
> +#define CLK_SET_PARENT_PARENT	BIT(9) /* propagate parent change up one level */
>
>   struct clk_hw;
>   struct dentry;
>

This would be very useful, at least on Exynos platforms, with 
mux-div-gate clock paths. PARENT_PARENT sounds a bit funny, though.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
