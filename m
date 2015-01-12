Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbbALQBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:01:51 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38096 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbALQBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:01:50 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 1/2] firmware_loader: abort request if wait_for_completion is interrupted
Date: Tue, 13 Jan 2015 00:01:35 +0800
Message-Id: <1421078495-12081-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If current request is interrupted by signal, such as 'ctrl + c',
this request has to be aborted for the following reasons:

	- the buf need to be removed from pending list
	- same requests from other contexts need to be completed

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 58470c3..6bed4ae 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -927,6 +927,13 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 	retval = wait_for_completion_interruptible(&buf->completion);
 
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
+
+	if (retval == -ERESTARTSYS) {
+		mutex_lock(&fw_lock);
+		fw_load_abort(fw_priv);
+		mutex_unlock(&fw_lock);
+	}
+
 	if (is_fw_load_aborted(buf))
 		retval = -EAGAIN;
 	else if (!buf->data)
-- 
1.7.9.5

