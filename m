Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaEHLNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:13:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48093 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaEHLNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:13:30 -0400
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Subject: [PATCH v2] staging: lirc: Fix sparse warnings
Date: Thu,  8 May 2014 14:13:17 +0300
Message-Id: <1399547597-4006-1-git-send-email-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warnings by adding __user and __iomem annotations where
necessary and removing certain unnecessary casts. While at it,
also use u32 in place of __u32.

Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
---
 Compile tested only.
 v2 changes:
   - introduce variable 'uptr' instead of open-coding (__u32 *)arg everywhere
   - replaces __u32 with u32
   - passes checkpatch --strict
 drivers/staging/media/lirc/lirc_bt829.c    |    6 ++---
 drivers/staging/media/lirc/lirc_parallel.c |   26 ++++++++++++----------
 drivers/staging/media/lirc/lirc_serial.c   |   11 +++++-----
 drivers/staging/media/lirc/lirc_sir.c      |   33 ++++++++++++++--------------
 drivers/staging/media/lirc/lirc_zilog.c    |   23 +++++++++----------
 5 files changed, 52 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/media/lirc/lirc_bt829.c
index 30edc74..fe01054 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -64,7 +64,7 @@ static bool debug;
 
 static int atir_minor;
 static phys_addr_t pci_addr_phys;
-static unsigned char *pci_addr_lin;
+static unsigned char __iomem *pci_addr_lin;
 
 static struct lirc_driver atir_driver;
 
@@ -382,7 +382,7 @@ static unsigned char do_get_bits(void)
 
 static unsigned int read_index(unsigned char index)
 {
-	unsigned char *addr;
+	unsigned char __iomem *addr;
 	unsigned int value;
 	/*  addr = pci_addr_lin + DATA_PCI_OFF + ((index & 0xFF) << 2); */
 	addr = pci_addr_lin + ((index & 0xFF) << 2);
@@ -392,7 +392,7 @@ static unsigned int read_index(unsigned char index)
 
 static void write_index(unsigned char index, unsigned int reg_val)
 {
-	unsigned char *addr;
+	unsigned char __iomem *addr;
 	addr = pci_addr_lin + ((index & 0xFF) << 2);
 	writel(reg_val, addr);
 }
diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index 62f5137..1394f02 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -324,7 +324,8 @@ static loff_t lirc_lseek(struct file *filep, loff_t offset, int orig)
 	return -ESPIPE;
 }
 
-static ssize_t lirc_read(struct file *filep, char *buf, size_t n, loff_t *ppos)
+static ssize_t lirc_read(struct file *filep, char __user *buf, size_t n,
+			 loff_t *ppos)
 {
 	int result = 0;
 	int count = 0;
@@ -362,7 +363,7 @@ static ssize_t lirc_read(struct file *filep, char *buf, size_t n, loff_t *ppos)
 	return count ? count : result;
 }
 
-static ssize_t lirc_write(struct file *filep, const char *buf, size_t n,
+static ssize_t lirc_write(struct file *filep, const char __user *buf, size_t n,
 			  loff_t *ppos)
 {
 	int count;
@@ -463,43 +464,44 @@ static unsigned int lirc_poll(struct file *file, poll_table *wait)
 static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	int result;
-	__u32 features = LIRC_CAN_SET_TRANSMITTER_MASK |
-			 LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2;
-	__u32 mode;
-	__u32 value;
+	u32 __user *uptr = (u32 __user *)arg;
+	u32 features = LIRC_CAN_SET_TRANSMITTER_MASK |
+		       LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2;
+	u32 mode;
+	u32 value;
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
-		result = put_user(features, (__u32 *) arg);
+		result = put_user(features, uptr);
 		if (result)
 			return result;
 		break;
 	case LIRC_GET_SEND_MODE:
-		result = put_user(LIRC_MODE_PULSE, (__u32 *) arg);
+		result = put_user(LIRC_MODE_PULSE, uptr);
 		if (result)
 			return result;
 		break;
 	case LIRC_GET_REC_MODE:
-		result = put_user(LIRC_MODE_MODE2, (__u32 *) arg);
+		result = put_user(LIRC_MODE_MODE2, uptr);
 		if (result)
 			return result;
 		break;
 	case LIRC_SET_SEND_MODE:
-		result = get_user(mode, (__u32 *) arg);
+		result = get_user(mode, uptr);
 		if (result)
 			return result;
 		if (mode != LIRC_MODE_PULSE)
 			return -EINVAL;
 		break;
 	case LIRC_SET_REC_MODE:
-		result = get_user(mode, (__u32 *) arg);
+		result = get_user(mode, uptr);
 		if (result)
 			return result;
 		if (mode != LIRC_MODE_MODE2)
 			return -ENOSYS;
 		break;
 	case LIRC_SET_TRANSMITTER_MASK:
-		result = get_user(value, (__u32 *) arg);
+		result = get_user(value, uptr);
 		if (result)
 			return result;
 		if ((value & LIRC_PARALLEL_TRANSMITTER_MASK) != value)
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 10c685d..dc5ba43 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1011,7 +1011,8 @@ static ssize_t lirc_write(struct file *file, const char __user *buf,
 static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	int result;
-	__u32 value;
+	u32 __user *uptr = (u32 __user *)arg;
+	u32 value;
 
 	switch (cmd) {
 	case LIRC_GET_SEND_MODE:
@@ -1020,7 +1021,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 		result = put_user(LIRC_SEND2MODE
 				  (hardware[type].features&LIRC_CAN_SEND_MASK),
-				  (__u32 *) arg);
+				  uptr);
 		if (result)
 			return result;
 		break;
@@ -1029,7 +1030,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if (!(hardware[type].features&LIRC_CAN_SEND_MASK))
 			return -ENOIOCTLCMD;
 
-		result = get_user(value, (__u32 *) arg);
+		result = get_user(value, uptr);
 		if (result)
 			return result;
 		/* only LIRC_MODE_PULSE supported */
@@ -1046,7 +1047,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if (!(hardware[type].features&LIRC_CAN_SET_SEND_DUTY_CYCLE))
 			return -ENOIOCTLCMD;
 
-		result = get_user(value, (__u32 *) arg);
+		result = get_user(value, uptr);
 		if (result)
 			return result;
 		if (value <= 0 || value > 100)
@@ -1059,7 +1060,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if (!(hardware[type].features&LIRC_CAN_SET_SEND_CARRIER))
 			return -ENOIOCTLCMD;
 
-		result = get_user(value, (__u32 *) arg);
+		result = get_user(value, uptr);
 		if (result)
 			return result;
 		if (value > 500000 || value < 20000)
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index f781c53..e31cbb8 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -187,10 +187,10 @@ static bool debug;
 
 /* Communication with user-space */
 static unsigned int lirc_poll(struct file *file, poll_table *wait);
-static ssize_t lirc_read(struct file *file, char *buf, size_t count,
-		loff_t *ppos);
-static ssize_t lirc_write(struct file *file, const char *buf, size_t n,
-		loff_t *pos);
+static ssize_t lirc_read(struct file *file, char __user *buf, size_t count,
+			 loff_t *ppos);
+static ssize_t lirc_write(struct file *file, const char __user *buf, size_t n,
+			  loff_t *pos);
 static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 static void add_read_queue(int flag, unsigned long val);
 static int init_chrdev(void);
@@ -252,8 +252,8 @@ static unsigned int lirc_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-static ssize_t lirc_read(struct file *file, char *buf, size_t count,
-		loff_t *ppos)
+static ssize_t lirc_read(struct file *file, char __user *buf, size_t count,
+			 loff_t *ppos)
 {
 	int n = 0;
 	int retval = 0;
@@ -266,9 +266,9 @@ static ssize_t lirc_read(struct file *file, char *buf, size_t count,
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (n < count) {
 		if (rx_head != rx_tail) {
-			if (copy_to_user((void *) buf + n,
-					(void *) (rx_buf + rx_head),
-					sizeof(int))) {
+			if (copy_to_user(buf + n,
+					 rx_buf + rx_head,
+					 sizeof(int))) {
 				retval = -EFAULT;
 				break;
 			}
@@ -291,8 +291,8 @@ static ssize_t lirc_read(struct file *file, char *buf, size_t count,
 	set_current_state(TASK_RUNNING);
 	return n ? n : retval;
 }
-static ssize_t lirc_write(struct file *file, const char *buf, size_t n,
-				loff_t *pos)
+static ssize_t lirc_write(struct file *file, const char __user *buf, size_t n,
+			  loff_t *pos)
 {
 	unsigned long flags;
 	int i, count;
@@ -338,8 +338,9 @@ static ssize_t lirc_write(struct file *file, const char *buf, size_t n,
 
 static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
+	u32 __user *uptr = (u32 __user *)arg;
 	int retval = 0;
-	__u32 value = 0;
+	u32 value = 0;
 #ifdef LIRC_ON_SA1100
 
 	if (cmd == LIRC_GET_FEATURES)
@@ -364,16 +365,16 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case LIRC_GET_FEATURES:
 	case LIRC_GET_SEND_MODE:
 	case LIRC_GET_REC_MODE:
-		retval = put_user(value, (__u32 *) arg);
+		retval = put_user(value, uptr);
 		break;
 
 	case LIRC_SET_SEND_MODE:
 	case LIRC_SET_REC_MODE:
-		retval = get_user(value, (__u32 *) arg);
+		retval = get_user(value, uptr);
 		break;
 #ifdef LIRC_ON_SA1100
 	case LIRC_SET_SEND_DUTY_CYCLE:
-		retval = get_user(value, (__u32 *) arg);
+		retval = get_user(value, uptr);
 		if (retval)
 			return retval;
 		if (value <= 0 || value > 100)
@@ -388,7 +389,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			space_width -= LIRC_ON_SA1100_TRANSMITTER_LATENCY;
 		break;
 	case LIRC_SET_SEND_CARRIER:
-		retval = get_user(value, (__u32 *) arg);
+		retval = get_user(value, uptr);
 		if (retval)
 			return retval;
 		if (value > 500000 || value < 20000)
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index e1feb61..3259aac 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -892,7 +892,8 @@ out:
 }
 
 /* copied from lirc_dev */
-static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
+static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
+		    loff_t *ppos)
 {
 	struct IR *ir = filep->private_data;
 	struct IR_rx *rx;
@@ -954,7 +955,7 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 			}
 			m = lirc_buffer_read(rbuf, buf);
 			if (m == rbuf->chunk_size) {
-				ret = copy_to_user((void *)outbuf+written, buf,
+				ret = copy_to_user(outbuf + written, buf,
 						   rbuf->chunk_size);
 				written += rbuf->chunk_size;
 			} else {
@@ -1094,8 +1095,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
  * sent to the device.  We have a spin lock as per i2c documentation to prevent
  * multiple concurrent sends which would probably cause the device to explode.
  */
-static ssize_t write(struct file *filep, const char *buf, size_t n,
-			  loff_t *ppos)
+static ssize_t write(struct file *filep, const char __user *buf, size_t n,
+		     loff_t *ppos)
 {
 	struct IR *ir = filep->private_data;
 	struct IR_tx *tx;
@@ -1237,6 +1238,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct IR *ir = filep->private_data;
+	unsigned long __user *uptr = (unsigned long __user *)arg;
 	int result;
 	unsigned long mode, features;
 
@@ -1244,11 +1246,10 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case LIRC_GET_LENGTH:
-		result = put_user((unsigned long)13,
-				  (unsigned long *)arg);
+		result = put_user(13UL, uptr);
 		break;
 	case LIRC_GET_FEATURES:
-		result = put_user(features, (unsigned long *) arg);
+		result = put_user(features, uptr);
 		break;
 	case LIRC_GET_REC_MODE:
 		if (!(features&LIRC_CAN_REC_MASK))
@@ -1256,13 +1257,13 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 		result = put_user(LIRC_REC2MODE
 				  (features&LIRC_CAN_REC_MASK),
-				  (unsigned long *)arg);
+				  uptr);
 		break;
 	case LIRC_SET_REC_MODE:
 		if (!(features&LIRC_CAN_REC_MASK))
 			return -ENOSYS;
 
-		result = get_user(mode, (unsigned long *)arg);
+		result = get_user(mode, uptr);
 		if (!result && !(LIRC_MODE2REC(mode) & features))
 			result = -EINVAL;
 		break;
@@ -1270,13 +1271,13 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if (!(features&LIRC_CAN_SEND_MASK))
 			return -ENOSYS;
 
-		result = put_user(LIRC_MODE_PULSE, (unsigned long *) arg);
+		result = put_user(LIRC_MODE_PULSE, uptr);
 		break;
 	case LIRC_SET_SEND_MODE:
 		if (!(features&LIRC_CAN_SEND_MASK))
 			return -ENOSYS;
 
-		result = get_user(mode, (unsigned long *) arg);
+		result = get_user(mode, uptr);
 		if (!result && mode != LIRC_MODE_PULSE)
 			return -EINVAL;
 		break;
-- 
1.7.9.5

