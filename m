Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbaGXMD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:03:59 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:34631 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbaGXMDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:03:54 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com
Subject: [PATCH 1/2] serial: st-asc: Don't call BUG in asc_console_setup()
Date: Thu, 24 Jul 2014 14:02:55 +0200
Message-Id: <1406203376-18203-2-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406203376-18203-1-git-send-email-maxime.coquelin@st.com>
References: <1406203376-18203-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-24_03:2014-07-24,2014-07-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prevent an asc instance to be used as early console, BUG_ON is
used on either mapbase or membase being NULL.

Problem is that this condition is also true when we set console to be a ttyASx
different to the first asc instance being probed.

Instead of calling BUG_ON, it now returns -ENXIO when either mapbase or
membase is NULL.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/tty/serial/st-asc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index f48b1cc..2369bc0 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -849,7 +849,8 @@ static int asc_console_setup(struct console *co, char *options)
 	 * this to be called during the uart port registration when the
 	 * driver gets probed and the port should be mapped at that point.
 	 */
-	BUG_ON(ascport->port.mapbase == 0 || ascport->port.membase == NULL);
+	if (ascport->port.mapbase == 0 || ascport->port.membase == NULL)
+		return -ENXIO;
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
-- 
1.9.1

