Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaENO4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:56:08 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54986 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaENO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:56:04 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4/4] serial: kgdb_nmi: Improve console integration with KDB I/O
Date: Wed, 14 May 2014 15:55:35 +0100
Message-Id: <1400079335-32125-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400079335-32125-1-git-send-email-daniel.thompson@linaro.org>
References: <1400079335-32125-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kgdb_nmi_tty_enabled is used for two unrelated purposes, namely to
suppress normal TTY input handling and to suppress console output
(although it has no effect at all on TTY output). A much better way to
handle muting the console is to not have to mute it in the first place!
That's what this patch does.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/tty/serial/kgdb_nmi.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
index 20d21d0..cfadf29 100644
--- a/drivers/tty/serial/kgdb_nmi.c
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -44,13 +44,22 @@ MODULE_PARM_DESC(magic, "magic sequence to enter NMI debugger (default $3#33)");
 
 static bool kgdb_nmi_tty_enabled;
 
+static int kgdb_nmi_console_setup(struct console *co, char *options)
+{
+	/* The NMI console uses the dbg_io_ops to issue console messages. To
+	 * avoid duplicate messages during kdb sessions we must inform kdb's
+	 * I/O utilities that messages sent to the console will automatically
+	 * be displayed on the dbg_io.
+	 */
+	dbg_io_ops->is_console = true;
+
+	return 0;
+}
+
 static void kgdb_nmi_console_write(struct console *co, const char *s, uint c)
 {
 	int i;
 
-	if (!kgdb_nmi_tty_enabled || atomic_read(&kgdb_active) >= 0)
-		return;
-
 	for (i = 0; i < c; i++)
 		dbg_io_ops->write_char(s[i]);
 }
@@ -65,6 +74,7 @@ static struct tty_driver *kgdb_nmi_console_device(struct console *co, int *idx)
 
 static struct console kgdb_nmi_console = {
 	.name	= "ttyNMI",
+	.setup  = kgdb_nmi_console_setup,
 	.write	= kgdb_nmi_console_write,
 	.device	= kgdb_nmi_console_device,
 	.flags	= CON_PRINTBUFFER | CON_ANYTIME | CON_ENABLED,
-- 
1.9.0

