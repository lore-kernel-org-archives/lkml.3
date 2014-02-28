Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaB1NVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:21:48 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:38841 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaB1NVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:21:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 2/2] serial: sh-sci: Add missing call to uart_remove_one_port() in failure path
Date: Fri, 28 Feb 2014 14:21:33 +0100
Message-Id: <1393593694-30262-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393593694-30262-1-git-send-email-geert@linux-m68k.org>
References: <1393593694-30262-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

If cpufreq_register_notifier() fails, we have to remove the port added by
sci_probe_single(), which is not done by sci_cleanup_single().

Else the serial port stays active from the point of view of the serial
subsystem, and it may crash when userspace getty is started, or when the
loadable driver module is unloaded.

This was introduced by commit 6dae14216c85eea13db7b12c469475c5d30e5499
("serial: sh-sci: Fix probe error paths").

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
This depends on "serial_core: Unregister console in uart_remove_one_port()"
when using a serial console.
---
 drivers/tty/serial/sh-sci.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index be33d2b0613b..7958115e6a51 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2564,6 +2564,7 @@ static int sci_probe(struct platform_device *dev)
 	ret = cpufreq_register_notifier(&sp->freq_transition,
 					CPUFREQ_TRANSITION_NOTIFIER);
 	if (unlikely(ret < 0)) {
+		uart_remove_one_port(&sci_uart_driver, &sp->port);
 		sci_cleanup_single(sp);
 		return ret;
 	}
-- 
1.7.9.5

