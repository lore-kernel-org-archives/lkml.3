Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab3ETLVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:21:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3ETKwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anisse Astier <anisse@astier.eu>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 026/115] drm/gma500: fix backlight hotkeys behaviour on netbooks
Date: Mon, 20 May 2013 11:50:26 +0100
Message-Id: <1369047116-9378-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit e127dc28cc3057575da0216cde85687153ca180f upstream.

Backlight hotkeys weren't working before on certain cedartrail laptops.

The source of this problem is that the hotkeys' ASLE opregion interrupts
were simply ignored. Driver seemed to expect the interrupt to be
associated with a pipe, but it wasn't.

Accepting the ASLE interrupt without an associated pipe event flag fixes
the issue, the backlight code is called when needed, making the
brightness keys work properly.

[patrik: This patch affects irq handling on any netbook with opregion support]

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=833597
Reference: http://lists.freedesktop.org/archives/dri-devel/2012-July/025279.html
Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/gma500/psb_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/psb_irq.c b/drivers/gpu/drm/gma500/psb_irq.c
index 8652cdf..029eccf 100644
--- a/drivers/gpu/drm/gma500/psb_irq.c
+++ b/drivers/gpu/drm/gma500/psb_irq.c
@@ -211,7 +211,7 @@ irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
 
 	vdc_stat = PSB_RVDC32(PSB_INT_IDENTITY_R);
 
-	if (vdc_stat & _PSB_PIPE_EVENT_FLAG)
+	if (vdc_stat & (_PSB_PIPE_EVENT_FLAG|_PSB_IRQ_ASLE))
 		dsp_int = 1;
 
 	/* FIXME: Handle Medfield
-- 
1.8.1.2

