Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3H2VrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:47:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52351 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756373Ab3H2VrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:47:16 -0400
Message-ID: <1377812836.1928.135.camel@joe-AO722>
Subject: slab: krealloc with GFP_ZERO defect
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm <linux-mm@kvack.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 29 Aug 2013 14:47:16 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sequence can return non-zeroed memory from the
padding area of the original allocation.

	ptr = kzalloc(foo, GFP_KERNEL);
	if (!ptr)
		...
	new_ptr = krealloc(ptr, foo + bar, GFP_KERNEL | __GFP_ZERO);

If the realloc size is within the first actual allocation
then the additional memory is not zeroed.

If the realloc size is not within the original allocation
size, any non-zeroed padding from the original allocation
is overwriting newly allocated zeroed memory.

Maybe someone more familiar with the alignment & padding can
add the proper memset(,0,) for the __GFP_ZERO cases and also
optimize kmalloc_track_caller to not use __GFP_ZERO, memcpy
the current (non padded) size and zero the newly returned
remainder if necessary.

from: mm/util.c
---------------------------
static __always_inline void *__do_krealloc(const void *p, size_t new_size,
					   gfp_t flags)
{
	void *ret;
	size_t ks = 0;

	if (p)
		ks = ksize(p);

	if (ks >= new_size)
		return (void *)p;

	ret = kmalloc_track_caller(new_size, flags);
	if (ret && p)
		memcpy(ret, p, ks);

	return ret;
}


