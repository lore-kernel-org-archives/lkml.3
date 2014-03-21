Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbaCUQh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:37:26 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:45653 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753154AbaCUQhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:37:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2689:2729:2828:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3871:3872:3874:4225:4321:5007:7652:7875:7903:10004:10400:10471:10848:10946:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13255:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: end10_7a5c8872e2f18
X-Filterd-Recvd-Size: 3930
Message-ID: <1395419839.7776.108.camel@joe-AO722>
Subject: rfc: vsprintf and phys_addr_t and dma_addr_t via %pa (was Re:
 [PATCH] spi: fix spi-atmel.c printk format warnings)
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org, Wenyou Yang <wenyou.yang@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 21 Mar 2014 09:37:19 -0700
In-Reply-To: <532C6085.9070203@infradead.org>
References: <532C6085.9070203@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Stepan Moskovchenko who added %pa to vsprintf)

On Fri, 2014-03-21 at 08:53 -0700, Randy Dunlap wrote:
> Fix printk format warning by using %p extension 'ad' for dma_addr_t.

Hey Randy, Stepan and everyone else as well.

One of the things I'd like to get straightened out
before too many of these dma_addr_t conversions are
done is whether or not it should be prefixed by 0x.

%pad is not a direct replacement for %08x or %016x.
It changes the output.

Right now, all phys_addr_t and dma_addr_t types emitted
using %pa[pd] are "SPECIAL", meaning these are prefixed
with "0x".

No other pointer/address types have that "0x" prefix.

I'd prefer to remove the "SPECIAL" from the %pa extension
so that the output form of pointer/address types are
consistent.

This would change several output lines already using %pa.

I don't think that's bad, but maybe others do.

Thoughts?

---
 lib/vsprintf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 185b6d3..28fee91 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1161,18 +1161,18 @@ char *address_val(char *buf, char *end, const void *addr,
 {
 	unsigned long long num;
 
-	spec.flags |= SPECIAL | SMALL | ZEROPAD;
+	spec.flags |= SMALL | ZEROPAD;
 	spec.base = 16;
 
 	switch (fmt[1]) {
 	case 'd':
 		num = *(const dma_addr_t *)addr;
-		spec.field_width = sizeof(dma_addr_t) * 2 + 2;
+		spec.field_width = sizeof(dma_addr_t) * 2;
 		break;
 	case 'p':
 	default:
 		num = *(const phys_addr_t *)addr;
-		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
+		spec.field_width = sizeof(phys_addr_t) * 2;
 		break;
 	}
 


> drivers/spi/spi-atmel.c:1228:3: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]
> drivers/spi/spi-atmel.c:1228:3: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/spi/spi-atmel.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> I thought that a patch for this was already posted but I can't find it...
> Applies to mainline.
> 
> --- linux-next-20140321.orig/drivers/spi/spi-atmel.c
> +++ linux-next-20140321/drivers/spi/spi-atmel.c
> @@ -1226,10 +1226,10 @@ static int atmel_spi_transfer_one_messag
>  
>  	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
>  		dev_dbg(&spi->dev,
> -			"  xfer %p: len %u tx %p/%08x rx %p/%08x\n",
> +			"  xfer %p: len %u tx %p/%pad rx %p/%pad\n",
>  			xfer, xfer->len,
> -			xfer->tx_buf, xfer->tx_dma,
> -			xfer->rx_buf, xfer->rx_dma);
> +			xfer->tx_buf, &xfer->tx_dma,
> +			xfer->rx_buf, &xfer->rx_dma);
>  	}


