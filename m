Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaBXSBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:01:21 -0500
Received: from smtprelay0105.hostedemail.com ([216.40.44.105]:44048 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752579AbaBXSBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:01:19 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:981:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3871:3873:3874:4250:4321:5007:6119:7576:7652:7903:8603:10004:10400:10848:11026:11232:11657:11658:11914:12043:12295:12438:12517:12519:12555:12679:12694:12737:12740:13071:13161:13229:14093:14097:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: limit12_7faf4ccc83322
X-Filterd-Recvd-Size: 3941
Message-ID: <1393264876.11020.38.camel@joe-AO722>
Subject: Re: sisusb: Use static const, fix typo
From: Joe Perches <joe@perches.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Thomas Winischhofer <thomas@winischhofer.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 10:01:16 -0800
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6C9771@AcuExch.aculab.com>
References: <1393034412.3627.11.camel@joe-AO722>
	 <063D6719AE5E284EB5DD2968C1650D6D0F6C9771@AcuExch.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 10:26 +0000, David Laight wrote:
> From: Joe Perches
> > Reduce text a bit by using static const.
> 
> If you want to save a few bytes remove the pointers.
> (and the fixed RAM text to get below 7 chars).

Hi David.

> eg:
> 
> > -	const char *ramtypetext2[] = {	"SDR SDRAM", "SDR SGRAM",
> > -					"DDR SDRAM", "DDR SGRAM" };

The idea was use static to avoid the array reload
on each function entry.

> 	static const char ramtypetext2[8][] = {
> 		"SDR SD", "SDR SG", "DDR SD", "DDR SG"

8 is an odd number here.

That could be done with char like:

	static const char ram_datarate[4] = {'S', 'S', 'D', 'D'};
	static const char ram_dynamictype[4] = {'D', 'G', 'D', 'G'};
> ...
> > -	dev_info(&sisusb->sisusb_dev->dev, "%dMB %s %s, bus width %d\n", (sisusb->vramsize >> 20),
> > ramtypetext1,
> > -			ramtypetext2[ramtype], bw);
> 
> 	dev_info(&sisusb->sisusb_dev->dev, "%dMB %s %sRAM, bus width %d\n",
> 		 sisusb->vramsize >> 20, ramtypetext1, ramtypetext2[ramtype],
> 		 bw);

	dev_info(&sisusb->sisusb_dev->dev, "%dMB %s %c%cRAM, bus width %d\n",
		 sisusb->vramsize >> 20, ramtypetext1,
		 ram_datarate[ramtype], ram_dynamictype[ramtype], bw);

So something like:

Convert 1 char * array to 2 char arrays to reduce size.
Use static const to avoid array reloads on function entry.
Fix asymmetric typo.

$ size drivers/usb/misc/sisusbvga/sisusb.o*
   text	   data	    bss	    dec	    hex	filename
  29971	   4841	   9180	  43992	   abd8	drivers/usb/misc/sisusbvga/sisusb.o.new
  30083	   4841	   9180	  44104	   ac48	drivers/usb/misc/sisusbvga/sisusb.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/misc/sisusbvga/sisusb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index de98906..06b5d77 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -2123,8 +2123,8 @@ sisusb_get_ramconfig(struct sisusb_usb_data *sisusb)
 	u8 tmp8, tmp82, ramtype;
 	int bw = 0;
 	char *ramtypetext1 = NULL;
-	const char *ramtypetext2[] = {	"SDR SDRAM", "SDR SGRAM",
-					"DDR SDRAM", "DDR SGRAM" };
+	static const char ram_datarate[4] = {'S', 'S', 'D', 'D'};
+	static const char ram_dynamictype[4] = {'D', 'G', 'D', 'G'};
 	static const int busSDR[4]  = {64, 64, 128, 128};
 	static const int busDDR[4]  = {32, 32,  64,  64};
 	static const int busDDRA[4] = {64+32, 64+32 , (64+32)*2, (64+32)*2};
@@ -2156,8 +2156,10 @@ sisusb_get_ramconfig(struct sisusb_usb_data *sisusb)
 		break;
 	}
 
-	dev_info(&sisusb->sisusb_dev->dev, "%dMB %s %s, bus width %d\n", (sisusb->vramsize >> 20), ramtypetext1,
-			ramtypetext2[ramtype], bw);
+
+	dev_info(&sisusb->sisusb_dev->dev, "%dMB %s %cDR S%cRAM, bus width %d\n",
+		 sisusb->vramsize >> 20, ramtypetext1,
+		 ram_datarate[ramtype], ram_dynamictype[ramtype], bw);
 }
 
 static int


