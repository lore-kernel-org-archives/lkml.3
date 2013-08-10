Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab3HJMt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 08:49:59 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:44471 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab3HJMt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 08:49:58 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RXplcXVpZWwgR2FyY2lh?= 
	<ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?TGlvciBBbXNhbGVt?= <alior@marvell.com>,
        =?UTF-8?B?VGhvbWFzIFBldGF6em9uaQ==?= 
	<thomas.petazzoni@free-electrons.com>,
        =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        =?UTF-8?B?SmFzb24gQ29vcGVy?= <jason@lakedaemon.net>,
        =?UTF-8?B?QW5kcmV3IEx1bm4=?= <andrew@lunn.ch>,
        =?UTF-8?B?R3JlZ29yeSBDbGVtZW50?= 
	<gregory.clement@free-electrons.com>,
        =?UTF-8?B?U2ViYXN0aWFuIEhlc3NlbGJhcnRo?= 
	<sebastian.hesselbarth@gmail.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzNdIEFSTTogSW50cm9kdWNlIGF0b21pYyBNTUlPIGNs?=
 =?UTF-8?B?ZWFyL3NldA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sat, 10 Aug 2013 16:49:28 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1376138968.556911297@f376.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
In-Reply-To: <1376138582-7550-2-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1376138582-7550-2-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7ACo5xU014883

> Some SoC have MMIO regions that are shared across orthogonal
> subsystems. This commit implements a possible solution for the
> thread-safe access of such regions through a spinlock-protected API
> with clear-set semantics.
> 
> Concurrent access is protected with a single spinlock for the
> entire MMIO address space. While this protects shared-registers,
> it also serializes access to unrelated/unshared registers.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  arch/arm/include/asm/io.h |  5 +++++
>  arch/arm/kernel/io.c      | 24 ++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> index d070741..c84658d 100644
> --- a/arch/arm/include/asm/io.h
> +++ b/arch/arm/include/asm/io.h
> @@ -36,6 +36,11 @@
>  #define isa_bus_to_virt phys_to_virt
>  
>  /*
> + * Atomic MMIO-wide IO clear/set
> + */
> +extern void atomic_io_clear_set(void __iomem *reg, u32 clear, u32 set);
> +
> +/*
>   * Generic IO read/write.  These perform native-endian accesses.  Note
>   * that some architectures will want to re-define __raw_{read,write}w.
>   */
> diff --git a/arch/arm/kernel/io.c b/arch/arm/kernel/io.c
> index dcd5b4d..3ab8201 100644
> --- a/arch/arm/kernel/io.c
> +++ b/arch/arm/kernel/io.c
> @@ -1,6 +1,30 @@
>  #include <linux/export.h>
>  #include <linux/types.h>
>  #include <linux/io.h>
> +#include <linux/spinlock.h>
> +
> +static DEFINE_SPINLOCK(__io_lock);
> +
> +/*
> + * Some platforms have MMIO regions that are shared across orthogonal
> + * subsystems. This API implements thread-safe access to such regions
> + * through a spinlock-protected API with clear-set semantics.
> + *
> + * Concurrent access is protected with a single spinlock for the entire MMIO
> + * address space. While this protects shared-registers, it also serializes
> + * access to unrelated/unshared registers.
> + *
> + * Using this API on frequently accessed registers in performance-critical
> + * paths is not recommended, as the spinlock used by this API would become
> + * highly contended.
> + */
> +void atomic_io_clear_set(void __iomem *reg, u32 clear, u32 set)
> +{
> +	spin_lock(&__io_lock);
> +	writel((readl(reg) & ~clear) | set, reg);
> +	spin_unlock(&__io_lock);
> +}
> +EXPORT_SYMBOL(atomic_io_clear_set);

So, one lock is used to all possible registers?
Seems a regmap-mmio can be used for such access.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
