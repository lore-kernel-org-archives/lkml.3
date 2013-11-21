Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3KUPmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:42:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41689 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3KUPmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:42:44 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        catalin.marinas@arm.com, hpa@zytor.com, ak@linux.intel.com,
        mingo@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/4] wire up CPU features to udev based module loading
Date: Thu, 21 Nov 2013 16:42:28 +0100
Message-Id: <1385048552-12528-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86 maintainer(s): if you have no objections to this approach, may I please have
your ack(s) on the x86 bits so I can work with Catalin to take the series
upstream through his tree?

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

Changes wrt v1:
- use ELF_PLATFORM rather than hardcoded name for printing modalias on arm64

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

