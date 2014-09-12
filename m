Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaILSfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:35:42 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52026 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaILSfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:35:41 -0400
Message-ID: <54133CF1.4040306@cogentembedded.com>
Date: Fri, 12 Sep 2014 21:35:29 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>, linux-mips@linux-mips.org,
        nbd@openwrt.org, james.hogan@imgtec.com, jchandra@broadcom.com,
        paul.burton@imgtec.com, david.daney@cavium.com,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        markos.chandras@imgtec.com, macro@linux-mips.org,
        manuel.lauss@gmail.com, jerinjacobk@gmail.com, chenhc@lemote.com,
        blogic@openwrt.org
Subject: Re: [PATCH V2] MIPS: bugfix of coherentio variable default setup
References: <20140908191002.13852.47842.stgit@linux-yegoshin>
In-Reply-To: <20140908191002.13852.47842.stgit@linux-yegoshin>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 9/8/2014 10:10 PM, Leonid Yegoshin wrote:

> Patch commit b6d92b4a6bdb880b39789c677b952c53a437028d

    Just commit.

>      MIPS: Add option to disable software I/O coherency.

    It's enough to just cite the summary in parens after SHA1 ID.

>      Some MIPS controllers have hardware I/O coherency. This patch
>      detects those and turns off software coherency. A new kernel
>      command line option also allows the user to manually turn
>      software coherency on or off.

> in fact enforces L2 cache flushes even on systems with IOCU.
> The default value of coherentio is 0 and is not changed even with IOCU.
> It is a serious performance problem because it destroys all IOCU performance
> advantages.

> It is fixed by setting coherentio to tri-state with default value as (-1) and
> setup a final value during platform coherency setup.

> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
> ---
> V2: Missed signature added
> ---
>   arch/mips/include/asm/mach-generic/dma-coherence.h |    7 ++++++-
>   arch/mips/mm/c-r4k.c                               |    2 +-
>   arch/mips/mm/dma-default.c                         |    2 +-
>   arch/mips/mti-malta/malta-setup.c                  |    8 ++++++--
>   arch/mips/pci/pci-alchemy.c                        |    2 +-
>   5 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/arch/mips/include/asm/mach-generic/dma-coherence.h b/arch/mips/include/asm/mach-generic/dma-coherence.h
> index 7629c35..b4563df 100644
> --- a/arch/mips/include/asm/mach-generic/dma-coherence.h
> +++ b/arch/mips/include/asm/mach-generic/dma-coherence.h
> @@ -49,7 +49,12 @@ static inline int plat_dma_supported(struct device *dev, u64 mask)
>
>   static inline int plat_device_is_coherent(struct device *dev)
>   {
> -	return coherentio;
> +#ifdef CONFIG_DMA_COHERENT
> +	return 1;
> +#else
> +	return (coherentio > 0);

    *return* never needs parens around the value.

> +#endif
> +
>   }
>
>   #ifdef CONFIG_SWIOTLB
> diff --git a/arch/mips/mti-malta/malta-setup.c b/arch/mips/mti-malta/malta-setup.c
> index db7c9e5..48039fd 100644
> --- a/arch/mips/mti-malta/malta-setup.c
> +++ b/arch/mips/mti-malta/malta-setup.c
> @@ -147,13 +147,17 @@ static void __init plat_setup_iocoherency(void)
>   	if (plat_enable_iocoherency()) {
>   		if (coherentio == 0)
>   			pr_info("Hardware DMA cache coherency disabled\n");
> -		else
> +		else {
> +			coherentio = 1;

    You now need the parens around another arm of the *if* statement too. Such 
is the kernel style. :-)

>   			pr_info("Hardware DMA cache coherency enabled\n");
> +		}
>   	} else {
>   		if (coherentio == 1)
>   			pr_info("Hardware DMA cache coherency unsupported, but enabled from command line!\n");
> -		else
> +		else {
> +			coherentio = 0;

    Likewise.

>   			pr_info("Software DMA cache coherency enabled\n");
> +		}
>   	}
>   #else
>   	if (!plat_enable_iocoherency())

WBR, Sergei

