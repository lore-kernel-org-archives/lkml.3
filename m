Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3KYNW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:22:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57143 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab3KYNIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 38/78] ALSA: hda - Move one-time init codes from generic_hdmi_init()
Date: Mon, 25 Nov 2013 13:06:25 +0000
Message-Id: <1385384825-21681-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8b8d654b55648561287bd8baca0f75f964a17038 upstream.

The codes to initialize work struct or create a proc interface should
be called only once and never although it's called many times through
the init callback.  Move that stuff into patch_generic_hdmi() so that
it's called only once.

Signed-off-by: Takashi Iwai <tiwai@suse.de>

This is being backported to 3.4 and 3.5 due to prevention of kernel
panic. The kernel panic was observed by executing
'cat /proc/asound/card0/codec0' on a particular machine, which was
 - running in battery mode
 - having an external HDMI monitor connected
 - running the fglrx driver.

In short, the one-time init code initializes a delayed_work struct.
Then, I believe the following happened:
 1) the delayed_work was activated
 2) the delayed_work struct was reinitialized by the init code
 3) when the delayed_work timed out (ready to run the callback function),
    the kernel panic happened because the delayed_work struct had
    been corrupted in step 2.

BugLink: https://bugs.launchpad.net/bugs/1212160
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c3cd1f8..769ba9b 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1283,23 +1283,34 @@ static int generic_hdmi_build_controls(struct hda_codec *codec)
 	return 0;
 }
 
-static int generic_hdmi_init(struct hda_codec *codec)
+static int generic_hdmi_init_per_pins(struct hda_codec *codec)
 {
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx;
 
 	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
 		struct hdmi_spec_per_pin *per_pin = &spec->pins[pin_idx];
-		hda_nid_t pin_nid = per_pin->pin_nid;
 		struct hdmi_eld *eld = &per_pin->sink_eld;
 
-		hdmi_init_pin(codec, pin_nid);
-		snd_hda_jack_detect_enable(codec, pin_nid, pin_nid);
-
 		per_pin->codec = codec;
 		INIT_DELAYED_WORK(&per_pin->work, hdmi_repoll_eld);
 		snd_hda_eld_proc_new(codec, eld, pin_idx);
 	}
+	return 0;
+}
+
+static int generic_hdmi_init(struct hda_codec *codec)
+{
+	struct hdmi_spec *spec = codec->spec;
+	int pin_idx;
+
+	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
+		struct hdmi_spec_per_pin *per_pin = &spec->pins[pin_idx];
+		hda_nid_t pin_nid = per_pin->pin_nid;
+
+		hdmi_init_pin(codec, pin_nid);
+		snd_hda_jack_detect_enable(codec, pin_nid, pin_nid);
+	}
 	snd_hda_jack_report_sync(codec);
 	return 0;
 }
@@ -1344,6 +1355,7 @@ static int patch_generic_hdmi(struct hda_codec *codec)
 		return -EINVAL;
 	}
 	codec->patch_ops = generic_hdmi_patch_ops;
+	generic_hdmi_init_per_pins(codec);
 
 	init_channel_allocations();
 
-- 
1.8.3.2

