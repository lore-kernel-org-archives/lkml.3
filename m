Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3AYWsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:48:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3AYWqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:46:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 17/19] input/joystick: use get_cycles on ARM
Date: Fri, 25 Jan 2013 22:44:16 +0000
Message-Id: <1359153858-31992-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3zPCsW45a+IyIu7VGe/fP3dkSZWWHR7nfj1ySmOpKqU
 Ei0RUf3EFnE4ib/k5Gwkt58BqKvkznqI6jmKsyIRRlkNEBtWdy
 JhWT7GqRxvFk6MUJYINNdZ8jYgA6JJPGafAY6NGA1Xt3rR73tu
 EUOBecm2VjFmOVg3DW1nsk0byJwDABMjAzJAB3eoAA0adYGa7Q
 U3uzdvG/V9bBTTz1DVEpKeub1MJl7y3+ycdgS04y2CznGg9t+6
 C5ehv9mKh8OqGK+lP7Z14tLLjcO8OjyYlr4ZlnN+DMejsKOgFN
 XPgv1AJInnOmojGj5MI0v4KtFND/iQem/YRElQV/8nI5fhVeVN
 GctL+gJg1cGxrgR4dNXSRKLkMCbZmOvebeafACjEy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM normally has an accurate clock source, so
we can theoretically use analog joysticks more
accurately and at the same time avoid the
build warning

 #warning Precise timer not defined for this architecture.

from the joystick driver.

Now, why anybody would use that driver no ARM I have no
idea, but Ben Dooks enabled it in the s3c2410_defconfig
along with a bunch of other drivers, even though that
platform has neither ISA nor PCI support. It still
seems to be the right thing to fix this quirk.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 drivers/input/joystick/analog.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 358cd7e..9c3e3c1 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -158,14 +158,10 @@ static unsigned int get_time_pit(void)
 #define GET_TIME(x)	rdtscl(x)
 #define DELTA(x,y)	((y)-(x))
 #define TIME_NAME	"TSC"
-#elif defined(__alpha__)
+#elif defined(__alpha__) || defined(CONFIG_MN10300) || defined(CONFIG_ARM)
 #define GET_TIME(x)	do { x = get_cycles(); } while (0)
 #define DELTA(x,y)	((y)-(x))
-#define TIME_NAME	"PCC"
-#elif defined(CONFIG_MN10300)
-#define GET_TIME(x)	do { x = get_cycles(); } while (0)
-#define DELTA(x, y)	((x) - (y))
-#define TIME_NAME	"TSC"
+#define TIME_NAME	"get_cycles"
 #else
 #define FAKE_TIME
 static unsigned long analog_faketime = 0;
-- 
1.8.0

