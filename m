Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3ITUNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:13:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41539 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3ITUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:13:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 59/93] ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA
Date: Fri, 20 Sep 2013 13:08:54 -0700
Message-Id: <1379707768-1804-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 5c19496..40f5e2d 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -530,6 +530,17 @@ static int hdmi_channel_allocation(struct hdmi_eld *eld, int channels)
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
-- 
1.8.1.2

