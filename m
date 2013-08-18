Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3HRF44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 01:56:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39481 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab3HRF4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 01:56:54 -0400
Message-ID: <521061FB.2030504@ti.com>
Date: Sun, 18 Aug 2013 00:56:11 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2 02/14] crypto: omap-aes: Add useful debug macros
References: <1376793755-30478-1-git-send-email-joelf@ti.com>  <1376793755-30478-3-git-send-email-joelf@ti.com> <1376799747.2027.11.camel@joe-AO722>
In-Reply-To: <1376799747.2027.11.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 11:22 PM, Joe Perches wrote:
> On Sat, 2013-08-17 at 21:42 -0500, Joel Fernandes wrote:
>> When DEBUG is enabled, these macros can be used to print variables in integer
>> and hex format, and clearly display which registers, offsets and values are
>> being read/written , including printing the names of the offsets and their values.
>>
>> Note:
>> This patch results in a checkpatch error that cannot be fixed.
>> ERROR: Macros with multiple statements should be enclosed in a do - while loop
>> +#define omap_aes_read(dd, offset)                                      \
>> +       __raw_readl(dd->io_base + offset);                              \
>> +       pr_debug("omap_aes_read(" #offset ")\n");
>>
>> Using do-while loop will break a lot of code such as:
>> ret = omap_aes_read(..);
> 
> That's where you use a statement expression macro
> 
> #define omap_aes_read(dd, offset)					\
> ({									\
> 	pr_debug("omap_aes_read("omap_aes_read(" #offset ")\n");	\
> 	__raw_readl((dd)->iobase + offset);				\
> })
> 

That made things a lot simpler, thanks. Re-spinning just this patch as below:

--->8---

From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH] crypto: omap-aes: Add useful debug macros

When DEBUG is enabled, these macros can be used to print variables in integer
and hex format, and clearly display which registers, offsets and values are
being read/written , including printing the names of the offsets and their values.

Using statement expression macros in read path as,
Suggested-by: Joe Perches <joe@perches.com>

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ee15b0f..e26d4d4 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -13,7 +13,9 @@
  *
  */

-#define pr_fmt(fmt) "%s: " fmt, __func__
+#define pr_fmt(fmt) "%20s: " fmt, __func__
+#define prn(num) pr_debug(#num "=%d\n", num)
+#define prx(num) pr_debug(#num "=%x\n", num)

 #include <linux/err.h>
 #include <linux/module.h>
@@ -172,16 +174,36 @@ struct omap_aes_dev {
 static LIST_HEAD(dev_list);
 static DEFINE_SPINLOCK(list_lock);

+#ifdef DEBUG
+#define omap_aes_read(dd, offset)				\
+({								\
+	int _read_ret;						\
+	_read_ret = __raw_readl(dd->io_base + offset);		\
+	pr_debug("omap_aes_read(" #offset "=%#x)= %#x\n",	\
+		 offset, _read_ret);				\
+	_read_ret;						\
+})
+#else
 static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
 {
 	return __raw_readl(dd->io_base + offset);
 }
+#endif

+#ifdef DEBUG
+#define omap_aes_write(dd, offset, value)				\
+	do {								\
+		pr_debug("omap_aes_write(" #offset "=%#x) value=%#x\n",	\
+			 offset, value);				\
+		__raw_writel(value, dd->io_base + offset);		\
+	} while (0)
+#else
 static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
 				  u32 value)
 {
 	__raw_writel(value, dd->io_base + offset);
 }
+#endif

 static inline void omap_aes_write_mask(struct omap_aes_dev *dd, u32 offset,
 					u32 value, u32 mask)
-- 
1.7.9.5

