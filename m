Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaICJHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:07:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:49159 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbaICJHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:07:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="380724075"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: kmo@daterainc.com
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 1/2] md: Resolve shadow warnings
Date: Wed,  3 Sep 2014 02:07:08 -0700
Message-Id: <1409735229-24186-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve shadow warnings caused by having the variable "ret"
in the RB_* macros, which matches the same local name in
functions that use the macros. Because these inner blocks
are defined in a macro, if the outer "ret" were passed to
the macro, madness would ensue. Reduce the hazard by prepending
an _ to the names of the inner block symbols, which seems to
be standard practice anyway.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/md/bcache/util.h | 80 ++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 98df757..508f68b 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -484,65 +484,65 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done);
 
 #define RB_INSERT(root, new, member, cmp)				\
 ({									\
-	__label__ dup;							\
-	struct rb_node **n = &(root)->rb_node, *parent = NULL;		\
-	typeof(new) this;						\
-	int res, ret = -1;						\
+	__label__ _dup;							\
+	struct rb_node **_n = &(root)->rb_node, *_parent = NULL;	\
+	typeof(new) _this;						\
+	int _res, _ret = -1;						\
 									\
-	while (*n) {							\
-		parent = *n;						\
-		this = container_of(*n, typeof(*(new)), member);	\
-		res = cmp(new, this);					\
-		if (!res)						\
-			goto dup;					\
-		n = res < 0						\
-			? &(*n)->rb_left				\
-			: &(*n)->rb_right;				\
+	while (*_n) {							\
+		_parent = *_n;						\
+		_this = container_of(*_n, typeof(*(new)), member);	\
+		_res = cmp(new, _this);					\
+		if (!_res)						\
+			goto _dup;					\
+		_n = _res < 0						\
+			? &(*_n)->rb_left				\
+			: &(*_n)->rb_right;				\
 	}								\
 									\
-	rb_link_node(&(new)->member, parent, n);			\
+	rb_link_node(&(new)->member, _parent, _n);			\
 	rb_insert_color(&(new)->member, root);				\
-	ret = 0;							\
-dup:									\
-	ret;								\
+	_ret = 0;							\
+_dup:									\
+	_ret;								\
 })
 
 #define RB_SEARCH(root, search, member, cmp)				\
 ({									\
-	struct rb_node *n = (root)->rb_node;				\
-	typeof(&(search)) this, ret = NULL;				\
-	int res;							\
+	struct rb_node *_n = (root)->rb_node;				\
+	typeof(&(search)) _this, _ret = NULL;				\
+	int _res;							\
 									\
-	while (n) {							\
-		this = container_of(n, typeof(search), member);		\
-		res = cmp(&(search), this);				\
-		if (!res) {						\
-			ret = this;					\
+	while (_n) {							\
+		_this = container_of(_n, typeof(search), member);		\
+		_res = cmp(&(search), _this);				\
+		if (!_res) {						\
+			_ret = _this;					\
 			break;						\
 		}							\
-		n = res < 0						\
-			? n->rb_left					\
-			: n->rb_right;					\
+		_n = _res < 0						\
+			? _n->rb_left					\
+			: _n->rb_right;					\
 	}								\
-	ret;								\
+	_ret;								\
 })
 
 #define RB_GREATER(root, search, member, cmp)				\
 ({									\
-	struct rb_node *n = (root)->rb_node;				\
-	typeof(&(search)) this, ret = NULL;				\
-	int res;							\
+	struct rb_node *_n = (root)->rb_node;				\
+	typeof(&(search)) _this, _ret = NULL;				\
+	int _res;							\
 									\
-	while (n) {							\
-		this = container_of(n, typeof(search), member);		\
-		res = cmp(&(search), this);				\
-		if (res < 0) {						\
-			ret = this;					\
-			n = n->rb_left;					\
+	while (_n) {							\
+		_this = container_of(_n, typeof(search), member);	\
+		_res = cmp(&(search), _this);				\
+		if (_res < 0) {						\
+			_ret = _this;					\
+			_n = _n->rb_left;					\
 		} else							\
-			n = n->rb_right;				\
+			_n = _n->rb_right;				\
 	}								\
-	ret;								\
+	_ret;								\
 })
 
 #define RB_FIRST(root, type, member)					\
-- 
1.9.3

