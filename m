Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbaFLRFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:05:05 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60897 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaFLRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:05:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v3] ARM: add get_user() support for 8 byte types
Date: Thu, 12 Jun 2014 19:04:52 +0200
Message-ID: <4740478.2oOtz84PUv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1402587755-29245-1-git-send-email-daniel.thompson@linaro.org>
References: <1402587755-29245-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nbH5JGzngPJVbtvfpLx8uC5A7jTMR0Xvqgx7tJgWc/i
 rrSRWYF+y7HoaQuQOHKk5woVwmm6RUuxoHbxKHzkZbQSrt7Ty6
 vGVR4136dl0odqvr1eQeD1hYVLt8ks+Axxdm6XhpXDIriyZs0W
 DUL1QCyiNK35zp/dUUGWuHBk7yuVmfnkvGvOYaEuZ2gfyHnWar
 sYSpuiyeFIMSai+cy1G5d49aC87QfTiXyu4kq6ugyY1qa5++4+
 Q1aql+Ax5zFWtVu9Pv91hyi/tOBD6y/S0YihKG4d5NseUYMAtw
 7bLpdhxLV/iSaiVIjfdOOyL5m7h4FiHQYKt8OuD+E8cT9+r9UM
 YRBnE8V/EoCT+l7E92cE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2014 16:42:35 Daniel Thompson wrote:
>  #define __get_user_check(x,p)                                                  \
>         ({                                                              \
>                 unsigned long __limit = current_thread_info()->addr_limit - 1; \
>                 register const typeof(*(p)) __user *__p asm("r0") = (p);\
> -               register unsigned long __r2 asm("r2");                  \
> +               register typeof(x) __r2 asm("r2");                      \
>                 register unsigned long __l asm("r1") = __limit;         \
>                 register int __e asm("r0");                             \
>                 switch (sizeof(*(__p))) {                               \
> @@ -142,6 +152,12 @@ extern int __get_user_4(void *);
>                 case 4:                                                 \
>                         __get_user_x(__r2, __p, __e, __l, 4);           \
>                         break;                                          \
> +               case 8:                                                 \
> +                       if (sizeof((x)) < 8)                            \
> +                               __get_user_xb(__r2, __p, __e, __l, 4);  \
> +                       else                                            \
> +                               __get_user_x(__r2, __p, __e, __l, 8);   \
> +                       break;                                          \
>                 default: __e = __get_user_bad(); break;                 \
>                 }                                                       \
>                 x = (typeof(*(p))) __r2;                                \
> 

I don't think there is a way to do this without copying the
__builtin_choose_expr() hack from x86.

	Arnd
