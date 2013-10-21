Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3JUIvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39495 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612Ab3JUIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?Q?Peter=20Fr=C3=BChberger?=" <fritsch@xbmc.org>,
        "Frank Zafka" <kafkaesque1978@gmail.com>, Ashecrow@decadent.org.uk,
        "Takashi Iwai" <tiwai@suse.de>, GrimGriefer@decadent.org.uk,
        "Anssi Hannula" <anssi.hannula@iki.fi>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.712217819@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 047/149] ALSA: hda - hdmi: Fallback to ALSA allocation
 when selecting CA
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 18e391862cceaf43ddb8eb5cca05e1a83abdebaa upstream.

hdmi_channel_allocation() tries to find a HDMI channel allocation that
matches the number channels in the playback stream and contains only
speakers that the HDMI sink has reported as available via EDID. If no
such allocation is found, 0 (stereo audio) is used.

Using CA 0 causes the audio causes the sink to discard everything except
the first two channels (front left and front right).

However, the sink may be capable of receiving more channels than it has
speakers (and then perform downmix or discard the extra channels), in
which case it is preferable to use a CA that contains extra channels
than to use CA 0 which discards all the non-stereo channels.

Additionally, it seems that HBR (HD) passthrough output does not work on
Intel HDMI codecs when CA is set to 0 (possibly the codec zeroes
channels not present in CA). This happens with all receivers that report
a 5.1 speaker mask since a HBR stream is carried on 8 channels to the
codec.

Add a fallback in the CA selection so that the CA channel count at least
matches the stream channel count, even if the stream contains channels
not present in the sink speaker descriptor.

Thanks to GrimGriefer at OpenELEC forums for discovering that changing
the sink speaker mask allowed HBR output.

Reported-by: GrimGriefer
Reported-by: Ashecrow
Reported-by: Frank Zafka <kafkaesque1978@gmail.com>
Reported-by: Peter Frühberger <fritsch@xbmc.org>
Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_hdmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -512,6 +512,17 @@ static int hdmi_channel_allocation(struc
 		}
 	}
 
+	if (!ca) {
+		/* if there was no match, select the regular ALSA channel
+		 * allocation with the matching number of channels */
+		for (i = 0; i < ARRAY_SIZE(channel_allocations); i++) {
+			if (channels == channel_allocations[i].channels) {
+				ca = channel_allocations[i].ca_index;
+				break;
+			}
+		}
+	}
+
 	snd_print_channel_allocation(eld->spk_alloc, buf, sizeof(buf));
 	snd_printdd("HDMI: select CA 0x%x for %d-channel allocation: %s\n",
 		    ca, channels, buf);

