Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaLVQ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:57:44 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51518 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaLVQ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:57:42 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 3.19-rc1 v14 0/8] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Mon, 22 Dec 2014 16:57:17 +0000
Message-Id: <1419267445-8330-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes some single-platform compatibility tricks related
to DEBUG_LL and, as a result, allows multi_v7_defconfig derived builds
to enable DEBUG_LL. Currently the user selected kbuild setting is
ignored and the PL01X's DEBUG_LL stub is silently selected instead. This
is a pain if your hardware doesn't have this cell, not least because it
takes a little time to figure out that kbuild built the wrong code.

Warning:

    silentoldconfig on PL011 single platforms will result in DEBUG_LL
    being directed at ICEDCC rather than PL011. This should only
    affect silentoldconfig since oldconfig prompts and the defconfigs have
    been updated to avoid this problem.

Changes since v13:
- Rebased on 3.19-rc1 and dropped my patch for SA1100 which is
  obsoleted by commit e6131fa38354 ("ARM: debug: move StrongARM debug
  include to arch/arm/include/debug")

Changes since v12:
- v11 spuriously missed out changes from v10 and v11 (it was incorrectly
  derived from v9). All changes have been reinstated after thorough
  review of the diff between v13 and v11 (many thanks to Aaro Koskinen).
- Merged the changes to 8250 related changes to defconfig files into
  a single patch (Arnd Bergmann).

Changes since v11:
- Fixed sort order of Kconfig symbols (review of Russell King)
- Reviewed all defconfigs for the selection of DEBUG_UART_NONE.  All
  identified have 8250-based UARTs and are switched to DEBUG_LL_UART_8250
  (review of Arnd Bergmann).
- Fixed regression in the netx macros (bad setting of \rp and \rv.
- Rebased on latest mainline (v3.18-rc1). Note that two patches from v11
  were merged upstream and are no longer included here.
- Added a trivial fix to the defaults list for DEBUG_UART_PHYS which came
  to my attention as a merge conflict.

Changes since v10:
- Fixed typos in the omap1 config help texts (review of Aaro Koskinen).

Changes since v9:
- Removed a spuriously introduced (and unused) config variable from
  the netx patch (review of Paul Bolle).
- Fix netx macro to ensure \rv is correctly initialized.
- Rebased on v3.17rc4.

Changes since v8:
- Regenerated patch series with --find-renames to properly track code
  movement.

Changes since v7:
- Killed DEBUG_LL_UART_NONE completely and migrated over the four remaining
  platforms that relied on this (Arnd Bergmann, Russell King). This
  fixes some problems with oldconfig builds.
- Rebased on latest mainline (v3.17rc1).

Changes since v6:
- Removed a patch to limit DEBUG_LL_UART_NONE to platforms that support
  it because it almost time to drop DEBUG_LL_UART_NONE anyway (only
  four platforms still use it).
- Rebased on latest mainline (v3.16rc3).

Changes since v5:

- Shortened the list of platforms that can select DEBUG_LL_UART_NONE
  (changes Arnd Bergmann)
- Rebased on latest mainline (v3.15rc7).

Changes since v4:

- Rebased to latest mainline (and tested again). No functional changes.

Changes since v3:

- Converted from a single patch to a series.
- Tested defconfig builds of all impacted platforms.

Changes since v2:

- Switch from def_bool to bool (thanks Russell King)

Changes since v1:

- Remove pointless single platform support (thanks Arnd Bergmann)

Daniel Thompson (8):
  arm: cnx3xxxx: Remove spurious default for DEBUG_CNS3XXX
  arm: configs: Enable DEBUG_LL_UART_8250 where needed
  arm: Remove DEBUG_LL_UART_NONE
  arm: ks8695: Migrate debug_ll macros to shared directory
  arm: omap1: Migrate debug_ll macros to use 8250.S
  arm: netx: Migrate DEBUG_LL macros to shared directory
  arm: Seperate DEBUG_UART_PHYS from DEBUG_LL on EP93XX
  arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)

 arch/arm/Kconfig.debug                             | 101 +++++++++++++++++----
 arch/arm/configs/iop32x_defconfig                  |   1 +
 arch/arm/configs/iop33x_defconfig                  |   1 +
 arch/arm/configs/ixp4xx_defconfig                  |   1 +
 arch/arm/configs/lpc32xx_defconfig                 |   1 +
 arch/arm/configs/mv78xx0_defconfig                 |   1 +
 arch/arm/configs/orion5x_defconfig                 |   1 +
 arch/arm/configs/rpc_defconfig                     |   1 +
 .../mach/debug-macro.S => include/debug/ks8695.S}  |  10 +-
 .../mach/debug-macro.S => include/debug/netx.S}    |  22 ++---
 arch/arm/mach-omap1/include/mach/debug-macro.S     | 101 ---------------------
 11 files changed, 106 insertions(+), 135 deletions(-)
 rename arch/arm/{mach-ks8695/include/mach/debug-macro.S => include/debug/ks8695.S} (80%)
 rename arch/arm/{mach-netx/include/mach/debug-macro.S => include/debug/netx.S} (62%)
 delete mode 100644 arch/arm/mach-omap1/include/mach/debug-macro.S

--
1.9.3

