Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab3CMQbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:31:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34681 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab3CMQbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:31:01 -0400
X-AuditID: cbfee61a-b7fa86d0000045ae-75-5140a9c347b7
From: Tomasz Figa <t.figa@samsung.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] clk: Add composite clock type
Date: Wed, 13 Mar 2013 17:30:53 +0100
Message-id: <2953843.6tCZYDlhTN@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10 (Linux/3.8.1-gentoo; KDE/4.10.0; x86_64; ; )
In-reply-to: <512F9FEF.4010304@wwwdotorg.org>
References: <1359965482-29655-1-git-send-email-pgaikwad@nvidia.com>
 <512F0E2F.4000104@nvidia.com> <512F9FEF.4010304@wwwdotorg.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t9jAd3DKx0CDdoaFSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGtvPnmQrOy1f0v9vL1MB4WaKLkZNDQsBEYuKcm4wQtpjEhXvr
	2boYuTiEBBYxSqxd28EO4Sxlkvhx4zYLSBWbgJrE54ZHbCC2iICWxOnFU8FsZoEFTBITOrVB
	bGEBU4nl97Yzg9gsAqoSU1/fB+vlFdCUOHRkLdg2fgF1iXfbnjKB2KICzhJrNy4Ci3MK6Er8
	6n4FdUULo8T6A7uZIJoFJX5MvscCsUxeYt/+qawQtpbE+p3HmSYwCs5CUjYLSdksJGULGJlX
	MYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQH5zOpHYwrGywOMQpwMCrx8B7odwgUYk0sK67M
	PcQowcGsJMK7PBcoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJ
	g1OqgVFG4v4daaMPLomclo3WGpZ2rqcuZHLuEHh+pM9417WuWcmFFxvlb7szhXR+WGtqzbo8
	tuywiUPoLOYKm0fV9REeEvIOak62wXY1hmsc+5Quh39cJlzx82kDj/FDGecHv2zXqn1exuu/
	RVt6vs0tbR6BoM6zQd32MyYyHXx2RS3qfPx3noyNSizFGYmGWsxFxYkAVYyGsEoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prashant,

On Thursday 28 of February 2013 11:20:31 Stephen Warren wrote:
> On 02/28/2013 12:58 AM, Prashant Gaikwad wrote:
> > On Wednesday 06 February 2013 03:36 PM, Tomasz Figa wrote:
> >> On Wednesday 06 of February 2013 08:34:32 Prashant Gaikwad wrote:
> >>> On Tuesday 05 February 2013 03:45 PM, Tomasz Figa wrote:
> >>>> Hi Prashant,
> >>>> 
> >>>> Thank you for your patch. Please see some comments inline.
> >>>> 
> >>>> On Monday 04 of February 2013 13:41:22 Prashant Gaikwad wrote:
> >>>>> Not all clocks are required to be decomposed into basic clock
> >>>>> types but at the same time want to use the functionality
> >>>>> provided by these basic clock types instead of duplicating.
> >>>>> 
> >>>>> For example, Tegra SoC has ~100 clocks which can be decomposed
> >>>>> into Mux -> Div -> Gate clock types making the clock count to
> >>>>> ~300. Also, parent change operation can not be performed on gate
> >>>>> clock which forces to use mux clock in driver if want to change
> >>>>> the parent.
> >>>>> 
> >>>>> Instead aggregate the basic clock types functionality into one
> >>>>> clock and just use this clock for all operations. This clock
> >>>>> type re-uses the functionality of basic clock types and not
> >>>>> limited to basic clock types but any hardware-specific
> >>>>> implementation.
> >>>>> 
> >>>>> diff --git a/drivers/clk/clk-composite.c
> >>>>> 
> >>>>> +static u8 clk_composite_get_parent(struct clk_hw *hw)
> >>>>> +{
> >>>>> +     struct clk_composite *composite = to_clk_composite(hw);
> >>>>> +     const struct clk_ops *mux_ops = composite->mux_ops;
> >>>>> +     struct clk_hw *mux_hw = composite->mux_hw;
> >>>>> +
> >>>>> +     mux_hw->clk = hw->clk;
> >>>> 
> >>>> Why is this needed? Looks like this filed is already being initialized
> >>>> in clk_register_composite.
> >>> 
> >>> Some ops will get called during clk_init where this clk is not populated
> >>> hence doing here. I have done it for all ops to make sure that any
> >>> future change in clock framework don't break this clock.
> >>> Now, why duplicate it in clk_register_composite? It is possible that
> >>> none of these ops get called in clk_init.
> >>> For example, recalc_rate is called during init and this ops is supported
> >>> by div clock type, but what if div clock is not added.
> >>> 
> >>> I hope this explains the need.
> >> 
> >> Sorry, I don't understand your explanation.
> >> 
> >> I have asked why mux_hw->clk field has to be reinitialized in all the
> >> ops.
> >> 
> >> In other words, is it even possible that this clk pointer changes since
> >> calling clk_register from clk_register_composite and if yes, why?
> > 
> > Tomasz,
> > 
> > calling sequence is as
> > 
> > clk_register(struct clk_hw *hw)
> > 
> >     clk_init(struct clk_hw *hw)
> >     
> >         .
> >         .
> >         hw->clk = clk;
> >         clk->ops.recalc_rate(hw) => clk_composite_recalc_rate(hw) =>
> > 
> > composite->div_ops.recalc_rate(div_hw) => clk_divider_recalc_rate(hw)
> > 
> > Now if clk_divider_recalc_rate tries to access clk from hw then it will
> > get NULL since this is not assigned yet and that is what I am doing in
> > clk_composite_recalc_rate.
> > 
> > I am doing it in all ops because I can not assume which one will get
> > called first and always. If in future something changes the calling
> > sequence in ccf framework then it will break this clock.
> 
> Surely the CCF core should be taking care of this as part of
> clk_register() or clk_init()?

Any news on this? It would be nice if this patch could be merged soon, because 
we'd like to rework Exynos clock code to use composite clocks before merge 
window, to have that merged for 3.10.

If you don't have time to work on this, would you mind if I made any necessary 
fixes, added my sign-off next to yours and posted next version myself?

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Kernel and System Framework

