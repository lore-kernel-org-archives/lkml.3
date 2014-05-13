Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbaEMJ1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:27:06 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:37832 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbaEMJ1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:27:02 -0400
Message-ID: <1399973184.4137.8.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] compiler.h: don't use temporary variable in
 __compiletime_assert()
From: Johannes Berg <johannes@sipsolutions.net>
To: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Date: Tue, 13 May 2014 11:26:24 +0200
In-Reply-To: <5371DD92.5080304@imgtec.com>
References: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
		 <5370CFAC.40705@imgtec.com>
		 <20140512141642.5eb526deed5ea32ad5bced72@linux-foundation.org>
	 <1399966293.4137.5.camel@jlt4.sipsolutions.net>
	 <5371DD92.5080304@imgtec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

> Subject: [PATCH] compiler.h: avoid sparse errors in
>  __compiletime_error_fallback()
> 
> Usually, BUG_ON and friends aren't even evaluated in sparse, but
> recently compiletime_assert_atomic_type() was added, and that now
> results in a sparse warning every time it is used.
> 
> The reason turns out to be the temporary variable, after it sparse no
> longer considers the value to be a constant, and results in a warning
> and an error. The error is the more annoying part of this as it
> suppresses any further warnings in the same file, hiding other problems.
> 
> Unfortunately the condition cannot be simply expanded out to avoid the
> temporary variable since it breaks compiletime_assert on old versions of
> GCC such as GCC 4.2.4 which the latest metag compiler is based on.
> 
> Therefore #ifndef __CHECKER__ out the __compiletime_error_fallback which
> uses the potentially negative size array to trigger a conditional
> compiler error, so that sparse doesn't see it.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Daniel Santos <daniel.santos@pobox.com>
> Cc: Luciano Coelho <luciano.coelho@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> It's not particularly pretty, if you can think of a better solution that
> doesn't break old GCC I'm all ears.

>  #ifndef __compiletime_error
>  # define __compiletime_error(message)
> -# define __compiletime_error_fallback(condition) \
> +/*
> + * Sparse complains of variable sized arrays due to the temporary variable in
> + * __compiletime_assert. Unfortunately we can't just expand it out to make
> + * sparse see a constant array size without breaking compiletime_assert on old
> + * versions of GCC (e.g. 4.2.4), so hide the array from sparse altogether.
> + */
> +# ifndef __CHECKER__
> +#  define __compiletime_error_fallback(condition) \
>  	do { ((void)sizeof(char[1 - 2 * condition])); } while (0)
> -#else
> +# endif
> +#endif
> +#ifndef __compiletime_error_fallback
>  # define __compiletime_error_fallback(condition) do { } while (0)
>  #endif


That's pretty much what I had in mind, I may have expressed it a bit
differently but the end result is the same.

Thanks,
johannes

