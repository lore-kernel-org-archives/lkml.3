Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbaE2ItP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:49:15 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45239 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449AbaE2ItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:49:08 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-serial@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Jiri Slaby <jslaby@suse.cz>,
        Dirk Behme <dirk.behme@de.bosch.com>
Subject: [PATCH tty-next v2 4/4] serial: kgdb_nmi: Improve console integration with KDB I/O
Date: Thu, 29 May 2014 09:48:46 +0100
Message-Id: <1401353326-14148-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401353326-14148-1-git-send-email-daniel.thompson@linaro.org>
References: <20140528200344.GA2750@kroah.com>
 <1401353326-14148-1-git-send-email-daniel.thompson@linaro.org>
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

