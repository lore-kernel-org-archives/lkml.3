Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaJ1SBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:01:09 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36103 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaJ1SBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:01:06 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 0/3] backports: kernel integration support
Date: Tue, 28 Oct 2014 11:00:57 -0700
Message-Id: <1414519260-4780-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Here's my first batch if changes I've been grooming so far
in order to support kernel integration for backports, that
is in oder to allow folks to use backports to place drivers
from future kernels backported for target specific older
kernel source trees.

We got away with not doing much modifications on backports
for external module packages by relying on the CPTCFG hack
which in itself relies on the fact that kconfig internally
uses CONFIG_ as a macro for a getenv(), for kernel integration
relying on this doesn't work well, so we either diverge for
kernel integration or try to find a unified solution. Since
we have to address built-in support it seems best to just
address unifying the solution so I went with a CONFIG_BACKPORT
prefix instead of CPTCFG. This requires quite a bit of changes
on the Kconfig entries but also on the Makefiles.

Another set of changes required for kernel integration is to
ensure we provide a full path to the directory where we have
our backport sources, for an external package this is all
relateive to the parent directory but for kernel integration
I've stuffed all backport code on the backports/ directory
of the kernel source, this meant having to specify a variable
for our paths so that we can use the same Makefiles for both
packages / kernel integration.

This bit of changes are just the first step, but since this
is also a major change I think its best we start reviewing
this now. So far things look OK and I just have to address
what went wrong with compilation on older kernels:

mcgrof@drvbp1 ~/build/next-20141023 $ cat ckmake-report.log 
1   3.0.101             [  FAIL  ]
2   3.1.10              [  FAIL  ]
3   3.2.62              [  FAIL  ]
4   3.3.8               [  FAIL  ]
5   3.4.104             [  FAIL  ]
6   3.5.7               [  FAIL  ]
7   3.6.11              [  FAIL  ]
8   3.7.10              [  FAIL  ]
9   3.8.13              [  FAIL  ]
10  3.9.11              [  FAIL  ]
11  3.10.58             [  OK  ]
12  3.11.10             [  OK  ]
13  3.12.31             [  OK  ]
14  3.13.11             [  OK  ]
15  3.14.22             [  OK  ]
16  3.15.10             [  OK  ]
17  3.16.6              [  OK  ]
18  3.17.1              [  OK  ]
19  3.18-rc1            [  OK  ]

Once this is address the next steps to take to finish
kernel integration shouldn't be too hard. The real difficulty
here is actually the logic behind what we should do for symbols
on the kconfig entries once backported. I've stuffed most of
that logic on the kconfig library we have, it is OK but with
time I think we might want something a bit more well refined.

If this looks OK I'll continue to chug on. Let me know.

Luis R. Rodriguez (3):
  backports: replace CPTCFG prefix for CONFIG_BACKPORT
  backports: replace BACKPORT_PWD with BACKPORT_DIR
  backports: use BACKPORT_DIR prefix on kconfig sources

 backport/Kconfig                                   |   43 +-
 backport/Makefile                                  |    6 +-
 backport/Makefile.build                            |    4 +-
 backport/Makefile.kernel                           |   36 +-
 backport/Makefile.real                             |    4 +-
 backport/backport-include/asm/dma-mapping.h        |    4 +-
 backport/backport-include/backport/backport.h      |    1 -
 backport/backport-include/backport/checks.h        |   12 -
 backport/backport-include/backport/leds-disabled.h |    2 +-
 backport/backport-include/net/net_namespace.h      |    4 +-
 backport/compat/Makefile                           |   38 +-
 backport/compat/backport-3.15.c                    |    4 +-
 backport/compat/backports.h                        |    4 +-
 backport/defconfigs/alx                            |    2 +-
 backport/defconfigs/ar5523                         |   16 +-
 backport/defconfigs/ath10k                         |   22 +-
 backport/defconfigs/ath5k                          |   16 +-
 backport/defconfigs/ath6kl                         |   14 +-
 backport/defconfigs/ath9k                          |   18 +-
 backport/defconfigs/ath9k-debug                    |   38 +-
 backport/defconfigs/b43                            |   40 +-
 backport/defconfigs/b43legacy                      |   24 +-
 backport/defconfigs/brcmfmac                       |   14 +-
 backport/defconfigs/brcmsmac                       |   18 +-
 backport/defconfigs/carl9170                       |   16 +-
 backport/defconfigs/cw1200                         |   18 +-
 backport/defconfigs/hwsim                          |   24 +-
 backport/defconfigs/ieee802154                     |   16 +-
 backport/defconfigs/igb                            |    4 +-
 backport/defconfigs/iwlwifi                        |   34 +-
 backport/defconfigs/media                          | 1026 ++++++++++----------
 backport/defconfigs/nfc                            |   40 +-
 backport/defconfigs/rtlwifi                        |   46 +-
 backport/defconfigs/wcn36xx                        |   26 +-
 backport/defconfigs/wifi                           |  232 ++---
 backport/defconfigs/wil6210                        |   10 +-
 backport/defconfigs/wwan                           |   12 +-
 backport/scripts/uninstall.sh                      |    4 +-
 devel/ckmake                                       |    4 +-
 devel/doc/kconfig-operation                        |   22 +-
 gentree.py                                         |   30 +-
 lib/kconfig.py                                     |  126 ++-
 patches/backport-adjustments/devcoredump.patch     |    4 +-
 43 files changed, 1092 insertions(+), 986 deletions(-)
 delete mode 100644 backport/backport-include/backport/checks.h

-- 
2.1.1

