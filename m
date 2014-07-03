Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbaGCPCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:02:25 -0400
Received: from 15.mo6.mail-out.ovh.net ([188.165.39.161]:47819 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753988AbaGCPCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:02:23 -0400
X-Greylist: delayed 1285 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 11:02:23 EDT
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH 04/18] AT91: Rework ramc mapping code
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <1404396906-25194-5-git-send-email-maxime.ripard@free-electrons.com>
Date: Thu, 3 Jul 2014 22:34:17 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux@maxim.org.za, Nicolas FERRE <nicolas.ferre@atmel.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1DD61BDB-B880-49B4-BDAD-DC2BBE011F77@jcrosoft.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com> <1404396906-25194-5-git-send-email-maxime.ripard@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
X-Mailer: Apple Mail (2.1878.2)
X-Ovh-Tracer-Id: 7667096890828303293
X-Ovh-Remote: 193.138.230.182 (182.230.138.193.client.dyn.strong-ba6.blackoakcomputers.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch 4 and 18 what is the difference?

Best Regards,
J.
On Jul 3, 2014, at 10:14 PM, Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> 
> Adapt the ramc mapping code to handle multiple ram controllers in the DT.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
> arch/arm/mach-at91/setup.c | 26 ++++++++++++++------------
> 1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 9c4c7fb323fb..cc520596f23b 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -393,24 +393,26 @@ static void at91_dt_ramc(void)
> {
> 	struct device_node *np;
> 	const struct of_device_id *of_id;
> +	int idx = 0;
> 
> -	np = of_find_matching_node(NULL, ramc_ids);
> -	if (!np)
> -		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
> +	for_each_matching_node(np, ramc_ids) {
> +		at91_ramc_base[idx] = of_iomap(np, 0);
> +		if (!at91_ramc_base[idx])
> +			panic(pr_fmt("unable to map ramc[%d] cpu registers\n"), idx);
> 
> -	at91_ramc_base[0] = of_iomap(np, 0);
> -	if (!at91_ramc_base[0])
> -		panic(pr_fmt("unable to map ramc[0] cpu registers\n"));
> -	/* the controller may have 2 banks */
> -	at91_ramc_base[1] = of_iomap(np, 1);
> +		idx++;
> +	}
> +
> +	if (!idx)
> +		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
> 
> 	of_id = of_match_node(ramc_ids, np);
> -	if (!of_id)
> +	if (!of_id) {
> 		pr_warn("ramc no standby function available\n");
> -	else
> -		at91_pm_set_standby(of_id->data);
> +		return;
> +	}
> 
> -	of_node_put(np);
> +	at91_pm_set_standby(of_id->data);
> }
> 
> static struct of_device_id shdwc_ids[] = {
> -- 
> 2.0.1
> 

