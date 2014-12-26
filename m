Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaLZGLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 01:11:09 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52553 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaLZGLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 01:11:04 -0500
From: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soeren.brinkmann@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soeren.brinkmann@gmail.com>
Subject: [PATCH 1/2] staging: lustre: libcfs/nidstrings: Declare internal symbols static
Date: Fri, 26 Dec 2014 07:10:50 +0100
Message-Id: <1419574251-27087-1-git-send-email-soeren.brinkmann@gmail.com>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes sparse warnings:
  staging/lustre/lustre/libcfs/nidstrings.c:200:11: warning: symbol 'libcfs_nnetstrfns' was not declared. Should it be static?
  drivers/staging/lustre/lustre/libcfs/nidstrings.c:203:1: warning: symbol 'libcfs_lo_str2addr' was not declared. Should it be static?
  drivers/staging/lustre/lustre/libcfs/nidstrings.c:210:1: warning: symbol 'libcfs_ip_addr2str' was not declared. Should it be static?
  drivers/staging/lustre/lustre/libcfs/nidstrings.c:227:1: warning: symbol 'libcfs_ip_str2addr' was not declared. Should it be static?
  drivers/staging/lustre/lustre/libcfs/nidstrings.c:248:1: warning: symbol 'libcfs_decnum_addr2str' was not declared. Should it be static?
  drivers/staging/lustre/lustre/libcfs/nidstrings.c:254:1: warning: symbol 'libcfs_hexnum_addr2str' was not declared. Should it be static?
  drivers/staging/lustre/lustre/libcfs/nidstrings.c:260:1: warning: symbol 'libcfs_num_str2addr' was not declared. Should it be static?
  staging/lustre/lustre/libcfs/nidstrings.c:279:18: warning: symbol 'libcfs_lnd2netstrfns' was not declared. Should it be static?
  drivers/staging/lustre/lustre/libcfs/nidstrings.c:292:18: warning: symbol 'libcfs_namenum2netstrfns' was not declared. Should it be static?
  drivers/staging/lustre/lustre/libcfs/nidstrings.c:307:18: warning: symbol 'libcfs_name2netstrfns' was not declared. Should it be static?

Some functions had static forward declarations followed by non-static
implementations. Those forward declarations are removed and the
implementations are declared static and moved into a location that
doesn't require forward declarations.

Signed-off-by: Sören Brinkmann <soeren.brinkmann@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/nidstrings.c | 146 ++++++++++------------
 1 file changed, 66 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/nidstrings.c b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
index 47c239f22ba8..a73424a69982 100644
--- a/drivers/staging/lustre/lustre/libcfs/nidstrings.c
+++ b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
@@ -81,12 +81,68 @@ libcfs_next_nidstring(void)
 	return str;
 }
 
-static int  libcfs_lo_str2addr(const char *str, int nob, __u32 *addr);
-static void libcfs_ip_addr2str(__u32 addr, char *str);
-static int  libcfs_ip_str2addr(const char *str, int nob, __u32 *addr);
-static void libcfs_decnum_addr2str(__u32 addr, char *str);
-static void libcfs_hexnum_addr2str(__u32 addr, char *str);
-static int  libcfs_num_str2addr(const char *str, int nob, __u32 *addr);
+static int libcfs_lo_str2addr(const char *str, int nob, __u32 *addr)
+{
+	*addr = 0;
+	return 1;
+}
+
+static void libcfs_ip_addr2str(__u32 addr, char *str)
+{
+	snprintf(str, LNET_NIDSTR_SIZE, "%u.%u.%u.%u",
+		 (addr >> 24) & 0xff, (addr >> 16) & 0xff,
+		 (addr >> 8) & 0xff, addr & 0xff);
+}
+
+static int libcfs_ip_str2addr(const char *str, int nob, __u32 *addr)
+{
+	unsigned int	a;
+	unsigned int	b;
+	unsigned int	c;
+	unsigned int	d;
+	int		n = nob; /* XscanfX */
+
+	/* numeric IP? */
+	if (sscanf(str, "%u.%u.%u.%u%n", &a, &b, &c, &d, &n) >= 4 &&
+	    n == nob &&
+	    (a & ~0xff) == 0 && (b & ~0xff) == 0 &&
+	    (c & ~0xff) == 0 && (d & ~0xff) == 0) {
+		*addr = ((a<<24)|(b<<16)|(c<<8)|d);
+		return 1;
+	}
+
+	return 0;
+}
+
+static void libcfs_decnum_addr2str(__u32 addr, char *str)
+{
+	snprintf(str, LNET_NIDSTR_SIZE, "%u", addr);
+}
+
+static void libcfs_hexnum_addr2str(__u32 addr, char *str)
+{
+	snprintf(str, LNET_NIDSTR_SIZE, "0x%x", addr);
+}
+
+static int libcfs_num_str2addr(const char *str, int nob, __u32 *addr)
+{
+	int     n;
+
+	n = nob;
+	if (sscanf(str, "0x%x%n", addr, &n) >= 1 && n == nob)
+		return 1;
+
+	n = nob;
+	if (sscanf(str, "0X%x%n", addr, &n) >= 1 && n == nob)
+		return 1;
+
+	n = nob;
+	if (sscanf(str, "%u%n", addr, &n) >= 1 && n == nob)
+		return 1;
+
+	return 0;
+}
+
 static int  libcfs_num_parse(char *str, int len, struct list_head *list);
 static int  libcfs_num_match(__u32 addr, struct list_head *list);
 
@@ -197,24 +253,7 @@ static struct netstrfns  libcfs_netstrfns[] = {
 	{/* .nf_type      */  -1},
 };
 
-const int libcfs_nnetstrfns = ARRAY_SIZE(libcfs_netstrfns);
-
-int
-libcfs_lo_str2addr(const char *str, int nob, __u32 *addr)
-{
-	*addr = 0;
-	return 1;
-}
-
-void
-libcfs_ip_addr2str(__u32 addr, char *str)
-{
-#if 0   /* never lookup */
-#endif
-	snprintf(str, LNET_NIDSTR_SIZE, "%u.%u.%u.%u",
-		 (addr >> 24) & 0xff, (addr >> 16) & 0xff,
-		 (addr >> 8) & 0xff, addr & 0xff);
-}
+static const int libcfs_nnetstrfns = ARRAY_SIZE(libcfs_netstrfns);
 
 /* CAVEAT EMPTOR XscanfX
  * I use "%n" at the end of a sscanf format to detect trailing junk.  However
@@ -223,60 +262,7 @@ libcfs_ip_addr2str(__u32 addr, char *str)
  * fine, if it doesn't, then the scan ended at the end of the string, which is
  * fine too :) */
 
-int
-libcfs_ip_str2addr(const char *str, int nob, __u32 *addr)
-{
-	unsigned int	a;
-	unsigned int	b;
-	unsigned int	c;
-	unsigned int	d;
-	int		n = nob; /* XscanfX */
-
-	/* numeric IP? */
-	if (sscanf(str, "%u.%u.%u.%u%n", &a, &b, &c, &d, &n) >= 4 &&
-	    n == nob &&
-	    (a & ~0xff) == 0 && (b & ~0xff) == 0 &&
-	    (c & ~0xff) == 0 && (d & ~0xff) == 0) {
-		*addr = ((a<<24)|(b<<16)|(c<<8)|d);
-		return 1;
-	}
-
-	return 0;
-}
-
-void
-libcfs_decnum_addr2str(__u32 addr, char *str)
-{
-	snprintf(str, LNET_NIDSTR_SIZE, "%u", addr);
-}
-
-void
-libcfs_hexnum_addr2str(__u32 addr, char *str)
-{
-	snprintf(str, LNET_NIDSTR_SIZE, "0x%x", addr);
-}
-
-int
-libcfs_num_str2addr(const char *str, int nob, __u32 *addr)
-{
-	int     n;
-
-	n = nob;
-	if (sscanf(str, "0x%x%n", addr, &n) >= 1 && n == nob)
-		return 1;
-
-	n = nob;
-	if (sscanf(str, "0X%x%n", addr, &n) >= 1 && n == nob)
-		return 1;
-
-	n = nob;
-	if (sscanf(str, "%u%n", addr, &n) >= 1 && n == nob)
-		return 1;
-
-	return 0;
-}
-
-struct netstrfns *
+static struct netstrfns *
 libcfs_lnd2netstrfns(int lnd)
 {
 	int    i;
@@ -289,7 +275,7 @@ libcfs_lnd2netstrfns(int lnd)
 	return NULL;
 }
 
-struct netstrfns *
+static struct netstrfns *
 libcfs_namenum2netstrfns(const char *name)
 {
 	struct netstrfns *nf;
@@ -304,7 +290,7 @@ libcfs_namenum2netstrfns(const char *name)
 	return NULL;
 }
 
-struct netstrfns *
+static struct netstrfns *
 libcfs_name2netstrfns(const char *name)
 {
 	int    i;
-- 
2.2.1

