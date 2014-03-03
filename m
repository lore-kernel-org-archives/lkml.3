Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbaCCTSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:18:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaCCS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:56:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@fedoraproject.org>, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 07/67] [media] mxl111sf: Fix unintentional garbage stack read
Date: Mon,  3 Mar 2014 10:54:55 -0800
Message-Id: <1393872955-28810-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@fedoraproject.org>

commit 866e8d8a9dc1ebb4f9e67197e264ac2df81f7d4b upstream.

mxl111sf_read_reg takes an address of a variable to write to as an argument.
drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c:mxl111sf_config_pin_mux_modes
passes several uninitialized stack variables to this routine, expecting
them to be filled in.  In the event that something unexpected happens when
reading from the chip, we end up doing a pr_debug of the value passed in,
revealing whatever garbage happened to be on the stack.

Change the pr_debug to match what happens in the 'success' case, where we
assign buf[1] to *data.

Spotted with Coverity (Bugs 731910 through 731917)

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index efdcb15..a26cd01 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -103,7 +103,7 @@ int mxl111sf_read_reg(struct mxl111sf_state *state, u8 addr, u8 *data)
 		ret = -EINVAL;
 	}
 
-	deb_reg("R: (0x%02x, 0x%02x)\n", addr, *data);
+	deb_reg("R: (0x%02x, 0x%02x)\n", addr, buf[1]);
 fail:
 	return ret;
 }
-- 
1.8.3.2

