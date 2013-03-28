Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3C1VKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:10:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3C1VKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:10:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] usb: ehci: mark unlink_empty_async_suspended() as __maybe_unused
Date: Thu, 28 Mar 2013 21:09:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu
References: <1364362080-8489-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1364362080-8489-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303282109.47130.arnd@arndb.de>
X-Provags-ID: V02:K0:ctAxc6qwwbd1TVqJ8RU9cICUvNqw/1AIEkq98mVJ6sC
 fhqpOKyNDHwTRHeH4RBq8OBWs5cT1TAUG9mOGXB0+NAYtnJaxh
 RgVTlNSLbYCSMZZ8bneBk+PchnCgJnS9sdJAvNRKWGeUPJ2Fxs
 DncefPfxVzh5uf5+1exsNmMHavlgKah4NBj5i6O/QqF5p47BE+
 zRV4KunCdIEJJhNcFsQTX20RhDcTQxnmS4Edm00JiFzJBoJKiQ
 B3hbn+YBM5cWTMfRdH4kpeZxpF5aLy6jBMbHcn/iNQw8MeECh7
 TEziOYxL+1WLJI8O/kL840/8axKgMxQigpAnqbVaYE/4Jj4nX/
 0N+zZzgfstrD1+s8FXhM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 4d053fdac3 "usb: ehci: unlink_empty_async_suspended() only used
with CONFIG_PM" tried to hide the unlink_empty_async_suspended function
inside of an #ifdef to work around an unused function warning.

Unfortunately that had the effect of introducing a new warning:

drivers/usb/host/ehci-q.c:1297:13: warning: 'unlink_empty_async_suspended' 
	declared 'static' but never defined [-Wunused-function]

While we could add another #ifdef around the function declaration to avoid
this, a nicer solution is to mark it as __maybe_unused, which will let
gcc silently drop the function definition when it is not needed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 7562d76..d34b399 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1293,9 +1293,8 @@ static void unlink_empty_async(struct ehci_hcd *ehci)
 	}
 }
 
-#ifdef CONFIG_PM
 /* The root hub is suspended; unlink all the async QHs */
-static void unlink_empty_async_suspended(struct ehci_hcd *ehci)
+static void __maybe_unused unlink_empty_async_suspended(struct ehci_hcd *ehci)
 {
 	struct ehci_qh		*qh;
 
@@ -1306,7 +1305,6 @@ static void unlink_empty_async_suspended(struct ehci_hcd *ehci)
 	}
 	start_iaa_cycle(ehci);
 }
-#endif
 
 /* makes sure the async qh will become idle */
 /* caller must own ehci->lock */
