Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbbA2Nha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:37:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:34252 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbbA2Nh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,486,1418112000"; 
   d="scan'208";a="669696314"
Message-ID: <1422538649.31903.330.camel@linux.intel.com>
Subject: Re: [PATCH v2 2/3] lib/string_helpers.c: Refactor string_escape_mem
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Jan 2015 15:37:29 +0200
In-Reply-To: <87sietbulp.fsf@rasmusvillemoes.dk>
References: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1422525801-26560-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1422525801-26560-3-git-send-email-linux@rasmusvillemoes.dk>
	 <1422533541.31903.314.camel@linux.intel.com>
	 <87sietbulp.fsf@rasmusvillemoes.dk>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-29 at 14:10 +0100, Rasmus Villemoes wrote:
> On Thu, Jan 29 2015, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:


> >> -	*out++ = '\\';
> >> -	*out++ = to;
> >> +	if (out + 0 < end)
> >> +		out[0] = '\\';
> >> +	if (out + 1 < end)
> >> +		out[1] = to;
> >
> > Could we do this in the same way like for hex_string, i.e.
> >
> > if (out < end)
> >  *out = '\\';
> > ++out;
> >
> > …
> >
> > *dst = out;
> > return true;
> >
> > ?
> 
> We could, but I don't think either is more readable than the
> other. Hence I chose the one requiring 2n+1 lines instead of 3n+1
> lines. Had this been in vsprintf.c I would stick to the pattern you
> suggest.

I think the pattern with 3n lines is a bit more readable.

> >> +	ret = p - *dst;
> >>  	*dst = p;
> >> -
> >> -	if (ret < 0)
> >> -		return ret;
> >> -
> >> -	return p - out;
> >
> > …and do not change the logic right now. Just substitute if (ret < 0) by
> > above if (p > end).
> >
> 
> I'm not sure I follow. How does this change the logic? We return -ENOMEM
> if and only if the entire output didn't fit, while still updating *dst
> to point to one past the last output character. If the output did fit,
> we return the size of the output.

I meant to do the arithmetics like it was in the original code.

> One thing that only occured to me now is that we may now leave a partial
> escape sequence at the end of the buffer. I can't see how this can
> reasonably be avoided

I don't know which way is better, but you may check how it was done in
the original code. First it was checking for enough space, and only
after filling the destination buffer.

fs/proc/array.c, for example, originally might leave the back slash at
the end.

>  while still doing a meaningful refactorization
> preparing it for the next patch.
> 
> Rasmus


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

