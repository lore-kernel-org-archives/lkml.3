Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab3GOW45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:56:57 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:52044 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3GOW4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:56:55 -0400
Date: Tue, 16 Jul 2013 01:56:48 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Felipe Balbi <balbi@ti.com>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: v3.11-rc1 USB regressions
Message-ID: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think USB tree introduced regressions in v3.11-rc1, at least for some
OMAP devices using legacy boot. I have only bisected these; I have no
idea what the real fixes are but the following reverts make Nokia OMAP2+
boards again usable for kernel development work (they need working USB
connection for interacting with the device):

1) USB peripheral mode (g_ether) is broken on Nokia N900, N950 and N9
   (USB_MUSB_OMAP2PLUS). To make it it work, I need to revert three
   commits:

	09fc7d22b024692b2fe8a943b246de1af307132b
	usb: musb: fix incorrect usage of resource pointer
	(Reverting this fixes the g_ether probe failure "couldn't find
	 an available UDC")

	fe4cb0912f8e737f8e4b8b38b9e692f8062f5423
	usb: musb: gadget: remove hcd initialization
	(Reverting this fixes error "cdc_ether: probe of 4-1:1.0 failed
	 with error -110" seen on the host side.)

	8b125df5b24cfb0ec7fa1971e343cc0badc1827d
	usb: musb: eliminate musb_to_hcd	
	(Reverting this fixes compilation error cause by the previous
	 revert.)

2) USB peripheral mode (g_ether) is broken also on Nokia N800 and N810
   (USB_MUSB_TUSB6010). In addition to the above, I need to also revert
   the following:

	b7e2e75a8c6062afe1dd88b0b299938e5d36dff8
	usb: gadget: drop unused USB_GADGET_MUSB_HDRC

   (This commit is clearly incorrect - code checking for this still
   remain in the tree (see e.g. N8x0 board file), so it's not "unused".)

A.
