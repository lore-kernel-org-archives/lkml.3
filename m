Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaC3XgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:36:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36474 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Helge Deller" <deller@gmx.de>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.932897957@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 179/200] nfs: fix do_div() warning by instead using
 sector_div()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 3873d064b8538686bbbd4b858dc8a07db1f7f43a upstream.

When compiling a 32bit kernel with CONFIG_LBDAF=n the compiler complains like
shown below.  Fix this warning by instead using sector_div() which is provided
by the kernel.h header file.

fs/nfs/blocklayout/extents.c: In function ‘normalize’:
include/asm-generic/div64.h:43:28: warning: comparison of distinct pointer types lacks a cast [enabled by default]
fs/nfs/blocklayout/extents.c:47:13: note: in expansion of macro ‘do_div’
nfs/blocklayout/extents.c:47:2: warning: right shift count >= width of type [enabled by default]
fs/nfs/blocklayout/extents.c:47:2: warning: passing argument 1 of ‘__div64_32’ from incompatible pointer type [enabled by default]
include/asm-generic/div64.h:35:17: note: expected ‘uint64_t *’ but argument is of type ‘sector_t *’
extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/nfs/blocklayout/extents.c
+++ b/fs/nfs/blocklayout/extents.c
@@ -44,7 +44,7 @@
 static inline sector_t normalize(sector_t s, int base)
 {
 	sector_t tmp = s; /* Since do_div modifies its argument */
-	return s - do_div(tmp, base);
+	return s - sector_div(tmp, base);
 }
 
 static inline sector_t normalize_up(sector_t s, int base)

