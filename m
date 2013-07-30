Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3G3Kcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:32:32 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58818 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3G3Kc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:32:28 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v6 0/8] Sound support for at91sam9x5-wm8731 based boards
Date: Tue, 30 Jul 2013 12:32:01 +0200
Message-Id: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset add sound on the at91sam9x5ek board.
It's based on Nicolas Ferre's work in the 2.6.39 atmel patch for sam9x5:
https://github.com/linux4sam/linux-at91/commit/0aa157c9e71ccccf3abc30fa37eb5c95b392978d

It needs Bo Chen's patchset on the generic dmaengine (topic/atmel branch
on Mark's sound tree) and the SSC interrupts disabled (cf
http://www.spinics.net/lists/arm-kernel/msg256901.html)

As the at91 chips are on their way to the common clock framework, I thought
it may be better to retrieve the codec MCLK via this framework.
So it needs Boris Brezillon patch set "ARM: at91: move to common clk framework"
I've separated this patch because I don't know what is better:
 * applying the patchset with a hard coded clock, and once at91 has moved to common
clock framework, update the code and change the DT binding.
 * wait for the common clock framework.

Outstanding issue:
If this machine driver will support more SoCs maybe we should name it differently.
Maybe atmel_wm8731.c ? Since it could be merged with sam9g20_wm8731.c
when the g20 is DT only (There will be some more work though).

It has been tested on at91sam9g35ek, and should work on g15, g25, x25 and x35 also.

patches applies on next-20130729 + "ARM: at91: move to common clk framework"

Changes from v5:
 * Update the wm8731 DT binding documentation with available audio endpoints.
 * Remove Uwe's signed-off since it seems to be "an integration signed-off"
 * Remove rate constrains if freq==0 in wm8731.
 * Allocate dynamically card, dai and private structures.
 * Add a separate patch to set the oscillator value via DT.
NB: this last patch needs Boris Brezillon patch set "ARM: at91: move to common clk framework"


Changes from v4:
 * Move the rates constraints into the codec
 * Hard code the DAI format since it cannot be changed anyway (and
remove the DT bindings accordingly)
 * Add some consistency in the functions naming (sam9x5ek/at91sam9x5ek/sam9x5)
 * Retrieve the SSC id from the SSC controller phandle
 * Clarify the atmel-ssc.txt documentation
 * Develop audio-routing documentation
 * Tidy up the includes in the machine driver

Changes from v3:
 * Remove the use of macros in device tree documentation.

Changes from v2:
 * Change atmel,sam9x5-audio-wm8731 to atmel,sam9x5-wm8731-audio for
consistency with sam9g20 machine driver.
 * Use the snd_pcm_hw_constraint() API as suggested by Mark and Lars-Peter.
 * Remove the unnecessary snd_soc_dapm_sync() call as Lars-Peter suggested.
 * Add documentation for machine driver DT binding.
 * Update atmel-ssc DT binding documentation.
 * Add GPL license instead of just the "GPL" word (hope that's ok !)

Changes from v1-RFC:
 * drop patches on SSC since Bo Chen already did the work
 * reorder patches to have the machine driver first
 * drop code already handled by the ASoC framework
 * drop unneeded SND_ATMEL_SOC_PDC config selection
 * use static snd_soc_card and snd_soc_dai_link structures.

Best regards,
Richard.

Nicolas Ferre (1):
  ASoC: atmel: machine driver for at91sam9x5-wm8731 boards

Richard Genoud (7):
  ASoC: wm8731: add rates constraints
  Documentation: DT: update atmel SSC with DMA binding
  ARM: AT91: DTS: sam9x5: add SSC DMA parameters
  ARM: AT91: DTS: sam9x5ek: add WM8731 codec
  ARM: AT91: DTS: sam9x5ek: enable SSC
  ARM: AT91: DTS: sam9x5ek: add sound configuration
  ASoC: sam9x5: get codec MCLK via device tree

 .../devicetree/bindings/misc/atmel-ssc.txt         |   23 ++-
 .../bindings/sound/atmel-sam9x5-wm8731-audio.txt   |   39 ++++
 Documentation/devicetree/bindings/sound/wm8731.txt |    9 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |    3 +
 arch/arm/boot/dts/at91sam9x5ek.dtsi                |   32 +++
 sound/soc/atmel/Kconfig                            |   10 +
 sound/soc/atmel/Makefile                           |    2 +
 sound/soc/atmel/sam9x5_wm8731.c                    |  218 ++++++++++++++++++++
 sound/soc/codecs/wm8731.c                          |   60 +++++-
 9 files changed, 392 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
 create mode 100644 sound/soc/atmel/sam9x5_wm8731.c

-- 
1.7.10.4

