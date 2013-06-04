Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3FDLxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:53:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3FDLxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:53:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] driver core: firmware loader: fix build error
Date: Tue, 04 Jun 2013 13:53:02 +0200
Message-ID: <1563703.RysIHVehbx@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:s+SbjkT95hQ74yKqcCOoCZUFa+HWv05sdcxR1QGU7Ui
 87CbWIg+UnuLlH94gXoRww1GavU2zDPbBvvGnTIPdryp3W7kns
 NaEAYuq73R797wtWGIMpxEpe4BembjNo2OkAY7+0pr7gUUxXNy
 pc1Ng48oj33XQGsiSQhgoyxunz4H2qn5ghRHfJARI4tkv7ZqCE
 19/GqjOvAdZWr4g1R7ZpB9UEBWgAXHDXZzi38JPoz+lzt6U95j
 yZK3ylqnOxq5EMfa6I+gWEUneeil/vj2V/wkfbJ70F2BEBOIfh
 h7HCs6pmDTUCYAvRYbALkssbOSzyyB2xx2VvUrCreyG3lNNUSP
 JlvxR08Q/MIK+DTFdrlM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch af5bc11e9 "driver core: firmware loader: kill FW_ACTION_NOHOTPLUG
requests before suspend" caused a regression for the case where
CONFIG_FW_LOADER_USER_HELPER is not enabled, because it adds
references to code that is not available in that configuration:

drivers/base/firmware_class.c: In function 'kill_requests_without_uevent':
drivers/base/firmware_class.c:1424:49: error: 'struct firmware_buf' has no member named 'pending_list'
  list_for_each_entry_safe(buf, next, &pending_fw_head, pending_list) {
drivers/base/firmware_class.c:1426:5: error: implicit declaration of function 'fw_load_abort' [-Werror=implicit-function-declaration]

This fixes the build error by making the new code conditional
as well. Found using ARM ape6evm_defconfig on today's linux-next.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c415043..6cca468 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1417,6 +1417,7 @@ static void __device_uncache_fw_images(void)
 /* kill pending requests without uevent to avoid blocking suspend */
 static void kill_requests_without_uevent(void)
 {
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 	struct firmware_buf *buf;
 	struct firmware_buf *next;
 
@@ -1426,6 +1427,7 @@ static void kill_requests_without_uevent(void)
 			 fw_load_abort(buf);
 	}
 	mutex_unlock(&fw_lock);
+#endif
 }
 
 /**

