Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaKDInL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:43:11 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:64402 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaKDInI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:43:08 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 00/11] backports: add kernel integration support
Date: Tue,  4 Nov 2014 00:42:51 -0800
Message-Id: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This is a cleaned up respin of kernel integration support. It
splits up all the patches as much as possible and while doing
so noted a few adjustments that could be made that could help
simplify sharing paths / code between packaging and integration.
The biggest change here is I've dropped the CONFIG_BACKPORT idea
for packaging and kept the CPTCFG_ for that, we will only use
CONFIG_BACKPORT for kernel integration given that some folks
are already heavily relying on CPTCFG_ stuff and doing a major
change will cause pain.

To test, reset a linux git tree to tag v3.15 and linux-next to next-20141023
then do:

time ./gentree.py --gitdebug --clean --integrate /home/mcgrof/linux-next/ /home/mcgrof/linux/

real	0m58.616s
user	1m36.273s
sys	0m10.415s

So it takes ~1 minute on my laptop to integrate next-20141023 device
divers into v3.15 right now.

At first you will probably have a hard time trying to enable any driver
on the backports menu, the reason is you must first disable the respective
drivers that you would otherwise get from your kernel. Look at the last
patch for example of what options you need for example for cfg80211
and mac80211.

This goes run time tested with kernel integration on v3.15, and ckmake
compile tested for packaging across all supported kernels.  I suppose we'll
need a beefier machine if we want to do testing on integration all the
time for all supported kernels as well. Since integration is new integration
goes without much testing but with the hopes others will find it useful,
start testing it and expand on it.

Luis R. Rodriguez (11):
  backports: move legacy and SmPL patch application into helper
  backports: extend module_init() module_exit() for built-in
  backports: allow for different backport prefix
  backports: replace BACKPORT_PWD with BACKPORT_DIR
  backports: use BACKPORT_DIR prefix on kconfig sources
  backports: update dependencies map file
  backports: split Kconfig into Kconfig.package and Kconfig.sources
  backports: move version file generation to run earlier
  backports: use Kconfig for backport version information
  backports: prefix c-file / h-file auto backport with BPAUTO
  backports: add full kernel integration support

 backport/Kconfig                                   |  47 --
 backport/Kconfig.integrate                         |  36 ++
 backport/Kconfig.package                           |  49 +++
 backport/Kconfig.sources                           |  23 +
 backport/Makefile                                  |   6 +-
 backport/Makefile.build                            |   4 +-
 backport/Makefile.kernel                           |  17 +-
 backport/Makefile.real                             |  12 +-
 backport/backport-include/asm/dma-mapping.h        |   4 +-
 backport/backport-include/backport/backport.h      |   5 +
 backport/backport-include/backport/leds-disabled.h |   2 +-
 backport/backport-include/linux/module.h           |  31 +-
 backport/compat/Kconfig                            |  80 ++--
 backport/compat/Makefile                           |   8 +-
 backport/compat/backports.h                        |   4 +-
 backport/compat/main.c                             |  50 ++-
 backport/scripts/uninstall.sh                      |   4 +-
 dependencies                                       |  31 +-
 devel/ckmake                                       |   2 +
 devel/doc/kconfig-operation                        |   7 +-
 gentree.py                                         | 489 +++++++++++++--------
 .../0001-enable-backports-built-in.patch           |  40 ++
 lib/bpversion.py                                   |  48 ++
 lib/kconfig.py                                     | 159 ++++++-
 patches/backport-adjustments/devcoredump.patch     |   4 +-
 25 files changed, 821 insertions(+), 341 deletions(-)
 delete mode 100644 backport/Kconfig
 create mode 100644 backport/Kconfig.integrate
 create mode 100644 backport/Kconfig.package
 create mode 100644 backport/Kconfig.sources
 create mode 100644 integration-patches/0001-enable-backports/0001-enable-backports-built-in.patch
 create mode 100644 lib/bpversion.py

-- 
2.1.1

