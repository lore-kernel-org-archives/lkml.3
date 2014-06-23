Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaFWBc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:32:56 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39772 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbaFWBcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:54 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 12/18] staging/lustre/osc: osc_extent_truncate()) ASSERTION( !ext->oe_urgent ) failed
Date: Sun, 22 Jun 2014 21:32:16 -0400
Message-Id: <1403487142-4880-13-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andriy Skulysh <Andriy_Skulysh@xyratex.com>

The bug was caused by race between truncate & fsync.
osc_extent_wait() doesn't takes into account oe_trunc_pending
during setting oe_urgent. The race arises after
osc_object_unlock().
osc_extent_wait() should ignore extents with oe_trunc_pending
while waiting for OES_INV. osc_cache_truncate_end() will set
oe_urgent and call osc_io_unplug_async()

Signed-off-by: Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Reviewed-on: http://review.whamcloud.com/10204
Xyratex-bug-id: LELUS-239
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4852
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_cache.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index 00f38ee..f075b69 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -871,7 +871,8 @@ static int osc_extent_wait(const struct lu_env *env, struct osc_extent *ext,
 	LASSERT(sanity_check_nolock(ext) == 0);
 	/* `Kick' this extent only if the caller is waiting for it to be
 	 * written out. */
-	if (state == OES_INV && !ext->oe_urgent && !ext->oe_hp) {
+	if (state == OES_INV && !ext->oe_urgent && !ext->oe_hp &&
+	    !ext->oe_trunc_pending) {
 		if (ext->oe_state == OES_ACTIVE) {
 			ext->oe_urgent = 1;
 		} else if (ext->oe_state == OES_CACHE) {
@@ -922,8 +923,8 @@ static int osc_extent_truncate(struct osc_extent *ext, pgoff_t trunc_index,
 	int		    rc       = 0;
 
 	LASSERT(sanity_check(ext) == 0);
-	LASSERT(ext->oe_state == OES_TRUNC);
-	LASSERT(!ext->oe_urgent);
+	EASSERT(ext->oe_state == OES_TRUNC, ext);
+	EASSERT(!ext->oe_urgent, ext);
 
 	/* Request new lu_env.
 	 * We can't use that env from osc_cache_truncate_start() because
-- 
1.9.0

