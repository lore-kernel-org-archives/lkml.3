Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3CAVpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:45:20 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56349 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3CAVpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:45:19 -0500
Date: Fri, 1 Mar 2013 13:45:14 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: markus@trippelsdorf.de, linux-kernel@vger.kernel.org
Subject: [PATCH] idr: remove WARN_ON_ONCE() on negative IDs
Message-ID: <20130301214514.GG2481@mtj.dyndns.org>
References: <20130228090846.GA249@x4>
 <20130301133159.0711f81a.akpm@linux-foundation.org>
 <20130301213511.GF2481@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130301213511.GF2481@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_find(), idr_remove() and idr_replace() used to silently ignore the
sign bit and perform lookup with the rest of the bits.  The weird
behavior has been changed such that negative IDs are treated as
invalid.  As the behavior change was subtle, WARN_ON_ONCE() was added
in the hope of determining who's calling idr functions with negative
IDs so that they can be examined for problems.

Up until now, all two reported cases are ID number coming directly
from userland and getting fed into idr_find() and the warnings seem to
cause more problems than being helpful.  Drop the WARN_ON_ONCE()s.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: markus@trippelsdorf.de
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/idr.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 73f4d53..00739aa 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -569,8 +569,7 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *p;
 	struct idr_layer *to_free;
 
-	/* see comment in idr_find_slowpath() */
-	if (WARN_ON_ONCE(id < 0))
+	if (id < 0)
 		return;
 
 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
@@ -667,15 +666,7 @@ void *idr_find_slowpath(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
-	/*
-	 * If @id is negative, idr_find() used to ignore the sign bit and
-	 * performed lookup with the rest of bits, which is weird and can
-	 * lead to very obscure bugs.  We're now returning NULL for all
-	 * negative IDs but just in case somebody was depending on the sign
-	 * bit being ignored, let's trigger WARN_ON_ONCE() so that they can
-	 * be detected and fixed.  WARN_ON_ONCE() can later be removed.
-	 */
-	if (WARN_ON_ONCE(id < 0))
+	if (id < 0)
 		return NULL;
 
 	p = rcu_dereference_raw(idp->top);
@@ -824,8 +815,7 @@ void *idr_replace(struct idr *idp, void *ptr, int id)
 	int n;
 	struct idr_layer *p, *old_p;
 
-	/* see comment in idr_find_slowpath() */
-	if (WARN_ON_ONCE(id < 0))
+	if (id < 0)
 		return ERR_PTR(-EINVAL);
 
 	p = idp->top;
