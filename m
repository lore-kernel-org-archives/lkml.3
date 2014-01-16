Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaAPEdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:33:54 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45798 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaAPEdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:33:49 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 12/15] w1: ds2490 fix and enable hardware search
Date: Wed, 15 Jan 2014 22:29:23 -0600
Message-Id: <1389846566-28862-13-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:33:43 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware search was failing without the COMM_RST flag.  Enabled
the flag and rewrote the function to handle more than one buffer of
results and to continuing where the search left off.  Remove hardware
search note from the limitations now that it works.  The "w1: ds2490
USB setup fixes" change went from 23.16 seconds to about 3 seconds,
this takes the time for the search down to .307346 seconds.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 Documentation/w1/masters/ds2490 |    2 -
 drivers/w1/masters/ds2490.c     |  108 +++++++++++++++++++++++++++++++--------
 2 files changed, 86 insertions(+), 24 deletions(-)

diff --git a/Documentation/w1/masters/ds2490 b/Documentation/w1/masters/ds2490
index 28176de..3e09115 100644
--- a/Documentation/w1/masters/ds2490
+++ b/Documentation/w1/masters/ds2490
@@ -21,8 +21,6 @@ Notes and limitations.
 - The weak pullup current is a minimum of 0.9mA and maximum of 6.0mA.
 - The 5V strong pullup is supported with a minimum of 5.9mA and a
   maximum of 30.4 mA.  (From DS2490.pdf)
-- While the ds2490 supports a hardware search the code doesn't take
-  advantage of it (in tested case it only returned first device).
 - The hardware will detect when devices are attached to the bus on the
   next bus (reset?) operation, however only a message is printed as
   the core w1 code doesn't make use of the information.  Connecting
diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index cd59e12..db0bf32 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -698,37 +698,102 @@ static int ds_write_block(struct ds_device *dev, u8 *buf, int len)
 	return !(err == len);
 }
 
-#if 0
-
-static int ds_search(struct ds_device *dev, u64 init, u64 *buf, u8 id_number, int conditional_search)
+static void ds9490r_search(void *data, struct w1_master *master,
+	u8 search_type, w1_slave_found_callback callback)
 {
+	/* When starting with an existing id, the first id returned will
+	 * be that device (if it is still on the bus most likely).
+	 *
+	 * If the number of devices found is less than or equal to the
+	 * search_limit, that number of IDs will be returned.  If there are
+	 * more, search_limit IDs will be returned followed by a non-zero
+	 * discrepency value.
+	 */
+	struct ds_device *dev = data;
 	int err;
 	u16 value, index;
 	struct ds_status st;
+	u8 st_buf[ST_SIZE];
+	int search_limit;
+	int found = 0;
+	int i;
 
-	memset(buf, 0, sizeof(buf));
-
-	err = ds_send_data(ds_dev, (unsigned char *)&init, 8);
-	if (err)
-		return err;
+	/* DS18b20 spec, 13.16 ms per device, 75 per second, sleep for
+	 * discovering 8 devices (1 bulk transfer and 1/2 FIFO size) at a time.
+	 */
+	const unsigned long jtime = msecs_to_jiffies(1000*8/75);
+	/* FIFO 128 bytes, bulk packet size 64, read a multiple of the
+	 * packet size.
+	 */
+	u64 buf[2*64/8];
 
-	ds_wait_status(ds_dev, &st);
+	/* address to start searching at */
+	if (ds_send_data(dev, (u8 *)&master->search_id, 8) < 0)
+		return;
+	master->search_id = 0;
+
+	value = COMM_SEARCH_ACCESS | COMM_IM | COMM_RST | COMM_SM | COMM_F |
+		COMM_RTS;
+	search_limit = master->max_slave_count;
+	if (search_limit > 255)
+		search_limit = 0;
+	index = search_type | (search_limit << 8);
+	if (ds_send_control(dev, value, index) < 0)
+		return;
 
-	value = COMM_SEARCH_ACCESS | COMM_IM | COMM_SM | COMM_F | COMM_RTS;
-	index = (conditional_search ? 0xEC : 0xF0) | (id_number << 8);
-	err = ds_send_control(ds_dev, value, index);
-	if (err)
-		return err;
+	do {
+		schedule_timeout(jtime);
 
-	ds_wait_status(ds_dev, &st);
+		if (ds_recv_status_nodump(dev, &st, st_buf, sizeof(st_buf)) <
+			sizeof(st)) {
+			break;
+		}
 
-	err = ds_recv_data(ds_dev, (unsigned char *)buf, 8*id_number);
-	if (err < 0)
-		return err;
+		if (st.data_in_buffer_status) {
+			/* Bulk in can receive partial ids, but when it does
+			 * they fail crc and will be discarded anyway.
+			 * That has only been seen when status in buffer
+			 * is 0 and bulk is read anyway, so don't read
+			 * bulk without first checking if status says there
+			 * is data to read.
+			 */
+			err = ds_recv_data(dev, (u8 *)buf, sizeof(buf));
+			if (err < 0)
+				break;
+			for (i = 0; i < err/8; ++i) {
+				++found;
+				if (found <= search_limit)
+					callback(master, buf[i]);
+				/* can't know if there will be a discrepancy
+				 * value after until the next id */
+				if (found == search_limit)
+					master->search_id = buf[i];
+			}
+		}
 
-	return err/8;
+		if (test_bit(W1_ABORT_SEARCH, &master->flags))
+			break;
+	} while (!(st.status & (ST_IDLE | ST_HALT)));
+
+	/* only continue the search if some weren't found */
+	if (found <= search_limit) {
+		master->search_id = 0;
+	} else if (!test_bit(W1_WARN_MAX_COUNT, &master->flags)) {
+		/* Only max_slave_count will be scanned in a search,
+		 * but it will start where it left off next search
+		 * until all ids are identified and then it will start
+		 * over.  A continued search will report the previous
+		 * last id as the first id (provided it is still on the
+		 * bus).
+		 */
+		dev_info(&dev->udev->dev, "%s: max_slave_count %d reached, "
+			"will continue next search.\n", __func__,
+			master->max_slave_count);
+		set_bit(W1_WARN_MAX_COUNT, &master->flags);
+	}
 }
 
+#if 0
 static int ds_match_access(struct ds_device *dev, u64 init)
 {
 	int err;
@@ -902,6 +967,7 @@ static int ds_w1_init(struct ds_device *dev)
 	dev->master.write_block	= &ds9490r_write_block;
 	dev->master.reset_bus	= &ds9490r_reset;
 	dev->master.set_pullup	= &ds9490r_set_pullup;
+	dev->master.search	= &ds9490r_search;
 
 	return w1_add_master_device(&dev->master);
 }
@@ -920,13 +986,11 @@ static int ds_probe(struct usb_interface *intf,
 	struct ds_device *dev;
 	int i, err, alt;
 
-	dev = kmalloc(sizeof(struct ds_device), GFP_KERNEL);
+	dev = kzalloc(sizeof(struct ds_device), GFP_KERNEL);
 	if (!dev) {
 		printk(KERN_INFO "Failed to allocate new DS9490R structure.\n");
 		return -ENOMEM;
 	}
-	dev->spu_sleep = 0;
-	dev->spu_bit = 0;
 	dev->udev = usb_get_dev(udev);
 	if (!dev->udev) {
 		err = -ENOMEM;
-- 
1.7.10.4

