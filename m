Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab3EIWdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:33:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab3EIWdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anisse Astier <anisse@astier.eu>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [ 33/73] drm/gma500: fix backlight hotkeys behaviour on netbooks
Date: Thu,  9 May 2013 15:31:56 -0700
Message-Id: <20130509222801.554753171@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/gma500/psb_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/gma500/psb_irq.c
+++ b/drivers/gpu/drm/gma500/psb_irq.c
@@ -211,7 +211,7 @@ irqreturn_t psb_irq_handler(DRM_IRQ_ARGS
 
 	vdc_stat = PSB_RVDC32(PSB_INT_IDENTITY_R);
 
-	if (vdc_stat & _PSB_PIPE_EVENT_FLAG)
+	if (vdc_stat & (_PSB_PIPE_EVENT_FLAG|_PSB_IRQ_ASLE))
 		dsp_int = 1;
 
 	/* FIXME: Handle Medfield


