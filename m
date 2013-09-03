Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab3ICQ3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:29:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064Ab3ICQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:28:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 40/58] drm/i915: Don't deref pipe->cpu_transcoder in the hangcheck code
Date: Tue,  3 Sep 2013 09:23:44 -0700
Message-Id: <1378225442-20654-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 63b66e5ba54b15a6592be00555d762db6db739ce upstream.

If we get an error event really early in the driver setup sequence,
which gen3 is especially prone to with various display GTT faults we
Oops. So try to avoid this.

Additionally with Haswell the transcoders are a separate bank of
registers from the pipes (4 transcoders, 3 pipes). In event of an
error, we want to be sure we have a complete and accurate picture of
the machine state, so record all the transcoders in addition to all
the active pipes.

This regression has been introduced in

commit 702e7a56af3780d8b3a717f698209bef44187bb0
Author: Paulo Zanoni <paulo.r.zanoni@intel.com>
Date:   Tue Oct 23 18:29:59 2012 -0200

    drm/i915: convert PIPECONF to use transcoder instead of pipe

Based on the patch "drm/i915: Dump all transcoder registers on error"
from Chris Wilson:

v2: Rebase so that we don't try to be clever and try to figure out the
cpu transcoder from hw state. That exercise should be done when we
analyze the error state offline.

The actual bugfix is to not call intel_pipe_to_cpu_transcoder in the
error state capture code in case the pipes aren't fully set up yet.

v3: Simplifiy the err->num_transcoders computation a bit. While at it
make the error capture stuff save on systems without a display block.

v4: Fix fail, spotted by Jani.

v5: Completely new commit message, cc: stable.

Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Cc: Damien Lespiau <damien.lespiau@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=60021
Tested-by: Dustin King <daking@rescomp.stanford.edu>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>

Conflicts:
	drivers/gpu/drm/i915/intel_display.c
---
 drivers/gpu/drm/i915/intel_display.c | 83 +++++++++++++++++++++++++-----------
 1 file changed, 58 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b101a02..33015db 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9461,6 +9461,9 @@ int intel_modeset_vga_set_state(struct drm_device *dev, bool state)
 #include <linux/seq_file.h>
 
 struct intel_display_error_state {
+
+	int num_transcoders;
+
 	struct intel_cursor_error_state {
 		u32 control;
 		u32 position;
@@ -9469,15 +9472,7 @@ struct intel_display_error_state {
 	} cursor[I915_MAX_PIPES];
 
 	struct intel_pipe_error_state {
-		u32 conf;
 		u32 source;
-
-		u32 htotal;
-		u32 hblank;
-		u32 hsync;
-		u32 vtotal;
-		u32 vblank;
-		u32 vsync;
 	} pipe[I915_MAX_PIPES];
 
 	struct intel_plane_error_state {
@@ -9489,6 +9484,19 @@ struct intel_display_error_state {
 		u32 surface;
 		u32 tile_offset;
 	} plane[I915_MAX_PIPES];
+
+	struct intel_transcoder_error_state {
+		enum transcoder cpu_transcoder;
+
+		u32 conf;
+
+		u32 htotal;
+		u32 hblank;
+		u32 hsync;
+		u32 vtotal;
+		u32 vblank;
+		u32 vsync;
+	} transcoder[4];
 };
 
 struct intel_display_error_state *
@@ -9496,16 +9504,22 @@ intel_display_capture_error_state(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct intel_display_error_state *error;
-	enum transcoder cpu_transcoder;
+	int transcoders[] = {
+		TRANSCODER_A,
+		TRANSCODER_B,
+		TRANSCODER_C,
+		TRANSCODER_EDP,
+	};
 	int i;
 
+	if (INTEL_INFO(dev)->num_pipes == 0)
+		return NULL;
+
 	error = kmalloc(sizeof(*error), GFP_ATOMIC);
 	if (error == NULL)
 		return NULL;
 
 	for_each_pipe(i) {
-		cpu_transcoder = intel_pipe_to_cpu_transcoder(dev_priv, i);
-
 		error->cursor[i].control = I915_READ(CURCNTR(i));
 		error->cursor[i].position = I915_READ(CURPOS(i));
 		error->cursor[i].base = I915_READ(CURBASE(i));
@@ -9520,14 +9534,25 @@ intel_display_capture_error_state(struct drm_device *dev)
 			error->plane[i].tile_offset = I915_READ(DSPTILEOFF(i));
 		}
 
-		error->pipe[i].conf = I915_READ(PIPECONF(cpu_transcoder));
 		error->pipe[i].source = I915_READ(PIPESRC(i));
-		error->pipe[i].htotal = I915_READ(HTOTAL(cpu_transcoder));
-		error->pipe[i].hblank = I915_READ(HBLANK(cpu_transcoder));
-		error->pipe[i].hsync = I915_READ(HSYNC(cpu_transcoder));
-		error->pipe[i].vtotal = I915_READ(VTOTAL(cpu_transcoder));
-		error->pipe[i].vblank = I915_READ(VBLANK(cpu_transcoder));
-		error->pipe[i].vsync = I915_READ(VSYNC(cpu_transcoder));
+	}
+
+	error->num_transcoders = INTEL_INFO(dev)->num_pipes;
+	if (HAS_DDI(dev_priv->dev))
+		error->num_transcoders++; /* Account for eDP. */
+
+	for (i = 0; i < error->num_transcoders; i++) {
+		enum transcoder cpu_transcoder = transcoders[i];
+
+		error->transcoder[i].cpu_transcoder = cpu_transcoder;
+
+		error->transcoder[i].conf = I915_READ(PIPECONF(cpu_transcoder));
+		error->transcoder[i].htotal = I915_READ(HTOTAL(cpu_transcoder));
+		error->transcoder[i].hblank = I915_READ(HBLANK(cpu_transcoder));
+		error->transcoder[i].hsync = I915_READ(HSYNC(cpu_transcoder));
+		error->transcoder[i].vtotal = I915_READ(VTOTAL(cpu_transcoder));
+		error->transcoder[i].vblank = I915_READ(VBLANK(cpu_transcoder));
+		error->transcoder[i].vsync = I915_READ(VSYNC(cpu_transcoder));
 	}
 
 	return error;
@@ -9540,17 +9565,13 @@ intel_display_print_error_state(struct seq_file *m,
 {
 	int i;
 
+	if (!error)
+		return;
+
 	seq_printf(m, "Num Pipes: %d\n", INTEL_INFO(dev)->num_pipes);
 	for_each_pipe(i) {
 		seq_printf(m, "Pipe [%d]:\n", i);
-		seq_printf(m, "  CONF: %08x\n", error->pipe[i].conf);
 		seq_printf(m, "  SRC: %08x\n", error->pipe[i].source);
-		seq_printf(m, "  HTOTAL: %08x\n", error->pipe[i].htotal);
-		seq_printf(m, "  HBLANK: %08x\n", error->pipe[i].hblank);
-		seq_printf(m, "  HSYNC: %08x\n", error->pipe[i].hsync);
-		seq_printf(m, "  VTOTAL: %08x\n", error->pipe[i].vtotal);
-		seq_printf(m, "  VBLANK: %08x\n", error->pipe[i].vblank);
-		seq_printf(m, "  VSYNC: %08x\n", error->pipe[i].vsync);
 
 		seq_printf(m, "Plane [%d]:\n", i);
 		seq_printf(m, "  CNTR: %08x\n", error->plane[i].control);
@@ -9568,5 +9589,17 @@ intel_display_print_error_state(struct seq_file *m,
 		seq_printf(m, "  POS: %08x\n", error->cursor[i].position);
 		seq_printf(m, "  BASE: %08x\n", error->cursor[i].base);
 	}
+
+	for (i = 0; i < error->num_transcoders; i++) {
+		seq_printf(m, "  CPU transcoder: %c\n",
+			   transcoder_name(error->transcoder[i].cpu_transcoder));
+		seq_printf(m, "  CONF: %08x\n", error->transcoder[i].conf);
+		seq_printf(m, "  HTOTAL: %08x\n", error->transcoder[i].htotal);
+		seq_printf(m, "  HBLANK: %08x\n", error->transcoder[i].hblank);
+		seq_printf(m, "  HSYNC: %08x\n", error->transcoder[i].hsync);
+		seq_printf(m, "  VTOTAL: %08x\n", error->transcoder[i].vtotal);
+		seq_printf(m, "  VBLANK: %08x\n", error->transcoder[i].vblank);
+		seq_printf(m, "  VSYNC: %08x\n", error->transcoder[i].vsync);
+	}
 }
 #endif
-- 
1.8.1.2

