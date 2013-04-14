Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3DNQM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:12:57 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35385 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3DNQM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:12:56 -0400
From: Milan Broz <gmazyland@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] algif_skcipher: Avoid crash if buffer is not multiple of cipher block size
Date: Sun, 14 Apr 2013 18:12:32 +0200
Message-Id: <1365955952-12381-1-git-send-email-gmazyland@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When user requests encryption (or decryption) of block which
is not aligned to cipher block size through userspace crypto
interface, an OOps like this can happen:

[  112.738285] BUG: unable to handle kernel paging request at e1c44840
[  112.738407] IP: [<c121f473>] scatterwalk_done+0x53/0x70
...
[  112.740515] Call Trace:
[  112.740588]  [<c1221d30>] blkcipher_walk_done+0x160/0x1e0
[  112.740663]  [<c12220c8>] blkcipher_walk_next+0x318/0x3c0
[  112.740737]  [<c12221e0>] blkcipher_walk_first+0x70/0x160
[  112.740811]  [<c1222327>] blkcipher_walk_virt+0x17/0x20
[  112.740886]  [<e0ce4249>] cbc_encrypt+0x29/0x100 [aesni_intel]
[  112.740968]  [<c1029f73>] ? get_user_pages_fast+0x123/0x150
[  112.741046]  [<c106e7db>] ? trace_hardirqs_on+0xb/0x10
[  112.741119]  [<e081e1c9>] __ablk_encrypt+0x39/0x40 [ablk_helper]
[  112.741198]  [<e081e1ea>] ablk_encrypt+0x1a/0x70 [ablk_helper]
[  112.741275]  [<e0f715ac>] skcipher_recvmsg+0x20c/0x400 [algif_skcipher]
[  112.741359]  [<c1056a1d>] ? sched_clock_cpu+0x11d/0x1a0
[  112.741435]  [<c10a5eb9>] ? find_get_page+0x79/0xc0
[  112.741509]  [<c135e034>] sock_aio_read+0x104/0x140
[  112.741580]  [<c10be638>] ? __do_fault+0x248/0x420
[  112.741650]  [<c10d3d27>] do_sync_read+0x97/0xd0
[  112.741719]  [<c10d45ed>] vfs_read+0x11d/0x140
[  112.741789]  [<c135f683>] ? sys_socketcall+0x2a3/0x320
[  112.741861]  [<c10d4762>] sys_read+0x42/0x90
[  112.742578]  [<c141c27a>] sysenter_do_call+0x12/0x32

Patch fixes it by simply rejecting buffer which is not multiple of cipher block.

(Bug is present in all stable kernels as well.)

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 crypto/algif_skcipher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a6dfc0..5f7713b 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -463,7 +463,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 				used -= used % bs;
 
 			err = -EINVAL;
-			if (!used)
+			if (!used || used % bs)
 				goto free;
 
 			ablkcipher_request_set_crypt(&ctx->req, sg,
-- 
1.7.10.4

