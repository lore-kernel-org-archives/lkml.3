Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaBGLtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:49:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaBGLtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olivier Grenie <olivier.grenie@parrot.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 065/233] [media] dib8000: fix regression with dib807x
Date: Fri,  7 Feb 2014 11:44:44 +0000
Message-Id: <1391773652-25214-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Grenie <olivier.grenie@parrot.com>

commit d67350f8c4e67f5eba627e1fd111f16257ca9c95 upstream.

Commit 173a64cb3fcf broke support for some dib807x versions.

Fix it by providing backward compatibility with the older versions.

[mkrufky@linuxtv.org: conflict handling and CodingStyle fixes]

Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
Acked-by: Patrick Boettcher <pboettcher@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-frontends/dib8000.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 9053614..487c253 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2445,7 +2445,8 @@ static int dib8000_autosearch_start(struct dvb_frontend *fe)
 	if (state->revision == 0x8090)
 		internal = dib8000_read32(state, 23) / 1000;
 
-	if (state->autosearch_state == AS_SEARCHING_FFT) {
+	if ((state->revision >= 0x8002) &&
+	    (state->autosearch_state == AS_SEARCHING_FFT)) {
 		dib8000_write_word(state,  37, 0x0065); /* P_ctrl_pha_off_max default values */
 		dib8000_write_word(state, 116, 0x0000); /* P_ana_gain to 0 */
 
@@ -2481,7 +2482,8 @@ static int dib8000_autosearch_start(struct dvb_frontend *fe)
 		dib8000_write_word(state, 770, (dib8000_read_word(state, 770) & 0xdfff) | (1 << 13)); /* P_restart_ccg = 1 */
 		dib8000_write_word(state, 770, (dib8000_read_word(state, 770) & 0xdfff) | (0 << 13)); /* P_restart_ccg = 0 */
 		dib8000_write_word(state, 0, (dib8000_read_word(state, 0) & 0x7ff) | (0 << 15) | (1 << 13)); /* P_restart_search = 0; */
-	} else if (state->autosearch_state == AS_SEARCHING_GUARD) {
+	} else if ((state->revision >= 0x8002) &&
+		   (state->autosearch_state == AS_SEARCHING_GUARD)) {
 		c->transmission_mode = TRANSMISSION_MODE_8K;
 		c->guard_interval = GUARD_INTERVAL_1_8;
 		c->inversion = 0;
@@ -2583,7 +2585,8 @@ static int dib8000_autosearch_irq(struct dvb_frontend *fe)
 	struct dib8000_state *state = fe->demodulator_priv;
 	u16 irq_pending = dib8000_read_word(state, 1284);
 
-	if (state->autosearch_state == AS_SEARCHING_FFT) {
+	if ((state->revision >= 0x8002) &&
+	    (state->autosearch_state == AS_SEARCHING_FFT)) {
 		if (irq_pending & 0x1) {
 			dprintk("dib8000_autosearch_irq: max correlation result available");
 			return 3;
-- 
1.8.3.2

