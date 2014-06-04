Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaFDIBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:01:34 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54306 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaFDIBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:01:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Reichel <sre@kernel.org>
Cc: Carlos Chinea <carlos.chinea@nokia.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] hsi: omap_ssi_port: use normal module refcounting
Date: Wed, 04 Jun 2014 10:00:59 +0200
Message-ID: <4579153.ES6XlsZ43F@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7426698.eEpYu3o0WK@wuerfel>
References: <7426698.eEpYu3o0WK@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:chzBIY1byMuxca8CpwyUksxcTEeiFaYx3ZYR7gEq99/
 U+ddI86fDURgkszpHNnYXjA0vSHR35AZlV5ktQclUq7wkd24BB
 6yZrWb/GfELUWSNDE5HL7NcpQqvhQKMamMNm4nCqhRuxx6F2jt
 LaD5fOPbxJJSRpTOLcBlmA9FbAWsclKa/Wsa+vuboylpkpj/DX
 vOEbriiGkyCgfZXGVVFXGkyFxB3eirijva9f6cR69ZWGvSy8Dp
 xfvcwjQgzGKjZbVv21B2sZuruj1mLBTkRBDGEgzFKLcXiSSbwe
 xj/Cwn9/L3gJ6ITfRosZGlENNh3ZatvFF2LojU2eDP89JhaksX
 llPFIUeOpGZAyGMtfL9M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ref_module() function is used for internal housekeeping of the
module code, it's not normally used by subsystems or device drivers,
and the use of ref_module in the omap_ssi_port driver causes a link
build error when modules are disabled:

hsi/controllers/omap_ssi_port.c: In function 'ssi_port_probe':
hsi/controllers/omap_ssi_port.c:1119:2: error: implicit declaration of function 'ref_module' [-Werror=implicit-function-declaration]

This changes the omap_ssi_port driver to use try_module_get()
and module_put() instead, which is the normal way to ensure that
the driver providing a device used in another module does not
go away.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Carlos Chinea <carlos.chinea@nokia.com>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
v2: fix a stupid typo, I accidentally sent out the wrong version of the patch

diff --git a/drivers/hsi/controllers/omap_ssi_port.c b/drivers/hsi/controllers/omap_ssi_port.c
index b8693f0..29aea0b 100644
--- a/drivers/hsi/controllers/omap_ssi_port.c
+++ b/drivers/hsi/controllers/omap_ssi_port.c
@@ -1116,8 +1116,7 @@ static int __init ssi_port_probe(struct platform_device *pd)
 
 	dev_dbg(&pd->dev, "init ssi port...\n");
 
-	err = ref_module(THIS_MODULE, ssi->owner);
-	if (err) {
+	if (!try_module_get(ssi->owner)) {
 		dev_err(&pd->dev, "could not increment parent module refcount (err=%d)\n",
 			err);
 		return -ENODEV;
@@ -1254,6 +1253,7 @@ static int __exit ssi_port_remove(struct platform_device *pd)
 
 	omap_ssi->port[omap_port->port_id] = NULL;
 	platform_set_drvdata(pd, NULL);
+	module_put(ssi->owner);
 	pm_runtime_disable(&pd->dev);
 
 	return 0;

