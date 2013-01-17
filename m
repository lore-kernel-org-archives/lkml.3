Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab3AQRNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:13:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17460 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3AQRNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:13:48 -0500
X-Authority-Analysis: v=2.0 cv=e+OEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZF3fSwPLIvUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=PNVBakpotukA:10 a=37rDS-QxAAAA:8 a=VwQbUJbxAAAA:8 a=8Mp7U4MB-6elABKeDl4A:9 a=PUjeQqilurYA:10 a=Qbg8LneXD70A:10 a=6uQODOVjHeUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358442826.23211.18.camel@gandalf.local.home>
Subject: slob: Check for NULL pointer before calling ctor()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Date: Thu, 17 Jan 2013 12:13:46 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry for the duplicate email, it's linux-mm@kvack.org not linux-mm@vger.kernel.org ] 

While doing some code inspection, I noticed that the slob constructor
method can be called with a NULL pointer. If memory is tight and slob
fails to allocate with slob_alloc() or slob_new_pages() it still calls
the ctor() method with a NULL pointer. Looking at the first ctor()
method I found, I noticed that it can not handle a NULL pointer (I'm
sure others probably can't either):

static void sighand_ctor(void *data)
{
        struct sighand_struct *sighand = data;

        spin_lock_init(&sighand->siglock);
        init_waitqueue_head(&sighand->signalfd_wqh);
}

The solution is to only call the ctor() method if allocation succeeded.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/mm/slob.c b/mm/slob.c
index a99fdf7..48fcb90 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -554,7 +554,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 					    flags, node);
 	}
 
-	if (c->ctor)
+	if (b && c->ctor)
 		c->ctor(b);
 
 	kmemleak_alloc_recursive(b, c->size, 1, c->flags, flags);



