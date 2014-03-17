Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbaCQPAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:00:40 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:56506 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933163AbaCQPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:00:36 -0400
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: i4passt@lists.cs.fau.de, neilb@suse.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthias Oefelein <ma.oefelein@arcor.de>
Subject: [PATCH 1/2] md: Add configurability for consistency check feature
Date: Mon, 17 Mar 2014 16:00:04 +0100
Message-Id: <1395068405-13860-2-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395068405-13860-1-git-send-email-linux-kernel@rmueck.de>
References: <1395068405-13860-1-git-send-email-linux-kernel@rmueck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sysfs configurability for the md level-1 RAID
consistency check.
The feature introduces a new attribute in sysfs named "safe_read".
To toggle consistency checks on/off, simply echo safe_read in
/sys/block/md*/md/safe_read.

Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>

---
 drivers/md/md.c | 27 +++++++++++++++++++++++++++
 drivers/md/md.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4ad5cc4..5cc9a00 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4652,6 +4652,32 @@ static struct md_sysfs_entry md_array_size =
 __ATTR(array_size, S_IRUGO|S_IWUSR, array_size_show,
        array_size_store);
 
+static ssize_t
+safe_read_show(struct mddev *mddev, char *page)
+{
+	if(mddev->safe_read)
+		return sprintf(page, "enabled\n");
+	else
+		return sprintf(page, "disabled\n");
+}
+
+static ssize_t
+safe_read_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	if(mddev->pers->level != 1) {
+		printk(KERN_NOTICE "RAID level not supported!\n");
+		return len;
+	}
+	if (strncmp(buf, "safe_read", 9) == 0) {
+		mddev->safe_read = !mddev->safe_read;
+	}
+	return len;
+}
+
+static struct md_sysfs_entry md_safe_read =
+__ATTR(safe_read, S_IRUGO|S_IWUSR, safe_read_show,
+       safe_read_store);
+
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_layout.attr,
@@ -4667,6 +4693,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_reshape_direction.attr,
 	&md_array_size.attr,
 	&max_corr_read_errors.attr,
+	&md_safe_read.attr,
 	NULL,
 };
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 07bba96..7e59cf1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -346,6 +346,9 @@ struct mddev {
 	 */
 	int				recovery_disabled;
 
+	/* Set to 1 if the user desires a safe read (check for bitrot) */
+	int				safe_read;
+
 	int				in_sync;	/* know to not need resync */
 	/* 'open_mutex' avoids races between 'md_open' and 'do_md_stop', so
 	 * that we are never stopping an array while it is open.
-- 
1.8.3.2

