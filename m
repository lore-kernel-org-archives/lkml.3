Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaDRRSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:18:54 -0400
Received: from mail-qg0-f74.google.com ([209.85.192.74]:36465 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaDRRSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:18:50 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Doug Anderson <dianders@chromium.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kdb: Put a cr before lf when working w/ a non open console port
Date: Fri, 18 Apr 2014 10:17:28 -0700
Message-Id: <1397841448-12942-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In (efe2f29 kgdboc,kdb: Allow kdb to work on a non open console port)
support was added to directly use the "write_char" functions when
doing kdb over a non-open console port.  This is great, but it ends up
bypassing the normal code in uart_console_write() that adds a carriage
return before any newlines.

Add similar code in kdb so we don't get things like:
[0]kdb>
       [0]kdb>
              [0]kdb>

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 kernel/debug/kdb/kdb_io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 14ff484..513ed44 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -698,6 +698,9 @@ kdb_printit:
 			len = retlen;
 			cp = kdb_buffer;
 			while (len--) {
+				if (*cp == '\n')
+					dbg_io_ops->write_char('\r');
+
 				dbg_io_ops->write_char(*cp);
 				cp++;
 			}
@@ -759,6 +762,9 @@ kdb_printit:
 			len = strlen(moreprompt);
 			cp = moreprompt;
 			while (len--) {
+				if (*cp == '\n')
+					dbg_io_ops->write_char('\r');
+
 				dbg_io_ops->write_char(*cp);
 				cp++;
 			}
-- 
1.9.1.423.g4596e3a

