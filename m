Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab3I3LKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:10:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44156 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3I3LKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:10:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: David Henningsson <david.henningsson@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 026/104] ALSA: hda - hdmi: Refactor hdmi_eld into parsed_hdmi_eld
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
	<1380535881-9239-27-git-send-email-luis.henriques@canonical.com>
	<52495273.8050308@canonical.com>
Date: Mon, 30 Sep 2013 12:10:50 +0100
In-Reply-To: <52495273.8050308@canonical.com> (David Henningsson's message of
	"Mon, 30 Sep 2013 12:29:07 +0200")
Message-ID: <87r4c61s5h.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

David Henningsson <david.henningsson@canonical.com> writes:

> On 09/30/2013 12:10 PM, Luis Henriques wrote:
>> 3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: David Henningsson <david.henningsson@canonical.com>
>> 
>> commit 1613d6b46b433f07f1d2703e4bd102802dcd75a4 upstream.
>> 
>> For better readability, the information that is parsed out of the
>> ELD data is now put into a separate parsed_hdmi_eld struct.
>> 
>> Signed-off-by: David Henningsson <david.henningsson@canonical.com>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> [ luis: 3.5.y-prereq for:
>>   18e3918 ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA ]
>
> I don't think this is really a prereq. Sorting out the fuzz in
> hdmi_channel_allocation seems quite trivial to me, so I would suggest
> doing so instead.
>
> If you do go ahead and backport this patch, a bit of testing wouldn't
> hurt: this patch was part of a bigger patch set, and I don't think
> anyone tested just this one without the bigger set.

Ok, I agree with you and I'm dropping this patch from the 3.5 kernel.
Also, I'm replacing

 [PATCH 027/104] ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA

with the patch below.  Are you Ok with this?

(btw, thank you for your review!)

Cheers,
-- 
Luis

>From 51287bff2ce7478d73856459c23d52e5bf2e5592 Mon Sep 17 00:00:00 2001
From: Anssi Hannula <anssi.hannula@iki.fi>
Date: Sun, 1 Sep 2013 14:36:47 +0300
Subject: [PATCH] ALSA: hda - hdmi: Fallback to ALSA allocation when selecting
 CA
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 375e0ff..c3cd1f8 100644
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
 	snd_print_channel_allocation(eld->spk_alloc, buf, sizeof(buf));
 	snd_printdd("HDMI: select CA 0x%x for %d-channel allocation: %s\n",
 		    ca, channels, buf);
-- 
1.8.3.2

