Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaILWkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:40:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaILWkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:40:15 -0400
Date: Fri, 12 Sep 2014 15:40:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] kernel.h: use __COUNTER__ in min and max macros to
 avoid -Wshadow warnings
Message-Id: <20140912154013.47dad90e7519146c6da115e5@linux-foundation.org>
In-Reply-To: <1410471576-12053-2-git-send-email-mina86@mina86.com>
References: <1410471576-12053-1-git-send-email-mina86@mina86.com>
	<1410471576-12053-2-git-send-email-mina86@mina86.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 23:39:36 +0200 Michal Nazarewicz <mina86@mina86.com> wrote:

> Because min and max macros use the same variable names no matter
> how many times they are called (or how deep the nesting of their
> calls), each time min or max calls are nested, the same variables
> are declared.  This is especially noisy after min3 and max3 have
> been changed to nest min/max calls.
> 
> Using __COUNTER__ solves the problem since each variable will get
> a unique number aadded to it.  The code will still work even if
> the compiler does not support __COUNTER__, but then the protection
> from shadow warning won't work.
> 
> The same applies to min_t and max_t macros.
> 
> ...
>
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -695,15 +695,27 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>  #endif /* CONFIG_TRACING */
>  
>  /*
> + * Preprocessor magic generating unique identifiers to avoid -Wshadow warnings
> + * used by min, max, min_t and max_t macros.  cnt is __COUNTER__, op is the
> + * comparison operator; tx (ty) is type of the first (second) argument,
> + * xx (yy) is name of a temporary variable to hold the first (second) argument,
> + * and x (y) is the first (second) argument.
> + */
> +#define _min_max_var(cnt, base) _mm_ ## cnt ## base
> +#define _min_max__(op, tx, xx, x, ty, yy, y) ({		\
> +	tx xx = (x);					\
> +	ty yy = (y);					\
> +	(void) (&xx == &yy);				\
> +	xx op yy ? xx : yy; })
> +#define _min_max_(cnt, op, tx, x, ty, y)		\
> +	_min_max__(op, tx, _min_max_var(cnt, a), x, ty, _min_max_var(cnt, b), y)
> +#define _min_max(...) _min_max_(__COUNTER__, __VA_ARGS__)

The fact that __COUNTER__ is used in compiler-gcc4.h but not in
compiler-gcc3.h makes me suspicious about its availability?

I do think that [1/2] made the code significantly worse-looking and
this one is getting crazy.  How useful is W=2 anyway?  Has anyone found
a bug using it?  The number of warnings in default builds is already way
too high :(

