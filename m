Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab3CIMFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 07:05:00 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52280 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab3CIME5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 07:04:57 -0500
Message-ID: <513B25BC.3010609@gmail.com>
Date: Sat, 09 Mar 2013 13:06:20 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        a.p.zijlstra@chello.nl, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH v2 1/3] arch: make __mutex_fastpath_lock_retval
 return whether fastpath succeeded or not.
References: <20130228102452.15191.22673.stgit@patser>
In-Reply-To: <20130228102452.15191.22673.stgit@patser>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 11:24 AM, Maarten Lankhorst wrote:
> This will allow me to call functions that have multiple arguments if fastpath fails.
> This is required to support ticket mutexes, because they need to be able to pass an
> extra argument to the fail function.
> 
> Originally I duplicated the functions, by adding __mutex_fastpath_lock_retval_arg.
> This ended up being just a duplication of the existing function, so a way to test
> if fastpath was called ended up being better.
> 
> This also cleaned up the reservation mutex patch some by being able to call an
> atomic_set instead of atomic_xchg, and making it easier to detect if the wrong
> unlock function was previously used.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
>  arch/ia64/include/asm/mutex.h    |   10 ++++------
>  arch/powerpc/include/asm/mutex.h |   10 ++++------
>  arch/sh/include/asm/mutex-llsc.h |    4 ++--
>  arch/x86/include/asm/mutex_32.h  |   11 ++++-------
>  arch/x86/include/asm/mutex_64.h  |   11 ++++-------
>  include/asm-generic/mutex-dec.h  |   10 ++++------
>  include/asm-generic/mutex-null.h |    2 +-
>  include/asm-generic/mutex-xchg.h |   10 ++++------
>  kernel/mutex.c                   |   32 ++++++++++++++------------------
>  9 files changed, 41 insertions(+), 59 deletions(-)
[...]
> diff --git a/arch/x86/include/asm/mutex_32.h b/arch/x86/include/asm/mutex_32.h
> index 03f90c8..b7f6b34 100644
> --- a/arch/x86/include/asm/mutex_32.h
> +++ b/arch/x86/include/asm/mutex_32.h
> @@ -42,17 +42,14 @@ do {								\
>   *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
>   *                                 from 1 to a 0 value
>   *  @count: pointer of type atomic_t
> - *  @fail_fn: function to call if the original value was not 1
>   *
> - * Change the count from 1 to a value lower than 1, and call <fail_fn> if it
> - * wasn't 1 originally. This function returns 0 if the fastpath succeeds,
> - * or anything the slow path function returns
> + * Change the count from 1 to a value lower than 1. This function returns 0
> + * if the fastpath succeeds, or 1 otherwise.

The minus sign is missing, the return value should be -1.

[...]
> diff --git a/include/asm-generic/mutex-null.h b/include/asm-generic/mutex-null.h
> index e1bbbc7..efd6206 100644
> --- a/include/asm-generic/mutex-null.h
> +++ b/include/asm-generic/mutex-null.h
> @@ -11,7 +11,7 @@
>  #define _ASM_GENERIC_MUTEX_NULL_H
>  
>  #define __mutex_fastpath_lock(count, fail_fn)		fail_fn(count)
> -#define __mutex_fastpath_lock_retval(count, fail_fn)	fail_fn(count)
> +#define __mutex_fastpath_lock_retval(count, fail_fn)	(-1)

The fail_fn parameter should be dropped here as well.

Regards,
Francesco
