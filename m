Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672Ab3B0BCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:02:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3BZX5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 067/150] drm/radeon: properly validate the atpx interface
Date: Tue, 26 Feb 2013 15:55:24 -0800
Message-Id: <20130226235531.165850704@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 43a23aa450cc19fe8996caf09e7e21ae5f6e56e8 upstream.

Some bioses don't set the function mask correctly
which caused required functions to be disabled.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=53111

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |   73 ++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -43,6 +43,12 @@ struct atpx_verify_interface {
 	u32 function_bits;	/* supported functions bit vector */
 } __packed;
 
+struct atpx_px_params {
+	u16 size;		/* structure size in bytes (includes size field) */
+	u32 valid_flags;	/* which flags are valid */
+	u32 flags;		/* flags */
+} __packed;
+
 struct atpx_power_control {
 	u16 size;
 	u8 dgpu_state;
@@ -123,9 +129,61 @@ static void radeon_atpx_parse_functions(
 }
 
 /**
+ * radeon_atpx_validate_functions - validate ATPX functions
+ *
+ * @atpx: radeon atpx struct
+ *
+ * Validate that required functions are enabled (all asics).
+ * returns 0 on success, error on failure.
+ */
+static int radeon_atpx_validate(struct radeon_atpx *atpx)
+{
+	/* make sure required functions are enabled */
+	/* dGPU power control is required */
+	atpx->functions.power_cntl = true;
+
+	if (atpx->functions.px_params) {
+		union acpi_object *info;
+		struct atpx_px_params output;
+		size_t size;
+		u32 valid_bits;
+
+		info = radeon_atpx_call(atpx->handle, ATPX_FUNCTION_GET_PX_PARAMETERS, NULL);
+		if (!info)
+			return -EIO;
+
+		memset(&output, 0, sizeof(output));
+
+		size = *(u16 *) info->buffer.pointer;
+		if (size < 10) {
+			printk("ATPX buffer is too small: %zu\n", size);
+			kfree(info);
+			return -EINVAL;
+		}
+		size = min(sizeof(output), size);
+
+		memcpy(&output, info->buffer.pointer, size);
+
+		valid_bits = output.flags & output.valid_flags;
+		/* if separate mux flag is set, mux controls are required */
+		if (valid_bits & ATPX_SEPARATE_MUX_FOR_I2C) {
+			atpx->functions.i2c_mux_cntl = true;
+			atpx->functions.disp_mux_cntl = true;
+		}
+		/* if any outputs are muxed, mux controls are required */
+		if (valid_bits & (ATPX_CRT1_RGB_SIGNAL_MUXED |
+				  ATPX_TV_SIGNAL_MUXED |
+				  ATPX_DFP_SIGNAL_MUXED))
+			atpx->functions.disp_mux_cntl = true;
+
+		kfree(info);
+	}
+	return 0;
+}
+
+/**
  * radeon_atpx_verify_interface - verify ATPX
  *
- * @handle: acpi handle
  * @atpx: radeon atpx struct
  *
  * Execute the ATPX_FUNCTION_VERIFY_INTERFACE ATPX function
@@ -406,8 +464,19 @@ static bool radeon_atpx_pci_probe_handle
  */
 static int radeon_atpx_init(void)
 {
+	int r;
+
 	/* set up the ATPX handle */
-	return radeon_atpx_verify_interface(&radeon_atpx_priv.atpx);
+	r = radeon_atpx_verify_interface(&radeon_atpx_priv.atpx);
+	if (r)
+		return r;
+
+	/* validate the atpx setup */
+	r = radeon_atpx_validate(&radeon_atpx_priv.atpx);
+	if (r)
+		return r;
+
+	return 0;
 }
 
 /**


