Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaAUQ6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:58:40 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46441 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754438AbaAUQ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:58:36 -0500
Date: Tue, 21 Jan 2014 16:58:03 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] Use __kernel_long_t in struct timex
Message-ID: <20140121165803.GC20798@arm.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
 <1388165112-6545-2-git-send-email-hjl.tools@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388165112-6545-2-git-send-email-hjl.tools@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 05:25:05PM +0000, H.J. Lu wrote:
> X32 adjtimex system call is the same as x86-64 adjtimex system call,
> which uses 64-bit integer for long in struct timex. But x32 long is
> 32 bit.  This patch replaces long in struct timex with __kernel_long_t
> if __BITS_PER_LONG == 64.
> 
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> ---
>  include/uapi/linux/timex.h | 46 ++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/include/uapi/linux/timex.h b/include/uapi/linux/timex.h
> index a7ea81f..98314e9 100644
> --- a/include/uapi/linux/timex.h
> +++ b/include/uapi/linux/timex.h
> @@ -63,28 +63,58 @@
>   */
>  struct timex {
>  	unsigned int modes;	/* mode selector */
> +#if __BITS_PER_LONG == 64
> +	__kernel_long_t offset;	/* time offset (usec) */
> +	__kernel_long_t freq;	/* frequency offset (scaled ppm) */
> +	__kernel_long_t maxerror;/* maximum error (usec) */
> +	__kernel_long_t esterror;/* estimated error (usec) */
> +#else
>  	long offset;		/* time offset (usec) */
>  	long freq;		/* frequency offset (scaled ppm) */
>  	long maxerror;		/* maximum error (usec) */
>  	long esterror;		/* estimated error (usec) */
> +#endif

These changes should work on arm64 ILP32 as well.

>  	int status;		/* clock command/status */
> +#if __BITS_PER_LONG == 64
> +	__kernel_long_t constant;/* pll time constant */
> +	__kernel_long_t precision;/* clock precision (usec) (read only) */
> +	__kernel_long_t tolerance;/* clock frequency tolerance (ppm)
> +				   * (read only)
> +				   */
> +#else
>  	long constant;		/* pll time constant */
>  	long precision;		/* clock precision (usec) (read only) */
>  	long tolerance;		/* clock frequency tolerance (ppm)
>  				 * (read only)
>  				 */
> +#endif
>  	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */

struct timeval is already defined in terms of __kernel_long_t, so no
issues here either.

BTW, could we not avoid the #if and always use __kernel_long_t? This
wouldn't break the user ABI.

-- 
Catalin
