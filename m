Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbaAFWp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:45:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462AbaAFWmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.4 05/43] TTY: pmac_zilog, check existence of ports in pmz_console_init()
Date: Mon,  6 Jan 2014 14:39:22 -0800
Message-Id: <20140106223942.412026164@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/serial/pmac_zilog.c |    3 +++
 1 file changed, 3 insertions(+)

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


