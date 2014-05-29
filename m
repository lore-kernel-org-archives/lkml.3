Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbaE2N4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:56:39 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33854 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934495AbaE2N4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:56:36 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v5 0/9] Introducing (yet again) Device Tree Overlays
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1401281193-27146-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1401281193-27146-1-git-send-email-pantelis.antoniou@konsulko.com>
Date: Thu, 29 May 2014 14:56:29 +0100
Message-Id: <20140529135629.DEAA7C40A85@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 15:46:24 +0300, Pantelis Antoniou <pantelis.antoniou@konsulko.com> wrote:
> The following patchset introduces Device Tree overlays, a method
> of dynamically altering the kernel's live Device Tree, along with
> a generic interface to use it in a board agnostic manner.
> 
> It is against linux-next as of today 28/5/2014
> "134a9c91121b1081bcf737045a11b0510c5c9dfb - Add linux-next specific files for 20140528"
> 
> It relies on the following previously submitted patches/patchsets:
> 
> * OF: Add [__]of_find_node_by_full_name
> * OF: Utility helper functions for dynamic nodes

In the next version, can you include the patches you depend on that
aren't already in my tree?

> To compile overlays you need the DTC compiler patch
> 
> * "dtc: Dynamic symbols & fixup support (v2)"
> 
> Changes since V4:
> * New API of_overlay_create/destroy being able to support stacked
> overlays correctly.
> * Removed use of notifiers internally.
> * Removed own-grown bus handler notifiers; using already in-place DT
> notification infrastructure.
> * Split SPI notifier patch to one patch of generic changes and one
> for DT overlay notifier.
> * Removed unused overlay depth feature.
> * Updated documentation.
> * Moved configfs based interface to using the new API.
> * Added overlay removal stacking tests.

Good changes. This version is considerably better than the past one.
I've still got comments, but I'm a lot more comfortable with the
approach.

> Changes since V3:
> * Added overlay self-tests.
> * Fix bug in of_init_overlay_info (wrong sizeof)
> * Platform bus handler handles parent_pdev == NULL
> * of_resolve fixes according to comments by robh
>   + changed if (foo == NULL) to if (!foo)
>   + changed if (foo != NULL) to if (foo)
>   + drivers/of/Kconfig added dep on OF && !SPARC
>   + convert to using be32_to_cpup
>   + u32 -> __be32 when modifying property values
>   + cosmetic fixes
> 
> Changes since V2:
> * Use of a configfs board agnostic overlay method
> * Use of per bus handlers instead of hardcoded behaviour
> * Optional target-path overlay target, which allows one to use standard
> DTBs without resolution options.
> 
> Changes since V1:
> 
> * Removal of any bits related to a specific board (beaglebone).
> * Introduced a platform agnostic interface using /proc/device-tree-overlay
> * Various bug fixes related to i2c device handling have been squashed in.
> 
> Pantelis Antoniou (9):
>   OF: Introduce Device Tree resolve support.
>   OF: Introduce DT overlay support.
>   OF: DT-Overlay configfs interface
>   OF: platform: Add OF notifier handler
>   of: i2c: Export single device registration method
>   OF: i2c: Add OF notifier handler
>   of: spi: Export single device registration method and accessors
>   OF: spi: Add OF notifier handler
>   OF: selftest: Add overlay self-test support.
> 
>  Documentation/devicetree/bindings/selftest.txt     |   14 +
>  .../devicetree/dynamic-resolution-notes.txt        |   25 +
>  Documentation/devicetree/overlay-notes.txt         |  160 ++++
>  drivers/base/platform.c                            |   69 +-
>  drivers/i2c/i2c-core.c                             |  165 +++-
>  drivers/of/Kconfig                                 |   20 +
>  drivers/of/Makefile                                |    3 +
>  drivers/of/configfs.c                              |  251 +++++
>  drivers/of/overlay.c                               | 1001 ++++++++++++++++++++
>  drivers/of/resolver.c                              |  378 ++++++++
>  drivers/of/selftest.c                              |  481 ++++++++++
>  drivers/of/testcase-data/testcases.dtsi            |    1 +
>  drivers/of/testcase-data/tests-overlay.dtsi        |  180 ++++
>  drivers/spi/spi.c                                  |  323 +++++--
>  include/linux/i2c.h                                |   10 +
>  include/linux/of.h                                 |  167 ++++
>  16 files changed, 3094 insertions(+), 154 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/selftest.txt
>  create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
>  create mode 100644 Documentation/devicetree/overlay-notes.txt
>  create mode 100644 drivers/of/configfs.c
>  create mode 100644 drivers/of/overlay.c
>  create mode 100644 drivers/of/resolver.c
>  create mode 100644 drivers/of/testcase-data/tests-overlay.dtsi
> 
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

