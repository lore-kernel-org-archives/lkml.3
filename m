Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaDEAYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:24:22 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:64698 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaDEAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:24:14 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>
Cc: Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: [RESEND PATCH v3 6/9] tty: xuartps: Don't write IRQ disable register to enable interrupts
Date: Fri,  4 Apr 2014 17:23:42 -0700
Message-Id: <1396657425-31029-6-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
In-Reply-To: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A comment states, that, according to the data sheet, to enable
interrupts the disable register should be written, but the enable
register could be left untouched. And it suspsects a HW bug requiring
to write both.
Reviewing the data sheet, these statements seem wrong. Just as one would
expect. Writing to the enable/disable register enables/disables
interrupts.
Hence the misleading comment and needless write to the disable register
are removed from the enable sequence.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Tested-by: Michal Simek <michal.simek@xilinx.com>
---
I added a few lines to comment the change and altered the summary line.
In case this causes issues it should show up a little easier as a
candidate to revert.

Changes in v3: None
Changes in v2: None

---
 drivers/tty/serial/xilinx_uartps.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index b182ab8cfd07..f9a2c2fc03c4 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1085,11 +1085,7 @@ static void xuartps_console_write(struct console *co, const char *s,
 
 	xuartps_writel(ctrl, XUARTPS_CR_OFFSET);
 
-	/* restore interrupt state, it seems like there may be a h/w bug
-	 * in that the interrupt enable register should not need to be
-	 * written based on the data sheet
-	 */
-	xuartps_writel(~imr, XUARTPS_IDR_OFFSET);
+	/* restore interrupt state */
 	xuartps_writel(imr, XUARTPS_IER_OFFSET);
 
 	if (locked)
-- 
1.9.1.1.gbb9f595

