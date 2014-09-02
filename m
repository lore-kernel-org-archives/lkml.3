Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaIBNHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:07:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56997 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaIBNHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:07:32 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, kernel@stlinux.com,
        linux-serial@vger.kernel.org
Subject: [PATCH v11 17/19] serial: asc: Adopt readl_/writel_relaxed()
Date: Tue,  2 Sep 2014 14:00:51 +0100
Message-Id: <1409662853-29313-18-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The architectures where this peripheral exists (ARM and SH) have expensive
implementations of writel(), reliant on spin locks and explicit L2 cache
management. These architectures provide a cheaper writel_relaxed() which
is much better suited to peripherals that do not perform DMA. The
situation with readl()/readl_relaxed()is similar although less acute.

This driver does not use DMA and will be more power efficient and more
robust (due to absense of spin locks during console I/O) if it uses the
relaxed variants.

This change means the driver is no longer portable and therefore no
longer suitable for compile testing.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
Cc: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: kernel@stlinux.com
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/Kconfig  | 2 +-
 drivers/tty/serial/st-asc.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 26cec64d..e9b1735 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1527,7 +1527,7 @@ config SERIAL_FSL_LPUART_CONSOLE
 config SERIAL_ST_ASC
 	tristate "ST ASC serial port support"
 	select SERIAL_CORE
-	depends on ARM || COMPILE_TEST
+	depends on ARM
 	help
 	  This driver is for the on-chip Asychronous Serial Controller on
 	  STMicroelectronics STi SoCs.
diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index 2b5eb6e..df709ee 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -152,12 +152,12 @@ static inline struct asc_port *to_asc_port(struct uart_port *port)
 
 static inline u32 asc_in(struct uart_port *port, u32 offset)
 {
-	return readl(port->membase + offset);
+	return readl_relaxed(port->membase + offset);
 }
 
 static inline void asc_out(struct uart_port *port, u32 offset, u32 value)
 {
-	writel(value, port->membase + offset);
+	writel_relaxed(value, port->membase + offset);
 }
 
 /*
-- 
1.9.3

