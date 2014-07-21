Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaGUEhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 00:37:00 -0400
Received: from seketeli.net ([94.23.218.202]:59310 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbaGUEg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 00:36:58 -0400
From: Apelete Seketeli <apelete@seketeli.net>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alex Smith <alex.smith@imgtec.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/2] Use DMA for data transfers in JZ4740 MMC driver
Date: Mon, 21 Jul 2014 06:37:43 +0200
Message-Id: <1405917465-18185-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

MMC driver for JZ4740 SoC is currently relying on PIO mode only for
data transfers.

The patches that come as a follow-up of this message allow the use of
DMA for data transfers.

Changes since v5:
  - added a new patch to this series, on top of the previous one, to
    prepare next dma transfer in parallel with current transfer,

  - updated the benchmarks in this cover letter for the aforementioned
    patch.

Changes since v4:
  - prefix functions with jz4740_mmc_ instead of jz4740_ to keep
    consistency with the rest of the code,

  - test (host->sg_len == 0) instead of (host->sg_len < 0) after
    dma_map_sg() in jz4740_mmc_start_dma_transfer() according to
    dmaengine.txt instructions.

Changes since v3:
  - use DMA engine device instead of MMC device in dma_map_sg() and
    dma_unmap_sg() as the memory transfers will be performed by the
    DMA engine,

  - remove unnecessary mem_res == NULL check in jz4740_mmc_probe()
    since devm_ioremap_resource() handles the mem_res == NULL case and
    print a message,

  - added a check to host->use_dma in jz4740_mmc_remove() to avoid
    calling jz4740_release_dma_channels() unnecessarily.

Changes since v2:
  - declare sg_len member of struct jz4740_mmc_host as int instead of
    unsigned int.

Changes since v1:
  - remove blank line added by mistake in jz_mmc_prepare_data_transfer().

According to the following PIO vs DMA benchmarks there seems to be a
slight improvement in transfer speed with the Ben NanoNote booting
from SD card, while load average seems to be roughly on par.

No noticeable improvement in the DMA vs DMA + MMC asynchronous
requests case. The latter change should help reduce the impact of DMA
preparation overhead on fast SD cards performance though:

* With DMA + MMC asynchronous requests:

Test cases |             root@BenNanoNote:/# uptime              |   root@BenNanoNote:/# time zcat root/fedora-16.iso.gz > /dev/null && uptime
-----------|----------------------------------------------------------------------------------------------------------------------------------
Test run 1 | 00:01:35 up 1 min,  load average: 1.31, 0.44, 0.15  |  00:06:46 up 6 min,  load average: 2.53, 1.75, 0.81
Test run 2 | 00:10:09 up 1 min,  load average: 1.26, 0.42, 0.14  |  00:15:20 up 6 min,  load average: 2.46, 1.73, 0.80
Test run 3 | 00:31:22 up 1 min,  load average: 1.30, 0.44, 0.15  |  00:36:33 up 6 min,  load average: 2.45, 1.73, 0.80
-----------|----------------------------------------------------------------------------------------------------------------------------------
  Average  |             1 min,  load average: 1.29, 0.43, 0.14  |              6 min,  load average: 2.48, 1.73, 0.80


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


Changes were rebased on top of linux master branch, built and tested
successfully.

The following changes since commit 9a3c414:

  Linux 3.16-rc6

are available in the git repository at:

  git://git.seketeli.net/~apelete/linux.git jz4740-mmc-dma

Apelete Seketeli (2):
  mmc: jz4740: add dma infrastructure for data transfers
  mmc: jz4740: prepare next dma transfer in parallel with current
    transfer

 drivers/mmc/host/jz4740_mmc.c |  268 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 260 insertions(+), 8 deletions(-)

-- 
1.7.10.4

