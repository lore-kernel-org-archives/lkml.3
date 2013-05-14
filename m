Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab3ENHsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:48:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26716 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab3ENHr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:47:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,668,1363104000"; 
   d="scan'208,223";a="7264469"
Message-ID: <5191EBAE.5080200@cn.fujitsu.com>
Date: Tue, 14 May 2013 15:45:50 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: JBottomley@parallels.com
CC: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] driver/scsi: Use local_time_seconds() to simplify the
 get local timestamp operation
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 15:46:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 15:46:53,
	Serialize complete at 2013/05/14 15:46:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1abbcf9fa5ce6c9a0b005a445c53b9412b42fa83 Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Mon, 13 May 2013 14:58:49 +0900
Subject: [PATCH 2/2] driver/scsi: Use local_time_seconds() to simplify the get local timestamp operation


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/scsi/3w-9xxx.c |   14 ++------------
 drivers/scsi/3w-sas.c  |   14 ++------------
 2 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 5e1e12c..44b3ea8 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -374,8 +374,6 @@ out:
 /* This function will queue an event */
 static void twa_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_Header *header)
 {
-	u32 local_time;
-	struct timeval time;
 	TW_Event *event;
 	unsigned short aen;
 	char host[16];
@@ -398,9 +396,7 @@ static void twa_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_H
 	memset(event, 0, sizeof(TW_Event));
 
 	event->severity = TW_SEV_OUT(header->status_block.severity__reserved);
-	do_gettimeofday(&time);
-	local_time = (u32)(time.tv_sec - (sys_tz.tz_minuteswest * 60));
-	event->time_stamp_sec = local_time;
+	event->time_stamp_sec = local_time_seconds();
 	event->aen_code = aen;
 	event->retrieved = TW_AEN_NOT_RETRIEVED;
 	event->sequence_id = tw_dev->error_sequence_id;
@@ -479,11 +475,9 @@ out:
 static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 {
 	u32 schedulertime;
-	struct timeval utc;
 	TW_Command_Full *full_command_packet;
 	TW_Command *command_packet;
 	TW_Param_Apache *param;
-	u32 local_time;
 
 	/* Fill out the command packet */
 	full_command_packet = tw_dev->command_packet_virt[request_id];
@@ -503,11 +497,7 @@ static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 	param->parameter_id = cpu_to_le16(0x3); /* SchedulerTime */
 	param->parameter_size_bytes = cpu_to_le16(4);
 
-	/* Convert system time in UTC to local time seconds since last 
-           Sunday 12:00AM */
-	do_gettimeofday(&utc);
-	local_time = (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
-	schedulertime = local_time - (3 * 86400);
+	schedulertime = local_time_seconds() - (3 * 86400);
 	schedulertime = cpu_to_le32(schedulertime % 604800);
 
 	memcpy(param->data, &schedulertime, sizeof(u32));
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index c845bdb..69f1d8a 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -236,8 +236,6 @@ out:
 /* This function will queue an event */
 static void twl_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_Header *header)
 {
-	u32 local_time;
-	struct timeval time;
 	TW_Event *event;
 	unsigned short aen;
 	char host[16];
@@ -256,9 +254,7 @@ static void twl_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_H
 	memset(event, 0, sizeof(TW_Event));
 
 	event->severity = TW_SEV_OUT(header->status_block.severity__reserved);
-	do_gettimeofday(&time);
-	local_time = (u32)(time.tv_sec - (sys_tz.tz_minuteswest * 60));
-	event->time_stamp_sec = local_time;
+	event->time_stamp_sec = local_time_seconds();
 	event->aen_code = aen;
 	event->retrieved = TW_AEN_NOT_RETRIEVED;
 	event->sequence_id = tw_dev->error_sequence_id;
@@ -444,11 +440,9 @@ out:
 static void twl_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 {
 	u32 schedulertime;
-	struct timeval utc;
 	TW_Command_Full *full_command_packet;
 	TW_Command *command_packet;
 	TW_Param_Apache *param;
-	u32 local_time;
 
 	/* Fill out the command packet */
 	full_command_packet = tw_dev->command_packet_virt[request_id];
@@ -468,11 +462,7 @@ static void twl_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 	param->parameter_id = cpu_to_le16(0x3); /* SchedulerTime */
 	param->parameter_size_bytes = cpu_to_le16(4);
 
-	/* Convert system time in UTC to local time seconds since last 
-           Sunday 12:00AM */
-	do_gettimeofday(&utc);
-	local_time = (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
-	schedulertime = local_time - (3 * 86400);
+	schedulertime = local_time_seconds() - (3 * 86400);
 	schedulertime = cpu_to_le32(schedulertime % 604800);
 
 	memcpy(param->data, &schedulertime, sizeof(u32));
-- 
1.7.1

