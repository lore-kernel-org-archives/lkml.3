Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbaGYRH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:07:27 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:43461 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaGYRH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:07:26 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: comedi: amplc_dio200_common: prevent extra free_irq()
Date: Fri, 25 Jul 2014 18:07:07 +0100
Message-Id: <1406308029-15712-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
References: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`dio200_detach()` in "amplc_dio200.c" calls
`amplc_dio200_common_detach()` in "amplc_dio200_common.c", followed by
`comedi_legacy_detach()` in "../drivers.c".  Both of those functions
call `free_irq()` if `dev->irq` is non-zero.  The second call produces a
warning message because the handler has already been freed.  Prevent
that by setting `dev->irq = 0` in `amplc_dio200_common_detach()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_dio200_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_dio200_common.c b/drivers/staging/comedi/drivers/amplc_dio200_common.c
index 78700e8..3592e58 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200_common.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200_common.c
@@ -1202,8 +1202,10 @@ void amplc_dio200_common_detach(struct comedi_device *dev)
 
 	if (!thisboard || !devpriv)
 		return;
-	if (dev->irq)
+	if (dev->irq) {
 		free_irq(dev->irq, dev);
+		dev->irq = 0;
+	}
 }
 EXPORT_SYMBOL_GPL(amplc_dio200_common_detach);
 
-- 
2.0.0

