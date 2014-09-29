Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaI2Nct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:32:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:2354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaI2Ncq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:32:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393029917"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 01/18] mei: add hbm and pg state in devstate debugfs print
Date: Mon, 29 Sep 2014 16:31:33 +0300
Message-Id: <1411997510-29094-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
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

