Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbaGNViv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:38:51 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57227 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249AbaGNVih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:38:37 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] firmware_class: extract start loading logic
Date: Mon, 14 Jul 2014 14:38:15 -0700
Message-Id: <1405373897-31671-6-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405373897-31671-1-git-send-email-keescook@chromium.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the logic performed when starting a new firmware load.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/base/firmware_class.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7399bab71ced..b38cbcd6ebb1 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -604,6 +604,23 @@ static int fw_map_pages_buf(struct firmware_buf *buf)
 	return 0;
 }
 
+/* fw_lock must be held */
+static void fw_load_start(struct firmware_buf *fw_buf)
+{
+	/* discarding any previous partial load */
+	if (!test_bit(FW_STATUS_DONE, &fw_buf->status)) {
+		int i;
+
+		for (i = 0; i < fw_buf->nr_pages; i++)
+			__free_page(fw_buf->pages[i]);
+		kfree(fw_buf->pages);
+		fw_buf->pages = NULL;
+		fw_buf->page_array_size = 0;
+		fw_buf->nr_pages = 0;
+		set_bit(FW_STATUS_LOADING, &fw_buf->status);
+	}
+}
+
 /**
  * firmware_loading_store - set value in the 'loading' control file
  * @dev: device pointer
@@ -624,7 +641,6 @@ static ssize_t firmware_loading_store(struct device *dev,
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	struct firmware_buf *fw_buf;
 	int loading = simple_strtol(buf, NULL, 10);
-	int i;
 
 	mutex_lock(&fw_lock);
 	fw_buf = fw_priv->buf;
@@ -633,16 +649,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 
 	switch (loading) {
 	case 1:
-		/* discarding any previous partial load */
-		if (!test_bit(FW_STATUS_DONE, &fw_buf->status)) {
-			for (i = 0; i < fw_buf->nr_pages; i++)
-				__free_page(fw_buf->pages[i]);
-			kfree(fw_buf->pages);
-			fw_buf->pages = NULL;
-			fw_buf->page_array_size = 0;
-			fw_buf->nr_pages = 0;
-			set_bit(FW_STATUS_LOADING, &fw_buf->status);
-		}
+		fw_load_start(fw_buf);
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
-- 
1.7.9.5

