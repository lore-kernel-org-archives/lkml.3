Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaI3NwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:52:16 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:55759 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaI3NwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:52:14 -0400
Message-ID: <1412085083.10205.8.camel@L80496>
Subject: Re: [PATCH] tc: fix warning and coding style
From: Thibaut Robert <thibaut.robert@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Sep 2014 15:51:23 +0200
In-Reply-To: <CAMuHMdXj=b0G7foTRkcEtRC_De8+WjVefxBfW=s1sjaXLeF5nQ@mail.gmail.com>
References: <1412079396-26005-1-git-send-email-thibaut.robert@gmail.com>
	 <CAMuHMdXj=b0G7foTRkcEtRC_De8+WjVefxBfW=s1sjaXLeF5nQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Le mardi 30 septembre 2014 à 14:28 +0200, Geert Uytterhoeven a écrit :
> Hi Thibaut,
> 
> On Tue, Sep 30, 2014 at 2:16 PM, Thibaut Robert
> <thibaut.robert@gmail.com> wrote:
> > Fix gcc warning:
> > warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘resource_size_t’ [-Wformat=]
> >
> > As resource_size_t can be 32 or 64 bits (depending on CONFIG_RESOURCES_64BIT), this patch uses "%lld" format along with a cast to u64 for printing resource_size_t values
> 
> Please use %pR instead (cfr. Documentation/printk-formats.txt).

This code use 'resource_size_t' but I think %pR is for 'struct resource'. I got inspired by this patch: https://lkml.org/lkml/2008/8/29/187 

However, I've thought again, and '%u' is probably enough for displaying a size in MiB. So I propose the following :
(Parens around the cast were also missing in my first patch):

@@ -117,10 +114,10 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)
 			tdev->resource.start = extslotaddr;
 			tdev->resource.end = extslotaddr + devsize - 1;
 		} else {
-			printk(KERN_ERR "%s: Cannot provide slot space "
-			       "(%dMiB required, up to %dMiB supported)\n",
-			       dev_name(&tdev->dev), devsize >> 20,
-			       max(slotsize, extslotsize) >> 20);
+			dev_err(&tdev->dev,
+				"Cannot provide slot space (%uMiB required, up to %uMiB supported)\n",
+				(unsigned int) (devsize >> 20),
+				(unsigned int) (max(slotsize, extslotsize) >> 20));
 			kfree(tdev);
 			goto out_err;
 		}


WDYT ?

Thibaut



