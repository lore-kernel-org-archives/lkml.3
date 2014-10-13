Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaJMCax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:30:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbaJMCau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Gerlach <d-gerlach@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.17 21/25] usb: musb: dsps: kill OTG timer on suspend
Date: Mon, 13 Oct 2014 04:25:14 +0200
Message-Id: <20141013022455.193561947@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 468bcc2a2ca071f652009d2d20d97f2437630cae upstream.

if we don't make sure to kill the timer, it could
expire after we have already gated our clocks.

That will trigger a Data Abort exception because
we would try to access register while clock is gated.

Fix that bug.

Fixes 869c597 (usb: musb: dsps: add support for suspend and resume)
Tested-by: Dave Gerlach <d-gerlach@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_dsps.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -870,6 +870,7 @@ static int dsps_suspend(struct device *d
 	struct musb *musb = platform_get_drvdata(glue->musb);
 	void __iomem *mbase = musb->ctrl_base;
 
+	del_timer_sync(&glue->timer);
 	glue->context.control = dsps_readl(mbase, wrp->control);
 	glue->context.epintr = dsps_readl(mbase, wrp->epintr_set);
 	glue->context.coreintr = dsps_readl(mbase, wrp->coreintr_set);
@@ -895,6 +896,7 @@ static int dsps_resume(struct device *de
 	dsps_writel(mbase, wrp->mode, glue->context.mode);
 	dsps_writel(mbase, wrp->tx_mode, glue->context.tx_mode);
 	dsps_writel(mbase, wrp->rx_mode, glue->context.rx_mode);
+	setup_timer(&glue->timer, otg_timer, (unsigned long) musb);
 
 	return 0;
 }


