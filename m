Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3DVVQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:16:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3DVVQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:16:24 -0400
Date: Mon, 22 Apr 2013 14:16:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH] slab: Remove unnecessary __builtin_constant_p()
Message-Id: <20130422141621.384eb93a6a8f3d441cd1a991@linux-foundation.org>
In-Reply-To: <1366664301.9609.140.camel@gandalf.local.home>
References: <1366225776.8817.28.camel@pippen.local.home>
	<alpine.DEB.2.02.1304171702380.24494@chino.kir.corp.google.com>
	<20130422134415.32c7f2cac07c924bff3017a4@linux-foundation.org>
	<1366664301.9609.140.camel@gandalf.local.home>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013 16:58:21 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2013-04-22 at 13:44 -0700, Andrew Morton wrote:
> > On Wed, 17 Apr 2013 17:03:21 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> > 
> > > On Wed, 17 Apr 2013, Steven Rostedt wrote:
> > > 
> > > > The slab.c code has a size check macro that checks the size of the
> > > > following structs:
> > > > 
> > > > struct arraycache_init
> > > > struct kmem_list3
> > > > 
> > > > The index_of() function that takes the sizeof() of the above two structs
> > > > and does an unnecessary __builtin_constant_p() on that. As sizeof() will
> > > > always end up being a constant making this always be true. The code is
> > > > not incorrect, but it just adds added complexity, and confuses users and
> > > > wastes the time of reviewers of the code, who spends time trying to
> > > > figure out why the builtin_constant_p() was used.
> > > > 
> > > > This patch is just a clean up that makes the index_of() code a little
> > > > bit less complex.
> > > > 
> > > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > Acked-by: David Rientjes <rientjes@google.com>
> > > 
> > > Adding Pekka to the cc.
> > 
> > I ducked this patch because it seemed rather pointless - but a little
> > birdie told me that there is a secret motivation which seems pretty
> > reasonable to me.  So I shall await chirp-the-second, which hopefully
> > will have a fuller and franker changelog ;)
> 
> <little birdie voice>
> The real motivation behind this patch was it prevents LLVM (Clang) from
> compiling the kernel. There's currently a bug in Clang where it can't
> determine if a variable is constant or not, so instead, when
> __builtin_constant_p() is used, it just treats it like it isn't a
> constant (always taking the slow *safe* path).
> 
> Unfortunately, the "confusing" code of slub.c that unnecessarily uses
> the __builtin_constant_p() will fail to compile if the variable passed
> in is not constant. As Clang will say constants are not constant at this
> point, the compile fails.
> 
> When looking into this, we found the only two users of the index_of()
> static function that has this issue, passes in size_of(), which will
> always be a constant, making the check redundant.

Looking at the current callers is cheating.  What happens if someone
adds another caller which doesn't use sizeof?

> Note, this is a bug in Clang that will hopefully be fixed soon. But for
> now, this strange redundant compile time check is preventing Clang from
> even testing the Linux kernel build.
> </little birdie voice>
> 
> And I still think the original change log has rational for the change,
> as it does make it rather confusing to what is happening there.

The patch made index_of() weaker!

It's probably all a bit academic, given that linux-next does

-/*
- * This function must be completely optimized away if a constant is passed to
- * it.  Mostly the same as what is in linux/slab.h except it returns an index.
- */
-static __always_inline int index_of(const size_t size)
-{
-	extern void __bad_size(void);
-
-	if (__builtin_constant_p(size)) {
-		int i = 0;
-
-#define CACHE(x) \
-	if (size <=x) \
-		return i; \
-	else \
-		i++;
-#include <linux/kmalloc_sizes.h>
-#undef CACHE
-		__bad_size();
-	} else
-		__bad_size();
-	return 0;
-}
-

