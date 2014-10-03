Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbaJCXcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:32:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374AbaJCWDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.16 319/357] media: it913x: init tuner on attach
Date: Fri,  3 Oct 2014 14:31:45 -0700
Message-Id: <20141003212943.051546098@linuxfoundation.org>
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

From: Bimow Chen <Bimow.Chen@ite.com.tw>

commit 01b461bbe74b89da8941f4c95711777d87b9172e upstream.

That register is needed to program very first in order to operate
correctly.

[crope@iki.fi: returned sequence back, removed sleep, moved reg
write earlier to prevent populating tuner ops in case of failure]

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/tuners/tuner_it913x.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/tuners/tuner_it913x.c
+++ b/drivers/media/tuners/tuner_it913x.c
@@ -396,6 +396,7 @@ struct dvb_frontend *it913x_attach(struc
 		struct i2c_adapter *i2c_adap, u8 i2c_addr, u8 config)
 {
 	struct it913x_state *state = NULL;
+	int ret;
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct it913x_state), GFP_KERNEL);
@@ -425,6 +426,11 @@ struct dvb_frontend *it913x_attach(struc
 	state->tuner_type = config;
 	state->firmware_ver = 1;
 
+	/* tuner RF initial */
+	ret = it913x_wr_reg(state, PRO_DMOD, 0xec4c, 0x68);
+	if (ret < 0)
+		goto error;
+
 	fe->tuner_priv = state;
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
 			sizeof(struct dvb_tuner_ops));


