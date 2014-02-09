Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaBIHw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 02:52:29 -0500
Received: from linuxhacker.ru ([217.76.32.60]:37350 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaBIHwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 02:52:25 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: yang sheng <yang.sheng@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 3/5] lustre: instantiate negative dentry
Date: Sun,  9 Feb 2014 02:51:47 -0500
Message-Id: <1391932309-6009-4-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391932309-6009-1-git-send-email-green@linuxhacker.ru>
References: <1391932309-6009-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: yang sheng <yang.sheng@intel.com>

In the atomic_open callback. We should instantiate
negative dentry. Else will got sanity:183 failed.

Signed-off-by: yang sheng <yang.sheng@intel.com>
Reviewed-on: http://review.whamcloud.com/8110
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3228
Reviewed-by: Peng Tao <bergwolf@gmail.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/namei.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 8938d37..93c3744 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -468,6 +468,12 @@ int ll_lookup_it_finish(struct ptlrpc_request *request,
 		if (IS_ERR(alias))
 			return PTR_ERR(alias);
 		*de = alias;
+	} else if (!it_disposition(it, DISP_LOOKUP_NEG)  &&
+		   !it_disposition(it, DISP_OPEN_CREATE)) {
+		/* With DISP_OPEN_CREATE dentry will
+		   instantiated in ll_create_it. */
+		LASSERT((*de)->d_inode == NULL);
+		d_instantiate(*de, inode);
 	}
 
 	if (!it_disposition(it, DISP_LOOKUP_NEG)) {
-- 
1.8.5.3

