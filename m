Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbbAMW3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:29:44 -0500
Received: from mail.kernel.org ([198.145.29.136]:49556 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbbAMW3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:29:41 -0500
Date: Wed, 14 Jan 2015 00:29:35 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/2] tile: enable sparse checks for get/put_user
Message-ID: <20150113222935.GB23641@redhat.com>
References: <201501131950.t0DJognR027020@lab-37.internal.tilera.com>
 <201501131951.t0DJpIKt027023@lab-37.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501131951.t0DJpIKt027023@lab-37.internal.tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 02:41:20PM -0500, Chris Metcalf wrote:
> Add an extra intermediate variable to __get_user and __put_user
> to give sparse an opportunity to detect mismatches.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  arch/tile/include/asm/uaccess.h | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
> index b81b24a8489b..f41cb53cf645 100644
> --- a/arch/tile/include/asm/uaccess.h
> +++ b/arch/tile/include/asm/uaccess.h
> @@ -210,14 +210,16 @@ extern int __get_user_bad(void)
>  #define __get_user(x, ptr)						\
>  	({								\
>  		int __ret;						\
> +		typeof(x) _x;						\
>  		__chk_user_ptr(ptr);					\
>  		switch (sizeof(*(ptr))) {				\
> -		case 1: __get_user_1(x, ptr, __ret); break;		\
> -		case 2: __get_user_2(x, ptr, __ret); break;		\
> -		case 4: __get_user_4(x, ptr, __ret); break;		\
> -		case 8: __get_user_8(x, ptr, __ret); break;		\
> +		case 1: __get_user_1(_x, ptr, __ret); break;		\
> +		case 2: __get_user_2(_x, ptr, __ret); break;		\
> +		case 4: __get_user_4(_x, ptr, __ret); break;		\
> +		case 8: __get_user_8(_x, ptr, __ret); break;		\
>  		default: __ret = __get_user_bad(); break;		\
>  		}							\
> +		(x) = (typeof(*(ptr))) _x;				\
>  		__ret;							\
>  	})
>  
> @@ -289,12 +291,13 @@ extern int __put_user_bad(void)
>  #define __put_user(x, ptr)						\
>  ({									\
>  	int __ret;							\
> +	typeof(*(ptr)) _x = (x);					\
>  	__chk_user_ptr(ptr);						\
>  	switch (sizeof(*(ptr))) {					\
> -	case 1: __put_user_1(x, ptr, __ret); break;			\
> -	case 2: __put_user_2(x, ptr, __ret); break;			\
> -	case 4: __put_user_4(x, ptr, __ret); break;			\
> -	case 8: __put_user_8(x, ptr, __ret); break;			\
> +	case 1: __put_user_1(_x, ptr, __ret); break;			\
> +	case 2: __put_user_2(_x, ptr, __ret); break;			\
> +	case 4: __put_user_4(_x, ptr, __ret); break;			\
> +	case 8: __put_user_8(_x, ptr, __ret); break;			\
>  	default: __ret = __put_user_bad(); break;			\
>  	}								\
>  	__ret;								\
> -- 
> 2.1.2
