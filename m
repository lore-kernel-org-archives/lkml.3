Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbaIZTfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:35:21 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:57320 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaIZTfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:35:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: [PATCH] mmc: atmel-mci: fix mismatched section on atmci_cleanup_slot
Date: Fri, 26 Sep 2014 21:34:58 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org
References: <1411467606-13041-1-git-send-email-pramod.gurav@smartplayin.com> <1411467606-13041-2-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1411467606-13041-2-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409262134.58457.arnd@arndb.de>
X-Provags-ID: V02:K0:nlHdPn/4DEhtRaswddCjD9Np6/9jhdg0nJXlQdDs+hE
 0obbUbSihe5YZn0Cz3O1Va8CH49TPnW+c/+YP3Mbl3DlLsVn5R
 fKUSls9kfop1lE3eVoM5L28e1MO1nq/yZoEqKwzcEsgTUo8Zm9
 UG/Le9mMh/xGS23+HpT6vqFGF+BpEG4y7omhaSqnTE1RUVr9VP
 diV9mQ4H58Zh0sBfXRGU2uCfKDF1t4WAgWmImVLaILIhz0MEAh
 +RTF/lOccg2L5iPiM6StLZIvimtplSjS9v04gs4Gnug2lgSozz
 nBA75mVMyKswoAKe0byV0R5D2M95X9caOwOo7ibxiKaiRn6e0h
 DJwGvy4iYkhSTk9+X7Ik=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of 528bc7808f4e ("mmc: atmel-mci: Release mmc resources on failure in probe"),
the atmci_probe() function calls atmci_cleanup_slot in the failure path.

This causes a new warning whenever the driver is built:

WARNING: drivers/mmc/host/built-in.o(.init.text+0xa04): Section mismatch in reference from the function atmci_probe() to the function .exit.text:atmci_cleanup_slot()
The function __init atmci_probe() references
a function __exit atmci_cleanup_slot().

Gcc correctly warns about this function getting dropped in the link stage
for the built-in case, which would cause undefined behavior when this error
path is hit. The solution is to simply drop the __exit annotation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 528bc7808f4e ("mmc: atmel-mci: Release mmc resources on failure in probe")

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 772ef5b0e4d5..974626087732 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2244,7 +2244,7 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	return 0;
 }
 
-static void __exit atmci_cleanup_slot(struct atmel_mci_slot *slot,
+static void atmci_cleanup_slot(struct atmel_mci_slot *slot,
 		unsigned int id)
 {
 	/* Debugfs stuff is cleaned up by mmc core */
