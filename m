Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3J2WrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:47:17 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:52259 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3J2WrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:47:16 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: David Cohen <david.a.cohen@linux.intel.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC/PATCH v2 0/3] add gadget quirk to adapt f_fs for DWC3
Thread-Topic: [RFC/PATCH v2 0/3] add gadget quirk to adapt f_fs for DWC3
Thread-Index: AQHO1PDWRlemoVshIEmaro7KzmTD9JoMQWVg
Date: Tue, 29 Oct 2013 22:47:08 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458E2061F@US01WEMBX2.internal.synopsys.com>
References: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Cohen
> Sent: Tuesday, October 29, 2013 2:53 PM
> 
> These patches are a proposal to add gadget quirks in an immediate objective to
> adapt f_fs when using DWC3 controller. But the quirk solution is generic and
> can be used by other controllers to adapt gadget functions to their
> non-standard restrictions.
> 
> This change is necessary to make Android's adbd service to work on Intel
> Merrifield with f_fs instead of out-of-tree android gadget.
> 
> ---
> David Cohen (3):
>   usb: gadget: add quirks field to struct usb_gadget
>   usb: ffs: check quirk to pad epout buf size when not aligned to
>     maxpacketsize
>   usb: dwc3: add quirk USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget
>     driver
> 
>  drivers/usb/dwc3/gadget.c  |  1 +
>  drivers/usb/gadget/f_fs.c  | 17 +++++++++++++++++
>  include/linux/usb/gadget.h |  5 +++++
>  3 files changed, 23 insertions(+)

Wouldn't it be simpler and safer to just do this unconditionally? Sure,
you need it for DWC3 because the controller refuses to do an OUT transfer
at all if the transfer size is less than maxpacketsize. But it's possible
that other controllers allow the transfer, and it works in most cases,
but if an error occurs and the host sends too much data, they could
overrun the buffer and crash your device.

For example, the DWC2 databook says "For OUT transfers, the Transfer
Size field in the endpoint's Transfer Size register must be a multiple
of the maximum packet size of the endpoint". But I don't think the
controller enforces that, it is up to the programmer to do the right
thing. So that controller probably needs this quirk also. There could be
more like that which we don't know about.

So unless the buffer allocation code is in a real fast path, I would
suggest to just do the aligned buffer allocation always.

-- 
Paul

