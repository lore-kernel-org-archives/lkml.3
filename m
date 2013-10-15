Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641Ab3JOTcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:32:07 -0400
Received: from sauhun.de ([89.238.76.85]:36424 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933226Ab3JOTcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:32:03 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC RESEND 0/3] replace INIT_COMPLETION with reinit_completion
Date: Tue, 15 Oct 2013 21:31:17 +0200
Message-Id: <1381865480-3013-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had this on my mind for a bit of time now... When reviewing, I see problems
with the current INIT_COMPLETION because of inconsistencies. Quoting patch 1
for the motivation:

===

For the casual device driver writer, it is hard to remember when to use
init_completion (to init a completion structure) or INIT_COMPLETION (to
*reinit* a completion structure). Furthermore, while all other
completion functions exepct a pointer as a parameter, INIT_COMPLETION
does not. To make it easier to remember which function to use and to
make code more readable, introduce a new inline function with the proper
name and consistent argument type.

===

For this RFC, Patch 2/3 converts all current users in one go. I can split that
up easily later. I wonder what to do about the old INIT_COMPLETION, though. We
could:

a) remove it right away (bad luck for out-of-tree users; still my favourite)
b) keep it, but discourage its use (then we have cruft)
c) convert it to an inline function and mark that deprecated and remove it later

This series is based on v3.12-rc5  and I was able to compile test 74 out of 84
users, for the others I didn't have configs/compilers. Buildbots didn't
complain so far as well. The branch can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git reinit_completion

Looking forward to opinions. If accepted, I'd think it is probably best if this
gets in in one go via Linus directly?

Thanks,

   Wolfram


Wolfram Sang (3):
  sched: replace INIT_COMPLETION with reinit_completion
  tree-wide: use reinit_completion instead of INIT_COMPLETION
  sched: remove INIT_COMPLETION

 arch/arm/mach-tegra/apbio.c                        |  2 +-
 arch/powerpc/platforms/powermac/low_i2c.c          |  6 ++---
 arch/powerpc/platforms/pseries/suspend.c           |  2 +-
 crypto/af_alg.c                                    |  2 +-
 crypto/tcrypt.c                                    |  4 ++--
 crypto/testmgr.c                                   | 12 +++++-----
 drivers/ata/libata-eh.c                            |  4 ++--
 drivers/base/power/main.c                          |  4 ++--
 drivers/block/amiflop.c                            |  2 +-
 drivers/block/cciss.c                              |  4 ++--
 drivers/char/hw_random/timeriomem-rng.c            |  2 +-
 drivers/crypto/tegra-aes.c                         |  2 +-
 drivers/firewire/core-transaction.c                |  2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         |  2 +-
 drivers/hid/hid-wiimote.h                          |  2 +-
 drivers/hwmon/jz4740-hwmon.c                       |  2 +-
 drivers/i2c/busses/i2c-at91.c                      |  2 +-
 drivers/i2c/busses/i2c-bcm2835.c                   |  2 +-
 drivers/i2c/busses/i2c-davinci.c                   |  2 +-
 drivers/i2c/busses/i2c-designware-core.c           |  2 +-
 drivers/i2c/busses/i2c-ismt.c                      |  2 +-
 drivers/i2c/busses/i2c-mxs.c                       |  2 +-
 drivers/i2c/busses/i2c-omap.c                      |  2 +-
 drivers/i2c/busses/i2c-tegra.c                     |  2 +-
 drivers/i2c/busses/i2c-wmt.c                       |  4 ++--
 drivers/iio/adc/ad_sigma_delta.c                   |  6 ++---
 drivers/iio/adc/nau7802.c                          |  2 +-
 drivers/input/touchscreen/cyttsp_core.c            |  2 +-
 drivers/md/dm-crypt.c                              |  2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |  2 +-
 drivers/media/radio/radio-wl1273.c                 | 10 ++++----
 drivers/media/radio/si470x/radio-si470x-common.c   |  4 ++--
 drivers/media/rc/iguanair.c                        |  2 +-
 drivers/memstick/core/memstick.c                   |  2 +-
 drivers/memstick/host/r592.c                       |  2 +-
 drivers/misc/ti-st/st_kim.c                        | 12 +++++-----
 drivers/mtd/nand/mxc_nand.c                        |  2 +-
 drivers/mtd/nand/r852.c                            |  2 +-
 drivers/mtd/onenand/omap2.c                        | 10 ++++----
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  2 +-
 drivers/net/ieee802154/at86rf230.c                 |  2 +-
 drivers/net/ieee802154/mrf24j40.c                  |  2 +-
 drivers/net/wireless/ath/ath10k/htc.c              |  4 ++--
 drivers/net/wireless/ath/ath10k/mac.c              | 18 +++++++-------
 drivers/net/wireless/ath/carl9170/usb.c            |  2 +-
 drivers/net/wireless/ath/wil6210/main.c            |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  4 ++--
 drivers/net/wireless/zd1211rw/zd_usb.c             |  2 +-
 drivers/parport/parport_ip32.c                     |  4 ++--
 drivers/platform/x86/apple-gmux.c                  |  2 +-
 drivers/power/ab8500_fg.c                          |  4 ++--
 drivers/power/jz4740-battery.c                     |  2 +-
 drivers/rtc/rtc-hid-sensor-time.c                  |  2 +-
 drivers/spi/spi-bcm2835.c                          |  2 +-
 drivers/spi/spi-clps711x.c                         |  2 +-
 drivers/spi/spi-davinci.c                          |  2 +-
 drivers/spi/spi-fsl-espi.c                         |  2 +-
 drivers/spi/spi-fsl-spi.c                          |  2 +-
 drivers/spi/spi-mpc512x-psc.c                      |  2 +-
 drivers/spi/spi-mxs.c                              |  2 +-
 drivers/spi/spi-s3c64xx.c                          |  2 +-
 drivers/spi/spi-sh-msiof.c                         |  2 +-
 drivers/spi/spi-sirf.c                             |  4 ++--
 drivers/spi/spi-tegra114.c                         |  6 ++---
 drivers/spi/spi-tegra20-sflash.c                   |  2 +-
 drivers/spi/spi-tegra20-slink.c                    |  6 ++---
 drivers/spi/spi-xilinx.c                           |  2 +-
 drivers/staging/iio/adc/mxs-lradc.c                |  2 +-
 drivers/staging/media/solo6x10/solo6x10-p2m.c      |  2 +-
 drivers/staging/tidspbridge/core/sync.c            |  4 ++--
 .../staging/tidspbridge/include/dspbridge/sync.h   |  2 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |  6 ++---
 drivers/tty/metag_da.c                             |  2 +-
 drivers/usb/c67x00/c67x00-sched.c                  |  2 +-
 drivers/usb/gadget/f_fs.c                          |  2 +-
 drivers/usb/serial/mos7720.c                       |  2 +-
 drivers/video/exynos/exynos_mipi_dsi_common.c      |  4 ++--
 .../video/omap2/displays-new/encoder-tpd12s015.c   |  2 +-
 fs/ecryptfs/crypto.c                               |  2 +-
 fs/nfs/nfs4state.c                                 |  2 +-
 fs/ocfs2/dlmglue.c                                 |  4 ++--
 include/linux/completion.h                         | 28 ++++++++++++----------
 sound/soc/samsung/ac97.c                           |  6 ++---
 83 files changed, 149 insertions(+), 147 deletions(-)

-- 
1.8.4.rc3

