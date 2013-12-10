Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3LJCtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:49:15 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19563 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3LJCtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:49:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Dec 2013 18:42:19 -0800
Date: Mon, 9 Dec 2013 18:49:13 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: atmel_abdac: clk_round_rate() can return a zero upon
 error
Message-ID: <alpine.DEB.2.02.1312091845340.4127@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Treat both negative and zero return values from clk_round_rate()
as errors.  This is needed since subsequent patches will convert
clk_round_rate()'s return value to be an unsigned type, rather
than a signed type, since some clock sources can generate rates higher
than (2^31)-1 Hz.

Eventually, when calling clk_round_rate(), only a return value of
zero will be considered a error; all other values will be
considered valid rates.  The comparison against values less than
0 is kept to preserve the correct behavior in the meantime.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
---
Applies on v3.13-rc3.  See also:

http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  sound/atmel/abdac.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/atmel/abdac.c b/sound/atmel/abdac.c
index 721d8fd..3519518 100644
--- a/sound/atmel/abdac.c
+++ b/sound/atmel/abdac.c
@@ -354,7 +354,7 @@ static int set_sample_rates(struct atmel_abdac *dac)
  	/* we start at 192 kHz and work our way down to 5112 Hz */
  	while (new_rate >= RATE_MIN && index < (MAX_NUM_RATES + 1)) {
  		new_rate = clk_round_rate(dac->sample_clk, 256 * new_rate);
-		if (new_rate < 0)
+		if (new_rate <= 0)
  			break;
  		/* make sure we are below the ABDAC clock */
  		if (index < MAX_NUM_RATES &&
