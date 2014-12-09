Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaLIUI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:08:29 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55764 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaLIUHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:07:36 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/3] i8k: cosmetic: distinguish between fan speed and fan rpm
Date: Tue,  9 Dec 2014 21:06:59 +0100
Message-Id: <1418155621-21644-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver mix speed and rpm. Fan speed is value (0, 1, 2) which is used for
configuring fan. This patch change comments, function names and other
definitions so code should be unambiguous now.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
This patch is cosmetic and does not bring any change to code.
---
 drivers/char/i8k.c |   78 ++++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 48d701c..31e4beb 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -39,9 +39,9 @@
 
 #define I8K_SMM_FN_STATUS	0x0025
 #define I8K_SMM_POWER_STATUS	0x0069
-#define I8K_SMM_SET_FAN		0x01a3
-#define I8K_SMM_GET_FAN		0x00a3
-#define I8K_SMM_GET_SPEED	0x02a3
+#define I8K_SMM_GET_FAN_SPEED	0x00a3
+#define I8K_SMM_SET_FAN_SPEED	0x01a3
+#define I8K_SMM_GET_FAN_RPM	0x02a3
 #define I8K_SMM_GET_TEMP	0x10a3
 #define I8K_SMM_GET_TEMP_TYPE	0x11a3
 #define I8K_SMM_GET_DELL_SIG1	0xfea3
@@ -97,7 +97,7 @@ MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
 
 static int fan_mult = I8K_FAN_MULT;
 module_param(fan_mult, int, 0);
-MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
+MODULE_PARM_DESC(fan_mult, "Factor to multiply fan rpm with");
 
 static int fan_max = I8K_FAN_HIGH;
 module_param(fan_max, int, 0);
@@ -254,38 +254,38 @@ static int i8k_get_power_status(void)
 }
 
 /*
- * Read the fan status.
+ * Read the fan speed value (status).
  */
-static int i8k_get_fan_status(int fan)
+static int i8k_get_fan_speed(int fan)
 {
-	struct smm_regs regs = { .eax = I8K_SMM_GET_FAN, };
+	struct smm_regs regs = { .eax = I8K_SMM_GET_FAN_SPEED, };
 
 	regs.ebx = fan & 0xff;
 	return i8k_smm(&regs) ? : regs.eax & 0xff;
 }
 
 /*
- * Read the fan speed in RPM.
+ * Read the fan rpm.
  */
-static int i8k_get_fan_speed(int fan)
+static int i8k_get_fan_rpm(int fan)
 {
-	struct smm_regs regs = { .eax = I8K_SMM_GET_SPEED, };
+	struct smm_regs regs = { .eax = I8K_SMM_GET_FAN_RPM, };
 
 	regs.ebx = fan & 0xff;
 	return i8k_smm(&regs) ? : (regs.eax & 0xffff) * i8k_fan_mult;
 }
 
 /*
- * Set the fan speed (off, low, high). Returns the new fan status.
+ * Set the fan speed (off, low, high). Returns the new fan speed.
  */
-static int i8k_set_fan(int fan, int speed)
+static int i8k_set_fan_speed(int fan, int speed)
 {
-	struct smm_regs regs = { .eax = I8K_SMM_SET_FAN, };
+	struct smm_regs regs = { .eax = I8K_SMM_SET_FAN_SPEED, };
 
 	speed = (speed < 0) ? 0 : ((speed > i8k_fan_max) ? i8k_fan_max : speed);
 	regs.ebx = (fan & 0xff) | (speed << 8);
 
-	return i8k_smm(&regs) ? : i8k_get_fan_status(fan);
+	return i8k_smm(&regs) ? : i8k_get_fan_speed(fan);
 }
 
 static int i8k_get_temp_type(int sensor)
@@ -389,14 +389,14 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&val, argp, sizeof(int)))
 			return -EFAULT;
 
-		val = i8k_get_fan_speed(val);
+		val = i8k_get_fan_rpm(val);
 		break;
 
 	case I8K_GET_FAN:
 		if (copy_from_user(&val, argp, sizeof(int)))
 			return -EFAULT;
 
-		val = i8k_get_fan_status(val);
+		val = i8k_get_fan_speed(val);
 		break;
 
 	case I8K_SET_FAN:
@@ -409,7 +409,7 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&speed, argp + 1, sizeof(int)))
 			return -EFAULT;
 
-		val = i8k_set_fan(val, speed);
+		val = i8k_set_fan_speed(val, speed);
 		break;
 
 	default:
@@ -457,13 +457,13 @@ static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 static int i8k_proc_show(struct seq_file *seq, void *offset)
 {
 	int fn_key, cpu_temp, ac_power;
-	int left_fan, right_fan, left_speed, right_speed;
+	int left_fan, right_fan, left_rpm, right_rpm;
 
 	cpu_temp	= i8k_get_temp(0);			/* 11100 µs */
-	left_fan	= i8k_get_fan_status(I8K_FAN_LEFT);	/*   580 µs */
-	right_fan	= i8k_get_fan_status(I8K_FAN_RIGHT);	/*   580 µs */
-	left_speed	= i8k_get_fan_speed(I8K_FAN_LEFT);	/*   580 µs */
-	right_speed	= i8k_get_fan_speed(I8K_FAN_RIGHT);	/*   580 µs */
+	left_fan	= i8k_get_fan_speed(I8K_FAN_LEFT);	/*   580 µs */
+	right_fan	= i8k_get_fan_speed(I8K_FAN_RIGHT);	/*   580 µs */
+	left_rpm	= i8k_get_fan_rpm(I8K_FAN_LEFT);	/*   580 µs */
+	right_rpm	= i8k_get_fan_rpm(I8K_FAN_RIGHT);	/*   580 µs */
 	fn_key		= i8k_get_fn_status();			/*   750 µs */
 	if (power_status)
 		ac_power = i8k_get_power_status();		/* 14700 µs */
@@ -477,10 +477,10 @@ static int i8k_proc_show(struct seq_file *seq, void *offset)
 	 * 2)  BIOS version
 	 * 3)  BIOS machine ID
 	 * 4)  Cpu temperature
-	 * 5)  Left fan status
-	 * 6)  Right fan status
-	 * 7)  Left fan speed
-	 * 8)  Right fan speed
+	 * 5)  Left fan speed (status)
+	 * 6)  Right fan speed (status)
+	 * 7)  Left fan rpm
+	 * 8)  Right fan rpm
 	 * 9)  AC power
 	 * 10) Fn Key status
 	 */
@@ -489,7 +489,7 @@ static int i8k_proc_show(struct seq_file *seq, void *offset)
 			  bios_version,
 			  i8k_get_dmi_data(DMI_PRODUCT_SERIAL),
 			  cpu_temp,
-			  left_fan, right_fan, left_speed, right_speed,
+			  left_fan, right_fan, left_rpm, right_rpm,
 			  ac_power, fn_key);
 }
 
@@ -544,12 +544,12 @@ static ssize_t i8k_hwmon_show_fan(struct device *dev,
 				  char *buf)
 {
 	int index = to_sensor_dev_attr(devattr)->index;
-	int fan_speed;
+	int fan_rpm;
 
-	fan_speed = i8k_get_fan_speed(index);
-	if (fan_speed < 0)
-		return fan_speed;
-	return sprintf(buf, "%d\n", fan_speed);
+	fan_rpm = i8k_get_fan_rpm(index);
+	if (fan_rpm < 0)
+		return fan_rpm;
+	return sprintf(buf, "%d\n", fan_rpm);
 }
 
 static ssize_t i8k_hwmon_show_pwm(struct device *dev,
@@ -557,12 +557,12 @@ static ssize_t i8k_hwmon_show_pwm(struct device *dev,
 				  char *buf)
 {
 	int index = to_sensor_dev_attr(devattr)->index;
-	int status;
+	int fan_speed;
 
-	status = i8k_get_fan_status(index);
-	if (status < 0)
+	fan_speed = i8k_get_fan_speed(index);
+	if (fan_speed < 0)
 		return -EIO;
-	return sprintf(buf, "%d\n", clamp_val(status * i8k_pwm_mult, 0, 255));
+	return sprintf(buf, "%d\n", clamp_val(fan_speed * i8k_pwm_mult, 0, 255));
 }
 
 static ssize_t i8k_hwmon_set_pwm(struct device *dev,
@@ -579,7 +579,7 @@ static ssize_t i8k_hwmon_set_pwm(struct device *dev,
 	val = clamp_val(DIV_ROUND_CLOSEST(val, i8k_pwm_mult), 0, i8k_fan_max);
 
 	mutex_lock(&i8k_mutex);
-	err = i8k_set_fan(index, val);
+	err = i8k_set_fan_speed(index, val);
 	mutex_unlock(&i8k_mutex);
 
 	return err < 0 ? -EIO : count;
@@ -675,12 +675,12 @@ static int __init i8k_init_hwmon(void)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP4;
 
 	/* Left fan attributes, if left fan is present */
-	err = i8k_get_fan_status(I8K_FAN_LEFT);
+	err = i8k_get_fan_speed(I8K_FAN_LEFT);
 	if (err >= 0)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_FAN1;
 
 	/* Right fan attributes, if right fan is present */
-	err = i8k_get_fan_status(I8K_FAN_RIGHT);
+	err = i8k_get_fan_speed(I8K_FAN_RIGHT);
 	if (err >= 0)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_FAN2;
 
-- 
1.7.9.5

