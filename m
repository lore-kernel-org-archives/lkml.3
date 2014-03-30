Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaC3XsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:48:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371AbaC3Xnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Finn Thain" <fthain@telegraphics.com.au>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.387290928@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 181/200] TTY: pmac_zilog, check existence of ports in
 pmz_console_init()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/pmac_zilog.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -2198,6 +2198,9 @@ static int __init pmz_console_init(void)
 	/* Probe ports */
 	pmz_probe();
 
+	if (pmz_ports_count == 0)
+		return -ENODEV;
+
 	/* TODO: Autoprobe console based on OF */
 	/* pmz_console.index = i; */
 	register_console(&pmz_console);

