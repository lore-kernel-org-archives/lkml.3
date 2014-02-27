Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaB0S65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:58:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaB0S6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:58:55 -0500
Date: Thu, 27 Feb 2014 11:00:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] typecheck: introduce assign_if() and
 assign_if_enabled()
Message-ID: <20140227190032.GA4421@kroah.com>
References: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
 <1393261707-30565-2-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393261707-30565-2-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:08:25AM -0600, Josh Cartwright wrote:
> The assign_if() and assign_if_enable() macros are intended to be used
> in static initializers for function pointers, where the pointer is
> expected to be NULL when a compile-time condition does not hold.
> 
> These macros allow for implementing this behavior, without requiring the
> functions be wrapped in #ifdef conditionals, and while providing
> typesafety regardless of the value of the conditional.
> 
> For example, the following pattern is common:
> 
> 	#ifdef CONFIG_FOO
> 	static void foo_callback(void)
> 	{
> 	}
> 	#else
> 	#define foo_callback NULL
> 	#endif
> 
> 	static struct foo_object foo_obj = {
> 		.callback = foo_callback,
> 	};
> 
> Usage of assign_if_enabled() allows for achieving the same effect
> without the preprocessor conditional, and in addition, allowing the
> compiler to typecheck the function regardless of CONFIG_FOO.
> 
> 	static void foo_callback(void)
> 	{
> 	}
> 
> 	static struct foo_object foo_obj = {
> 		.callback = assign_if_enabled(CONFIG_FOO, foo_callback),
> 	};
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  include/linux/typecheck.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/include/linux/typecheck.h b/include/linux/typecheck.h
> index eb5b74a..04134c7 100644
> --- a/include/linux/typecheck.h
> +++ b/include/linux/typecheck.h
> @@ -21,4 +21,22 @@
>  	(void)__tmp; \
>  })
>  
> +/*
> + * Intended for use in static object initializers,
> + * assign_if(const_expr, function) evaluates to 'function' if 'const_expr',
> + * otherwise NULL.
> + *
> + * The type of the assign_if() expression is typeof(function), and therefore
> + * can provide typechecking regardless of 'const_expr'.
> + *
> + * gcc considers 'function' to be used and will not generate a 'defined but not
> + * used' warning when not 'const_expr', however, gcc is smart enough to
> + * eliminate 'function' if assign_if() is the only reference.
> + */

What version of gcc started doing this?  Does llvm also do this?

thanks,

greg k-h
