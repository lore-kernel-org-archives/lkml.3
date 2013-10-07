Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3JGQFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:05:55 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:6454
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab3JGQFw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:05:52 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1454I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz8dhz1de098h1de097h8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Mon, 7 Oct 2013 09:05:40 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Felipe Pena <felipensp@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] clk/zynq: Fix possible memory leak
References: <1381107317-18120-1-git-send-email-felipensp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1381107317-18120-1-git-send-email-felipensp@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <38108046-8400-4f4d-b61c-d3e0cdecb431@DB8EHSMHS013.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 09:55:17PM -0300, Felipe Pena wrote:
> The zynq_clk_register_fclk function can leak memory (fclk_lock) when unable 
> to alloc memory for fclk_gate_lock
> 
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>  drivers/clk/zynq/clkc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
> index cc40fe6..7ea4b5c 100644
> --- a/drivers/clk/zynq/clkc.c
> +++ b/drivers/clk/zynq/clkc.c
> @@ -117,6 +117,7 @@ static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
>  		goto err;
>  	fclk_gate_lock = kmalloc(sizeof(*fclk_gate_lock), GFP_KERNEL);
>  	if (!fclk_gate_lock)
> +		kfree(fclk_lock);
>  		goto err;

Looking at that function, the following calls to various clk_register_*
functions miss correct error handling as well. Therefore it might make
sense to consolidate this free in an error path at the bottom of the
function. That would make things easier when somebody wants to add more
error handling.

Other than that you're right and feel free to add my Acked-by, once you
have fixed the missing braces, Baruch pointed out.

	Sören


