Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3LBS7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:59:36 -0500
Received: from mout.gmx.net ([212.227.17.20]:60963 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab3LBS7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:59:35 -0500
Date: Mon, 2 Dec 2013 19:59:31 +0100
From: Helge Deller <deller@gmx.de>
To: linux-nfs@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH] nfs: fix do_div() warning by instead using sector_div()
Message-ID: <20131202185931.GA1992@ls3530.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:2w84FELOJ06Ui5FIColeSHt0NgjmHCKIIkCbBzy8WTsjjBBNEl2
 U1/r9ZptM8qgRMdgfH+8e515Fd7Rw3K39q5T4Sq7IXkK03EyWr+PUCQ/QvHNjU40yukPq6x
 a1SV1pg+DZJAZMfxJSI0OjPkeso0EYVI4JGiFXcKwsBEFf1LOwVAhDJiIS0/Lchec9LNnfJ
 xFXlFbyEPNJwjtg0/J6Iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/fs/nfs/blocklayout/extents.c b/fs/nfs/blocklayout/extents.c
index 9c3e117..4d01614 100644
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
