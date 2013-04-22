Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3DVXPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:15:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3DVXPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:15:21 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1tO4Y6a1dgIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=T6oyPw_TvikA:10 a=zGozMQkj8TWB3Rd4-iYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366672518.9609.142.camel@gandalf.local.home>
Subject: Re: [PATCH] slab: Remove unnecessary __builtin_constant_p()
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>,
        Behan Webster <behanw@converseincode.com>
Date: Mon, 22 Apr 2013 19:15:18 -0400
In-Reply-To: <20130422141621.384eb93a6a8f3d441cd1a991@linux-foundation.org>
References: <1366225776.8817.28.camel@pippen.local.home>
	 <alpine.DEB.2.02.1304171702380.24494@chino.kir.corp.google.com>
	 <20130422134415.32c7f2cac07c924bff3017a4@linux-foundation.org>
	 <1366664301.9609.140.camel@gandalf.local.home>
	 <20130422141621.384eb93a6a8f3d441cd1a991@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 14:16 -0700, Andrew Morton wrote:
> On Mon, 22 Apr 2013 16:58:21 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> > When looking into this, we found the only two users of the index_of()
> > static function that has this issue, passes in size_of(), which will
> > always be a constant, making the check redundant.
> 
> Looking at the current callers is cheating.  What happens if someone
> adds another caller which doesn't use sizeof?

Well, as it required a size of something, if it was dynamic then what
would the size be of?

> 
> > Note, this is a bug in Clang that will hopefully be fixed soon. But for
> > now, this strange redundant compile time check is preventing Clang from
> > even testing the Linux kernel build.
> > </little birdie voice>
> > 
> > And I still think the original change log has rational for the change,
> > as it does make it rather confusing to what is happening there.
> 
> The patch made index_of() weaker!
> 
> It's probably all a bit academic, given that linux-next does
> 
> -/*
> - * This function must be completely optimized away if a constant is passed to
> - * it.  Mostly the same as what is in linux/slab.h except it returns an index.
> - */
> -static __always_inline int index_of(const size_t size)
> -{
> -	extern void __bad_size(void);
> -
> -	if (__builtin_constant_p(size)) {
> -		int i = 0;
> -
> -#define CACHE(x) \
> -	if (size <=x) \
> -		return i; \
> -	else \
> -		i++;
> -#include <linux/kmalloc_sizes.h>
> -#undef CACHE
> -		__bad_size();
> -	} else
> -		__bad_size();
> -	return 0;
> -}
> -

Looks like someone just ate the bird.

-- Steve


