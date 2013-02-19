Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab3BSS7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:59:11 -0500
Received: from mail.ispras.ru ([83.149.199.45]:60527 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933237Ab3BSS7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:59:09 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Manu Abraham <manu@linuxtv.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] stv090x: do not unlock unheld mutex in stv090x_sleep()
Date: Tue, 19 Feb 2013 22:58:53 +0400
Message-Id: <1361300333-9410-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

goto err and goto err_gateoff before mutex_lock(&state->internal->demod_lock)
lead to unlock of unheld mutex in stv090x_sleep().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb-frontends/stv090x.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 13caec0..4f600ac 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -3906,12 +3906,12 @@ static int stv090x_sleep(struct dvb_frontend *fe)
 		reg = stv090x_read_reg(state, STV090x_TSTTNR1);
 		STV090x_SETFIELD(reg, ADC1_PON_FIELD, 0);
 		if (stv090x_write_reg(state, STV090x_TSTTNR1, reg) < 0)
-			goto err;
+			goto err_unlock;
 		/* power off DiSEqC 1 */
 		reg = stv090x_read_reg(state, STV090x_TSTTNR2);
 		STV090x_SETFIELD(reg, DISEQC1_PON_FIELD, 0);
 		if (stv090x_write_reg(state, STV090x_TSTTNR2, reg) < 0)
-			goto err;
+			goto err_unlock;
 
 		/* check whether path 2 is already sleeping, that is when
 		   ADC2 is off */
@@ -3930,7 +3930,7 @@ static int stv090x_sleep(struct dvb_frontend *fe)
 		if (full_standby)
 			STV090x_SETFIELD(reg, STOP_CLKFEC_FIELD, 1);
 		if (stv090x_write_reg(state, STV090x_STOPCLK1, reg) < 0)
-			goto err;
+			goto err_unlock;
 		reg = stv090x_read_reg(state, STV090x_STOPCLK2);
 		/* sampling 1 clock */
 		STV090x_SETFIELD(reg, STOP_CLKSAMP1_FIELD, 1);
@@ -3941,7 +3941,7 @@ static int stv090x_sleep(struct dvb_frontend *fe)
 		if (full_standby)
 			STV090x_SETFIELD(reg, STOP_CLKTS_FIELD, 1);
 		if (stv090x_write_reg(state, STV090x_STOPCLK2, reg) < 0)
-			goto err;
+			goto err_unlock;
 		break;
 
 	case STV090x_DEMODULATOR_1:
@@ -3949,12 +3949,12 @@ static int stv090x_sleep(struct dvb_frontend *fe)
 		reg = stv090x_read_reg(state, STV090x_TSTTNR3);
 		STV090x_SETFIELD(reg, ADC2_PON_FIELD, 0);
 		if (stv090x_write_reg(state, STV090x_TSTTNR3, reg) < 0)
-			goto err;
+			goto err_unlock;
 		/* power off DiSEqC 2 */
 		reg = stv090x_read_reg(state, STV090x_TSTTNR4);
 		STV090x_SETFIELD(reg, DISEQC2_PON_FIELD, 0);
 		if (stv090x_write_reg(state, STV090x_TSTTNR4, reg) < 0)
-			goto err;
+			goto err_unlock;
 
 		/* check whether path 1 is already sleeping, that is when
 		   ADC1 is off */
@@ -3973,7 +3973,7 @@ static int stv090x_sleep(struct dvb_frontend *fe)
 		if (full_standby)
 			STV090x_SETFIELD(reg, STOP_CLKFEC_FIELD, 1);
 		if (stv090x_write_reg(state, STV090x_STOPCLK1, reg) < 0)
-			goto err;
+			goto err_unlock;
 		reg = stv090x_read_reg(state, STV090x_STOPCLK2);
 		/* sampling 2 clock */
 		STV090x_SETFIELD(reg, STOP_CLKSAMP2_FIELD, 1);
@@ -3984,7 +3984,7 @@ static int stv090x_sleep(struct dvb_frontend *fe)
 		if (full_standby)
 			STV090x_SETFIELD(reg, STOP_CLKTS_FIELD, 1);
 		if (stv090x_write_reg(state, STV090x_STOPCLK2, reg) < 0)
-			goto err;
+			goto err_unlock;
 		break;
 
 	default:
@@ -3997,7 +3997,7 @@ static int stv090x_sleep(struct dvb_frontend *fe)
 		reg = stv090x_read_reg(state, STV090x_SYNTCTRL);
 		STV090x_SETFIELD(reg, STANDBY_FIELD, 0x01);
 		if (stv090x_write_reg(state, STV090x_SYNTCTRL, reg) < 0)
-			goto err;
+			goto err_unlock;
 	}
 
 	mutex_unlock(&state->internal->demod_lock);
@@ -4005,8 +4005,10 @@ static int stv090x_sleep(struct dvb_frontend *fe)
 
 err_gateoff:
 	stv090x_i2c_gate_ctrl(state, 0);
-err:
+	goto err;
+err_unlock:
 	mutex_unlock(&state->internal->demod_lock);
+err:
 	dprintk(FE_ERROR, 1, "I/O error");
 	return -1;
 }
-- 
1.7.9.5

