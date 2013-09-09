Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3IIKh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:37:27 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53453 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3IIKh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:37:26 -0400
MIME-Version: 1.0
In-Reply-To: <1378561605-18998-3-git-send-email-konrad.wilk@oracle.com>
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com> <1378561605-18998-3-git-send-email-konrad.wilk@oracle.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 16:06:46 +0530
Message-ID: <CALkWK0=T+Y4_oCD8nJW_zMA6TTOTNviSY30v9KR1dve6NrMRrw@mail.gmail.com>
Subject: Re: [PATCH 2/5] xen/spinlock: We don't need the old structure anymore
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index 0438b93..71db82c 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -81,7 +81,6 @@ static inline void spin_time_accum_blocked(u64 start)
>         spinlock_stats.time_blocked += delta;
>  }
>  #else  /* !CONFIG_XEN_DEBUG_FS */
> -#define TIMEOUT                        (1 << 10)

The timeout can be reduced, I think.

>  static inline void add_stats(enum xen_contention_stat var, u32 val)
>  {
>  }
> @@ -96,23 +95,6 @@ static inline void spin_time_accum_blocked(u64 start)
>  }
>  #endif  /* CONFIG_XEN_DEBUG_FS */
>
> -/*
> - * Size struct xen_spinlock so it's the same as arch_spinlock_t.
> - */
> -#if NR_CPUS < 256
> -typedef u8 xen_spinners_t;
> -# define inc_spinners(xl) \
> -       asm(LOCK_PREFIX " incb %0" : "+m" ((xl)->spinners) : : "memory");
> -# define dec_spinners(xl) \
> -       asm(LOCK_PREFIX " decb %0" : "+m" ((xl)->spinners) : : "memory");
> -#else
> -typedef u16 xen_spinners_t;
> -# define inc_spinners(xl) \
> -       asm(LOCK_PREFIX " incw %0" : "+m" ((xl)->spinners) : : "memory");
> -# define dec_spinners(xl) \
> -       asm(LOCK_PREFIX " decw %0" : "+m" ((xl)->spinners) : : "memory");
> -#endif
> -

Spinlocks on the filesystem help ensure consistency; otherwise, there
is a chance of a lot of noise coming through. Although NR_CPUS > 256,
very few CPUS are doing consistency checks.
