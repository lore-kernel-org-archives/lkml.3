Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3LQABc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:01:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3LQABb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:01:31 -0500
Date: Mon, 16 Dec 2013 16:01:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC][PATCH 0/7] re-shrink 'struct page' when SLUB is on.
Message-Id: <20131216160128.aa1f1eb8039f5eee578cf560@linux-foundation.org>
In-Reply-To: <20131213235903.8236C539@viggo.jf.intel.com>
References: <20131213235903.8236C539@viggo.jf.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013 15:59:03 -0800 Dave Hansen <dave@sr71.net> wrote:

> SLUB depends on a 16-byte cmpxchg for an optimization.  For the
> purposes of this series, I'm assuming that it is a very important
> optimization that we desperately need to keep around.

What if we don't do that.

> In order to get guaranteed 16-byte alignment (required by the
> hardware on x86), 'struct page' is padded out from 56 to 64
> bytes.
> 
> Those 8-bytes matter.  We've gone to great lengths to keep
> 'struct page' small in the past.  It's a shame that we bloat it
> now just for alignment reasons when we have extra space.  Plus,
> bloating such a commonly-touched structure *HAS* to have cache
> footprint implications.
> 
> These patches attempt _internal_ alignment instead of external
> alignment for slub.
> 
> I also got a bug report from some folks running a large database
> benchmark.  Their old kernel uses slab and their new one uses
> slub.  They were swapping and couldn't figure out why.  It turned
> out to be the 2GB of RAM that the slub padding wastes on their
> system.
> 
> On my box, that 2GB cost about $200 to populate back when we
> bought it.  I want my $200 back.
> 
> This set takes me from 16909584K of reserved memory at boot
> down to 14814472K, so almost *exactly* 2GB of savings!  It also
> helps performance, presumably because it touches 14% fewer
> struct page cachelines.  A 30GB dd to a ramfs file:
> 
>         dd if=/dev/zero of=bigfile bs=$((1<<30)) count=30
> 
> is sped up by about 4.4% in my testing.

This is a gruesome and horrible tale of inefficiency and regression.

>From 5-10 minutes of gitting I couldn't see any performance testing
results for slub's cmpxchg_double stuff.  I am thinking we should just
tip it all overboard unless someone can demonstrate sufficiently
serious losses from so doing.

--- a/arch/x86/Kconfig~a
+++ a/arch/x86/Kconfig
@@ -78,7 +78,6 @@ config X86
 	select ANON_INODES
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_CMPXCHG_LOCAL
-	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
_

