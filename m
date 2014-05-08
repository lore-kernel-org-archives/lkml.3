Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaEHO5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:57:09 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55831 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaEHO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:57:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 1/2] input: fix ps2/serio module dependency
Date: Thu,  8 May 2014 16:56:26 +0200
Message-Id: <1399560990-1402858-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:zb63cN4wU0WMphDBs0q3kDxg5CRz/9nHuID+KBdIp3z
 vXGQ0D9/cTPcLJzrIkohIfzDuvlzkD5Wq2HhISqz6bK/u/8g8e
 B5Ju1JmnkaGOpTqjvfaaxtgIOKkZQBFUsGCUfG88sik8v7AA5k
 OJ9WB7Q4f4ImAspxpT2U5T1nH2ueNDYxXiWqyZsSyeIadTaJZm
 mJcZYgFBAeUquTXkr6SZ9q5XEU3pJ4oRKDtYwF4Ai5nk60B0Z5
 /WrDTYsborX5r6k5meTsUC60AWrfoqBFbf5CNKVWOfBQfVtYKR
 mqKc9NSO2k2csI819cHRMLHoYpqAuWrX731LvnC5J138G1N9fs
 SfRwMvsHTNVQ9tRI7+VGzgjkOpWthMZAhTDXu6fUy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ps2 mouse and keyboard drivers use the "serio" framework that
they correctly select in Kconfig, and that in turn depends on the
i8042 driver, which is also allowed to be disabled for architectures
that don't have an i8042.

However, Kconfig also allows i8042 to be built as a module while
the serio framework is built-in, which causes this link error:

drivers/built-in.o: In function `ps2_begin_command':
:(.text+0x26b6cc): undefined reference to `i8042_check_port_owner'
:(.text+0x26b6d4): undefined reference to `i8042_lock_chip'
drivers/built-in.o: In function `ps2_end_command':
:(.text+0x26b734): undefined reference to `i8042_check_port_owner'
:(.text+0x26b73c): undefined reference to `i8042_unlock_chip'

On x86, a specific 'select SERIO_I8042' takes care of it, but
not on the other architecture that potentially have a u8042.

This patch changes the Kconfig logic to ensure that whenever
there is an i8042, it does get used for the serio driver, avoiding
the link error above.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
 drivers/input/keyboard/Kconfig | 2 +-
 drivers/input/mouse/Kconfig    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 4f115db..dd2435a 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -71,7 +71,7 @@ config KEYBOARD_ATKBD
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86
+	select SERIO_I8042 if X86 || ARCH_MIGHT_HAVE_PC_SERIO
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you want to use a standard AT or PS/2 keyboard. Usually
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index effa9c5..cf534ee 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -17,7 +17,7 @@ config MOUSE_PS2
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86
+	select SERIO_I8042 if X86 || ARCH_MIGHT_HAVE_PC_SERIO
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you have a PS/2 mouse connected to your system. This
-- 
1.8.3.2

