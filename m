Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaICMBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:01:09 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:57850 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbaICMBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:01:07 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, Jiri Slaby <jslaby@suse.cz>,
        kernel@stlinux.com, linux-serial@vger.kernel.org
Subject: [PATCH 3.17-rc3] serial: asc: Adopt readl_/writel_relaxed()
Date: Wed,  3 Sep 2014 13:00:51 +0100
Message-Id: <1409745651-3247-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
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
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: kernel@stlinux.com
Cc: linux-serial@vger.kernel.org
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Acked-by: Peter Griffin <peter.griffin@linaro.org>
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
index 8b2d735..adadbc1 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -151,12 +151,12 @@ static inline struct asc_port *to_asc_port(struct uart_port *port)

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

