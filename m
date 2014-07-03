Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaGCNu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:50:27 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:61402 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaGCNu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:50:26 -0400
Message-ID: <53B55FA6.5080801@cogentembedded.com>
Date: Thu, 03 Jul 2014 17:50:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Manuel Lauss <manuel.lauss@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 05/11] MIPS: Alchemy: pci: use clk framework to
 enable PCI clock
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com> <1404393762-858019-6-git-send-email-manuel.lauss@gmail.com>
In-Reply-To: <1404393762-858019-6-git-send-email-manuel.lauss@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/03/2014 05:22 PM, Manuel Lauss wrote:

> Use the clock framework to get at the PCI clock source and enable
> it on driver initialization.

> Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
> ---
>   arch/mips/pci/pci-alchemy.c | 23 ++++++++++++++++++++++-
>   1 file changed, 22 insertions(+), 1 deletion(-)

> diff --git a/arch/mips/pci/pci-alchemy.c b/arch/mips/pci/pci-alchemy.c
> index 912c5f2..adc810f 100644
> --- a/arch/mips/pci/pci-alchemy.c
> +++ b/arch/mips/pci/pci-alchemy.c
[...]
> @@ -394,11 +396,24 @@ static int alchemy_pci_probe(struct platform_device *pdev)
>   		goto out1;
>   	}
>
> +	c = clk_get(&pdev->dev, "pci_clko");
> +	if (IS_ERR(c)) {
> +		dev_err(&pdev->dev, "unable to find PCI clock\n");
> +		ret = PTR_ERR(c);
> +		goto out2;
> +	}
> +	ret = clk_prepare_enable(c);
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot enable PCI clock\n");
> +		clk_put(c);
> +		goto out2;

    Isn't it simpler to add one more label before clk_put() at end of function?

> +	}
> +
[...]
> @@ -466,12 +481,18 @@ static int alchemy_pci_probe(struct platform_device *pdev)
>   	register_syscore_ops(&alchemy_pci_pmops);
>   	register_pci_controller(&ctx->alchemy_pci_ctrl);
>
> +	dev_info(&pdev->dev, "PCI controller at %ld MHz\n",
> +		 clk_get_rate(c) / 1000000);
> +
>   	return 0;
>
>   out4:
>   	iounmap(virt_io);
>   out3:
>   	iounmap(ctx->regs);
> +out5:
> +	clk_disable_unprepare(c);
> +	clk_put(c);
>   out2:
>   	release_mem_region(r->start, resource_size(r));
>   out1:
>

WBR, Sergei

