Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaAGMag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:30:36 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:50806 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaAGMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:30:25 -0500
Subject: Re: [PATCH 1/2] GenWQE: Fix endian issues detected by sparse
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, jim.epost@gmail.com, sfr@canb.auug.org.au,
        gregkh@linuxfoundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kbuild-all@01.org
In-Reply-To: <20140107064130.GA5494@mwanda>
References: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
	 <1387553171-31469-1-git-send-email-haver@linux.vnet.ibm.com>
	 <20140107064130.GA5494@mwanda>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 07 Jan 2014 13:30:16 +0100
Message-ID: <1389097816.15325.7.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010712-2966-0000-0000-000009DDDCB0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Am Dienstag, den 07.01.2014, 09:41 +0300 schrieb Dan Carpenter:
> Could you also fix this Smatch warning?
> drivers/misc/genwqe/card_dev.c:658 do_flash_update() warn: maybe return -EFAULT instead of the bytes remaining?

I thought i fixed this already in my posting:
   [PATCH] GenWQE: Rework return code for flash-update ioctl
from 22.12.2013 14:16:36:

Here the spot:

@@ -565,14 +552,13 @@ static int do_flash_update(struct genwqe

                rc = copy_from_user(xbuf, buf, tocopy);
                if (rc) {
-                       dev_err(&pci_dev->dev,
-                               "err: could not copy all data rc=%d\n",
rc);
+                       rc = -EFAULT;
                        goto free_buffer;
                }
                crc = genwqe_crc32(xbuf, tocopy, 0xffffffff);

-               dev_info(&pci_dev->dev,
-                        "[%s] DMA: 0x%llx CRC: %08x SZ: %ld %d\n",
+               dev_dbg(&pci_dev->dev,
+                       "[%s] DMA: 0x%llx CRC: %08x SZ: %ld %d\n",
                        __func__, dma_addr, crc, tocopy,
blocks_to_flash);

> 
> Also we shouldn't be doing dev_err() on copy_to/from_user() problems.
> The user can trigger those and flood dmesg.  It is a DoS (annoying).
> 
> regards,
> dan carpenter
> 

In this patch I also removed most of the dev_err() messages. Fixing the
possibility to overflow the logs with error messages from user-side.
Greg did not pick up this patch yet, as far as I can see.

Regards

Frank

