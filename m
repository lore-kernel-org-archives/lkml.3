Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbbANNwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:52:53 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:49100 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbbANNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:52:00 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>, Lee Jones <lee.jones@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/3] Use of_get_child_by_name() instead of of_find_node_by_name()
Date: Wed, 14 Jan 2015 14:51:56 +0100
Message-Id: <1421243519-6257-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Ben, Bryan/Richard, Jingoo/Lee,

Internally, of_find_node_by_name() calls of_node_put() on its "from"
parameter.  This is a problem if that device_node will be used
afterwards, or if of_node_put() is called on it again (either manually
or in a for_each_*_node() loop) later, as that may cause a zero kref
refcount. This may be caught by the system if CONFIG_OF_DYNAMIC=y:

	ERROR: Bad of_node_put() on /....

Use of_get_child_by_name() instead to fix this, and remove existing
workarounds to pre-increase the refcount.

Compile-tested only.

Geert Uytterhoeven (3):
  powerpc/pmac: Fix DT refcount imbalance in pmac_pic_probe_oldstyle
  leds: leds-mc13783: Use of_get_child_by_name() instead of refcount
    hack
  backlight: 88pm860x_bl: Use of_get_child_by_name() instead of refcount
    hack

 arch/powerpc/platforms/powermac/pic.c | 2 +-
 drivers/leds/leds-mc13783.c           | 4 +---
 drivers/video/backlight/88pm860x_bl.c | 5 +----
 3 files changed, 3 insertions(+), 8 deletions(-)

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
