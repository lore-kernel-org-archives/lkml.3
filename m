Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaLRRrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:47:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:59711 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaLRRrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:47:23 -0500
Date: Thu, 18 Dec 2014 18:47:12 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        uwe@kleine-koenig.org
Subject: [PATCH] tty: serial: 8250: omap: add ttySx console if the user didn't
Message-ID: <20141218174712.GA26632@linutronix.de>
References: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
 <20141129094823.GA10840@linutronix.de>
 <20141129173418.GY2817@atomide.com>
 <20141201140914.728aaa46@lxorguk.ukuu.org.uk>
 <20141201231338.GA14524@fuloong-minipc.musicnaut.iki.fi>
 <20141202015118.GA1891@saruman>
 <20141205135133.37fb96f6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141205135133.37fb96f6@lxorguk.ukuu.org.uk>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch invokes add_preferred_console() with ttyS based on ttyO
arguments if the user didn't specify it on its own. This ensures that
the user will see the kernel booting on his serial console in case he
forgot to update the command line.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

While trying to to make a proxy driver like Alan suggested I wasn't sure
how to obtain the ttyS console via "official" API. Then I stumbled upon
update_console_cmdline() and then add_preferred_console(). 

 drivers/tty/serial/8250/8250_omap.c | 40 +++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig     | 19 ++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 336602eb453e..78401fbc823b 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1248,6 +1248,46 @@ static int omap8250_runtime_resume(struct device *dev)
 }
 #endif
 
+#ifdef CONFIG_SERIAL_8250_OMAP_TTYO_FIXUP
+static int __init omap8250_console_fixup(void)
+{
+	char *omap_str;
+	char *options;
+	u8 idx;
+
+	if (strstr(boot_command_line, "console=ttyS"))
+		/* user set a ttyS based name for the console */
+		return 0;
+
+	omap_str = strstr(boot_command_line, "console=ttyO");
+	if (!omap_str)
+		/* user did not set ttyO based console, so we don't care */
+		return 0;
+
+	omap_str += 12;
+	if ('0' <= *omap_str && *omap_str <= '9')
+		idx = *omap_str - '0';
+	else
+		return 0;
+
+	omap_str++;
+	if (omap_str[0] == ',') {
+		omap_str++;
+		options = omap_str;
+	} else {
+		options = NULL;
+	}
+
+	add_preferred_console("ttyS", idx, options);
+	pr_err("WARNING: Your 'console=ttyO%d' has been replaced by 'ttyS%d'\n",
+	       idx, idx);
+	pr_err("This ensures that you still see kernel messages. Please\n");
+	pr_err("update your kernel commandline.\n");
+	return 0;
+}
+console_initcall(omap8250_console_fixup);
+#endif
+
 static const struct dev_pm_ops omap8250_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(omap8250_suspend, omap8250_resume)
 	SET_RUNTIME_PM_OPS(omap8250_runtime_suspend,
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 0fcbcd29502f..87adf08b9b6b 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -308,6 +308,25 @@ config SERIAL_8250_OMAP
 
 	  This driver uses ttyS instead of ttyO.
 
+config SERIAL_8250_OMAP_TTYO_FIXUP
+	bool "Replace ttyO with ttyS"
+	depends on SERIAL_8250_OMAP=y && SERIAL_8250_CONSOLE
+	default y
+	help
+	  This option replaces the "console=ttyO" argument with the matching
+	  ttyS argument if the user did not specified it on the command line.
+	  This ensures that the user can see the kernel output during boot
+	  which he wouldn't see otherwise. The getty has still to be configured
+	  for ttyS instead of ttyO regardless of this option.
+	  This option is intended for people who "automatically" enable this
+	  driver without knowing that this driver requires a different console=
+	  argument. If you read this, please keep this option disabled and
+	  instead update your kernel command line. If you prepare a kernel for a
+	  distribution or other kind of larger user base then you probably want
+	  to keep this option enabled. Otherwise people might complain about a
+	  not booting kernel because the serial console remains silent in case
+	  they forgot to update the command line.
+
 config SERIAL_8250_FINTEK
 	tristate "Support for Fintek F81216A LPC to 4 UART"
 	depends on SERIAL_8250 && PNP
-- 
2.1.3

