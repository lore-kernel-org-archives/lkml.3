Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaIVOSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:18:15 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48014 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaIVOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:16:23 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org, kernel@stlinux.com,
        linux-serial@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH tty-next] serial: asc: Conditionally use readl_relaxed (COMPILE_TEST)
Date: Mon, 22 Sep 2014 15:16:07 +0100
Message-Id: <1411395367-17124-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 08177ece596c ("serial: asc: Adopt readl_/writel_relaxed()) is
upsetting the build bots primarily because m68k allmodconfig builds
have regressed. This is due to the unconditional use of readl_relaxed()
which, although documented, does not currently exist for m68k.

This is trivially fixable for st-asc because we can just update the
asc_in() accessor to make this conditional.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
Cc: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Jiri Slaby <jslaby@suse.cz>
---

Notes:
    Will Deacon is working on a patchset to introduce readl_relaxed (and
    writel_relaxed) to all platforms. I intend to keep an eye on this
    work and will remove the conditional code in asc_in/out() when this
    is possible.

 drivers/tty/serial/st-asc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index a3fc167..a316584 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -151,7 +151,11 @@ static inline struct asc_port *to_asc_port(struct uart_port *port)

 static inline u32 asc_in(struct uart_port *port, u32 offset)
 {
+#ifdef readl_relaxed
 	return readl_relaxed(port->membase + offset);
+#else
+	return readl(port->membase + offset);
+#endif
 }

 static inline void asc_out(struct uart_port *port, u32 offset, u32 value)
--
1.9.3

