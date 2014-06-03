Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbaFCWWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:22:48 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:35426 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbaFCWWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:22:47 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rashika Kheria <rashika.kheria@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: tidspbridge: pmgr: dspapi.c:  Cleaning up uninitialized variable
Date: Wed,  4 Jun 2014 00:23:39 +0200
Message-Id: <1401834219-30682-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variables will be used without being initialized.
Has also improved error handling, after an email proposal from Dan Carpenter.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/tidspbridge/pmgr/dspapi.c |   64 ++++++++++++++---------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index b7d5c8c..c4ccf17 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -340,23 +340,23 @@ int api_init_complete2(void)
 u32 mgrwrap_enum_node_info(union trapped_args *args, void *pr_ctxt)
 {
 	u8 *pndb_props;
-	u32 num_nodes;
-	int status = 0;
+	u32 num_nodes = 0;
+	int status;
 	u32 size = args->args_mgr_enumnode_info.ndb_props_size;
 
 	if (size < sizeof(struct dsp_ndbprops))
 		return -EINVAL;
+	size = sizeof(struct dsp_ndbprops);
 
 	pndb_props = kmalloc(size, GFP_KERNEL);
 	if (pndb_props == NULL)
-		status = -ENOMEM;
+		return -ENOMEM;
+
+	status =
+	    mgr_enum_node_info(args->args_mgr_enumnode_info.node_id,
+			       (struct dsp_ndbprops *)pndb_props, size,
+			       &num_nodes);
 
-	if (!status) {
-		status =
-		    mgr_enum_node_info(args->args_mgr_enumnode_info.node_id,
-				       (struct dsp_ndbprops *)pndb_props, size,
-				       &num_nodes);
-	}
 	CP_TO_USR(args->args_mgr_enumnode_info.ndb_props, pndb_props, status,
 		  size);
 	CP_TO_USR(args->args_mgr_enumnode_info.num_nodes, &num_nodes, status,
@@ -372,24 +372,26 @@ u32 mgrwrap_enum_node_info(union trapped_args *args, void *pr_ctxt)
 u32 mgrwrap_enum_proc_info(union trapped_args *args, void *pr_ctxt)
 {
 	u8 *processor_info;
-	u8 num_procs;
-	int status = 0;
+	u8 num_procs = 0;
+	int status;
 	u32 size = args->args_mgr_enumproc_info.processor_info_size;
 
 	if (size < sizeof(struct dsp_processorinfo))
 		return -EINVAL;
 
-	processor_info = kmalloc(size, GFP_KERNEL);
+	if (size > sizeof(struct mgr_processorextinfo))
+		size = sizeof(struct mgr_processorextinfo);
+
+	processor_info = kzalloc(size, GFP_KERNEL);
 	if (processor_info == NULL)
-		status = -ENOMEM;
+		return -ENOMEM;
+
+	status =
+	    mgr_enum_processor_info(args->args_mgr_enumproc_info.
+				    processor_id,
+				    (struct dsp_processorinfo *)
+				    processor_info, size, &num_procs);
 
-	if (!status) {
-		status =
-		    mgr_enum_processor_info(args->args_mgr_enumproc_info.
-					    processor_id,
-					    (struct dsp_processorinfo *)
-					    processor_info, size, &num_procs);
-	}
 	CP_TO_USR(args->args_mgr_enumproc_info.processor_info, processor_info,
 		  status, size);
 	CP_TO_USR(args->args_mgr_enumproc_info.num_procs, &num_procs,
@@ -475,11 +477,11 @@ u32 mgrwrap_wait_for_bridge_events(union trapped_args *args, void *pr_ctxt)
 	int status = 0;
 	struct dsp_notification *anotifications[MAX_EVENTS];
 	struct dsp_notification notifications[MAX_EVENTS];
-	u32 index, i;
+	u32 index = 0, i;
 	u32 count = args->args_mgr_wait.count;
 
 	if (count > MAX_EVENTS)
-		status = -EINVAL;
+		return -EINVAL;
 
 	/* get the array of pointers to user structures */
 	CP_FM_USR(anotifications, args->args_mgr_wait.anotifications,
@@ -487,19 +489,15 @@ u32 mgrwrap_wait_for_bridge_events(union trapped_args *args, void *pr_ctxt)
 	/* get the events */
 	for (i = 0; i < count; i++) {
 		CP_FM_USR(&notifications[i], anotifications[i], status, 1);
-		if (status || !notifications[i].handle) {
-			status = -EINVAL;
-			break;
-		}
+		if (status || !notifications[i].handle)
+			return -EINVAL;
 		/* set the array of pointers to kernel structures */
 		anotifications[i] = &notifications[i];
 	}
-	if (!status) {
-		status = mgr_wait_for_bridge_events(anotifications, count,
-							 &index,
-							 args->args_mgr_wait.
-							 timeout);
-	}
+	status = mgr_wait_for_bridge_events(anotifications, count,
+						 &index,
+						 args->args_mgr_wait.
+						 timeout);
 	CP_TO_USR(args->args_mgr_wait.index, &index, status, 1);
 	return status;
 }
@@ -1755,7 +1753,7 @@ u32 strmwrap_register_notify(union trapped_args *args, void *pr_ctxt)
  */
 u32 strmwrap_select(union trapped_args *args, void *pr_ctxt)
 {
-	u32 mask;
+	u32 mask = 0;
 	struct strm_object *strm_tab[MAX_STREAMS];
 	int status = 0;
 	struct strm_res_object *strm_res;
-- 
1.7.10.4

