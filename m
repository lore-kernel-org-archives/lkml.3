Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaGETxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:53:10 -0400
Received: from seketeli.net ([94.23.218.202]:48853 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbaGETxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:53:08 -0400
From: Apelete Seketeli <apelete@seketeli.net>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alex Smith <alex.smith@imgtec.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] Use DMA for data transfers in JZ4740 MMC driver
Date: Sat,  5 Jul 2014 21:53:35 +0200
Message-Id: <1404590016-15093-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

MMC driver for JZ4740 SoC is currently relying on PIO mode only for
data transfers.

The patch that comes as a follow-up of this message allows the use of
DMA for data transfers.

Changes since v1:
  - remove blank line added by mistake in jz_mmc_prepare_data_transfer().

According to the following DMA vs PIO benchmarks there seems to be a
slight improvement in transfer speed with the Ben NanoNote booting
from SD card, while load average seems to be roughly on par:

* With DMA:

Test cases |             root@BenNanoNote:/# uptime              |   root@BenNanoNote:/# time zcat root/fedora-16.iso.gz > /dev/null && uptime
-----------|----------------------------------------------------------------------------------------------------------------------------------
Test run 1 | 00:20:55 up 1 min,  load average: 1.26, 0.42, 0.14  |  00:26:10 up 6 min,  load average: 2.89, 1.94, 0.89
Test run 2 | 00:30:22 up 1 min,  load average: 1.16, 0.38, 0.13  |  00:35:34 up 6 min,  load average: 2.68, 1.86, 0.85
Test run 3 | 00:39:56 up 1 min,  load average: 1.16, 0.38, 0.13  |  00:45:06 up 6 min,  load average: 2.57, 1.76, 0.81
-----------|----------------------------------------------------------------------------------------------------------------------------------
  Average  |             1 min,  load average: 1.19, 0.39, 0.13  |              6 min,  load average: 2.71, 1.85, 0.85


* With PIO:

Test cases |             root@BenNanoNote:/# uptime              |   root@BenNanoNote:/# time zcat root/fedora-16.iso.gz > /dev/null && uptime
----------------------------------------------------------------------------------------------------------------------------------------------
Test run 1 | 00:50:47 up 1 min,  load average: 1.42, 0.49, 0.17  |  00:56:52 up 7 min,  load average: 2.47, 2.00, 0.98
Test run 2 | 01:00:19 up 1 min,  load average: 1.21, 0.39, 0.14  |  01:06:29 up 7 min,  load average: 2.45, 1.96, 0.96
Test run 3 | 01:11:27 up 1 min,  load average: 1.15, 0.36, 0.12  |  01:17:33 up 7 min,  load average: 2.63, 2.01, 0.97
-----------|----------------------------------------------------------------------------------------------------------------------------------
  Average  |             1 min,  load average: 1.26, 0.41, 0.14  |              7 min,  load average: 2.52, 1.99, 0.97


DMA tranfers performance might be further improved with a latter patch
by taking advantage of the asynchronous request capability of the MMC
framework.

Changes were rebased on top of linux master branch, built and tested
successfully.

The following changes since commit 4c83445:

  Linux 3.16-rc3

are available in the git repository at:

  git://git.seketeli.net/~apelete/linux.git mmc-dma-jz4740

Apelete Seketeli (1):
  mmc: jz4740: add dma infrastructure for data transfers

 drivers/mmc/host/jz4740_mmc.c |  172 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 164 insertions(+), 8 deletions(-)

-- 
1.7.10.4

