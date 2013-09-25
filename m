Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3IYAUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3IYAU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Frank Zafka <kafkaesque1978@gmail.com>,
        =?UTF-8?q?Peter=20Fr=C3=BChberger?= <fritsch@xbmc.org>,
        Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>
Subject: [ 058/117] ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA
Date: Tue, 24 Sep 2013 17:18:44 -0700
Message-Id: <20130925001747.188429678@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -553,6 +553,17 @@ static int hdmi_channel_allocation(struc
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


