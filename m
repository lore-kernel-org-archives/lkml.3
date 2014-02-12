Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaBLQAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:00:03 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63562 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaBLP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:59:56 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/13] pinctrl: mvebu: restructure resource allocation
Date: Wed, 12 Feb 2014 16:59:23 +0100
Message-Id: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set restructures the common pinctrl driver part of mvebu
to allow SoC specific controls to handle their own resources. Currently,
the common driver maps a single resource passed by DT while the SoC
specific controls cannot access that resource. To achieve the removal
of knowledge of resources in the common driver, we first need to rework
how SoC specific and common get/set callbacks are handled.

The patch set is based on two patch sets sent earlier [1][2] but drops
any Dove specific removal of hardcoded addresses. This allows to have
a clear view on the structural changes now and Dove specific changes
later on. The Dove specific patches will be re-sent on top of this one,
as soon as we are all happy with the resource allcation restruturing.

Also, in the meantime, pinctrl driver stubs for new Armada 375/28x have
been posted [3]. Before any of this patches move to a stable branch, I
plan to send an updated version comprising the required patches for the
new SoCs. As the new driver stubs are very much like what we already have
for Armada 370/XP, let's only discuss the general approach now and add
the branch dependency and patches later.

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

Patches 5-9 then add some global defines and provide SoC specific
callbacks even for the "generic" mpp controls. This allows Patch 10 to
move resource allocation to SoC specific drivers and remove the common
generic callbacks in Patch 11.

Patches 12-13 finally apply some consolidation and reuse patches to
Dove SoC driver that are now possible.

The patches are still based on pre-v3.14 but still apply cleanly on
v3.14-rc2 of course. They are also available on an *unstable* branch at

https://github.com/shesselba/linux-dove.git unstable/mvebu-pinctrl-v3.14_v3

As always they have been tested on Dove, compile-tested for the others,
and Andrew was so kind to give his Tested-by for common and Kirkwood
patches.

[1] http://www.spinics.net/lists/arm-kernel/msg303496.html
[2] lkml.org/lkml/2014/1/27/562
[3] http://www.spinics.net/lists/arm-kernel/msg306409.html

Sebastian Hesselbarth (13):
  pinctrl: mvebu: count unnamed controls and allocate name buffer
  pinctrl: mvebu: remove obsolete per-control name buffer allocation
  pinctrl: mvebu: identify generic controls by name
  pinctrl: mvebu: remove passing mvebu_mpp_ctrl to callbacks
  pinctrl: mvebu: add common mpp reg defines to mvebu pinctrl include
  pinctrl: mvebu: dove: provide generic mpp callbacks
  pinctrl: mvebu: kirkwood: provide generic mpp callbacks
  pinctrl: mvebu: armada-370: provide generic mpp callbacks
  pinctrl: mvebu: armada-xp: provide generic mpp callbacks
  pinctrl: mvebu: move resource allocation to SoC specific drivers
  pinctrl: mvebu: remove common get/set functions
  pinctrl: mvebu: dove: consolidate auto-numbered pmu mpp ranges
  pinctrl: mvebu: dove: reuse mpp_{set,get} in pmu callbacks

 drivers/pinctrl/mvebu/pinctrl-armada-370.c |  32 ++++++-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c  |  32 ++++++-
 drivers/pinctrl/mvebu/pinctrl-dove.c       | 145 ++++++++++++++---------------
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c   |  37 +++++++-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c      | 122 ++++++++----------------
 drivers/pinctrl/mvebu/pinctrl-mvebu.h      |  12 ++-
 6 files changed, 212 insertions(+), 168 deletions(-)

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

