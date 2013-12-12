Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3LLO2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:28:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:63832 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3LLO2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:28:46 -0500
Message-ID: <52A9C81B.7050007@atmel.com>
Date: Thu, 12 Dec 2013 15:28:43 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>
CC: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 0/5] net: macb updates
References: <1386720443-24100-1-git-send-email-soren.brinkmann@xilinx.com> <CAOesGMjcmeiBfc=EOvWazebg-9vnMuQtRC0aeHJy7Q=02RdRPA@mail.gmail.com>
In-Reply-To: <CAOesGMjcmeiBfc=EOvWazebg-9vnMuQtRC0aeHJy7Q=02RdRPA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 08:00, Olof Johansson :
> Hi Soren,
>
> On Tue, Dec 10, 2013 at 4:07 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
>
>> Soren Brinkmann (5):
>>    net: macb: Adjust tx_clk when link speed changes
>
> This patch causes build issues on some at91 platforms, namely
> at91sam9263 that lacks programmable clocks. So it doesn't implement
> clk_set_rate() and clk_round_rate().
>
> I don't know if there's any reasonable config option to check for
> (that wouldn't add at91-specific stuff to the driver which we don't
> want). So I suspect the best way would be to implement dummy versions
> for at91 when CONFIG_AT91_PROGRAMMABLE_CLOCKS isn't set.
>
> Nicolas, you OK with that? It'd be something like the below
> (copy-paste, whitespace damage, just RFC):

Well, in fact I am thinking about simply removing this 
AT91_PROGRAMMABLE_CLOCKS option out of the AT91 Kconfig.

After all, when not specified, it only removes a few lines of code... 
and that's it! For a so little benefit, I suspect it is sensible to 
remove this option.
I continue to discuss with AT91 active developers and write a patch soon.

Thanks for the heads-up on this issue Olof.

Bye,


> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
> index 6b2630a..17c52a7 100644
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -459,6 +459,22 @@ static void __init init_programmable_clock(struct clk *clk)
>          clk->rate_hz = parent->rate_hz / pmc_prescaler_divider(pckr);
>   }
>
> +#else  /* CONFIG_AT91_PROGRAMMABLE_CLOCKS */
> +
> +int clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +       if (rate == clk_get_rate(clk))
> +               return 0;
> +
> +       return -EINVAL;
> +}
> +
> +long clk_round_rate(struct clk *clk, unsigned long rate)
> +{
> +       /* There's really nothing sane to return here. */
> +       return clk_get_rate(clk);
> +}
> +
>   #endif /* CONFIG_AT91_PROGRAMMABLE_CLOCKS */
>


-- 
Nicolas Ferre
