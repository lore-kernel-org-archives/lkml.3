Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab3ERDNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:13:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab3ERDAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:17 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zue9PK2t4PsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=YDiVQaSWupwA:10 a=20KFwNOVAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=6VA72Ak_qQeqvqjNANgA:9 a=TX61lexfZa8A:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021658.878301853@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: <stable@kernel.org>, Anisse Astier <anisse@astier.eu>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [ 107/136 ] drm/gma500: fix backlight hotkeys behaviour on netbooks
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0107-drm-gma500-fix-backlight-hotkeys-behaviour-on-netboo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

[ Upstream commit e127dc28cc3057575da0216cde85687153ca180f ]

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
Cc: stable@kernel.org
Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/gma500/psb_irq.c |    2 +-
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
1.7.10.4


