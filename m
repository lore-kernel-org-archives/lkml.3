Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbbAPXdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 18:33:43 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46082 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbAPXdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 18:33:32 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R . Rodriguez" <mcgrof@suse.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 5/8] driver-core: platform_driver_probe() must probe synchronously
Date: Fri, 16 Jan 2015 15:33:14 -0800
Message-Id: <1421451197-19723-6-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because it checks, after trying to register driver, if there are any
devices that driver successfully bound to, driver's probe routine must
be run synchronously.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/base/platform.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 9421fed..5c9e1b6 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -604,6 +604,19 @@ int __init_or_module __platform_driver_probe(struct platform_driver *drv,
 {
 	int retval, code;
 
+	if (drv->driver.probe_type == PROBE_PREFER_ASYNCHRONOUS) {
+		pr_err("%s: drivers registered with %s can not be probed asynchronously\n",
+			 drv->driver.name, __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * We have to run our probes synchronously because we check if
+	 * we find any devices to bind to and exit with error if there
+	 * are any.
+	 */
+	drv->driver.probe_type = PROBE_FORCE_SYNCHRONOUS;
+
 	/*
 	 * Prevent driver from requesting probe deferral to avoid further
 	 * futile probe attempts.
-- 
2.2.0.rc0.207.ga3a616c

