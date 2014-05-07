Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaEGP4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:56:52 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:40656 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739AbaEGP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:56:50 -0400
Date: Wed, 7 May 2014 11:56:47 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH REPOST percpu/for-3.16 1/2] percpu-refcount: rename
 percpu_ref_tryget() to percpu_ref_tryget_live()
Message-ID: <20140507155647.GC26540@htj.dyndns.org>
References: <20140507155511.GB26540@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507155511.GB26540@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_ref_tryget() is different from the usual tryget semantics in
that it fails if the refcnt is in its dying stage even if the refcnt
hasn't reached zero yet.  We're about to introduce the more
conventional tryget and the current one has only one user.  Let's
rename it to percpu_ref_tryget_live() so that it explicitly signifies
the peculiarities of its semantics.

This is pure rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
Reposting with Kent's new email address.

Thanks.

 include/linux/cgroup.h          |    2 +-
 include/linux/percpu-refcount.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -108,7 +108,7 @@ static inline bool css_tryget(struct cgr
 {
 	if (css->flags & CSS_ROOT)
 		return true;
-	return percpu_ref_tryget(&css->refcnt);
+	return percpu_ref_tryget_live(&css->refcnt);
 }
 
 /**
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -118,7 +118,7 @@ static inline void percpu_ref_get(struct
 }
 
 /**
- * percpu_ref_tryget - try to increment a percpu refcount
+ * percpu_ref_tryget_live - try to increment a live percpu refcount
  * @ref: percpu_ref to try-get
  *
  * Increment a percpu refcount unless it has already been killed.  Returns
@@ -129,7 +129,7 @@ static inline void percpu_ref_get(struct
  * used.  After the confirm_kill callback is invoked, it's guaranteed that
  * no new reference will be given out by percpu_ref_tryget().
  */
-static inline bool percpu_ref_tryget(struct percpu_ref *ref)
+static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
 {
 	unsigned __percpu *pcpu_count;
 	int ret = false;
