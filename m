Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbaFSOui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:50:38 -0400
Received: from mout.gmx.net ([212.227.17.22]:51694 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435AbaFSOuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:50:37 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Kees Cook <keescook@chromium.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1 v2] media: dib9000: avoid out of bound access
Date: Thu, 19 Jun 2014 16:49:40 +0200
Message-Id: <1403189380-25134-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <CAGXu5jLJGpPhycff9OSMGu6wduLGQWhsu2mkGeM7R0O9CQZ7pg@mail.gmail.com>
References: <CAGXu5jLJGpPhycff9OSMGu6wduLGQWhsu2mkGeM7R0O9CQZ7pg@mail.gmail.com>
X-Provags-ID: V03:K0:MMsP1MxjMEyckSenHVJWVA1UewdLxlBEIYR+DgVJOlFLVJ1vJVQ
 1EyoPEyzWHWw6E12Qnqzym23LhBeZnncg3n5fJJ80HXCEeE94kiTKhGRV+Rd2zGEYxQWcrz
 psBAQqNgOxFGgmXB5fRpDpkDJyUd7EQkV24Aw1qmSZZJVUsNpbaobf3qyXVqJpyWJyYMawt
 9VgBw05Ig0s8A/kyKw2Aw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updated patch also fixes out of bound access to b[].

In dib9000_risc_apb_access_write() an out of bound access to mb[].

The current test to avoid out of bound access to mb[] is insufficient.
For len = 19 non-existent mb[10] will be accessed.

For odd values of len b[] is accessed out of bounds.

For large values of len an of bound access to mb[] may occur in
dib9000_mbx_send_attr.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/media/dvb-frontends/dib9000.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index e540cfb..f75dec4 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -1040,13 +1040,18 @@ static int dib9000_risc_apb_access_write(struct dib9000_state *state, u32 addres
 	if (address >= 1024 || !state->platform.risc.fw_is_running)
 		return -EINVAL;
 
+	if (len > 18)
+		return -EINVAL;
+
 	/* dprintk( "APB access thru wr fw %d %x", address, attribute); */
 
-	mb[0] = (unsigned short)address;
-	for (i = 0; i < len && i < 20; i += 2)
-		mb[1 + (i / 2)] = (b[i] << 8 | b[i + 1]);
+	mb[0] = (u16)address;
+	for (i = 0; i + 1 < len; i += 2)
+		mb[1 + i / 2] = b[i] << 8 | b[i + 1];
+	if (len & 1)
+		mb[1 + len / 2] = b[len - 1] << 8;
 
-	dib9000_mbx_send_attr(state, OUT_MSG_BRIDGE_APB_W, mb, 1 + len / 2, attribute);
+	dib9000_mbx_send_attr(state, OUT_MSG_BRIDGE_APB_W, mb, (3 + len) / 2, attribute);
 	return dib9000_mbx_get_message_attr(state, IN_MSG_END_BRIDGE_APB_RW, mb, &s, attribute) == 1 ? 0 : -EINVAL;
 }
 
-- 
2.0.0

