Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaH1Orw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:47:52 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:50728 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbaH1Orv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:47:51 -0400
Date: Thu, 28 Aug 2014 09:47:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: WANG Chao <chaowang@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm, slub: do not add duplicate sysfs
In-Reply-To: <20140828043211.GD3971@dhcp-17-37.nay.redhat.com>
Message-ID: <alpine.DEB.2.11.1408280947270.3275@gentwo.org>
References: <1409152488-21227-1-git-send-email-chaowang@redhat.com> <alpine.DEB.2.11.1408271023130.17080@gentwo.org> <alpine.DEB.2.11.1408271030360.17080@gentwo.org> <20140828043211.GD3971@dhcp-17-37.nay.redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, WANG Chao wrote:

> What about failslab_store()? SLAB_FAILSLAB is also a nomerge flag.


Subject: slub: Disable tracing and failslab for merged slabs

Tracing of mergeable slabs as well as uses of failslab are
confusing since the objects of multiple slab caches will be
affected. Moreover this creates a situation where a mergeable
slab will become unmergeable.

If tracing or failslab testing is desired then it may be best to
switch merging off for starters.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2014-08-08 11:52:30.039681592 -0500
+++ linux/mm/slub.c	2014-08-28 09:45:58.748840392 -0500
@@ -4604,6 +4604,14 @@ static ssize_t trace_show(struct kmem_ca
 static ssize_t trace_store(struct kmem_cache *s, const char *buf,
 							size_t length)
 {
+	/*
+	 * Tracing a merged cache is going to give confusing results
+	 * as well as cause other issues like converting a mergeable
+	 * cache into an umergeable one.
+	 */
+	if (s->refcount > 1)
+		return -EINVAL;
+
 	s->flags &= ~SLAB_TRACE;
 	if (buf[0] == '1') {
 		s->flags &= ~__CMPXCHG_DOUBLE;
@@ -4721,6 +4729,9 @@ static ssize_t failslab_show(struct kmem
 static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
 							size_t length)
 {
+	if (s->refcount > 1)
+		return -EINVAL;
+
 	s->flags &= ~SLAB_FAILSLAB;
 	if (buf[0] == '1')
 		s->flags |= SLAB_FAILSLAB;
