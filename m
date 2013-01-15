Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3AOWr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:47:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:45186 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab3AOWrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:47:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sasha Levin <sasha.levin@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 019/171] SCSI: prevent stack buffer overflow in host_reset
Date: Tue, 15 Jan 2013 14:43:04 -0800
Message-Id: <20130115224314.795442089@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 072f19b4bea31cdd482d79f805413f2f9ac9e233 upstream.

store_host_reset() has tried to re-invent the wheel to compare sysfs strings.
Unfortunately it did so poorly and never bothered to check the input from
userspace before overwriting stack with it, so something simple as:

echo "WoopsieWoopsie" >
/sys/devices/pseudo_0/adapter0/host0/scsi_host/host0/host_reset

would result in:

[  316.310101] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff81f5bac7
[  316.310101]
[  316.320051] Pid: 6655, comm: sh Tainted: G        W    3.7.0-rc5-next-20121114-sasha-00016-g5c9d68d-dirty #129
[  316.320051] Call Trace:
[  316.340058] pps pps0: PPS event at 1352918752.620355751
[  316.340062] pps pps0: capture assert seq #303
[  316.320051]  [<ffffffff83b3856b>] panic+0xcd/0x1f4
[  316.320051]  [<ffffffff81f5bac7>] ? store_host_reset+0xd7/0x100
[  316.320051]  [<ffffffff8110b996>] __stack_chk_fail+0x16/0x20
[  316.320051]  [<ffffffff81f5bac7>] store_host_reset+0xd7/0x100
[  316.320051]  [<ffffffff81e55bb3>] dev_attr_store+0x13/0x30
[  316.320051]  [<ffffffff812f7db1>] sysfs_write_file+0x101/0x170
[  316.320051]  [<ffffffff8127acc8>] vfs_write+0xb8/0x180
[  316.320051]  [<ffffffff8127ae80>] sys_write+0x50/0xa0
[  316.320051]  [<ffffffff83c03418>] tracesys+0xe1/0xe6

Fix this by uninventing whatever was going on there and just use sysfs_streq.

Bug introduced by 29443691 ("[SCSI] scsi: Added support for adapter and
firmware reset").

[jejb: added necessary const to prevent compile warnings]
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_sysfs.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -246,11 +246,11 @@ show_shost_active_mode(struct device *de
 
 static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
 
-static int check_reset_type(char *str)
+static int check_reset_type(const char *str)
 {
-	if (strncmp(str, "adapter", 10) == 0)
+	if (sysfs_streq(str, "adapter"))
 		return SCSI_ADAPTER_RESET;
-	else if (strncmp(str, "firmware", 10) == 0)
+	else if (sysfs_streq(str, "firmware"))
 		return SCSI_FIRMWARE_RESET;
 	else
 		return 0;
@@ -263,12 +263,9 @@ store_host_reset(struct device *dev, str
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct scsi_host_template *sht = shost->hostt;
 	int ret = -EINVAL;
-	char str[10];
 	int type;
 
-	sscanf(buf, "%s", str);
-	type = check_reset_type(str);
-
+	type = check_reset_type(buf);
 	if (!type)
 		goto exit_store_host_reset;
 


