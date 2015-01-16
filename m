Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbbAPJ4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:56:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:36480 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbbAPJ4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:56:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="441323146"
From: "Kaukab, Yousaf" <yousaf.kaukab@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Felipe Balbi <balbi@ti.com>,
        "Greg KH" <greg@kroah.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: RE: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Thread-Topic: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Thread-Index: AQHQMVUFV4KyeZL6/kefSEFRWf/Ei5zCfaCw
Date: Fri, 16 Jan 2015 09:56:42 +0000
Message-ID: <B1AFEC30BE3ADF488E833B59904F5C3209836D93@IRSMSX107.ger.corp.intel.com>
References: <20150116172346.4add4867@canb.auug.org.au>
In-Reply-To: <20150116172346.4add4867@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Friday, January 16, 2015 7:24 AM
> To: Felipe Balbi; Greg KH
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Robert Baldyga;
> Kaukab, Yousaf
> Subject: linux-next: manual merge of the usb-gadget tree with the usb.current
> tree
> 
> Hi Felipe,
> 
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/dwc2/gadget.c between commit 62f4f0651ce8 ("usb: dwc2:
> gadget: kill requests with 'force' in s3c_hsotg_udc_stop()") from the usb.current
> tree and commit c6f5c050e2a7 ("usb: dwc2: gadget: add bi-directional
> endpoint support") and 1141ea01d5fa ("usb: dwc2: gadget:
> kill requests after disabling ep") from the usb-gadget tree.

commit 62f4f0651ce8 ("usb: dwc2: gadget: kill requests with 'force' in s3c_hsotg_udc_stop()")
should have been reverted by http://www.spinics.net/lists/linux-usb/msg119287.html.
Somehow it didn't make it to linux-next.

6b448af46e2a ("drivers: usb: dwc2: remove 'force' parameter from kill_all_requests()"),
which is added by this merge, is the replacement.

> 
> I fixed it up (I think - see below) and can carry the fix as necessary (no action is
> required).
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/usb/dwc2/gadget.c
> index 79242008085b,882a1a8953f5..000000000000
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@@ -2927,8 -2960,12 +2964,12 @@@ static int s3c_hsotg_udc_stop(struct
> us
>   	mutex_lock(&hsotg->init_mutex);
> 
>   	/* all endpoints should be shutdown */
> - 	for (ep = 1; ep < hsotg->num_of_eps; ep++)
> - 		s3c_hsotg_ep_disable_force(&hsotg->eps[ep].ep,
> true);
> + 	for (ep = 1; ep < hsotg->num_of_eps; ep++) {
> + 		if (hsotg->eps_in[ep])
>  -			s3c_hsotg_ep_disable(&hsotg-
> >eps_in[ep]->ep);
> ++
> 	s3c_hsotg_ep_disable_force(&hsotg->eps_in[ep]->ep, true);
> + 		if (hsotg->eps_out[ep])
>  -			s3c_hsotg_ep_disable(&hsotg-
> >eps_out[ep]->ep);
> ++
> 	s3c_hsotg_ep_disable_force(&hsotg->eps_out[ep]->ep, true);
> + 	}
> 
>   	spin_lock_irqsave(&hsotg->lock, flags);
> 

This can work. However, the force argument to s3c_hsotg_ep_disable_force is unused now. So might just leave s3c_hsotg_ep_disable as is, as done by c6f5c050e2a7.

BR,
Yousaf
