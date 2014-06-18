Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaFRWCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:02:44 -0400
Received: from mout.gmx.net ([212.227.15.15]:62187 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbaFRWCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:02:42 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>, Kees Cook <keescook@chromium.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] media: dib9000: avoid out of bound access
Date: Thu, 19 Jun 2014 00:02:25 +0200
Message-Id: <1403128945-28298-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.0.0
X-Provags-ID: V03:K0:+mBK1sc3ZWXhWJmINFqP4eL936i8MytQjYHKNg3qQMuL+/GA16j
 BnxodDrsDwQbh19Qj12gcUmJCobCKfzdsU9tHyYRSXmEIPgXa+s5hy/ySmPAV+mJiaSW5LJ
 oFItgg9cEA0w/DsAMCRMaWSwA5QJ+Yv9mOH/SDz2n+jIhECXtweJqNUz9x1hHCWup2j+9yY
 Q2/U4uDLnwWmRl/6ir8vw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current test to avoid out of bound access to mb[] is insufficient.
For len = 19 non-existent mb[10] will be accessed.

A check in the for loop is insufficient to avoid out of bound access in
dib9000_mbx_send_attr.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/media/dvb-frontends/dib9000.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index e540cfb..6a71917 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -1040,10 +1040,13 @@ static int dib9000_risc_apb_access_write(struct dib9000_state *state, u32 addres
 	if (address >= 1024 || !state->platform.risc.fw_is_running)
 		return -EINVAL;
 
+	if (len > 18)
+		return -EINVAL;
+
 	/* dprintk( "APB access thru wr fw %d %x", address, attribute); */
 
 	mb[0] = (unsigned short)address;
-	for (i = 0; i < len && i < 20; i += 2)
+	for (i = 0; i < len; i += 2)
 		mb[1 + (i / 2)] = (b[i] << 8 | b[i + 1]);
 
 	dib9000_mbx_send_attr(state, OUT_MSG_BRIDGE_APB_W, mb, 1 + len / 2, attribute);
-- 
2.0.0

