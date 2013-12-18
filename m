Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3LRRw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:52:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63748 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754628Ab3LRRvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:51:39 -0500
Message-Id: <20131218175137.318130858@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 18 Dec 2013 12:35:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 2/2] ALSA: hda - Change codec configs to be disabled by localmodconfig
References: <20131218173519.265509723@goodmis.org>
Content-Disposition: inline; filename=0002-ALSA-hda-Change-codec-configs-to-be-disabled-by-loca.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If a user (or high level kernel developer) wants to use localmodconfig
to help them trim their config down to compile only the modules that
are needed by their computer (as reported by lsmod), they will be very
disappointed in the results of the ALSA hda codec modules.

The reason is that the way the kconfig is set up for codecs hides
the configs as being for modules by havinhg them be bools instead of
tristates. The Kconfig looks like this:

config SND_HDA_CODEC_REALTEK
        bool "Build Realtek HD-audio codec support"
        default y
[..]

config SND_HDA_CODEC_ANALOG
        bool "Build Analog Device HD-audio codec support"
        default y
[..]

config SND_HDA_CODEC_SIGMATEL
        bool "Build IDT/Sigmatel HD-audio codec support"
[..]

And the Makefile looks like this:

 # codec drivers (note: CONFIG_SND_HDA_CODEC_XXX are booleans)
ifdef CONFIG_SND_HDA_CODEC_REALTEK
obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-realtek.o
endif
ifdef CONFIG_SND_HDA_CODEC_CMEDIA
obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-cmedia.o
endif
ifdef CONFIG_SND_HDA_CODEC_ANALOG
obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-analog.o
endif
ifdef CONFIG_SND_HDA_CODEC_SIGMATEL
obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-idt.o
endif
ifdef CONFIG_SND_HDA_CODEC_SI3054
obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-si3054.o
endif
[...]

To enable snd-hda-codec-realtek.o as a module, you need to make sure
SND_HDA_INTEL is set to a module and then select SND_HDA_CODEC_REALTEK
as '=y'! That is not a module, but a boolean.

Localmodconfig will not turn off any '=y' because there's not enough
information in the lsmod output to know if it is safe to disable a '=y'
config or not. Localmodconfig can only safely disable '=m' options.

The reason the HDA codec code is like this is because all the codecs must
match the tristate SND_HDA_INTEL. That is, if SND_HDA_INTEL is a module
'=m', then all the codecs can only be modules or not defined '=m' or '=n'.
That case is very common, but HDA codecs can not be a module if SND_HDA_INTEL
is built-in '=y'. If SND_HDA_INTEL is '=y' then the codecs can only be
'=y' or '=n'. They can not be '=m', as the SND_HDA_INTEL code expects all
the codecs to be statically linked in at bootup when built-in.

Now to fix this so that the codecs match the tristate of SND_HDA_INTEL
we can add a config that states that SND_HDA_INTEL is 'y', and then add
another config for each codec for it to build the module. We then switch
all the codecs to be tristates too.

The new config for HDA_INTEL set as 'y' is:

config SND_HDA_YES
	default y if SND_HDA_INTEL=y

The new codec configs will have the following format:

config SND_HDA_CODEC_FOO_BUILD
	def_tristate (SND_HDA_CODEC_FOO=m && SND_HDA_YES) || SND_HDA_CODEC_FOO

What the above does is to set SND_HDA_CODEC_FOO_BUILD to 'y' if
SND_HDA_CODEC_FOO is a module and SND_HDA_YES is set. This forces
the codec to be built-in. Otherwise, it just sets it to the state of
SND_HDA_CODEC_FOO.

This change lets localmodconfig turn off codecs that are not being used.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/pci/hda/Kconfig  | 64 ++++++++++++++++++++++++++++++++++++++++----------
 sound/pci/hda/Makefile | 44 +++++++++-------------------------
 2 files changed, 63 insertions(+), 45 deletions(-)

diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
index 4cdd9de..97cd02b 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -1,3 +1,7 @@
+config SND_HDA_YES
+	bool
+	default y if SND_HDA_INTEL=y
+
 menuconfig SND_HDA_INTEL
 	tristate "Intel HD Audio"
 	select SND_PCM
@@ -87,7 +91,7 @@ config SND_HDA_PATCH_LOADER
 	  This option turns on hwdep and reconfig features automatically.
 
 config SND_HDA_CODEC_REALTEK
-	bool "Build Realtek HD-audio codec support"
+	tristate "Build Realtek HD-audio codec support"
 	default y
 	select SND_HDA_GENERIC
 	help
@@ -99,8 +103,11 @@ config SND_HDA_CODEC_REALTEK
 	  snd-hda-codec-realtek.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_REALTEK_BUILD
+	def_tristate (SND_HDA_CODEC_REALTEK=m && SND_HDA_YES) || SND_HDA_CODEC_REALTEK
+
 config SND_HDA_CODEC_ANALOG
-	bool "Build Analog Device HD-audio codec support"
+	tristate "Build Analog Device HD-audio codec support"
 	default y
 	select SND_HDA_GENERIC
 	help
@@ -112,8 +119,11 @@ config SND_HDA_CODEC_ANALOG
 	  snd-hda-codec-analog.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_ANALOG_BUILD
+	def_tristate (SND_HDA_CODEC_ANALOG=m && SND_HDA_YES) || SND_HDA_CODEC_ANALOG
+
 config SND_HDA_CODEC_SIGMATEL
-	bool "Build IDT/Sigmatel HD-audio codec support"
+	tristate "Build IDT/Sigmatel HD-audio codec support"
 	default y
 	select SND_HDA_GENERIC
 	help
@@ -125,8 +135,11 @@ config SND_HDA_CODEC_SIGMATEL
 	  snd-hda-codec-idt.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_SIGMATEL_BUILD
+	def_tristate (SND_HDA_CODEC_SIGMATEL=m && SND_HDA_YES) || SND_HDA_CODEC_SIGMATEL
+
 config SND_HDA_CODEC_VIA
-	bool "Build VIA HD-audio codec support"
+	tristate "Build VIA HD-audio codec support"
 	default y
 	select SND_HDA_GENERIC
 	help
@@ -138,8 +151,11 @@ config SND_HDA_CODEC_VIA
 	  snd-hda-codec-via.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_VIA_BUILD
+	def_tristate (SND_HDA_CODEC_VIA=m && SND_HDA_YES) || SND_HDA_CODEC_VIA
+
 config SND_HDA_CODEC_HDMI
-	bool "Build HDMI/DisplayPort HD-audio codec support"
+	tristate "Build HDMI/DisplayPort HD-audio codec support"
 	default y
 	help
 	  Say Y here to include HDMI and DisplayPort HD-audio codec
@@ -151,13 +167,16 @@ config SND_HDA_CODEC_HDMI
 	  snd-hda-codec-hdmi.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_HDMI_BUILD
+	def_tristate (SND_HDA_CODEC_HDMI=m && SND_HDA_YES) || SND_HDA_CODEC_HDMI
+
 config SND_HDA_I915
 	bool
 	default y
 	depends on DRM_I915
 
 config SND_HDA_CODEC_CIRRUS
-	bool "Build Cirrus Logic codec support"
+	tristate "Build Cirrus Logic codec support"
 	default y
 	select SND_HDA_GENERIC
 	help
@@ -169,8 +188,11 @@ config SND_HDA_CODEC_CIRRUS
 	  snd-hda-codec-cirrus.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_CIRRUS_BUILD
+	def_tristate (SND_HDA_CODEC_CIRRUS=m && SND_HDA_YES) || SND_HDA_CODEC_CIRRUS
+
 config SND_HDA_CODEC_CONEXANT
-	bool "Build Conexant HD-audio codec support"
+	tristate "Build Conexant HD-audio codec support"
 	default y
 	select SND_HDA_GENERIC
 	help
@@ -182,8 +204,11 @@ config SND_HDA_CODEC_CONEXANT
 	  snd-hda-codec-conexant.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_CONEXANT_BUILD
+	def_tristate (SND_HDA_CODEC_CONEXANT=m && SND_HDA_YES) || SND_HDA_CODEC_CONEXANT
+
 config SND_HDA_CODEC_CA0110
-	bool "Build Creative CA0110-IBG codec support"
+	tristate "Build Creative CA0110-IBG codec support"
 	default y
 	select SND_HDA_GENERIC
 	help
@@ -195,8 +220,11 @@ config SND_HDA_CODEC_CA0110
 	  snd-hda-codec-ca0110.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_CA0110_BUILD
+	def_tristate (SND_HDA_CODEC_CA0110=m && SND_HDA_YES) || SND_HDA_CODEC_CA0110
+
 config SND_HDA_CODEC_CA0132
-	bool "Build Creative CA0132 codec support"
+	tristate "Build Creative CA0132 codec support"
 	default y
 	help
 	  Say Y here to include Creative CA0132 codec support in
@@ -207,8 +235,11 @@ config SND_HDA_CODEC_CA0132
 	  snd-hda-codec-ca0132.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_CA0132_BUILD
+	def_tristate (SND_HDA_CODEC_CA0132=m && SND_HDA_YES) || SND_HDA_CODEC_CA0132
+
 config SND_HDA_CODEC_CA0132_DSP
-	bool "Support new DSP code for CA0132 codec"
+	tristate "Support new DSP code for CA0132 codec"
 	depends on SND_HDA_CODEC_CA0132
 	select SND_HDA_DSP_LOADER
 	select FW_LOADER
@@ -219,8 +250,11 @@ config SND_HDA_CODEC_CA0132_DSP
 	  Note that this option requires the external firmware file
 	  (ctefx.bin).
 
+config SND_HDA_CODEC_CA0132_DSP_BUILD
+	def_tristate (SND_HDA_CODEC_CA0132_DSP=m && SND_HDA_YES) || SND_HDA_CODEC_CA0132_DSP
+
 config SND_HDA_CODEC_CMEDIA
-	bool "Build C-Media HD-audio codec support"
+	tristate "Build C-Media HD-audio codec support"
 	default y
 	select SND_HDA_GENERIC
 	help
@@ -232,8 +266,11 @@ config SND_HDA_CODEC_CMEDIA
 	  snd-hda-codec-cmedia.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_CMEDIA_BUILD
+	def_tristate (SND_HDA_CODEC_CMEDIA=m && SND_HDA_YES) || SND_HDA_CODEC_CMEDIA
+
 config SND_HDA_CODEC_SI3054
-	bool "Build Silicon Labs 3054 HD-modem codec support"
+	tristate "Build Silicon Labs 3054 HD-modem codec support"
 	default y
 	help
 	  Say Y here to include Silicon Labs 3054 HD-modem codec
@@ -244,6 +281,9 @@ config SND_HDA_CODEC_SI3054
 	  snd-hda-codec-si3054.
 	  This module is automatically loaded at probing.
 
+config SND_HDA_CODEC_SI3054_BUILD
+	def_tristate (SND_HDA_CODEC_SI3054=m && SND_HDA_YES) || SND_HDA_CODEC_SI3054
+
 config SND_HDA_GENERIC
 	bool "Enable generic HD-audio codec parser"
 	default y
diff --git a/sound/pci/hda/Makefile b/sound/pci/hda/Makefile
index c091438..41d00ac 100644
--- a/sound/pci/hda/Makefile
+++ b/sound/pci/hda/Makefile
@@ -28,39 +28,17 @@ snd-hda-codec-hdmi-objs :=	patch_hdmi.o hda_eld.o
 obj-$(CONFIG_SND_HDA_INTEL) := snd-hda-codec.o
 
 # codec drivers (note: CONFIG_SND_HDA_CODEC_XXX are booleans)
-ifdef CONFIG_SND_HDA_CODEC_REALTEK
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-realtek.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_CMEDIA
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-cmedia.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_ANALOG
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-analog.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_SIGMATEL
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-idt.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_SI3054
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-si3054.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_CIRRUS
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-cirrus.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_CA0110
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-ca0110.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_CA0132
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-ca0132.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_CONEXANT
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-conexant.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_VIA
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-via.o
-endif
-ifdef CONFIG_SND_HDA_CODEC_HDMI
-obj-$(CONFIG_SND_HDA_INTEL) += snd-hda-codec-hdmi.o
-endif
+obj-$(CONFIG_SND_HDA_CODEC_REALTEK_BUILD) += snd-hda-codec-realtek.o
+obj-$(CONFIG_SND_HDA_CODEC_CMEDIA_BUILD) += snd-hda-codec-cmedia.o
+obj-$(CONFIG_SND_HDA_CODEC_ANALOG_BUILD) += snd-hda-codec-analog.o
+obj-$(CONFIG_SND_HDA_CODEC_SIGMATEL_BUILD) += snd-hda-codec-idt.o
+obj-$(CONFIG_SND_HDA_CODEC_SI3054_BUILD) += snd-hda-codec-si3054.o
+obj-$(CONFIG_SND_HDA_CODEC_CIRRUS_BUILD) += snd-hda-codec-cirrus.o
+obj-$(CONFIG_SND_HDA_CODEC_CA0110_BUILD) += snd-hda-codec-ca0110.o
+obj-$(CONFIG_SND_HDA_CODEC_CA0132_BUILD) += snd-hda-codec-ca0132.o
+obj-$(CONFIG_SND_HDA_CODEC_CONEXANT_BUILD) += snd-hda-codec-conexant.o
+obj-$(CONFIG_SND_HDA_CODEC_VIA_BUILD) += snd-hda-codec-via.o
+obj-$(CONFIG_SND_HDA_CODEC_HDMI_BUILD) += snd-hda-codec-hdmi.o
 
 # this must be the last entry after codec drivers;
 # otherwise the codec patches won't be hooked before the PCI probe
-- 
1.8.4.3


