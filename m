Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaBWO0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:26:11 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:48293 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaBWOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:21:26 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/16] pinctrl: mvebu: restructure resource allocation
Date: Sun, 23 Feb 2014 15:20:58 +0100
Message-Id: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set restructures the common pinctrl driver part of mvebu
to allow SoC specific controls to handle their own resources. Currently,
the common driver maps a single resource passed by DT while the SoC
specific controls cannot access that resource. To achieve the removal
of knowledge of resources in the common driver, we first need to rework
how SoC specific and common get/set callbacks are handled.

The patch set is based on three patch sets sent earlier [1][2][3] but drops
any Dove specific removal of hardcoded addresses. This allows to have
a clear view on the structural changes now and Dove specific changes
later on. The Dove specific patches will be re-sent on top of this one,
as soon as we are all happy with the resource allcation restruturing.

Also, in the meantime, pinctrl driver stubs for new Armada 375/38x have
been posted [4]. Compared to v3, this patch set now also takes care of
the new pinctrl stubs for Armada 375/38x. Those patches have been provided
by Thomas Petazzoni and make this patches depend on them. We have no stable
branch for the Armada 375/38x pinctrl patches but I guess Jason will provide
one soon.

In contrast to v3, we provide a generic mpp ctrl helper that is now
reused in the SoC-specific stubs instead of replaying the same code over
and over again. A more detailled changelog is given in the single patches.

Patches 1-3 first deal with the way we handle unnamed "generic" mpp
controls. Patch 1 consolidates the per-control allocation of name buffers
to counting unnamed controls first and then allocate a global name buffer
for all those controls. Patch 2 then removes the now obsolete per-control
allocation of name buffers. Patch 3 then makes the common driver to
identify "generic" mpp controls by an empty name and adds some valuable
comments about that special treatment.

Patch 4 removes passing struct mvebu_mpp_ctrl to the special callback
as the only relevant information in that struct for the callback is the
pin number which is passed directly instead.

Patches 5-11 then add generic mpp helpers and provide SoC specific
callbacks even for the "generic" mpp controls. This allows Patch 12 to
move resource allocation to SoC specific drivers and remove the common
generic callbacks and now unused macro in Patch 13 and 14, respectively.

Patches 15-16 finally apply some consolidation and reuse patches to
Dove SoC driver that are now possible.

The patches are based on 3.14-rc3. They are also available on an *unstable*
branch at

https://github.com/shesselba/linux-dove.git unstable/mvebu-pinctrl-v3.14_v4

They have been tested on Dove and Kirkwood, compile-tested for the others,
Andrew's Tested-by for the Kirkwood patches still applies, Thomas gave his
Tested-by for Armada XP on v3.

[1] http://www.spinics.net/lists/arm-kernel/msg303496.html
[2] http://lkml.org/lkml/2014/1/27/562
[3] http://lkml.org/lkml/2014/2/12/427
[4] http://www.spinics.net/lists/arm-kernel/msg306409.html

Sebastian Hesselbarth (13):
  pinctrl: mvebu: count unnamed controls and allocate name buffer
  pinctrl: mvebu: remove obsolete per-control name buffer allocation
  pinctrl: mvebu: identify generic controls by name
  pinctrl: mvebu: remove passing mvebu_mpp_ctrl to callbacks
  pinctrl: mvebu: add common mpp reg helper to mvebu pinctrl include
  pinctrl: mvebu: dove: provide generic mpp callbacks
  pinctrl: mvebu: kirkwood: provide generic mpp callbacks
  pinctrl: mvebu: armada-370: provide generic mpp callbacks
  pinctrl: mvebu: armada-xp: provide generic mpp callbacks
  pinctrl: mvebu: move resource allocation to SoC specific drivers
  pinctrl: mvebu: remove common get/set functions
  pinctrl: mvebu: dove: consolidate auto-numbered pmu mpp ranges
  pinctrl: mvebu: dove: reuse mpp_{set,get} in pmu callbacks

Thomas Petazzoni (3):
  pinctrl: mvebu: armada-375: provide generic mpp callbacks
  pinctrl: mvebu: armada-38x: provide generic mpp callbacks
  pinctrl: mvebu: remove MPP_REG_CTRL macro

 drivers/pinctrl/mvebu/pinctrl-armada-370.c |  20 ++++-
 drivers/pinctrl/mvebu/pinctrl-armada-375.c |  20 ++++-
 drivers/pinctrl/mvebu/pinctrl-armada-38x.c |  20 ++++-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c  |  24 +++++-
 drivers/pinctrl/mvebu/pinctrl-dove.c       | 133 +++++++++++++----------------
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c   |  25 +++++-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c      | 122 +++++++++-----------------
 drivers/pinctrl/mvebu/pinctrl-mvebu.h      |  55 +++++++-----
 8 files changed, 231 insertions(+), 188 deletions(-)

---
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.8.5.3

