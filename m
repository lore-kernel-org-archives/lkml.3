Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaGFQqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:46:00 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:34958 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaGFQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:45:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2] tty: serial: msm_serial.c:  Cleaning up uninitialized variables
Date: Sun,  6 Jul 2014 18:47:12 +0200
Message-Id: <1404665232-14311-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set reasonable initial value of some variables, in case
they do not get set to something otherwise.
And I've also added a plausibility control of the values.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/tty/serial/msm_serial.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 72000a6..4491108 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -917,7 +917,7 @@ static int __init msm_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port;
 	struct msm_port *msm_port;
-	int baud, flow, bits, parity;
+	int baud = 115200, flow = 'n', bits = 8, parity = 'n';
 
 	if (unlikely(co->index >= UART_NR || co->index < 0))
 		return -ENXIO;
@@ -930,17 +930,21 @@ static int __init msm_console_setup(struct console *co, char *options)
 
 	msm_init_clock(port);
 
-	if (options)
+	if (options) {
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
+		if (baud < 300 || baud > 115200)
+			baud = 115200;
+		if (NULL == strchr("noeNOE", parity))
+			parity = 'n';
+		if (bits != 7)
+			bits = 8;
+		if (flow != 'r')
+			flow = 'n';
+	}
 
-	bits = 8;
-	parity = 'n';
-	flow = 'n';
 	msm_write(port, UART_MR2_BITS_PER_CHAR_8 | UART_MR2_STOP_BIT_LEN_ONE,
 		  UART_MR2);	/* 8N1 */
 
-	if (baud < 300 || baud > 115200)
-		baud = 115200;
 	msm_set_baud_rate(port, baud);
 
 	msm_reset(port);
-- 
1.7.10.4

