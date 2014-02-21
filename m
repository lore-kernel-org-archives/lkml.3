Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaBUNBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:01:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbaBUNBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:01:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@fedoraproject.org>, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 06/60] [media] mxl111sf: Fix unintentional garbage stack read
Date: Fri, 21 Feb 2014 13:00:33 +0000
Message-Id: <1392987687-15367-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - file rename: drivers/media/usb/dvb-usb-v2/mxl111sf.c ->
    drivers/media/dvb/dvb-usb/mxl111sf.c
  - replaced pr_debug() by deb_reg() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb/dvb-usb/mxl111sf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-usb/mxl111sf.c b/drivers/media/dvb/dvb-usb/mxl111sf.c
index cd84279..086fb8a 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf.c
@@ -101,7 +101,7 @@ int mxl111sf_read_reg(struct mxl111sf_state *state, u8 addr, u8 *data)
 		ret = -EINVAL;
 	}
 
-	deb_reg("R: (0x%02x, 0x%02x)\n", addr, *data);
+	deb_reg("R: (0x%02x, 0x%02x)\n", addr, buf[1]);
 fail:
 	return ret;
 }
-- 
1.9.0

