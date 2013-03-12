Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3CLQcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:32:10 -0400
Received: from kanga.kvack.org ([205.233.56.17]:56674 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3CLQcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:32:09 -0400
Date: Tue, 12 Mar 2013 12:32:07 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-arch@vger.kernel.org,
        sfr@canb.auug.org.au, Joakim.Tjernlund@transmode.se, arnd@arndb.de,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] UAPI: Fix endianness conditionals in linux/aio_abi.h
Message-ID: <20130312163207.GI8869@kvack.org>
References: <20130306204724.31327.43118.stgit@warthog.procyon.org.uk> <20130306204733.31327.97388.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130306204733.31327.97388.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 08:47:33PM +0000, David Howells wrote:
> In the UAPI header files, __BIG_ENDIAN and __LITTLE_ENDIAN must be compared
> against __BYTE_ORDER in preprocessor conditionals where these are exposed to
> userspace (that is they're not inside __KERNEL__ conditionals).
> 
> However, in the main kernel the norm is to check for "defined(__XXX_ENDIAN)"
> rather than comparing against __BYTE_ORDER and this has incorrectly leaked
> into the userspace headers.
> 
> The definition of PADDED() in linux/aio_abi.h is wrong in this way.  Note that
> userspace will likely interpret this and thus the order of fields in struct
> iocb incorrectly as the little-endian variant on big-endian machines -
> depending on header inclusion order.
> 
> [!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It might
> be better to fix the ordering of aio_key and aio_reserved1 in struct iocb.

It is unlikely that anyone has used the existing kernel headers and hit this 
issue given that most existing users use the libaio.h include (which does not 
get the endianness tests wrong).  Given that the kernel has always used the 
correct endian mappings, this change is correct.

Acked-by: Benjamin LaHaise <bcrl@kvack.org>

		-ben

> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Benjamin LaHaise <bcrl@kvack.org>
> cc: linux-aio@kvack.org
> ---
> 
>  include/uapi/linux/aio_abi.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
> index 86fa7a7..bb2554f 100644
> --- a/include/uapi/linux/aio_abi.h
> +++ b/include/uapi/linux/aio_abi.h
> @@ -62,9 +62,9 @@ struct io_event {
>  	__s64		res2;		/* secondary result */
>  };
>  
> -#if defined(__LITTLE_ENDIAN)
> +#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
>  #define PADDED(x,y)	x, y
> -#elif defined(__BIG_ENDIAN)
> +#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
>  #define PADDED(x,y)	y, x
>  #else
>  #error edit for your odd byteorder.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

-- 
"Thought is the essence of where you are now."
