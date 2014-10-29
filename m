Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaJ2IVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:21:51 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45821 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbaJ2IVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:21:48 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v2 0/4] backports: kernel integration support
Date: Wed, 29 Oct 2014 01:21:38 -0700
Message-Id: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Here's a v2 spin on the previous RFCs with a new patch
added at the end that actually modifies gentree.py to
add the ability to do the kernel integration magic now.

If you'd like to test this get Linus' tree and reset it
to some old kernel:

git reset --hard v3.15

Then get linux-next and reset it to the latest supported
tag:

git reset --hard next-20141003o

apply this series on top of that lest backports tree and then
do somethine like:

mcgrof@ergon ~/backports (git::master)$ ./gentree.py --clean --integrate --gitdebug /home/mcgrof/linux-next/ /home/mcgrof/test-linus-tree/

The test-linus-tree in this case is a clone of Linus'
tree reset to v3.15. What this will do is add the drivers
that backports supports into that tree already backported
for you and with tha appropriate kconfig / makefile magic
done. The way we use --gitdebug is that since you are using
a git tree for Linus' tree you'll see commits of each
change done by the integration, this leverages off of
Johannes's git debug work but applies now also nicely
for integration to see each step.

On 'make menuconfig' you will now see a backports menu,
drivers will only be available if you do not enable them
on your older kernel options. Right now things build with
make M=backports and the last piece of integration with
vmlinux still needs some refinement. I notice that the
souce "drivers/..." on some backports/drivers/ Kconfig
files didn't get modified with source "backports/drivers/..."
so that needs to be fixed to populate more divers.

This obviously also needs testing to ensure we don't break
packaging of backports with ckmake, but we can start looking
at that once we at least complete integration which hopefully
shouldn't take much longer.

Reminder: we should add a Kconfig entry for the LINUX_BACKPORT
define symbol as part of this work as some folks dont' want
to use it.

Please note that this last patch was a bit sloppy but hence
the RFC, figured its best to get this out for more eyeball
review than hogging it up longer.

Luis R. Rodriguez (4):
  backports: replace CPTCFG prefix for CONFIG_BACKPORT
  backports: replace BACKPORT_PWD with BACKPORT_DIR
  backports: use BACKPORT_DIR prefix on kconfig sources
  backports: add kernl integration support to gentree.py

 backport/Kconfig                                   |   47 -
 backport/Kconfig.sources                           |   23 +
 backport/Makefile                                  |    7 +-
 backport/Makefile.build                            |    4 +-
 backport/Makefile.kernel                           |   54 +-
 backport/Makefile.real                             |    4 +-
 backport/backport-include/asm/dma-mapping.h        |    4 +-
 backport/backport-include/backport/backport.h      |    3 +-
 backport/backport-include/backport/checks.h        |   12 -
 backport/backport-include/backport/leds-disabled.h |    2 +-
 backport/backport-include/net/net_namespace.h      |    4 +-
 backport/compat/Makefile                           |   42 +-
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
 gentree.py                                         |  212 +++-
 lib/bpversion.py                                   |   48 +
 lib/kconfig.py                                     |  136 ++-
 patches/backport-adjustments/devcoredump.patch     |    4 +-
 45 files changed, 1323 insertions(+), 1047 deletions(-)
 delete mode 100644 backport/Kconfig
 create mode 100644 backport/Kconfig.sources
 delete mode 100644 backport/backport-include/backport/checks.h
 create mode 100644 lib/bpversion.py

-- 
2.1.1

