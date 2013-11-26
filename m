Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3KZCFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:05:50 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58582 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3KZCFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:05:45 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Mikhail Pershin <tappro@whamcloud.com>,
        Mikhail Pershin <mike.pershin@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 01/16] staging/lustre/server: use unified request handler for MGS
Date: Tue, 26 Nov 2013 10:04:55 +0800
Message-Id: <1385431510-18988-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Pershin <tappro@whamcloud.com>

- Unify request handler. It finds target for particular request and
  calls appropriate handler for it. Generic handlers are moved to
  the unified target code. The tgt_session_info is introduced to
  store all request-related data and passed to all handlers.
- Pack reply in llog server functions early and use err_serious()
- remove obsoleted llog_origin_handle_cancel(), it is not used
  anymore
- remove push_ctxt/pop_ctxt from llog server function, it is based
  on OSD now.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2145
Lustre-change: http://review.whamcloud.com/4826
Signed-off-by: Mikhail Pershin <mike.pershin@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre_req_layout.h      |    2 ++
 .../staging/lustre/lustre/include/obd_support.h    |    7 +++++++
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |    7 ++++++-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |    4 ++--
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_req_layout.h b/drivers/staging/lustre/lustre/include/lustre_req_layout.h
index f4d3820..2832569 100644
--- a/drivers/staging/lustre/lustre/include/lustre_req_layout.h
+++ b/drivers/staging/lustre/lustre/include/lustre_req_layout.h
@@ -245,6 +245,8 @@ extern struct req_format RQF_LLOG_ORIGIN_HANDLE_PREV_BLOCK;
 extern struct req_format RQF_LLOG_ORIGIN_HANDLE_READ_HEADER;
 extern struct req_format RQF_LLOG_ORIGIN_CONNECT;
 
+extern struct req_format RQF_CONNECT;
+
 extern struct req_msg_field RMF_GENERIC_DATA;
 extern struct req_msg_field RMF_PTLRPC_BODY;
 extern struct req_msg_field RMF_MDT_BODY;
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 9697e7f..825a0c9 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -416,6 +416,13 @@ int obd_alloc_fail(const void *ptr, const char *name, const char *type,
 #define OBD_FAIL_MGC_PAUSE_PROCESS_LOG   0x903
 #define OBD_FAIL_MGS_PAUSE_REQ	   0x904
 #define OBD_FAIL_MGS_PAUSE_TARGET_REG    0x905
+#define OBD_FAIL_MGS_CONNECT_NET	 0x906
+#define OBD_FAIL_MGS_DISCONNECT_NET	 0x907
+#define OBD_FAIL_MGS_SET_INFO_NET	 0x908
+#define OBD_FAIL_MGS_EXCEPTION_NET	 0x909
+#define OBD_FAIL_MGS_TARGET_REG_NET	 0x90a
+#define OBD_FAIL_MGS_TARGET_DEL_NET	 0x90b
+#define OBD_FAIL_MGS_CONFIG_READ_NET	 0x90c
 
 #define OBD_FAIL_QUOTA_DQACQ_NET			0xA01
 #define OBD_FAIL_QUOTA_EDQUOT	    0xA02
diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 504682d..4d6ac686 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -738,7 +738,8 @@ static struct req_format *req_formats[] = {
 	&RQF_LLOG_ORIGIN_HANDLE_NEXT_BLOCK,
 	&RQF_LLOG_ORIGIN_HANDLE_PREV_BLOCK,
 	&RQF_LLOG_ORIGIN_HANDLE_READ_HEADER,
-	&RQF_LLOG_ORIGIN_CONNECT
+	&RQF_LLOG_ORIGIN_CONNECT,
+	&RQF_CONNECT,
 };
 
 struct req_msg_field {
@@ -1504,6 +1505,10 @@ struct req_format RQF_LLOG_ORIGIN_CONNECT =
 	DEFINE_REQ_FMT0("LLOG_ORIGIN_CONNECT", llogd_conn_body_only, empty);
 EXPORT_SYMBOL(RQF_LLOG_ORIGIN_CONNECT);
 
+struct req_format RQF_CONNECT =
+	DEFINE_REQ_FMT0("CONNECT", obd_connect_client, obd_connect_server);
+EXPORT_SYMBOL(RQF_CONNECT);
+
 struct req_format RQF_OST_CONNECT =
 	DEFINE_REQ_FMT0("OST_CONNECT",
 			obd_connect_client, obd_connect_server);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 65451f7..1be9786 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -114,10 +114,10 @@ struct ll_rpc_opcode {
 	{ MGS_SET_INFO,     "mgs_set_info" },
 	{ MGS_CONFIG_READ,  "mgs_config_read" },
 	{ OBD_PING,	 "obd_ping" },
-	{ OBD_LOG_CANCEL,   "llog_origin_handle_cancel" },
+	{ OBD_LOG_CANCEL,	"llog_cancel" },
 	{ OBD_QC_CALLBACK,  "obd_quota_callback" },
 	{ OBD_IDX_READ,	    "dt_index_read" },
-	{ LLOG_ORIGIN_HANDLE_CREATE,     "llog_origin_handle_create" },
+	{ LLOG_ORIGIN_HANDLE_CREATE,	 "llog_origin_handle_open" },
 	{ LLOG_ORIGIN_HANDLE_NEXT_BLOCK, "llog_origin_handle_next_block" },
 	{ LLOG_ORIGIN_HANDLE_READ_HEADER,"llog_origin_handle_read_header" },
 	{ LLOG_ORIGIN_HANDLE_WRITE_REC,  "llog_origin_handle_write_rec" },
-- 
1.7.9.5

