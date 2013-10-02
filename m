Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3JBPn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:43:56 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:7025 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138Ab3JBPnv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:43:51 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2013 11:43:50 EDT
From: "Bird, Tim" <Tim.Bird@sonymobile.com>
To: Christoph Lameter <cl@linux.com>, Frank Rowand <frowand.list@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Bobniev, Roman" <Roman.Bobniev@sonymobile.com>,
        =?iso-8859-1?Q?=22Andersson=2C_Bj=F6rn=22?= 
	<Bjorn.Andersson@sonymobile.com>
Date: Wed, 2 Oct 2013 17:33:47 +0200
Subject: RE: [PATCH] slub: Proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
Thread-Topic: [PATCH] slub: Proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
Thread-Index: Ac6/fX+1M81dHYfOQB6TpMo+HQymRwABEgnq
Message-ID: <F5184659D418E34EA12B1903EE5EF5FD8538E86615@seldmbx02.corpusers.net>
References: <5245ECC3.8070200@gmail.com>,<00000141799dd4b3-f6df96c0-1003-427d-9bd8-f6455622f4ea-000000@email.amazonses.com>
In-Reply-To: <00000141799dd4b3-f6df96c0-1003-427d-9bd8-f6455622f4ea-000000@email.amazonses.com>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 02, 2013 7:41 AM, Christoph Lameter [cl@linux.com] wrote:
>
>On Fri, 27 Sep 2013, Frank Rowand wrote:
>
>> Move the kmemleak code for small block allocation out from
>> under CONFIG_SLUB_DEBUG.
>
>Well in that case it may be better to move the hooks as a whole out of
>the CONFIG_SLUB_DEBUG section. Do the #ifdeffering for each call from the
>hooks instead.
>
>The point of the hook functions is to separate the hooks out of the
>functions so taht they do not accumulate in the main code.
>
>The patch moves one hook back into the main code. Please keep the checks
>in the hooks.

Thanks for the feedback.  Roman's first patch, which we discussed internally
before sending this one, did exactly that.  I guess Roman gets to say "I told
you so." :-)  My bad for telling him to change it.

We'll refactor along the lines that you describe, and send another one.

The problem child is actually the unconditional call to kmemleak_alloc()
in kmalloc_large_node() (in slub.c).  The problem comes because that call
is unconditional on CONFIG_SLUB_DEBUG but the kmemleak
calls in the hook routines are conditional on CONFIG_SLUB_DEBUG.
So if you have CONFIG_SLUB_DEBUG=n but CONFIG_DEBUG_KMEMLEAK=y,
you get the false reports.

Now, there are kmemleak calls in kmalloc_large_node() and kfree() that don't
follow the "hook" pattern.  Should these be moved to 'hook' routines, to keep
all the checks in the hooks?

Personally, I like the idea of keeping bookeeping/tracing/debug stuff in hook
routines.  I also like de-coupling CONFIG_SLUB_DEBUG and CONFIG_DEBUG_KMEMLEAK,
but maybe others have a different opinon.  Unless someone speaks up, we'll
move the the currently in-function kmemleak calls into hooks, and all of the
kmemleak stuff out from under CONFIG_SLUB_DEBUG.
We'll have to see if the ifdefs get a little messy.
  -- Tim


