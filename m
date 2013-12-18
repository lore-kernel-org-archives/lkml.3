Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3LRRvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:51:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63748 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753242Ab3LRRvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:51:38 -0500
Message-Id: <20131218173519.265509723@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 18 Dec 2013 12:35:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 0/2] localmodconfig / ALSA: hda - Have codecs be disabled by localmodconfig
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds reported that 'make localmodconfig' would never work on
his ALSA codec modules. That is, although his box only had realtek and
hdmi codec modules, all of the codec modules would still be built after
running localmodconfig.

When he showed me his config file which had this:

  CONFIG_SND_HDA_CODEC_REALTEK=y
  CONFIG_SND_HDA_CODEC_ANALOG=y
  CONFIG_SND_HDA_CODEC_SIGMATEL=y
  CONFIG_SND_HDA_CODEC_VIA=y
  CONFIG_SND_HDA_CODEC_HDMI=y
  CONFIG_SND_HDA_CODEC_CIRRUS=y
  CONFIG_SND_HDA_CODEC_CONEXANT=y
  CONFIG_SND_HDA_CODEC_CA0110=y
  CONFIG_SND_HDA_CODEC_CA0132=y
  CONFIG_SND_HDA_CODEC_CA0132_DSP=y
  CONFIG_SND_HDA_CODEC_CMEDIA=y
  CONFIG_SND_HDA_CODEC_SI3054=y
  ..

I was confused to why they were '=y' if they were to build modules
and not '=m'. Localmodconfig will not disable anything with '=y' because
there's not enough information in lsmod to safely disable a built-in
config.

Investigating as to why these were '=y' I found this in the Makefile:

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

And the reason for this is because if the code for SND_HDA_INTEL
is a built-in, then all the codecs that are configured must also be
built-in. If it is a module, then all the codecs must also be a module.

To put this another way; if SND_HDA_INTEL is 'y' then all the codecs
must either be 'y' or 'n'. If SND_HDA_INTEL is 'm', then all the
codecs must be 'm' or 'n'. The latter is already supported by the
kconfig code, but the former is not. That is, if a tristate config
is dependent on a config that is built-in 'y', then that config can
still become a module 'm'. This trick that is done above prevents that.
But unfortunately, it also confuses localmodconfig, and the user
does not get the correct result.

Ideally, having a "match_config" option in the kconfig subsystem would
be ideal. But anyone that ever took a look at the kconfig code knows that
is much more difficult to implement than one would expect, as that
code can cause severe eye strain.

But luckily for us, we can do another trick to keep the behavior needed
by the ALSA hda code, and still allow for localmodconfig to disable the
modules.

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

The first patch fixes a bug in localmodconfig that this ordeal uncovered,
and that was the fact that localmodconfig did not honor default dependencies
like "def_tristate (SND_HDA_CODEC_FOO=m && SND_HDA_YES) || SND_HDA_CODEC_FOO"

-- Steve


Steven Rostedt (Red Hat) (2):
      localmodconfig: Add config depends by default settings
      ALSA: hda - Change codec configs to be disabled by localmodconfig

----
 scripts/kconfig/streamline_config.pl |  7 ++++
 sound/pci/hda/Kconfig                | 64 +++++++++++++++++++++++++++++-------
 sound/pci/hda/Makefile               | 44 +++++++------------------
 3 files changed, 70 insertions(+), 45 deletions(-)
