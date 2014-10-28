Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaJ1UgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:36:16 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52834 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaJ1UgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:36:13 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v8 0/8] Device Tree Overlays - 8th time's the charm
Date: Tue, 28 Oct 2014 22:35:57 +0200
Message-Id: <1414528565-10907-1-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset introduces Device Tree overlays, a method
of dynamically altering the kernel's live Device Tree, along with
a generic interface to use it in a board agnostic manner.

It is against linux mainline as of today 28/10/2014
"f7e87a44ef60ad379e39b45437604141453bf0ec"
Merge tag 'media/v3.18-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media

It relies on the following previously submitted patches/patchsets:

* configfs: Implement binary attributes (v2)

To compile overlays you need the DTC compiler patch

* "dtc: Dynamic symbols & fixup support (v3)"

The full patchset is applied to the following tree/branch:

git:    git@github.com:pantoniou/linux-beagle-track-mainline.git
branch: dt-ng/bbb
http:   https://github.com/pantoniou/linux-beagle-track-mainline/tree/dt-ng4/gcl-bbb

Changes since V7:
* Using the mainline resolver with the updated local fixups format.
* Drop delete capability using '-' prefix. The '-' prefixed names
are valid properties and nodes and there is no need for it just yet.
* Do not update special properties - name & phandle ones.
* Change order of node attachment, so that the special property update
works.

Changes since V6:
* Now using the updated transaction API.

Changes since V5:
* Rely on transactions for affecting changes to the live tree.
This makes the patchset considerably smaller, and easier to grok.
* Removed the internal API, simplyfing the interface.

Changes since V4:
* New API of_overlay_create/destroy being able to support stacked
overlays correctly.
* Removed use of notifiers internally.
* Removed own-grown bus handler notifiers; using already in-place DT
notification infrastructure.
* Split SPI notifier patch to one patch of generic changes and one
for DT overlay notifier.
* Removed unused overlay depth feature.
* Updated documentation.
* Moved configfs based interface to using the new API.
* Added overlay removal stacking tests.

Changes since V3:
* Added overlay self-tests.
* Fix bug in of_init_overlay_info (wrong sizeof)
* Platform bus handler handles parent_pdev == NULL
* of_resolve fixes according to comments by robh
 + changed if (foo == NULL) to if (!foo)
 + changed if (foo != NULL) to if (foo)
 + drivers/of/Kconfig added dep on OF && !SPARC
 + convert to using be32_to_cpup
 + u32 -> __be32 when modifying property values
 + cosmetic fixes

Changes since V2:
* Use of a configfs board agnostic overlay method
* Use of per bus handlers instead of hardcoded behaviour
* Optional target-path overlay target, which allows one to use standard
DTBs without resolution options.

Changes since V1:

* Removal of any bits related to a specific board (beaglebone).
* Introduced a platform agnostic interface using /proc/device-tree-overlay
* Various bug fixes related to i2c device handling have been squashed in.

Pantelis Antoniou (9):
 OF: Introduce Device Tree resolve support.
 OF: Introduce DT overlay support.
 OF: selftest: Add overlay self-test support.
 OF: DT-Overlay configfs interface
 OF: platform: Add OF notifier handler
 of: i2c: Export single device registration method
 OF: i2c: Add OF notifier handler
 of: spi: Export single device registration method and accessors
 OF: spi: Add OF notifier handler

Pantelis Antoniou (8):
  OF: Introduce DT overlay support. (v2)
  OF: selftest: Add overlay self-test support. (v2)
  OF: DT-Overlay configfs interface (v2)
  OF: platform: Add OF notifier handler
  of: i2c: Export single device registration method
  OF: i2c: Add OF notifier handler
  of: spi: Export single device registration method and accessors
  OF: spi: Add OF notifier handler

 Documentation/devicetree/bindings/selftest.txt |  14 +
 Documentation/devicetree/overlay-notes.txt     | 137 ++++++
 drivers/base/platform.c                        |  18 +-
 drivers/i2c/i2c-core.c                         | 178 +++++--
 drivers/of/Kconfig                             |  14 +
 drivers/of/Makefile                            |   2 +
 drivers/of/configfs.c                          | 340 +++++++++++++
 drivers/of/overlay.c                           | 656 +++++++++++++++++++++++++
 drivers/of/platform.c                          |  78 +++
 drivers/of/selftest.c                          | 481 ++++++++++++++++++
 drivers/of/testcase-data/testcases.dts         |  16 +
 drivers/of/testcase-data/tests-overlay.dtsi    | 180 +++++++
 drivers/spi/spi.c                              | 334 +++++++++----
 include/linux/i2c.h                            |  10 +
 include/linux/of.h                             |  31 ++
 include/linux/of_platform.h                    |  10 +
 16 files changed, 2351 insertions(+), 148 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/selftest.txt
 create mode 100644 Documentation/devicetree/overlay-notes.txt
 create mode 100644 drivers/of/configfs.c
 create mode 100644 drivers/of/overlay.c
 create mode 100644 drivers/of/testcase-data/tests-overlay.dtsi

-- 
1.7.12

