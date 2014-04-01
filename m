Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaDAO3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:29:34 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44832 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDAO3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:29:32 -0400
X-Originating-IP: 50.43.32.211
Date: Tue, 1 Apr 2014 07:28:53 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Christopher Li <sparse@chrisli.org>
Subject: Re: [PATCH] Fix _IOC_TYPECHECK sparse error
Message-ID: <20140401142852.GA22576@leaf>
References: <533A64EC.2090106@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533A64EC.2090106@xs4all.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 09:04:12AM +0200, Hans Verkuil wrote:
> When running sparse over drivers/media/v4l2-core/v4l2-ioctl.c I get these
> errors:
> 
> drivers/media/v4l2-core/v4l2-ioctl.c:2043:9: error: bad integer constant expression
> drivers/media/v4l2-core/v4l2-ioctl.c:2044:9: error: bad integer constant expression
> drivers/media/v4l2-core/v4l2-ioctl.c:2045:9: error: bad integer constant expression
> drivers/media/v4l2-core/v4l2-ioctl.c:2046:9: error: bad integer constant expression
> 
> etc.
> 
> The root cause of that turns out to be in include/asm-generic/ioctl.h:
> 
> #include <uapi/asm-generic/ioctl.h>
> 
> /* provoke compile error for invalid uses of size argument */
> extern unsigned int __invalid_size_argument_for_IOC;
> #define _IOC_TYPECHECK(t) \
>         ((sizeof(t) == sizeof(t[1]) && \
>           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>           sizeof(t) : __invalid_size_argument_for_IOC)
> 
> If it is defined as this (as is already done if __KERNEL__ is not defined):
> 
> #define _IOC_TYPECHECK(t) (sizeof(t))
> 
> then all is well with the world.
> 
> This patch allows sparse to work correctly.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> diff --git a/include/asm-generic/ioctl.h b/include/asm-generic/ioctl.h
> index d17295b..297fb0d 100644
> --- a/include/asm-generic/ioctl.h
> +++ b/include/asm-generic/ioctl.h
> @@ -3,10 +3,15 @@
>  
>  #include <uapi/asm-generic/ioctl.h>
>  
> +#ifdef __CHECKER__
> +#define _IOC_TYPECHECK(t) (sizeof(t))
> +#else
>  /* provoke compile error for invalid uses of size argument */
>  extern unsigned int __invalid_size_argument_for_IOC;
>  #define _IOC_TYPECHECK(t) \
>  	((sizeof(t) == sizeof(t[1]) && \
>  	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>  	  sizeof(t) : __invalid_size_argument_for_IOC)
> +#endif
> +
>  #endif /* _ASM_GENERIC_IOCTL_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
