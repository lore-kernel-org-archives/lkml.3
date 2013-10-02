Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3JBP5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:57:16 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:44364 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339Ab3JBP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:57:14 -0400
Date: Wed, 2 Oct 2013 15:57:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Bird, Tim" <Tim.Bird@sonymobile.com>
cc: Frank Rowand <frowand.list@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Bobniev, Roman" <Roman.Bobniev@sonymobile.com>,
        =?ISO-8859-15?Q?=22Andersson=2C_Bj=F6rn=22?= 
	<Bjorn.Andersson@sonymobile.com>
Subject: RE: [PATCH] slub: Proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
In-Reply-To: <F5184659D418E34EA12B1903EE5EF5FD8538E86615@seldmbx02.corpusers.net>
Message-ID: <0000014179e31953-a05dd7d1-d0f8-474f-810a-809cd8a724f8-000000@email.amazonses.com>
References: <5245ECC3.8070200@gmail.com>,<00000141799dd4b3-f6df96c0-1003-427d-9bd8-f6455622f4ea-000000@email.amazonses.com> <F5184659D418E34EA12B1903EE5EF5FD8538E86615@seldmbx02.corpusers.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.02-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Oct 2013, Bird, Tim wrote:

> The problem child is actually the unconditional call to kmemleak_alloc()
> in kmalloc_large_node() (in slub.c).  The problem comes because that call
> is unconditional on CONFIG_SLUB_DEBUG but the kmemleak
> calls in the hook routines are conditional on CONFIG_SLUB_DEBUG.
> So if you have CONFIG_SLUB_DEBUG=n but CONFIG_DEBUG_KMEMLEAK=y,
> you get the false reports.

Right. You need to put the #ifdef CONFIG_SLUB_DEBUG around the hooks that
need it in the function itself instead of disabling the whole function if
CONFIG_SLUB_DEUBG is not set.

> Now, there are kmemleak calls in kmalloc_large_node() and kfree() that don't
> follow the "hook" pattern.  Should these be moved to 'hook' routines, to keep
> all the checks in the hooks?

That would be great.

> Personally, I like the idea of keeping bookeeping/tracing/debug stuff in hook
> routines.  I also like de-coupling CONFIG_SLUB_DEBUG and CONFIG_DEBUG_KMEMLEAK,
> but maybe others have a different opinon.  Unless someone speaks up, we'll
> move the the currently in-function kmemleak calls into hooks, and all of the
> kmemleak stuff out from under CONFIG_SLUB_DEBUG.
> We'll have to see if the ifdefs get a little messy.

Decouple of you want. CONFIG_SLUB_DEBUG may duplicate what you already do.

