Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3LCWRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:17:04 -0500
Received: from smtprelay0026.hostedemail.com ([216.40.44.26]:59959 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754851Ab3LCWQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:16:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:4250:4321:4605:5007:6119:7652:7903:7904:10004:10400:10848:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:12740:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nut00_279016fcff4c
X-Filterd-Recvd-Size: 4725
Message-ID: <1386109016.30493.25.camel@joe-AO722>
Subject: [PATCH -next] vsprintf: add %pad extension for dma_addr_t use
From: Joe Perches <joe@perches.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Tue, 03 Dec 2013 14:16:56 -0800
In-Reply-To: <1385975297.1871.39.camel@smile>
References: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1385663555.12210.19.camel@joe-AO722> <1385729760.1871.23.camel@smile>
	 <1385763040.12210.34.camel@joe-AO722> <1385975219.1871.38.camel@smile>
	 <1385975297.1871.39.camel@smile>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_addr_t's can be either u32 or u64 depending
on a CONFIG option.

There are a few hundred dma_addr_t's printed via
either cast to unsigned long long, unsigned long
or no cast at all.

Add %pad to be able to emit them without the cast.

Update Documentation/printk-formats.txt too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/printk-formats.txt | 11 +++++++++--
 lib/vsprintf.c                   | 33 +++++++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 445ad74..6f4eb32 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -55,14 +55,21 @@ Struct Resources:
 	For printing struct resources. The 'R' and 'r' specifiers result in a
 	printed resource with ('R') or without ('r') a decoded flags member.
 
-Physical addresses:
+Physical addresses types phys_addr_t:
 
-	%pa	0x01234567 or 0x0123456789abcdef
+	%pa[p]	0x01234567 or 0x0123456789abcdef
 
 	For printing a phys_addr_t type (and its derivatives, such as
 	resource_size_t) which can vary based on build options, regardless of
 	the width of the CPU data path. Passed by reference.
 
+DMA addresses types dma_addr_t:
+
+	%pad	0x01234567 or 0x0123456789abcdef
+
+	For printing a dma_addr_t type which can vary based on build options,
+	regardless of the width of the CPU data path. Passed by reference.
+
 Raw buffer as a hex string:
 	%*ph	00 01 02  ...  3f
 	%*phC	00:01:02: ... :3f
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 10909c5..185b6d3 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1155,6 +1155,30 @@ char *netdev_feature_string(char *buf, char *end, const u8 *addr,
 	return number(buf, end, *(const netdev_features_t *)addr, spec);
 }
 
+static noinline_for_stack
+char *address_val(char *buf, char *end, const void *addr,
+		  struct printf_spec spec, const char *fmt)
+{
+	unsigned long long num;
+
+	spec.flags |= SPECIAL | SMALL | ZEROPAD;
+	spec.base = 16;
+
+	switch (fmt[1]) {
+	case 'd':
+		num = *(const dma_addr_t *)addr;
+		spec.field_width = sizeof(dma_addr_t) * 2 + 2;
+		break;
+	case 'p':
+	default:
+		num = *(const phys_addr_t *)addr;
+		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
+		break;
+	}
+
+	return number(buf, end, num, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1218,7 +1242,8 @@ int kptr_restrict __read_mostly;
  *              N no separator
  *            The maximum supported length is 64 bytes of the input. Consider
  *            to use print_hex_dump() for the larger input.
- * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
+ * - 'a[pd]' For address types [p] phys_addr_t, [d] dma_addr_t and derivatives
+ *           (default assumed to be phys_addr_t, passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
  *
@@ -1353,11 +1378,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		}
 		break;
 	case 'a':
-		spec.flags |= SPECIAL | SMALL | ZEROPAD;
-		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
-		spec.base = 16;
-		return number(buf, end,
-			      (unsigned long long) *((phys_addr_t *)ptr), spec);
+		return address_val(buf, end, ptr, spec, fmt);
 	case 'd':
 		return dentry_name(buf, end, ptr, spec, fmt);
 	case 'D':


