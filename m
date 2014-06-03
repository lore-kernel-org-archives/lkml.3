Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaFCJYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:24:20 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56074 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaFCJYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:24:16 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2] coccinelle: Check for missing NULL terminators in
 of_device_id tables
To: Stephen Boyd <sboyd@codeaurora.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Mitchel Humpherys <mitchelh@codeaurora.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
In-Reply-To: <1401213858-31950-1-git-send-email-sboyd@codeaurora.org>
References: <1401213858-31950-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 03 Jun 2014 10:24:12 +0100
Message-Id: <20140603092412.AAEE2C40D3B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 11:04:18 -0700, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Failure to terminate an of_device_id table can lead to confusing
> failures depending on where the compiler places the array. Add a
> check to make sure these tables are terminated. Thanks to Mitchel
> Humpherys for coming up with the pattern initially.
> 
> Cc: Mitchel Humpherys <mitchelh@codeaurora.org>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: Gilles Muller <Gilles.Muller@lip6.fr>
> Cc: Nicolas Palix <nicolas.palix@imag.fr>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Looks good to me:

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  scripts/coccinelle/misc/of_table.cocci | 73 ++++++++++++++++++++++++++++++++++
>  1 file changed, 73 insertions(+)
>  create mode 100644 scripts/coccinelle/misc/of_table.cocci
> 
> diff --git a/scripts/coccinelle/misc/of_table.cocci b/scripts/coccinelle/misc/of_table.cocci
> new file mode 100644
> index 000000000000..838c74c418c9
> --- /dev/null
> +++ b/scripts/coccinelle/misc/of_table.cocci
> @@ -0,0 +1,73 @@
> +/// Make sure of_device_id tables are NULL terminated
> +//
> +// Keywords: of_table
> +// Confidence: Medium
> +// Options: --include-headers
> +
> +virtual patch
> +virtual context
> +virtual org
> +virtual report
> +
> +@bad_of_table exists@
> +identifier var, arr;
> +expression E;
> +@@
> +struct of_device_id arr[] = {
> +	...,
> +	{
> +	.var = E,
> +	}
> +};
> +
> +@depends on bad_of_table && context@
> +identifier var, arr;
> +expression E;
> +@@
> +struct of_device_id arr[] = {
> +	...,
> +	{
> +*	.var = E,
> +	}
> +};
> +
> +@depends on bad_of_table && patch@
> +identifier var, arr;
> +expression E;
> +@@
> +struct of_device_id arr[] = {
> +	...,
> +	{
> +	.var = E,
> +-	}
> ++	},
> ++	{ }
> +};
> +
> +@r depends on bad_of_table exists@
> +position p1;
> +identifier var, arr;
> +expression E;
> +@@
> +struct of_device_id arr[] = {
> +	...,
> +	{
> +	.var = E,
> +	}
> +	@p1
> +};
> +
> +@script:python depends on org@
> +p1 << r.p1;
> +arr << r.arr;
> +@@
> +
> +cocci.print_main(arr,p1)
> +
> +@script:python depends on report@
> +p1 << r.p1;
> +arr << r.arr;
> +@@
> +
> +msg = "%s is not NULL terminated at line %s" % (arr, p1[0].line)
> +coccilib.report.print_report(p1[0],msg)
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

