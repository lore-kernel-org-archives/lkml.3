Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaIZJ5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:57:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbaIZJqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "Berg, Christopher" <Christopher.Berg@atmel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Ben Hutchings <ben@decadent.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 043/142] tpm: Provide a generic means to override the chip returned timeouts
Date: Fri, 26 Sep 2014 11:44:14 +0200
Message-Id: <3f06fd495304eaca2d7e61b7db3e0c27e152b36e.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8e54caf407b98efa05409e1fee0e5381abd2b088 upstream.

Some Atmel TPMs provide completely wrong timeouts from their
TPM_CAP_PROP_TIS_TIMEOUT query. This patch detects that and returns
new correct values via a DID/VID table in the TIS driver.

Tested on ARM using an AT97SC3204T FW version 37.16

[PHuewe: without this fix these 'broken' Atmel TPMs won't function on
older kernels]
Signed-off-by: "Berg, Christopher" <Christopher.Berg@atmel.com>
Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
[bwh: Backported to 3.10:
 - Adjust filename, context
 - s/chip->ops->/chip->vendor./]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/tpm/tpm.c     | 62 ++++++++++++++++++++++++++++++----------------
 drivers/char/tpm/tpm.h     |  3 +++
 drivers/char/tpm/tpm_tis.c | 31 +++++++++++++++++++++++
 3 files changed, 75 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 334b9ef1bb1d..48138b311460 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -533,11 +533,10 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
 	struct tpm_cmd_t tpm_cmd;
-	struct timeout_t *timeout_cap;
+	unsigned long new_timeout[4];
+	unsigned long old_timeout[4];
 	struct duration_t *duration_cap;
 	ssize_t rc;
-	u32 timeout;
-	unsigned int scale = 1;
 
 	tpm_cmd.header.in = tpm_getcap_header;
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
@@ -571,25 +570,46 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
 		return -EINVAL;
 
-	timeout_cap = &tpm_cmd.params.getcap_out.cap.timeout;
-	/* Don't overwrite default if value is 0 */
-	timeout = be32_to_cpu(timeout_cap->a);
-	if (timeout && timeout < 1000) {
-		/* timeouts in msec rather usec */
-		scale = 1000;
-		chip->vendor.timeout_adjusted = true;
+	old_timeout[0] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.a);
+	old_timeout[1] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.b);
+	old_timeout[2] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.c);
+	old_timeout[3] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.d);
+	memcpy(new_timeout, old_timeout, sizeof(new_timeout));
+
+	/*
+	 * Provide ability for vendor overrides of timeout values in case
+	 * of misreporting.
+	 */
+	if (chip->vendor.update_timeouts != NULL)
+		chip->vendor.timeout_adjusted =
+			chip->vendor.update_timeouts(chip, new_timeout);
+
+	if (!chip->vendor.timeout_adjusted) {
+		/* Don't overwrite default if value is 0 */
+		if (new_timeout[0] != 0 && new_timeout[0] < 1000) {
+			int i;
+
+			/* timeouts in msec rather usec */
+			for (i = 0; i != ARRAY_SIZE(new_timeout); i++)
+				new_timeout[i] *= 1000;
+			chip->vendor.timeout_adjusted = true;
+		}
 	}
-	if (timeout)
-		chip->vendor.timeout_a = usecs_to_jiffies(timeout * scale);
-	timeout = be32_to_cpu(timeout_cap->b);
-	if (timeout)
-		chip->vendor.timeout_b = usecs_to_jiffies(timeout * scale);
-	timeout = be32_to_cpu(timeout_cap->c);
-	if (timeout)
-		chip->vendor.timeout_c = usecs_to_jiffies(timeout * scale);
-	timeout = be32_to_cpu(timeout_cap->d);
-	if (timeout)
-		chip->vendor.timeout_d = usecs_to_jiffies(timeout * scale);
+
+	/* Report adjusted timeouts */
+	if (chip->vendor.timeout_adjusted) {
+		dev_info(chip->dev,
+			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->%luus D %lu->%luus\n",
+			 old_timeout[0], new_timeout[0],
+			 old_timeout[1], new_timeout[1],
+			 old_timeout[2], new_timeout[2],
+			 old_timeout[3], new_timeout[3]);
+	}
+
+	chip->vendor.timeout_a = usecs_to_jiffies(new_timeout[0]);
+	chip->vendor.timeout_b = usecs_to_jiffies(new_timeout[1]);
+	chip->vendor.timeout_c = usecs_to_jiffies(new_timeout[2]);
+	chip->vendor.timeout_d = usecs_to_jiffies(new_timeout[3]);
 
 duration:
 	tpm_cmd.header.in = tpm_getcap_header;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index a7bfc176ed43..b911d79fbd58 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -95,6 +95,9 @@ struct tpm_vendor_specific {
 	int (*send) (struct tpm_chip *, u8 *, size_t);
 	void (*cancel) (struct tpm_chip *);
 	u8 (*status) (struct tpm_chip *);
+	bool (*update_timeouts)(struct tpm_chip *chip,
+				unsigned long *timeout_cap);
+
 	void (*release) (struct device *);
 	struct miscdevice miscdev;
 	struct attribute_group *attr_group;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 5796d0157ce0..e7b1a0ae4300 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -373,6 +373,36 @@ out_err:
 	return rc;
 }
 
+struct tis_vendor_timeout_override {
+	u32 did_vid;
+	unsigned long timeout_us[4];
+};
+
+static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
+	/* Atmel 3204 */
+	{ 0x32041114, { (TIS_SHORT_TIMEOUT*1000), (TIS_LONG_TIMEOUT*1000),
+			(TIS_SHORT_TIMEOUT*1000), (TIS_SHORT_TIMEOUT*1000) } },
+};
+
+static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
+				    unsigned long *timeout_cap)
+{
+	int i;
+	u32 did_vid;
+
+	did_vid = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
+
+	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
+		if (vendor_timeout_overrides[i].did_vid != did_vid)
+			continue;
+		memcpy(timeout_cap, vendor_timeout_overrides[i].timeout_us,
+		       sizeof(vendor_timeout_overrides[i].timeout_us));
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Early probing for iTPM with STS_DATA_EXPECT flaw.
  * Try sending command without itpm flag set and if that
@@ -475,6 +505,7 @@ static struct tpm_vendor_specific tpm_tis = {
 	.recv = tpm_tis_recv,
 	.send = tpm_tis_send,
 	.cancel = tpm_tis_ready,
+	.update_timeouts = tpm_tis_update_timeouts,
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_tis_req_canceled,
-- 
2.1.0

