Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab3GOO1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:27:52 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47228 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3GOO1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:27:49 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 04/17] staging/lustre: don't assert ln_refcount in LNetGetId
Date: Mon, 15 Jul 2013 22:27:07 +0800
Message-Id: <1373898440-14208-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If LNetNIInit() fails, we'll get zero ln_refcount. So fail
LNetGetId() properly instead of asserting.

We can get to it when socklnd fails to scan network interfaces,
which is possible if Lustre is builtin.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/lnet/api-ni.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index e88bee3..250c618 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -1541,7 +1541,10 @@ LNetGetId(unsigned int index, lnet_process_id_t *id)
 	int		rc = -ENOENT;
 
 	LASSERT(the_lnet.ln_init);
-	LASSERT(the_lnet.ln_refcount > 0);
+
+	/* LNetNI initilization failed? */
+	if (the_lnet.ln_refcount == 0)
+		return rc;
 
 	cpt = lnet_net_lock_current();
 
-- 
1.7.9.5

