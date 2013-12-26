Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3LZCMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 21:12:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:4082 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab3LZCMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 21:12:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,551,1384329600"; 
   d="scan'208";a="457740099"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "burzalodowa@gmail.com" <burzalodowa@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
Thread-Topic: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
Thread-Index: Ac7/zXecO35CkBpaT+GTORmHLtV6Vf//wciA//4eTGCAA+P8AIABIPeA//7BKBA=
Date: Thu, 26 Dec 2013 02:11:54 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01A3190F@SHSMSX103.ccr.corp.intel.com>
References: <Pine.LNX.4.44L0.1312241623390.337-100000@netrider.rowland.org>
 <Pine.LNX.4.44L0.1312251002020.9215-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1312251002020.9215-100000@netrider.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 24 Dec 2013, Alan Stern wrote:
> I think this will fix it.  Take a close look and do some careful testing.
> 
> Alan Stern
> 
> Index: usb-3.13/drivers/usb/core/hub.c
> ==========================================================
> =========
> --- usb-3.13.orig/drivers/usb/core/hub.c
> +++ usb-3.13/drivers/usb/core/hub.c
> @@ -1622,11 +1622,14 @@ static void hub_disconnect(struct usb_in
>  	hub->error = 0;
>  	hub_quiesce(hub, HUB_DISCONNECT);
> 
> -	usb_set_intfdata (intf, NULL);
> -
>  	for (i = 0; i < hdev->maxchild; i++)
>  		usb_hub_remove_port_device(hub, i + 1);
> +
> +	/* Avoid races with recursively_mark_NOTATTACHED() */
> +	spin_lock_irq(&device_state_lock);
>  	hub->hdev->maxchild = 0;
> +	usb_set_intfdata(intf, NULL);
> +	spin_unlock_irq(&device_state_lock);
> 
>  	if (hub->hdev->speed == USB_SPEED_HIGH)
>  		highspeed_hubs--;
> 

Sorry for late response. Agree with you. I will test your patch carefully and 
let you know the result. Thanks!

