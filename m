Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3KKKTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:19:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46203 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3KKKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:19:43 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, catalin.marinas@arm.com, hpa@zytor.com,
        steve.capper@linaro.org, ak@linux.intel.com, dave.martin@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/4] wire up CPU features to udev based module loading
Date: Mon, 11 Nov 2013 11:19:31 +0100
Message-Id: <1384165175-16134-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements automatic module loading based on optional CPU features,
and tries to do so in a generic way.

Typical usage would look like this:

static struct cpu_feature mod_cpu_feature[] = {
	{ HWCAP_CRC32 },
	{}
};
MODULE_DEVICE_TABLE(cpu, mod_cpu_feature);

where (on the arm64 arch) the module in question would be loaded automatically
if the CPU has support for the optional CRC instructions. [Note that the example
is based on a pending patch by Steve Capper: 'arm64: Add hwcaps for crypto and
CRC32 extensions']

Changes wrt RFC version of this series:
- this time, instead of doing something entirely separate for non-x86 archs, the
  new generic modalias version allocates enough bits to cover all x86 features
  (320+), and the x86 version was tweaked to resemble the generic one more
  closely (i.e., both use 'cpu:type:...:feature:...' now)
- removed the weak and alias GCC attribute foo

Ard Biesheuvel (4):
  x86: move arch_cpu_uevent() to generic code
  cpu: advertise CPU features over udev in a generic way
  x86: align with generic cpu modalias
  arm64: advertise CPU features for modalias matching

 arch/arm64/Kconfig                |  3 +++
 arch/arm64/kernel/setup.c         | 20 ++++++++++++++++++++
 arch/x86/kernel/cpu/match.c       | 14 +-------------
 drivers/base/cpu.c                | 15 ++++++++++++++-
 include/linux/cpu.h               |  1 -
 include/linux/mod_devicetable.h   | 11 +++++++++++
 scripts/mod/devicetable-offsets.c |  3 +++
 scripts/mod/file2alias.c          | 20 +++++++++++++++-----
 8 files changed, 67 insertions(+), 20 deletions(-)

-- 
1.8.3.2

