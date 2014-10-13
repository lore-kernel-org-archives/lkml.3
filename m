Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaJMLUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:20:00 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49302 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaJMLT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:19:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH v3] drivers: of: add return value to of_reserved_mem_device_init
Date: Mon, 13 Oct 2014 13:19:09 +0200
Message-ID: <13963062.ORRNOhrvYD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412857080-5100-1-git-send-email-m.szyprowski@samsung.com>
References: <1410434561-9294-2-git-send-email-m.szyprowski@samsung.com> <1412857080-5100-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:oxL/Obo32s/1SL3nwFxe6OfInlQzsI9+Po6LyAF03QV
 rxTteFWElKo2FJHJhIVoueZvzjnOwkU9kwiFKaYpXaVtLSXm5O
 k7QFRCSBe9plTlf2WRWgEUW2ij1FKTDCiVDUgmofkP/tl/sJEi
 mX8Pjo8SlhZaEGdr472Htr4bBNAv4F+9wyhz8k1ZMSlv5YGQyd
 EIBOKbyuNQySoXlbW86PJOAOBdeavdshdWwS6NKf8WVbNh/cTk
 l/DGtnnd7TJEpQ6gLRij5mNas+DTM7WoY7lIOrfO28hu4j86E4
 kut7cEM83DyCJy9F/Zfi4ou5d261NEZIfLfvgFrHgK5uqMpbvm
 8+q6tec017ehKr19C5fg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 14:18:00 Marek Szyprowski wrote:
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 59fb12e..70780ad 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c

>         if (!rmem || !rmem->ops || !rmem->ops->device_init)
> -               return;
> +               return -EINVAL;
>  
>         rmem->ops->device_init(rmem, dev);
>         dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
> +       return 0;
>  }

You don't actually return the value from ->device_init() here but always
return 0 on success. There are no callers of this function, so it's
hard to tell if this actually makes a difference, but it contradicts
your patch description.

> diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
> index 5b5efae..ad2f670 100644
> --- a/include/linux/of_reserved_mem.h
> +++ b/include/linux/of_reserved_mem.h
> @@ -16,7 +16,7 @@ struct reserved_mem {
>  };
>  
>  struct reserved_mem_ops {
> -       void    (*device_init)(struct reserved_mem *rmem,
> +       int     (*device_init)(struct reserved_mem *rmem,
>                                struct device *dev);
>         void    (*device_release)(struct reserved_mem *rmem,
>                                   struct device *dev);

This part is definitely needed to avoid the new compile warnings we
are getting.

	Arnd
