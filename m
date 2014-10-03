Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbaJCXbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:31:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387AbaJCWDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.16 321/357] media: af9033: feed clock to RF tuner
Date: Fri,  3 Oct 2014 14:31:47 -0700
Message-Id: <20141003212943.108684979@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 9dc0f3fe3fe6b83b44e5920a0b143b4f96755b59 upstream.

IT9135 RF tuner clock is coming from demodulator. We need enable it
early in demod init, before any tuner I/O. Currently it is enabled
by tuner driver itself, but it is too late and performance will be
reduced as some registers are not updated correctly. Clock is
disabled automatically when demod is put onto sleep.

Cc: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/af9033.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -314,6 +314,19 @@ static int af9033_init(struct dvb_fronte
 			goto err;
 	}
 
+	/* feed clock to RF tuner */
+	switch (state->cfg.tuner) {
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		ret = af9033_wr_reg(state, 0x80fba8, 0x00);
+		if (ret < 0)
+			goto err;
+	}
+
 	/* settings for TS interface */
 	if (state->cfg.ts_mode == AF9033_TS_MODE_USB) {
 		ret = af9033_wr_reg_mask(state, 0x80f9a5, 0x00, 0x01);


