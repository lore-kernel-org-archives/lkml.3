Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaLZGLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 01:11:25 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57293 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaLZGLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 01:11:05 -0500
From: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soeren.brinkmann@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soeren.brinkmann@gmail.com>
Subject: [PATCH 2/2] staging: lustre: libcfs/nidstrings: Avoid forward declarations
Date: Fri, 26 Dec 2014 07:10:51 +0100
Message-Id: <1419574251-27087-2-git-send-email-soeren.brinkmann@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419574251-27087-1-git-send-email-soeren.brinkmann@gmail.com>
References: <1419574251-27087-1-git-send-email-soeren.brinkmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid forward declaratoins by moving functions to a location before they
are referenced.

Signed-off-by: Sören Brinkmann <soeren.brinkmann@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/nidstrings.c | 77 +++++++++++------------
 1 file changed, 37 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/nidstrings.c b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
index a73424a69982..c70da373e412 100644
--- a/drivers/staging/lustre/lustre/libcfs/nidstrings.c
+++ b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
@@ -143,8 +143,43 @@ static int libcfs_num_str2addr(const char *str, int nob, __u32 *addr)
 	return 0;
 }
 
-static int  libcfs_num_parse(char *str, int len, struct list_head *list);
-static int  libcfs_num_match(__u32 addr, struct list_head *list);
+/**
+ * Nf_parse_addrlist method for networks using numeric addresses.
+ *
+ * Examples of such networks are gm and elan.
+ *
+ * \retval 0 if \a str parsed to numeric address
+ * \retval errno otherwise
+ */
+static int
+libcfs_num_parse(char *str, int len, struct list_head *list)
+{
+	struct cfs_expr_list *el;
+	int	rc;
+
+	rc = cfs_expr_list_parse(str, len, 0, MAX_NUMERIC_VALUE, &el);
+	if (rc == 0)
+		list_add_tail(&el->el_link, list);
+
+	return rc;
+}
+
+/*
+ * Nf_match_addr method for networks using numeric addresses
+ *
+ * \retval 1 on match
+ * \retval 0 otherwise
+ */
+static int
+libcfs_num_match(__u32 addr, struct list_head *numaddr)
+{
+	struct cfs_expr_list *el;
+
+	LASSERT(!list_empty(numaddr));
+	el = list_entry(numaddr->next, struct cfs_expr_list, el_link);
+
+	return cfs_expr_list_match(addr, el);
+}
 
 struct netstrfns {
 	int	  nf_type;
@@ -572,27 +607,6 @@ struct addrrange {
 };
 
 /**
- * Nf_parse_addrlist method for networks using numeric addresses.
- *
- * Examples of such networks are gm and elan.
- *
- * \retval 0 if \a str parsed to numeric address
- * \retval errno otherwise
- */
-static int
-libcfs_num_parse(char *str, int len, struct list_head *list)
-{
-	struct cfs_expr_list *el;
-	int	rc;
-
-	rc = cfs_expr_list_parse(str, len, 0, MAX_NUMERIC_VALUE, &el);
-	if (rc == 0)
-		list_add_tail(&el->el_link, list);
-
-	return rc;
-}
-
-/**
  * Parses \<addrrange\> token on the syntax.
  *
  * Allocates struct addrrange and links to \a nidrange via
@@ -798,23 +812,6 @@ cfs_parse_nidlist(char *str, int len, struct list_head *nidlist)
 }
 EXPORT_SYMBOL(cfs_parse_nidlist);
 
-/*
- * Nf_match_addr method for networks using numeric addresses
- *
- * \retval 1 on match
- * \retval 0 otherwise
- */
-static int
-libcfs_num_match(__u32 addr, struct list_head *numaddr)
-{
-	struct cfs_expr_list *el;
-
-	LASSERT(!list_empty(numaddr));
-	el = list_entry(numaddr->next, struct cfs_expr_list, el_link);
-
-	return cfs_expr_list_match(addr, el);
-}
-
 /**
  * Matches a nid (\a nid) against the compiled list of nidranges (\a nidlist).
  *
-- 
2.2.1

