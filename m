Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaFMRTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:19:18 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57465 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753308AbaFMRTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:19:16 -0400
Date: Fri, 13 Jun 2014 18:19:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] "bio_vec-backed iov_iter" breaks gcc 4.6.4
Message-ID: <20140613171910.GT23430@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 62a8067a7f35dba2de501c9cb00e4cf36da90bc0 has broken the build
with gcc 4.6.4:

diff --git a/include/linux/uio.h b/include/linux/uio.h
 struct iov_iter {
...
+       union {
+               const struct iovec *iov;
+               const struct bio_vec *bvec;
+       };
...
diff --git a/mm/page_io.c b/mm/page_io.c
...
+               struct iov_iter from = {
...
+                       .bvec = &bv

mm/page_io.c: In function '__swap_writepage':
mm/page_io.c:277:4: error: unknown field 'bvec' specified in initializer
mm/page_io.c:278:3: warning: excess elements in struct initializer
mm/page_io.c:278:3: warning: (near initialization for 'from')
make[2]: *** [mm/page_io.o] Error 1

The problem here is that only relatively recent gcc's are able to deal
with anonymous union/struct initialisers.

Documentation wise, we're telling people that the minimum version of GCC
required to build the kernel is:

o  Gnu C                  3.2                     # gcc --version

The patch below fixes it for me - but it's not ideal because the only
reason it works is that we have the initialisers in the same order as
the structure.

Any suggestions?

 mm/page_io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 243a9b76e5ce..e9a2a0aca8ea 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -271,10 +271,12 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		};
 		struct iov_iter from = {
 			.type = ITER_BVEC | WRITE,
-			.count = PAGE_SIZE,
 			.iov_offset = 0,
+			.count = PAGE_SIZE,
+			{
+				.bvec = &bv
+			},
 			.nr_segs = 1,
-			.bvec = &bv
 		};
 
 		init_sync_kiocb(&kiocb, swap_file);


-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
