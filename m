Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaJVPPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:15:51 -0400
Received: from axentia.se ([87.96.186.132]:43156 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaJVPPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:15:50 -0400
From: Peter Rosin <peda@axentia.se>
To: Bo Shen <voice.shen@atmel.com>
CC: "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>
Subject: [PATCH v2] ASoC: atmel_ssc_dai: Match the CMR divider only in full
 duplex.
Thread-Topic: [PATCH v2] ASoC: atmel_ssc_dai: Match the CMR divider only in
 full duplex.
Thread-Index: Ac/uCq+7f2mIJZfwS7Gq4jwDTeKBCg==
Date: Wed, 22 Oct 2014 15:13:55 +0000
Message-ID: <5733bb4302d148feb0bbd8ffd8c054a2@EMAIL.axentia.se>
Accept-Language: en-US, sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.210.101.82]
x-gfi-smtp-submission: 1
x-gfi-smtp-hellodomain: EMAIL.axentia.se
x-gfi-smtp-remoteip: 192.168.2.5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 86be84c4de4e7b21cfda9656a02a902c543210af Mon Sep 17 00:00:00 2001
From: Peter Rosin <peda@axentia.se>
Date: Wed, 22 Oct 2014 16:45:29 +0200
Subject: [PATCH v2] ASoC: atmel_ssc_dai: Match the CMR divider only in full
 duplex.

The CMR divider register is shared by playback and capture. The SSC driver
therefore tries to enforce rules so that the needed register content do
not conflict during simultaneous playback/capture. However, the
implementation also prevents changing the register content in
half-duplex scenarios, which is needed when using the OSS API.

Thus, only lock the divider if there is a stream in the other direction.

Fixes the below program to not fail with the atmel ssc dai in master mode.

#include <sys/ioctl.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/soundcard.h>

int
main(void)
{
	int fd;
	int format;
	int channels;
	int speed;

	if ((fd = open("/dev/dsp", O_WRONLY, 0)) == -1) {
		perror("open");
		return 1;
	}
	format = AFMT_S16_LE;
	if (ioctl(fd, SNDCTL_DSP_SETFMT, &format) == -1) {
		perror("SNDCTL_DSP_SETFMT");
		return 1;
	}
	channels = 2;
	if (ioctl(fd, SNDCTL_DSP_CHANNELS, &channels) == -1) {
		perror("SNDCTL_DSP_CHANNELS");
		return 1;
	}
	speed = 22025;
	if (ioctl(fd, SNDCTL_DSP_SPEED, &speed) == -1) {
		perror("SNDCTL_DSP_SPEED");
		return 1;
	}
	return 0;
}

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 sound/soc/atmel/atmel_ssc_dai.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index de433cfd..9ae8475 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -310,7 +310,10 @@ static int atmel_ssc_set_dai_clkdiv(struct snd_soc_dai *cpu_dai,
 		 * transmit and receive, so if a value has already
 		 * been set, it must match this value.
 		 */
-		if (ssc_p->cmr_div == 0)
+		if (ssc_p->dir_mask !=
+			(SSC_DIR_MASK_PLAYBACK | SSC_DIR_MASK_CAPTURE))
+			ssc_p->cmr_div = div;
+		else if (ssc_p->cmr_div == 0)
 			ssc_p->cmr_div = div;
 		else
 			if (div != ssc_p->cmr_div)
-- 
1.7.10.4

