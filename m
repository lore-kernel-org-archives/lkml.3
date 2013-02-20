Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab3BTXgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:36:07 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47824 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3BTXgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:36:02 -0500
Date: Wed, 20 Feb 2013 15:35:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] idr: explain WARN_ON_ONCE() on negative IDs out-of-range ID
Message-ID: <20130220233557.GM3570@htj.dyndns.org>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
 <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
 <512522CF.1020901@oracle.com>
 <20130220210116.GD3570@htj.dyndns.org>
 <20130220132300.ccffde44.akpm@linux-foundation.org>
 <20130220213701.GE3570@htj.dyndns.org>
 <20130220140551.8017e795.akpm@linux-foundation.org>
 <20130220220823.GH3570@htj.dyndns.org>
 <20130220224019.GI3570@htj.dyndns.org>
 <20130220232412.GL3570@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220232412.GL3570@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until recently, when an negative ID is specified, idr functions used
to ignore the sign bit and proceeded with the operation with the rest
of bits, which is bizarre and error-prone.  The behavior recently got
changed so that negative IDs are treated as invalid but we're
triggering WARN_ON_ONCE() on negative IDs just in case somebody was
depending on the sign bit being ignored, so that those can be detected
and fixed easily.

We only need this for a while.  Explain why WARN_ON_ONCE()s are there
and that they can be removed later.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 lib/idr.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/idr.c b/lib/idr.c
index 5c772dc..134a61a 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -569,6 +569,7 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *p;
 	struct idr_layer *to_free;
 
+	/* see comment in idr_find_slowpath() */
 	if (WARN_ON_ONCE(id < 0))
 		return;
 
@@ -666,6 +667,14 @@ void *idr_find_slowpath(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
+	/*
+	 * If @id is negative, idr_find() used to ignore the sign bit and
+	 * performed lookup with the rest of bits, which is weird and can
+	 * lead to very obscure bugs.  We're now returning NULL for all
+	 * negative IDs but just in case somebody was depending on the sign
+	 * bit being ignored, let's trigger WARN_ON_ONCE() so that they can
+	 * be detected and fixed.  WARN_ON_ONCE() can later be removed.
+	 */
 	if (WARN_ON_ONCE(id < 0))
 		return NULL;
 
@@ -815,6 +824,7 @@ void *idr_replace(struct idr *idp, void *ptr, int id)
 	int n;
 	struct idr_layer *p, *old_p;
 
+	/* see comment in idr_find_slowpath() */
 	if (WARN_ON_ONCE(id < 0))
 		return ERR_PTR(-EINVAL);
 
