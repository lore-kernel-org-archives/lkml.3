Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbbARKzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 05:55:49 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40647 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbbARKzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 05:55:44 -0500
From: jmmahler@gmail.com
X-Google-Original-From: jeri@newt
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH] staging: lustre: fix min() comparison types lacks cast build warning
Date: Sun, 18 Jan 2015 02:54:59 -0800
Message-Id: <1421578499-6192-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes to use the builtin min functions [1] introduced
type checking which wasn't present before.  This resulted in
"comparision of distinct pointer types lacks a cast" build
warnings on non X86 architectures [2,3].

  [1]: https://lkml.org/lkml/2014/12/25/145
  [2]: https://lists.01.org/pipermail/kbuild-all/2015-January/008588.html
  [3]: https://lists.01.org/pipermail/kbuild-all/2015-January/008589.html

The call to min() which resulted in this warning took the result
of kiblnd_rd_frag_size(), which returned a __u32, and the
variable 'resid', which is an int.  'resid' is inside a while
loop which is only entered if it is positive.  Casting it as a
__u32 can be perormed without a loss of data or change in
functionality.

Fix the warning by casting 'resid' as a __u32.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 74df2af..d2e5667 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -1126,7 +1126,8 @@ kiblnd_init_rdma (kib_conn_t *conn, kib_tx_t *tx, int type,
 		}
 
 		wrknob = min(min(kiblnd_rd_frag_size(srcrd, srcidx),
-				 kiblnd_rd_frag_size(dstrd, dstidx)), resid);
+				 kiblnd_rd_frag_size(dstrd, dstidx)),
+			     (__u32) resid);
 
 		sge = &tx->tx_sge[tx->tx_nwrq];
 		sge->addr   = kiblnd_rd_frag_addr(srcrd, srcidx);
-- 
2.1.4

