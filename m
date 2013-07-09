Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3GIGqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:46:20 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:51295 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3GIGqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:46:19 -0400
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Joe Perches <joe@perches.com>
Cc: Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
        Wedson Almeida Filho <wedsonaf@gmail.com>
Subject: [PATCH v2] lib: One less subtraction in binary search iterations.
Date: Mon,  8 Jul 2013 23:37:02 -0700
Message-Id: <1373351822-52050-1-git-send-email-wedsonaf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CANeycqoHsRqCU4BSkPYK5O++ciShAmFcpEx+D3XUha7kukU0bQ@mail.gmail.com>
References: <CANeycqoHsRqCU4BSkPYK5O++ciShAmFcpEx+D3XUha7kukU0bQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subtraction is removed at the expense of generality: when the element size
is 1, the array length cannot exceed half the architecture's addressable
memory.

Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
---
 lib/bsearch.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/bsearch.c b/lib/bsearch.c
index e33c179..668ae6c 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -24,6 +24,11 @@
  * contents of the array should already be in ascending sorted order
  * under the provided comparison function.
  *
+ * There is a limitation when @size is 1: in this case @num must be at
+ * most SIZE_MAX / 2; that is, the number of elements in the sorted
+ * array must be at most half the maximum number expressible as a size_t
+ * to avoid overflows.
+ *
  * Note that the key need not have the same type as the elements in
  * the array, e.g. key could be a string and the comparison function
  * could compare the string with the struct's name field.  However, if
@@ -37,7 +42,7 @@ void *bsearch(const void *key, const void *base, size_t num, size_t size,
 	int result;
 
 	while (start < end) {
-		size_t mid = start + (end - start) / 2;
+		size_t mid = (start + end) / 2;
 
 		result = cmp(key, base + mid * size);
 		if (result < 0)
-- 
1.7.9.5

