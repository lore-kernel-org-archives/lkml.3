Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbaEMJPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:15:51 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:46014 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955AbaEMJPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:15:48 -0400
MIME-Version: 1.0
X-Originating-IP: [217.156.156.35]
In-Reply-To: <1399971749-4004-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<1399971749-4004-1-git-send-email-lftan@altera.com>
Date: Tue, 13 May 2014 10:15:47 +0100
X-Google-Sender-Auth: MQqCVXar_3YrA-NvENIWneyPbEE
Message-ID: <CAAG0J9-ieBNfyRa6kf22TNd_3mg57GYuGHagQ-pPLY41iM3Zyg@mail.gmail.com>
Subject: Re: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
From: James Hogan <james.hogan@imgtec.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lftan.linux@gmail.com, cltang@codesourcery.com,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13 May 2014 10:02, Ley Foon Tan <lftan@altera.com> wrote:
> Use 64 bit time_t and clock_t as default. 32 bit users can provide
> an override to define these as "long" if needed.
>
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>  include/uapi/asm-generic/posix_types.h | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/asm-generic/posix_types.h b/include/uapi/asm-generic/posix_types.h
> index fe74fcc..3f0e613 100644
> --- a/include/uapi/asm-generic/posix_types.h
> +++ b/include/uapi/asm-generic/posix_types.h
> @@ -81,12 +81,22 @@ typedef struct {
>  #endif
>
>  /*
> + * Use 64 bit time_t and clock_t as default. 32 bit users can provide an override to
> + * define these as "long" if needed.
> + */
> +#ifndef __kernel_time_t
> +typedef long long      __kernel_time_t;
> +#endif
> +
> +#ifndef __kernel_clock_t
> +typedef long long      __kernel_clock_t;
> +#endif

I think having this as the first patch in the series will break
bisection for existing 32-bit arches. This needs to be done in such a
way that at no intermediate commit are __kernel_time_t or
__kernel_clock_t the wrong size for existing arches, e.g. by having a
first patch which makes the typedefs conditional but leaves them as
__kernel_long_t, and a final patch that changes the default after all
the arches have got their overrides in place.

Cheers
James

> +
> +/*
>   * anything below here should be completely generic
>   */
>  typedef __kernel_long_t        __kernel_off_t;
>  typedef long long      __kernel_loff_t;
> -typedef __kernel_long_t        __kernel_time_t;
> -typedef __kernel_long_t        __kernel_clock_t;
>  typedef int            __kernel_timer_t;
>  typedef int            __kernel_clockid_t;
>  typedef char *         __kernel_caddr_t;
> --
> 1.8.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
