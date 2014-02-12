Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaBLBdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 20:33:31 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44346 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBLBda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 20:33:30 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Kees Cook <keescook@chromium.org>
Subject: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Date: Tue, 11 Feb 2014 17:33:22 -0800
Message-Id: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an RFC to seed the random number pool earlier when using devicetree.
The big issue this is trying to solve is the fact that the stack canary for
ARM tends to be the same across bootups of the same device. This is because
the random number pools do not get initialized until after the canary has
been set up. The canary can be moved later, but in general there is still
no way to reliably get random numbers early for other features (e.g. vector
randomization).

The goal here is to allow devices to add to the random pools via
add_device_randomness or some other method of their chosing at FDT time.
I realize that ARCH_RANDOM is already available but this didn't work because
1) ARCH_RANDOM is not multi-platform compatible without added
infrastructure to ARM
2) There is no uniform way to generate the random numbers which
would require an additional framework (same result as #1, different
reasons)
3) Given there is no uniform way to generate the random numbers, it seems
unlikely that 'early' random numbers would work the same as 'non-early'
random number which adds another layer of complexity.

The big reason to skip ARCH_RANDOM though is that the random number generation
we have would be reasonable if only seeded earlier.

Thanks,
Laura


Laura Abbott (3):
  of: Add early randomness hooks
  arm: Add ARCH_WANT_OF_RANDOMNESS
  init: Move stack canary initialization after setup_arch

 arch/arm/Kconfig                  |    3 ++
 arch/arm/kernel/vmlinux.lds.S     |    1 +
 drivers/of/Kconfig                |    7 ++++++
 drivers/of/Makefile               |    1 +
 drivers/of/fdt.c                  |    7 ++++++
 drivers/of/of_randomness.c        |   43 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |    5 ++++
 include/linux/of_randomness.h     |   42 ++++++++++++++++++++++++++++++++++++
 init/main.c                       |    9 +++----
 9 files changed, 113 insertions(+), 5 deletions(-)
 create mode 100644 drivers/of/of_randomness.c
 create mode 100644 include/linux/of_randomness.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

