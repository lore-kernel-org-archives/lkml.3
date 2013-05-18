Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3ERCUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:20:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab3ERCQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:55 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=s2oC0HmCRecA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AyD7Jo7L7LcA:10 a=cm27Pg_UAAAA:8 a=L8c3rYF_AAAA:8 a=VnNF1IyMAAAA:8 a=l_LuiD7xZb9VDRkP5TAA:9 a=zv9_9hqRWm8A:10 a=jeBq3FmKZ4MA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021648.995381908@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Duncan Laurie <dlaurie@chromium.org>, Kent Yoder <key@linux.vnet.ibm.com>
Subject: [ 045/136 ] TPM: Retry SaveState command in suspend path
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0045-TPM-Retry-SaveState-command-in-suspend-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Duncan Laurie <dlaurie@chromium.org>

[ Upstream commit 32d33b29ba077d6b45de35f2181e0a7411b162f4 ]

If the TPM has already been sent a SaveState command before the driver
is loaded it may have problems sending that same command again later.

This issue is seen with the Chromebook Pixel due to a firmware bug in
the legacy mode boot path which is sending the SaveState command
before booting the kernel.  More information is available at
http://crbug.com/203524

This change introduces a retry of the SaveState command in the suspend
path in order to work around this issue.  A future firmware update
should fix this but this is also a trivial workaround in the driver
that has no effect on systems that do not show this problem.

When this does happen the TPM responds with a non-fatal TPM_RETRY code
that is defined in the specification:

  The TPM is too busy to respond to the command immediately, but the
  command could be resubmitted at a later time.  The TPM MAY return
  TPM_RETRY for any command at any time.

It can take several seconds before the TPM will respond again.  I
measured a typical time between 3 and 4 seconds and the timeout is set
at a safe 5 seconds.

It is also possible to reproduce this with commands via /dev/tpm0.
The bug linked above has a python script attached which can be used to
test for this problem.  I tested a variety of TPMs from Infineon,
Nuvoton, Atmel, and STMicro but was only able to reproduce this with
LPC and I2C TPMs from Infineon.

The TPM specification only loosely defines this behavior:

  TPM Main Level 2 Part 3 v1.2 r116, section 3.3. TPM_SaveState:
  The TPM MAY declare all preserved values invalid in response to any
  command other than TPM_Init.

  TCG PC Client BIOS Spec 1.21 section 8.3.1.
  After issuing a TPM_SaveState command, the OS SHOULD NOT issue TPM
  commands before transitioning to S3 without issuing another
  TPM_SaveState command.

  TCG PC Client TIS 1.21, section 4. Power Management:
  The TPM_SaveState command allows a Static OS to indicate to the TPM
  that the platform may enter a low power state where the TPM will be
  required to enter into the D3 power state.  The use of the term "may"
  is significant in that there is no requirement for the platform to
  actually enter the low power state after sending the TPM_SaveState
  command.  The software may, in fact, send subsequent commands after
  sending the TPM_SaveState command.

Change-Id: I52b41e826412688e5b6c8ddd3bb16409939704e9
Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/tpm/tpm.c |   32 ++++++++++++++++++++++++++++----
 drivers/char/tpm/tpm.h |    2 ++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 4dc8024..8a3a5fb 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -35,6 +35,7 @@ enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
 	TPM_BUFSIZE = 4096,
 	TPM_NUM_DEVICES = 256,
+	TPM_RETRY = 50,		/* 5 seconds */
 };
 
 enum tpm_duration {
@@ -1293,7 +1294,7 @@ int tpm_pm_suspend(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	struct tpm_cmd_t cmd;
-	int rc;
+	int rc, try;
 
 	u8 dummy_hash[TPM_DIGEST_SIZE] = { 0 };
 
@@ -1311,9 +1312,32 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 	/* now do the actual savestate */
-	cmd.header.in = savestate_header;
-	rc = transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE,
-			  "sending savestate before suspend");
+	for (try = 0; try < TPM_RETRY; try++) {
+		cmd.header.in = savestate_header;
+		rc = transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, NULL);
+
+		/*
+		 * If the TPM indicates that it is too busy to respond to
+		 * this command then retry before giving up.  It can take
+		 * several seconds for this TPM to be ready.
+		 *
+		 * This can happen if the TPM has already been sent the
+		 * SaveState command before the driver has loaded.  TCG 1.2
+		 * specification states that any communication after SaveState
+		 * may cause the TPM to invalidate previously saved state.
+		 */
+		if (rc != TPM_WARN_RETRY)
+			break;
+		msleep(TPM_TIMEOUT_RETRY);
+	}
+
+	if (rc)
+		dev_err(chip->dev,
+			"Error (%d) sending savestate before suspend\n", rc);
+	else if (try > 0)
+		dev_warn(chip->dev, "TPM savestate took %dms\n",
+			 try * TPM_TIMEOUT_RETRY);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_suspend);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 917f727..7ccb3ec 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -30,6 +30,7 @@
 
 enum tpm_timeout {
 	TPM_TIMEOUT = 5,	/* msecs */
+	TPM_TIMEOUT_RETRY = 100 /* msecs */
 };
 
 /* TPM addresses */
@@ -38,6 +39,7 @@ enum tpm_addr {
 	TPM_ADDR = 0x4E,
 };
 
+#define TPM_WARN_RETRY          0x800
 #define TPM_WARN_DOING_SELFTEST 0x802
 #define TPM_ERR_DEACTIVATED     0x6
 #define TPM_ERR_DISABLED        0x7
-- 
1.7.10.4


