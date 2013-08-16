Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3HPWhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:37:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51417 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3HPWhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:37:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Haitao Zhang <haitao.zhang@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 080/133] drm/i915: Make data/link N value power of two
Date: Fri, 16 Aug 2013 15:33:42 -0700
Message-Id: <1376692475-28413-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit a65851af59387146a28a928c3e7bb17dabc5db72 upstream.

The BIOS uses power of two values for the data/link N value.

Follow suit to make the Zotac DP to dual-HDMI dongle work.

v2: Clean up the magic numbers and defines
    Change the N clamping to be a bit easier on the eye
    Rename intel_reduce_ratio to intel_reduce_m_n_ratio

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=49402
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59810
Tested-by:  Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[Haitao Zhang: backport to 3.8]
Signed-off-by: Haitao Zhang <haitao.zhang@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h      | 12 ++++--------
 drivers/gpu/drm/i915/intel_display.c | 23 +++++++++++++++--------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index b7315e3..24f0368 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2602,14 +2602,14 @@
 #define _PIPEB_GMCH_DATA_M			0x71050
 
 /* Transfer unit size for display port - 1, default is 0x3f (for TU size 64) */
-#define   PIPE_GMCH_DATA_M_TU_SIZE_MASK		(0x3f << 25)
-#define   PIPE_GMCH_DATA_M_TU_SIZE_SHIFT	25
+#define  TU_SIZE(x)             (((x)-1) << 25) /* default size 64 */
+#define  TU_SIZE_MASK           (0x3f << 25)
 
-#define   PIPE_GMCH_DATA_M_MASK			(0xffffff)
+#define  DATA_LINK_M_N_MASK	(0xffffff)
+#define  DATA_LINK_N_MAX	(0x800000)
 
 #define _PIPEA_GMCH_DATA_N			0x70054
 #define _PIPEB_GMCH_DATA_N			0x71054
-#define   PIPE_GMCH_DATA_N_MASK			(0xffffff)
 
 /*
  * Computing Link M and N values for the Display Port link
@@ -2624,11 +2624,9 @@
 
 #define _PIPEA_DP_LINK_M				0x70060
 #define _PIPEB_DP_LINK_M				0x71060
-#define   PIPEA_DP_LINK_M_MASK			(0xffffff)
 
 #define _PIPEA_DP_LINK_N				0x70064
 #define _PIPEB_DP_LINK_N				0x71064
-#define   PIPEA_DP_LINK_N_MASK			(0xffffff)
 
 #define PIPE_GMCH_DATA_M(pipe) _PIPE(pipe, _PIPEA_GMCH_DATA_M, _PIPEB_GMCH_DATA_M)
 #define PIPE_GMCH_DATA_N(pipe) _PIPE(pipe, _PIPEA_GMCH_DATA_N, _PIPEB_GMCH_DATA_N)
@@ -3294,8 +3292,6 @@
 
 
 #define _PIPEA_DATA_M1           0x60030
-#define  TU_SIZE(x)             (((x)-1) << 25) /* default size 64 */
-#define  TU_SIZE_MASK           0x7e000000
 #define  PIPE_DATA_M1_OFFSET    0
 #define _PIPEA_DATA_N1           0x60034
 #define  PIPE_DATA_N1_OFFSET    0
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e094040..1f20ac5 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4042,26 +4042,33 @@ struct fdi_m_n {
 static void
 fdi_reduce_ratio(u32 *num, u32 *den)
 {
-	while (*num > 0xffffff || *den > 0xffffff) {
+	while (*num > DATA_LINK_M_N_MASK ||
+	       *den > DATA_LINK_M_N_MASK) {
 		*num >>= 1;
 		*den >>= 1;
 	}
 }
 
+static void compute_m_n(unsigned int m, unsigned int n,
+			uint32_t *ret_m, uint32_t *ret_n)
+{
+	*ret_n = min_t(unsigned int, roundup_pow_of_two(n), DATA_LINK_N_MAX);
+	*ret_m = div_u64((uint64_t) m * *ret_n, n);
+	fdi_reduce_ratio(ret_m, ret_n);
+}
+
 static void
 ironlake_compute_m_n(int bits_per_pixel, int nlanes, int pixel_clock,
 		     int link_clock, struct fdi_m_n *m_n)
 {
 	m_n->tu = 64; /* default size */
 
-	/* BUG_ON(pixel_clock > INT_MAX / 36); */
-	m_n->gmch_m = bits_per_pixel * pixel_clock;
-	m_n->gmch_n = link_clock * nlanes * 8;
-	fdi_reduce_ratio(&m_n->gmch_m, &m_n->gmch_n);
+	compute_m_n(bits_per_pixel * pixel_clock,
+		    link_clock * nlanes * 8,
+		    &m_n->gmch_m, &m_n->gmch_n);
 
-	m_n->link_m = pixel_clock;
-	m_n->link_n = link_clock;
-	fdi_reduce_ratio(&m_n->link_m, &m_n->link_n);
+	compute_m_n(pixel_clock, link_clock,
+		    &m_n->link_m, &m_n->link_n);
 }
 
 static inline bool intel_panel_use_ssc(struct drm_i915_private *dev_priv)
-- 
1.8.1.2

