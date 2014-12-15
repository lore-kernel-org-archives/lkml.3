Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaLOO4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:56:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaLOO2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 080/168] spi: Fix mapping from vmalloc-ed buffer to scatter list
Date: Mon, 15 Dec 2014 14:25:34 +0000
Message-Id: <1418653622-21105-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit c1aefbdd050e1fb15e92bcaf34d95b17ea952097 upstream.

We can only use page_address on memory that has been mapped using kmap,
when the buffer passed to the SPI has been allocated by vmalloc the page
has not necessarily been mapped through kmap. This means sometimes
page_address will return NULL causing the pointer we pass to sg_set_buf
to be invalid.

As we only call page_address so that we can pass a virtual address to
sg_set_buf which will then immediately call virt_to_page on it, fix this
by calling sg_set_page directly rather then relying on the sg_set_buf
helper.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index d4f9670b51bc..d9a59a0464cd 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -606,13 +606,13 @@ static int spi_map_buf(struct spi_master *master, struct device *dev,
 				sg_free_table(sgt);
 				return -ENOMEM;
 			}
-			sg_buf = page_address(vm_page) +
-				((size_t)buf & ~PAGE_MASK);
+			sg_set_page(&sgt->sgl[i], vm_page,
+				    min, offset_in_page(buf));
 		} else {
 			sg_buf = buf;
+			sg_set_buf(&sgt->sgl[i], sg_buf, min);
 		}
 
-		sg_set_buf(&sgt->sgl[i], sg_buf, min);
 
 		buf += min;
 		len -= min;
-- 
2.1.3

