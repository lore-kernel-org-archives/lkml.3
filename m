Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab3BKVel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:34:41 -0500
Received: from mail.tpi.com ([70.99.223.143]:2038 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759394Ab3BKVek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:34:40 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.freedesktop.org
Subject: =?UTF-8?q?=5BPATCH=20linux-next=5D=20drm/radeon=3A=20Avoid=20NULL=20pointer=20dereference=20from=20atom=5Findex=5Fiio=28=29=20allocation=20failure?=
Date: Mon, 11 Feb 2013 14:34:32 -0700
Message-Id: <1360618472-14821-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch anlysis:

drivers/gpu/drm/radeon/atom.c:1242 atom_index_iio() error: potential null
 dereference 'ctx->iio'.  (kzalloc returns null)

Also cleaned up some checks before calls to kfree(). kfree(NULL) is OK.

Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Michel Dänzer" <michel.daenzer@amd.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/gpu/drm/radeon/atom.c          |    9 +++++++--
 drivers/gpu/drm/radeon/radeon_device.c |    9 ++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 5ce9bf5..46a9c37 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1238,6 +1238,8 @@ static int atom_iio_len[] = { 1, 2, 3, 3, 3, 3, 4, 4, 4, 3 };
 static void atom_index_iio(struct atom_context *ctx, int base)
 {
 	ctx->iio = kzalloc(2 * 256, GFP_KERNEL);
+	if (!ctx->iio)
+		return;
 	while (CU8(base) == ATOM_IIO_START) {
 		ctx->iio[CU8(base + 1)] = base + 2;
 		base += 2;
@@ -1287,6 +1289,10 @@ struct atom_context *atom_parse(struct card_info *card, void *bios)
 	ctx->cmd_table = CU16(base + ATOM_ROM_CMD_PTR);
 	ctx->data_table = CU16(base + ATOM_ROM_DATA_PTR);
 	atom_index_iio(ctx, CU16(ctx->data_table + ATOM_DATA_IIO_PTR) + 4);
+	if (!ctx->iio) {
+		atom_destroy(ctx);
+		return NULL;
+	}
 
 	str = CSTR(CU16(base + ATOM_ROM_MSG_PTR));
 	while (*str && ((*str == '\n') || (*str == '\r')))
@@ -1335,8 +1341,7 @@ int atom_asic_init(struct atom_context *ctx)
 
 void atom_destroy(struct atom_context *ctx)
 {
-	if (ctx->iio)
-		kfree(ctx->iio);
+	kfree(ctx->iio);
 	kfree(ctx);
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 8794de1..44b8034 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -759,6 +759,11 @@ int radeon_atombios_init(struct radeon_device *rdev)
 	atom_card_info->pll_write = cail_pll_write;
 
 	rdev->mode_info.atom_context = atom_parse(atom_card_info, rdev->bios);
+	if (!rdev->mode_info.atom_context) {
+		radeon_atombios_fini(rdev);
+		return -ENOMEM;
+	}
+
 	mutex_init(&rdev->mode_info.atom_context->mutex);
 	radeon_atom_initialize_bios_scratch_regs(rdev->ddev);
 	atom_allocate_fb_scratch(rdev->mode_info.atom_context);
@@ -778,9 +783,11 @@ void radeon_atombios_fini(struct radeon_device *rdev)
 {
 	if (rdev->mode_info.atom_context) {
 		kfree(rdev->mode_info.atom_context->scratch);
-		kfree(rdev->mode_info.atom_context);
 	}
+	kfree(rdev->mode_info.atom_context);
+	rdev->mode_info.atom_context = NULL;
 	kfree(rdev->mode_info.atom_card_info);
+	rdev->mode_info.atom_card_info = NULL;
 }
 
 /* COMBIOS */
-- 
1.7.9.5

