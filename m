Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3I3KMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43459 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3I3KMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 027/104] ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA
Date: Mon, 30 Sep 2013 11:10:04 +0100
Message-Id: <1380535881-9239-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index bbd5e8d..59f8cac 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -513,6 +513,17 @@ static int hdmi_channel_allocation(struct hdmi_eld *eld, int channels)
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
 	snd_print_channel_allocation(eld->info.spk_alloc, buf, sizeof(buf));
 	snd_printdd("HDMI: select CA 0x%x for %d-channel allocation: %s\n",
 		    ca, channels, buf);
-- 
1.8.3.2

