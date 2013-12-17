Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3LQS2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:28:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab3LQSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 064/103] nfs: fix do_div() warning by instead using sector_div()
Date: Tue, 17 Dec 2013 18:12:53 +0000
Message-Id: <1387304012-23805-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/blocklayout/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/blocklayout/extents.c b/fs/nfs/blocklayout/extents.c
index 1f9a603..51f9ff2 100644
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
-- 
1.8.3.2

