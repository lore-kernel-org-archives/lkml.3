Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaAMO10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:27:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51263 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaAMOZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 20/96] TTY: pmac_zilog, check existence of ports in pmz_console_init()
Date: Mon, 13 Jan 2014 14:23:43 +0000
Message-Id: <1389623099-18783-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit dc1dc2f8a5dd863bf2e79f338fc3ae29e99c683a upstream.

When booting a multi-platform m68k kernel on a non-Mac with "console=ttyS0"
on the kernel command line, it crashes with:

Unable to handle kernel NULL pointer dereference at virtual address   (null)
Oops: 00000000
PC: [<0013ad28>] __pmz_startup+0x32/0x2a0
...
Call Trace: [<002c5d3e>] pmz_console_setup+0x64/0xe4

The normal tty driver doesn't crash, because init_pmz() checks
pmz_ports_count again after calling pmz_probe().

In the serial console initialization path, pmz_console_init() doesn't do
this, causing the driver to crash later.

Add a check for pmz_ports_count to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/pmac_zilog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 333c8d0..3f93c47 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -2051,6 +2051,9 @@ static int __init pmz_console_init(void)
 	/* Probe ports */
 	pmz_probe();
 
+	if (pmz_ports_count == 0)
+		return -ENODEV;
+
 	/* TODO: Autoprobe console based on OF */
 	/* pmz_console.index = i; */
 	register_console(&pmz_console);
-- 
1.8.3.2

