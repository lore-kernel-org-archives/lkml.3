Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3HRCoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:44:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57483 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab3HRCnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:50 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH v2 00/14] crypto: omap-aes: Improve DMA, add PIO mode and support for AM437x
Date: Sat, 17 Aug 2013 21:42:21 -0500
Message-ID: <1376793755-30478-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch series rewrites the DMA code to be cleaner and faster. Earlier,
only a single SG was used for DMA purpose, and the SG-list passed from the
crypto layer was being copied and DMA'd one entry at a time. This turns out to
be quite inefficient and lot of code, we replace it with much simpler approach
that directly passes the SG-list from crypto to the DMA layers for cases where
possible. For all cases where such a direct passing of SG list is not possible,
we create a new SG-list and do the copying. This is still better than before, as
we create an SG list as big as needed and not just 1-element list.

We also add PIO mode support to the driver, and switch to it whenever the DMA
channel allocation is not available. This also has shown to give good performance
for small blocks as shown below.

Tests have been performed on AM335x, OMAP4 and AM437x SoCs.

Below is a sample run on AM335x SoC (beaglebone board), showing
performance improvement (20% for 8K blocks):

With DMA rewrite (key size = 128-bit)
16 byte blocks: 4318 operations in 1 seconds (69088 bytes)
64 byte blocks: 4360 operations in 1 seconds (279040 bytes)
256 byte blocks: 3609 operations in 1 seconds (923904 bytes)
1024 byte blocks: 3418 operations in 1 seconds (3500032 bytes)
8192 byte blocks: 1766 operations in 1 seconds (14467072 bytes)

Without DMA rewrite:
16 byte blocks: 4417 operations in 1 seconds (70672 bytes)
64 byte blocks: 4221 operations in 1 seconds (270144 bytes)
256 byte blocks: 3528 operations in 1 seconds (903168 bytes)
1024 byte blocks: 3281 operations in 1 seconds (3359744 bytes)
8192 byte blocks: 1460 operations in 1 seconds (11960320 bytes)

With PIO mode, good performance is observed for small blocks:
16 byte blocks: 20585 operations in 1 seconds (329360 bytes)
64 byte blocks: 8106 operations in 1 seconds (518784 bytes)
256 byte blocks: 2359 operations in 1 seconds (603904 bytes)
1024 byte blocks: 605 operations in 1 seconds (619520 bytes)
8192 byte blocks: 79 operations in 1 seconds (647168 bytes)

Future work in this direction would be to dynamically change between PIO/DMA mode
based on the block size.

Changes since last series:
* Unaligned cases for omap-aes are handled with patch: 
   "Add support for cases of unaligned lengths"
* Support for am437x SoC is added and tested.
* Changes following review comments on debug patch 

Note:
  The debug patch:  "crypto: omap-aes: Add useful debug macros" will generate
  a checkpatch error, which cannot be fixed. Refer to patch for error message
  and reasons for why cannot be fixed, thanks.

Joel Fernandes (14):
  crypto: scatterwalk:  Add support for calculating number of SG
    elements
  crypto: omap-aes: Add useful debug macros
  crypto: omap-aes: Populate number of SG elements
  crypto: omap-aes: Simplify DMA usage by using direct SGs
  crypto: omap-aes: Sync SG before DMA operation
  crypto: omap-aes: Remove previously used intermediate buffers
  crypto: omap-aes: Add IRQ info and helper macros
  crypto: omap-aes: PIO mode: Add IRQ handler and walk SGs
  crypto: omap-aes: PIO mode: platform data for OMAP4/AM437x and
    trigger
  crypto: omap-aes: Switch to PIO mode during probe
  crypto: omap-aes: Add support for cases of unaligned lengths
  crypto: omap-aes: Convert kzalloc to devm_kzalloc
  crypto: omap-aes: Convert request_irq to devm_request_irq
  crypto: omap-aes: Kconfig: Add build support for AM437x

 crypto/scatterwalk.c         |   22 ++
 drivers/crypto/Kconfig       |    2 +-
 drivers/crypto/omap-aes.c    |  466 +++++++++++++++++++++++-------------------
 include/crypto/scatterwalk.h |    2 +
 4 files changed, 284 insertions(+), 208 deletions(-)

-- 
1.7.9.5

