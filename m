Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaCGPSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:18:49 -0500
Received: from mx0.aculab.com ([213.249.233.131]:33839 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753219AbaCGPSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:18:45 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] Revert "xhci 1.0: Limit arbitrarily-aligned scatter
 gather."
Thread-Topic: [PATCH 1/2] Revert "xhci 1.0: Limit arbitrarily-aligned
 scatter gather."
Thread-Index: AQHPOhWgbeh2OUSVo0Cyj0vVCN9CQ5rVu4bw
Date: Fri, 7 Mar 2014 15:18:06 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6D771D@AcuExch.aculab.com>
References: <1394204818-25323-1-git-send-email-mathias.nyman@linux.intel.com>
 <1394204818-25323-2-git-send-email-mathias.nyman@linux.intel.com>
In-Reply-To: <1394204818-25323-2-git-send-email-mathias.nyman@linux.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman
> This reverts commit 247bf557273dd775505fb9240d2d152f4f20d304.

You need to revert further.
Just don’t set hcd->self.no_sg_constraint ever - since it just
doesn't work.
That will stop the ax88179_178a driver sending fragmented packets.

With the check for aligned non-terminal fragments removed the 
code will be as bad as the earlier releases.

> This commit, together with commit 3804fad45411b48233b48003e33a78f290d227c8
> "USBNET: ax88179_178a: enable tso if usb host supports sg dma" were
> origially added to get xHCI 1.0 hosts and usb ethernet ax88179_178a devices
> working together with scatter gather. xHCI 1.0 hosts pose some requirement on how transfer
> buffers are aligned, setting this requirement for 1.0 hosts caused USB 3.0 mass
> storage devices to fail more frequently.
> 
> USB 3.0 mass storage devices used to work before 3.14-rc1.  Theoretically,
> the TD fragment rules could have caused an occasional disk glitch.
> Now the devices *will* fail, instead of theoretically failing.
> From a user perspective, this looks like a regression; the USB device obviously
> fails on 3.14-rc1, and may sometimes silently fail on prior kernels.
> 
> The proper soluition is to implement the TD fragment rules required, but for now
> this patch needs to be reverted to get USB 3.0 mass storage devices working at the
> level they used to.
> 
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Cc: stable <stable@vger.kernel.org>
> ---
>  drivers/usb/host/xhci.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 6fe577d..924a6cc 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -4733,6 +4733,9 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
>  	/* Accept arbitrarily long scatter-gather lists */
>  	hcd->self.sg_tablesize = ~0;
> 
> +	/* support to build packet from discontinuous buffers */
> +	hcd->self.no_sg_constraint = 1;
> +

Don't add the above - it only looked at by the usbnet code
and in particular the ax88179_178a driver

>  	/* XHCI controllers don't stop the ep queue on short packets :| */
>  	hcd->self.no_stop_on_short = 1;
> 
> @@ -4757,14 +4760,6 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
>  		/* xHCI private pointer was set in xhci_pci_probe for the second
>  		 * registered roothub.
>  		 */
> -		xhci = hcd_to_xhci(hcd);
> -		/*
> -		 * Support arbitrarily aligned sg-list entries on hosts without
> -		 * TD fragment rules (which are currently unsupported).
> -		 */
> -		if (xhci->hci_version < 0x100)
> -			hcd->self.no_sg_constraint = 1;
> -
>  		return 0;
>  	}
> 
> @@ -4793,9 +4788,6 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
>  	if (xhci->hci_version > 0x96)
>  		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
> 
> -	if (xhci->hci_version < 0x100)
> -		hcd->self.no_sg_constraint = 1;
> -
>  	/* Make sure the HC is halted. */
>  	retval = xhci_halt(xhci);
>  	if (retval)
> --
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


