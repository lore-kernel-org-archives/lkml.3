Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbaJXK5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:57:02 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51652 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbaJXKzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:55:19 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v12 00/15] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Fri, 24 Oct 2014 11:54:21 +0100
Message-Id: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
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

Daniel Thompson (15):
  arm: cnx3xxxx: Remove spurious default for DEBUG_CNS3XXX
  arm: iop32x: Enable DEBUG_LL_UART_8250
  arm: iop33x: Enable DEBUG_LL_UART_8250
  arm: ixp4xx: Enable DEBUG_LL_UART_8250
  arm: lpc32xx: Enable DEBUG_LL_UART_8250
  arm: mv78xx0: Enable DEBUG_LL_UART_8250
  arm: orion5x: Enable DEBUG_LL_UART_8250
  arm: rpc: Enable DEBUG_LL_UART_8250
  arm: Remove DEBUG_LL_UART_NONE
  arm: ks8695: Migrate debug_ll macros to shared directory
  arm: omap1: Migrate debug_ll macros to use 8250.S
  arm: netx: Migrate DEBUG_LL macros to shared directory
  arm: sa1100: Migrate DEBUG_LL macros to shared directory
  arm: Seperate DEBUG_UART_PHYS from DEBUG_LL on EP93XX
  arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)

 arch/arm/Kconfig.debug                             | 141 +++++++++++++++++----
 arch/arm/configs/iop32x_defconfig                  |   1 +
 arch/arm/configs/iop33x_defconfig                  |   1 +
 arch/arm/configs/ixp4xx_defconfig                  |   1 +
 arch/arm/configs/lpc32xx_defconfig                 |   1 +
 arch/arm/configs/mv78xx0_defconfig                 |   1 +
 arch/arm/configs/orion5x_defconfig                 |   1 +
 arch/arm/configs/rpc_defconfig                     |   1 +
 .../mach/debug-macro.S => include/debug/ks8695.S}  |  10 +-
 .../mach/debug-macro.S => include/debug/netx.S}    |  22 ++--
 arch/arm/include/debug/sa1100.S                    |  37 ++++++
 arch/arm/mach-omap1/include/mach/debug-macro.S     | 101 ---------------
 arch/arm/mach-sa1100/include/mach/debug-macro.S    |  62 ---------
 13 files changed, 181 insertions(+), 199 deletions(-)
 rename arch/arm/{mach-ks8695/include/mach/debug-macro.S => include/debug/ks8695.S} (80%)
 rename arch/arm/{mach-netx/include/mach/debug-macro.S => include/debug/netx.S} (62%)
 create mode 100644 arch/arm/include/debug/sa1100.S
 delete mode 100644 arch/arm/mach-omap1/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-sa1100/include/mach/debug-macro.S

--
1.9.3

