Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbaHYVya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:54:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:11405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933438AbaHYVy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,398,1406617200"; 
   d="scan'208";a="563299589"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 03/10] mei: add hbm and pg state in devstate debugfs print
Date: Tue, 26 Aug 2014 00:53:21 +0300
Message-Id: <1409003608-30274-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
References: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add hbm state, pg enablement and state to devstate file in debugfs
(<debugfs>/mei/devstate)

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/debugfs.c |  7 ++++++-
 drivers/misc/mei/hbm.c     | 16 ++++++++++++++++
 drivers/misc/mei/hbm.h     |  2 ++
 drivers/misc/mei/init.c    | 12 ++++++++++++
 drivers/misc/mei/mei_dev.h |  2 ++
 5 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index 3b03288..2399b31 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -134,8 +134,13 @@ static ssize_t mei_dbgfs_read_devstate(struct file *fp, char __user *ubuf,
 	if  (!buf)
 		return -ENOMEM;
 
-	pos += scnprintf(buf + pos, bufsz - pos, "%s\n",
+	pos += scnprintf(buf + pos, bufsz - pos, "dev: %s\n",
 			mei_dev_state_str(dev->dev_state));
+	pos += scnprintf(buf + pos, bufsz - pos, "hbm: %s\n",
+			mei_hbm_state_str(dev->hbm_state));
+	pos += scnprintf(buf + pos, bufsz - pos, "pg:  %s, %s\n",
+			mei_pg_is_enabled(dev) ? "ENABLED" : "DISABLED",
+			mei_pg_state_str(mei_pg_state(dev)));
 	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, pos);
 	kfree(buf);
 	return ret;
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 9fc051b..3311b5c 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -56,6 +56,22 @@ static const char *mei_cl_conn_status_str(enum mei_cl_connect_status status)
 #undef MEI_CL_CCS
 }
 
+const char *mei_hbm_state_str(enum mei_hbm_state state)
+{
+#define MEI_HBM_STATE(state) case MEI_HBM_##state: return #state
+	switch (state) {
+	MEI_HBM_STATE(IDLE);
+	MEI_HBM_STATE(STARTING);
+	MEI_HBM_STATE(STARTED);
+	MEI_HBM_STATE(ENUM_CLIENTS);
+	MEI_HBM_STATE(CLIENT_PROPERTIES);
+	MEI_HBM_STATE(STOPPED);
+	default:
+		return "unknown";
+	}
+#undef MEI_HBM_STATE
+}
+
 /**
  * mei_cl_conn_status_to_errno - convert client connect response
  * status to error code
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index 80920f0..efcb0d4 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -40,6 +40,8 @@ enum mei_hbm_state {
 	MEI_HBM_STOPPED,
 };
 
+const char *mei_hbm_state_str(enum mei_hbm_state state);
+
 int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr);
 
 static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 9f635be..81695e4 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -43,6 +43,18 @@ const char *mei_dev_state_str(int state)
 #undef MEI_DEV_STATE
 }
 
+const char *mei_pg_state_str(enum mei_pg_state state)
+{
+#define MEI_PG_STATE(state) case MEI_PG_##state: return #state
+	switch (state) {
+	MEI_PG_STATE(OFF);
+	MEI_PG_STATE(ON);
+	default:
+		return "unknown";
+	}
+#undef MEI_PG_STATE
+}
+
 
 /**
  * mei_cancel_work. Cancel mei background jobs
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 719edee..be7b147 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -375,6 +375,8 @@ enum mei_pg_state {
 	MEI_PG_ON =  1,
 };
 
+const char *mei_pg_state_str(enum mei_pg_state state);
+
 /*
  * mei_cfg
  *
-- 
1.9.3

