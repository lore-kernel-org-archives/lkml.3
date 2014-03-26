Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaCZKcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:32:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37975 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaCZKb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:31:59 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>,
        "Ezequiel Garcia (ezequiel.garcia@free-electrons.com)" 
	<ezequiel.garcia@free-electrons.com>
Subject: RE: [RFC 43/47] mtd: nand: stm_nand_bch: read and write functions
 (BCH)
Thread-Topic: [RFC 43/47] mtd: nand: stm_nand_bch: read and write functions
 (BCH)
Thread-Index: AQHPSANC8jUEqMNnzUiCVLmh21QTXJrzK4kA
Date: Wed, 26 Mar 2014 10:31:14 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAB5CC7@DBDE04.ent.ti.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-44-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1395735604-26706-44-git-send-email-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

>From: Lee Jones [mailto:lee.jones@linaro.org]
>
>Helper function for bch_mtd_read() and bch_mtd_write() to handle
>multi-page or non-aligned reads and writes respectively.
>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---

I think below code is duplicate of nand_do_read_ops() and nand_do_write_ops()
in nand_base.c. If you could just populate chip->ecc.read_page and
chip->ecc.write_page much of this could be avoided.
Also, you need to break your bch_read_page() into given generic NAND
driver interfaces chip->ecc.calculate(), chip->ecc.correct() ...

This would make your driver much more simpler, and easy to maintain.


> drivers/mtd/nand/stm_nand_bch.c | 143 ++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 143 insertions(+)
>
>diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
>index 389ccee..bcaed32 100644
>--- a/drivers/mtd/nand/stm_nand_bch.c
>+++ b/drivers/mtd/nand/stm_nand_bch.c
>@@ -507,6 +507,149 @@ static uint8_t bch_write_page(struct nandi_controller *nandi,
> 	return status;
> }
>
>+/* Helper function for bch_mtd_read to handle multi-page or non-aligned reads */
>+static int bch_read(struct nandi_controller *nandi,
>+		    loff_t from, size_t len,
>+		    size_t *retlen, u_char *buf)
>+{
>+	struct mtd_ecc_stats stats;
>+	uint32_t page_size = nandi->info.mtd.writesize;
>+	uint32_t col_offs;
>+	loff_t page_mask;
>+	loff_t page_offs;
>+	int ecc_errs, max_ecc_errs = 0;
>+	int page_num;
>+	size_t bytes;
>+	uint8_t *p;
>+	bool bounce = false;
>+
>+	dev_dbg(nandi->dev, "%s: %llu @ 0x%012llx\n", __func__,
>+		(unsigned long long)len, from);
>+
>+	stats = nandi->info.mtd.ecc_stats;
>+	page_mask = (loff_t)page_size - 1;
>+	col_offs  = (uint32_t)(from & page_mask);
>+	page_offs = from & ~page_mask;
>+	page_num  = (int)(page_offs >> nandi->page_shift);
>+
>+	while (len > 0) {
>+		bytes = min((page_size - col_offs), len);
>+
>+		if ((bytes != page_size) ||
>+		    ((unsigned int)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
>+		    (!virt_addr_valid(buf))) /* vmalloc'd buffer! */
>+			bounce = true;
>+
>+		if (page_num == nandi->cached_page) {
>+			memcpy(buf, nandi->page_buf + col_offs, bytes);
>+			goto done;
>+		}
>+
>+		p = bounce ? nandi->page_buf : buf;
>+
>+		ecc_errs = bch_read_page(nandi, page_offs, p);
>+		if (bounce)
>+			memcpy(buf, p + col_offs, bytes);
>+
>+		if (ecc_errs < 0) {
>+			dev_err(nandi->dev,
>+				"%s: uncorrectable error at 0x%012llx\n",
>+				__func__, page_offs);
>+			nandi->info.mtd.ecc_stats.failed++;
>+
>+			/* Do not cache uncorrectable pages */
>+			if (bounce)
>+				nandi->cached_page = -1;
>+
>+			goto done;
>+		}
>+
>+		if (ecc_errs) {
>+			dev_info(nandi->dev,
>+				 "%s: corrected %u error(s) at 0x%012llx\n",
>+				 __func__, ecc_errs, page_offs);
>+
>+			nandi->info.mtd.ecc_stats.corrected += ecc_errs;
>+
>+			if (ecc_errs > max_ecc_errs)
>+				max_ecc_errs = ecc_errs;
>+		}
>+
>+		if (bounce)
>+			nandi->cached_page = page_num;
>+
>+done:
>+		buf += bytes;
>+		len -= bytes;
>+
>+		if (retlen)
>+			*retlen += bytes;
>+
>+		/* We are now page-aligned */
>+		page_offs += page_size;
>+		page_num++;
>+		col_offs = 0;
>+	}
>+
>+	/* Return '-EBADMSG' on uncorrectable errors */
>+	if (nandi->info.mtd.ecc_stats.failed - stats.failed)
>+		return -EBADMSG;
>+
>+	return max_ecc_errs;
>+}
>+
>+/* Helper function for mtd_write, to handle multi-page and non-aligned writes */
>+static int bch_write(struct nandi_controller *nandi,
>+		     loff_t to, size_t len,
>+		     size_t *retlen, const uint8_t *buf)
>+{
>+	uint32_t page_size = nandi->info.mtd.writesize;
>+	int page_num;
>+	bool bounce = false;
>+	const uint8_t *p = NULL;
>+	uint8_t ret;
>+
>+	dev_dbg(nandi->dev, "%s: %llu @ 0x%012llx\n", __func__,
>+		(unsigned long long)len, to);
>+
>+	BUG_ON(len & (page_size - 1));
>+	BUG_ON(to & (page_size - 1));
>+
>+	if (((unsigned long)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
>+	    !virt_addr_valid(buf)) { /* vmalloc'd buffer! */
>+		bounce = true;
>+	}
>+
>+	page_num = (int)(to >> nandi->page_shift);
>+
>+	while (len > 0) {
>+		if (bounce) {
>+			memcpy(nandi->page_buf, buf, page_size);
>+			p = nandi->page_buf;
>+			nandi->cached_page = -1;
>+		} else {
>+			p = buf;
>+		}
>+
>+		if (nandi->cached_page == page_num)
>+			nandi->cached_page = -1;
>+
>+		ret = bch_write_page(nandi, to, p);
>+		if (ret & NAND_STATUS_FAIL)
>+			return -EIO;
>+
>+		to += page_size;
>+		page_num++;
>+		buf += page_size;
>+		len -= page_size;
>+
>+		if (retlen)
>+			*retlen += page_size;
>+	}
>+
>+	return 0;
>+}
>+
> /*
>  * Hamming-FLEX operations
>  */
>--
>1.8.3.2


with regards, pekon
