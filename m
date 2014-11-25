Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbaKYLCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:02:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58979 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaKYKnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 193/254] drm/radeon: add locking around atombios scratch space usage
Date: Tue, 25 Nov 2014 10:39:03 +0000
Message-Id: <1416912004-5928-194-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 1c9498425453bb65ef339a57705c5ef59fe1541d upstream.

While developing MST support I noticed I often got the wrong data
back from a transaction, in a racy fashion. I noticed the scratch
space wasn't locked against concurrent users.

Based on a patch by Alex, but I've made it a bit more obvious when
things are locked.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atom.c          | 11 ++++++++++-
 drivers/gpu/drm/radeon/atom.h          |  2 ++
 drivers/gpu/drm/radeon/atombios_dp.c   |  4 +++-
 drivers/gpu/drm/radeon/atombios_i2c.c  |  4 +++-
 drivers/gpu/drm/radeon/radeon_device.c |  1 +
 5 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 15da7ef344a4..ec1593a6a561 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1217,7 +1217,7 @@ free:
 	return ret;
 }
 
-int atom_execute_table(struct atom_context *ctx, int index, uint32_t * params)
+int atom_execute_table_scratch_unlocked(struct atom_context *ctx, int index, uint32_t * params)
 {
 	int r;
 
@@ -1238,6 +1238,15 @@ int atom_execute_table(struct atom_context *ctx, int index, uint32_t * params)
 	return r;
 }
 
+int atom_execute_table(struct atom_context *ctx, int index, uint32_t * params)
+{
+	int r;
+	mutex_lock(&ctx->scratch_mutex);
+	r = atom_execute_table_scratch_unlocked(ctx, index, params);
+	mutex_unlock(&ctx->scratch_mutex);
+	return r;
+}
+
 static int atom_iio_len[] = { 1, 2, 3, 3, 3, 3, 4, 4, 4, 3 };
 
 static void atom_index_iio(struct atom_context *ctx, int base)
diff --git a/drivers/gpu/drm/radeon/atom.h b/drivers/gpu/drm/radeon/atom.h
index feba6b8d36b3..6d014ddb6b78 100644
--- a/drivers/gpu/drm/radeon/atom.h
+++ b/drivers/gpu/drm/radeon/atom.h
@@ -125,6 +125,7 @@ struct card_info {
 struct atom_context {
 	struct card_info *card;
 	struct mutex mutex;
+	struct mutex scratch_mutex;
 	void *bios;
 	uint32_t cmd_table, data_table;
 	uint16_t *iio;
@@ -145,6 +146,7 @@ extern int atom_debug;
 
 struct atom_context *atom_parse(struct card_info *, void *);
 int atom_execute_table(struct atom_context *, int, uint32_t *);
+int atom_execute_table_scratch_unlocked(struct atom_context *, int, uint32_t *);
 int atom_asic_init(struct atom_context *);
 void atom_destroy(struct atom_context *);
 bool atom_parse_data_header(struct atom_context *ctx, int index, uint16_t *size,
diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index b1e11f8434e2..67fb65428b1e 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -100,6 +100,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 	memset(&args, 0, sizeof(args));
 
 	mutex_lock(&chan->mutex);
+	mutex_lock(&rdev->mode_info.atom_context->scratch_mutex);
 
 	base = (unsigned char *)(rdev->mode_info.atom_context->scratch + 1);
 
@@ -113,7 +114,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 	if (ASIC_IS_DCE4(rdev))
 		args.v2.ucHPD_ID = chan->rec.hpd;
 
-	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+	atom_execute_table_scratch_unlocked(rdev->mode_info.atom_context, index, (uint32_t *)&args);
 
 	*ack = args.v1.ucReplyStatus;
 
@@ -147,6 +148,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 
 	r = recv_bytes;
 done:
+	mutex_unlock(&rdev->mode_info.atom_context->scratch_mutex);
 	mutex_unlock(&chan->mutex);
 
 	return r;
diff --git a/drivers/gpu/drm/radeon/atombios_i2c.c b/drivers/gpu/drm/radeon/atombios_i2c.c
index 9c570fb15b8c..4157780585a0 100644
--- a/drivers/gpu/drm/radeon/atombios_i2c.c
+++ b/drivers/gpu/drm/radeon/atombios_i2c.c
@@ -48,6 +48,7 @@ static int radeon_process_i2c_ch(struct radeon_i2c_chan *chan,
 	memset(&args, 0, sizeof(args));
 
 	mutex_lock(&chan->mutex);
+	mutex_lock(&rdev->mode_info.atom_context->scratch_mutex);
 
 	base = (unsigned char *)rdev->mode_info.atom_context->scratch;
 
@@ -82,7 +83,7 @@ static int radeon_process_i2c_ch(struct radeon_i2c_chan *chan,
 	args.ucSlaveAddr = slave_addr << 1;
 	args.ucLineNumber = chan->rec.i2c_id;
 
-	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+	atom_execute_table_scratch_unlocked(rdev->mode_info.atom_context, index, (uint32_t *)&args);
 
 	/* error */
 	if (args.ucStatus != HW_ASSISTED_I2C_STATUS_SUCCESS) {
@@ -95,6 +96,7 @@ static int radeon_process_i2c_ch(struct radeon_i2c_chan *chan,
 		radeon_atom_copy_swap(buf, base, num, false);
 
 done:
+	mutex_unlock(&rdev->mode_info.atom_context->scratch_mutex);
 	mutex_unlock(&chan->mutex);
 
 	return r;
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 52a0cfd0276a..d024389c4272 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -902,6 +902,7 @@ int radeon_atombios_init(struct radeon_device *rdev)
 	}
 
 	mutex_init(&rdev->mode_info.atom_context->mutex);
+	mutex_init(&rdev->mode_info.atom_context->scratch_mutex);
 	radeon_atom_initialize_bios_scratch_regs(rdev->ddev);
 	atom_allocate_fb_scratch(rdev->mode_info.atom_context);
 	return 0;
-- 
2.1.0

