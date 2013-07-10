Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3GJXNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:13:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3GJXNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:13:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: USB host support should depend on HAS_DMA
Date: Thu, 11 Jul 2013 01:12:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1307101724430.1215-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307101724430.1215-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307110112.57398.arnd@arndb.de>
X-Provags-ID: V02:K0:7pezN/15TEg5XxyX/QFdHPQn5H1H6WEJ62EjZo/qdOR
 w0ngjqfj6bdjeydBtW9m+LXyWk5CvNKXWWdjH4G7G16SzQYia4
 i/ytPGIJgkcbaZ7wobRV3z1vNIkFaxaTDwTF+ldpP+O1Xjf0ZE
 6l1AO98gqoU/EUVwZe61v02kMZ4RGc0QBX0cBYs6tcmNuAL5Dk
 ehvkutnyMpxfL4SsD63tEfskItvv4eJbhJMz3yc3E8+97bDC+K
 OPDzeaTitYwue6bqdtnbOgf0dYAZH0UIPuMNOxgGNMvj5xaAZw
 Eon58WNqoNC5hqnVhSU7z39YBySSQ69/IRrAngYysfTsEHFseE
 F6G0CMBB4MiQQr6BKQfk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 July 2013, Alan Stern wrote:
> This isn't right.  There are USB host controllers that use PIO, not
> DMA.  The HAS_DMA dependency should go with the controller driver, not 
> the USB core.
> 
> On the other hand, the USB core does call various routines like 
> dma_unmap_single.  It ought to be possible to compile these calls even 
> when DMA isn't enabled.  That is, they should be defined as do-nothing 
> stubs.

The asm-generic/dma-mapping-broken.h file intentionally causes link
errors, but that could be changed.

The better approach in my mind would be to replace code like


	if (hcd->self.uses_dma)

with

	if (IS_ENABLED(CONFIG_HAS_DMA) && hcd->self.uses_dma) {

which will reliably cause that reference to be omitted from object code,
but not stop giving link errors for drivers that actually require
DMA.

	Arnd
