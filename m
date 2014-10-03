Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbaJDAq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:46:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbaJCVcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Robbins <drobbins@funtoo.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.16 057/357] ALSA: dice: fix wrong channel mappping at higher sampling rate
Date: Fri,  3 Oct 2014 14:27:23 -0700
Message-Id: <20141003212935.166575993@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 1033eb5b5aeeb526c22068e0fb0cef9f3c14231e upstream.

The channel mapping is initialized by amdtp_stream_set_parameters(), however
Dice driver set it before calling this function. Furthermore, the setting is
wrong because the index is the value of array, and vice versa.

This commit moves codes for channel mapping after the function and set it correctly.

Reported-by: Daniel Robbins <drobbins@funtoo.org>
Fixes: 10550bea44a8 ("ALSA: dice/firewire-lib: Keep dualwire mode but obsolete CIP_HI_DUALWIRE")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/dice.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/sound/firewire/dice.c
+++ b/sound/firewire/dice.c
@@ -579,11 +579,6 @@ static int dice_hw_params(struct snd_pcm
 			return err;
 		}
 
-		for (i = 0; i < channels; i++) {
-			dice->stream.pcm_positions[i * 2] = i;
-			dice->stream.pcm_positions[i * 2 + 1] = i + channels;
-		}
-
 		rate /= 2;
 		channels *= 2;
 	}
@@ -591,6 +586,15 @@ static int dice_hw_params(struct snd_pcm
 	mode = rate_index_to_mode(rate_index);
 	amdtp_stream_set_parameters(&dice->stream, rate, channels,
 				    dice->rx_midi_ports[mode]);
+	if (rate_index > 4) {
+		channels /= 2;
+
+		for (i = 0; i < channels; i++) {
+			dice->stream.pcm_positions[i] = i * 2;
+			dice->stream.pcm_positions[i + channels] = i * 2 + 1;
+		}
+	}
+
 	amdtp_stream_set_pcm_format(&dice->stream,
 				    params_format(hw_params));
 


