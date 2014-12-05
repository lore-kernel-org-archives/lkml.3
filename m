Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaLEWw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:52:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaLEWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 087/122] spi: Fix mapping from vmalloc-ed buffer to scatter list
Date: Fri,  5 Dec 2014 14:44:21 -0800
Message-Id: <20141205223318.881920786@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -609,13 +609,13 @@ static int spi_map_buf(struct spi_master
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


