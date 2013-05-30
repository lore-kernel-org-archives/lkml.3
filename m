Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642Ab3E3WYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 18:24:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab3E3WYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 18:24:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH] arm: Prevent memory aliasing on non-LPAE kernels
Date: Fri, 31 May 2013 00:24:13 +0200
Message-ID: <3054064.aJsgTxiNUL@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1369950320-22784-1-git-send-email-stepanm@codeaurora.org>
References: <1369950320-22784-1-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GkWyD1HRAwT8rDLFrvf+tePUH1iX03JmCXuHimVDg5s
 +QbYTCXFcAOLTqFVmXMzxNejRLXpVPPm7g1KLYyXMgohIEivZ1
 VhHxtfpb3/T5oCX7ZpePXHAt7gu9+aVXa2KpS/5czS+5LEz/E4
 uAYmd0dyTZlpYIwbnQk/ml3v6ZCOsJcB8fPQ4eQDHcK32h20BO
 NEbbeFE7gl79EAvt1UWB13hZBGLbJC47XoWvlJw3OEmWC3ireO
 PHbZUHUUXPheDR348SmoZ0U3c5ZacP5UVK+UUg7HHaQeZX1A7d
 1E1WfufMN6QgE1tFUqZIIEHBSugQQKrwaIxym8xy2Ra6OaZO/i
 ObuZaIs+5sKnJHw+EjTU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 May 2013 14:45:20 Stepan Moskovchenko wrote:
> 
>  void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>  {
> +#ifndef CONFIG_ARM_LPAE
> +       if (base > ((phys_addr_t)~0)) {
> +               pr_crit("Ignoring memory at 0x%08llx due to lack of LPAE support\n",
> +                       base);
> +               return;
> +       }
> +
> +       if (size > ((phys_addr_t)~0))
> +               size = ((phys_addr_t)~0);
> +
> +       /* arm_add_memory() already checks for the case of base + size > 4GB */
> +#endif
>         arm_add_memory(base, size);
>  }

This looks wrong for the case where 'base' is between >0 and 4GB and 'size'
makes it spill over the 4GB boundary. You need to set
'size = (phys_addr_t)~0 - base' then.

	Arnd
