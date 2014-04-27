Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaD0RHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:07:44 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47950 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaD0RHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:40 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Hongchao Zhang <hongchao.zhang@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 05/47] staging/lustre/osc: don't activate deactivated obd_import
Date: Sun, 27 Apr 2014 13:06:29 -0400
Message-Id: <1398618431-29757-6-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongchao Zhang <hongchao.zhang@intel.com>

In ptlrpc_activate_import(), obd_import->imp_deactive should
be checked if it is deactivated, otherwise it will trigger an
LBUG in ptlrpc_invalidate_import():

  ptlrpc_invalidate_import() ASSERTION(imp->imp_invalid) failed

Signed-off-by: Hongchao Zhang <hongchao.zhang@intel.com>
Reviewed-on: http://review.whamcloud.com/8747
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4386
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/import.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 537aa62..a04a1cc 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -381,6 +381,11 @@ void ptlrpc_activate_import(struct obd_import *imp)
 	struct obd_device *obd = imp->imp_obd;
 
 	spin_lock(&imp->imp_lock);
+	if (imp->imp_deactive != 0) {
+		spin_unlock(&imp->imp_lock);
+		return;
+	}
+
 	imp->imp_invalid = 0;
 	spin_unlock(&imp->imp_lock);
 	obd_import_event(obd, imp, IMP_EVENT_ACTIVE);
-- 
1.8.5.3

