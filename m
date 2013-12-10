Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3LJCkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:40:51 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10424 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3LJCku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:40:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Dec 2013 18:33:55 -0800
Date: Mon, 9 Dec 2013 18:40:48 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: at73c213: clk_round_rate() can return a zero upon
 error
Message-ID: <alpine.DEB.2.02.1312091837280.4127@tamien>
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
zero will be considered a error.  All other values will be
considered valid rates.  The comparison against values less than
0 is kept to preserve the correct behavior in the meantime.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
---
Applies on v3.13-rc3.  See also:

http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  sound/spi/at73c213.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 8e3d9a6c7a3b..25c38afaee49 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -174,7 +174,7 @@ static int snd_at73c213_set_bitrate(struct snd_at73c213 *chip)
  		dac_rate_new = 8 * (ssc_rate / ssc_div);

  		status = clk_round_rate(chip->board->dac_clk, dac_rate_new);
-		if (status < 0)
+		if (status <= 0)
  			return status;

  		/* Ignore difference smaller than 256 Hz. */
