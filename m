Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaBKTFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:05:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbaBKTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olivier Grenie <olivier.grenie@parrot.com>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.13 071/120] [media] dib8000: fix regression with dib807x
Date: Tue, 11 Feb 2014 11:05:12 -0800
Message-Id: <20140211184825.638531341@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Grenie <olivier.grenie@parrot.com>

commit d67350f8c4e67f5eba627e1fd111f16257ca9c95 upstream.

Commit 173a64cb3fcf broke support for some dib807x versions.

Fix it by providing backward compatibility with the older versions.

[mkrufky@linuxtv.org: conflict handling and CodingStyle fixes]

Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
Acked-by: Patrick Boettcher <pboettcher@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/dib8000.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2462,7 +2462,8 @@ static int dib8000_autosearch_start(stru
 	if (state->revision == 0x8090)
 		internal = dib8000_read32(state, 23) / 1000;
 
-	if (state->autosearch_state == AS_SEARCHING_FFT) {
+	if ((state->revision >= 0x8002) &&
+	    (state->autosearch_state == AS_SEARCHING_FFT)) {
 		dib8000_write_word(state,  37, 0x0065); /* P_ctrl_pha_off_max default values */
 		dib8000_write_word(state, 116, 0x0000); /* P_ana_gain to 0 */
 
@@ -2498,7 +2499,8 @@ static int dib8000_autosearch_start(stru
 		dib8000_write_word(state, 770, (dib8000_read_word(state, 770) & 0xdfff) | (1 << 13)); /* P_restart_ccg = 1 */
 		dib8000_write_word(state, 770, (dib8000_read_word(state, 770) & 0xdfff) | (0 << 13)); /* P_restart_ccg = 0 */
 		dib8000_write_word(state, 0, (dib8000_read_word(state, 0) & 0x7ff) | (0 << 15) | (1 << 13)); /* P_restart_search = 0; */
-	} else if (state->autosearch_state == AS_SEARCHING_GUARD) {
+	} else if ((state->revision >= 0x8002) &&
+		   (state->autosearch_state == AS_SEARCHING_GUARD)) {
 		c->transmission_mode = TRANSMISSION_MODE_8K;
 		c->guard_interval = GUARD_INTERVAL_1_8;
 		c->inversion = 0;
@@ -2600,7 +2602,8 @@ static int dib8000_autosearch_irq(struct
 	struct dib8000_state *state = fe->demodulator_priv;
 	u16 irq_pending = dib8000_read_word(state, 1284);
 
-	if (state->autosearch_state == AS_SEARCHING_FFT) {
+	if ((state->revision >= 0x8002) &&
+	    (state->autosearch_state == AS_SEARCHING_FFT)) {
 		if (irq_pending & 0x1) {
 			dprintk("dib8000_autosearch_irq: max correlation result available");
 			return 3;


