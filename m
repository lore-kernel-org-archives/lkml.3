Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaH2PHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:07:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:50124 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbaH2PHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:07:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="565409940"
Message-ID: <54009A50.9010707@intel.com>
Date: Fri, 29 Aug 2014 18:20:48 +0300
From: Mathias Nyman <mathias.nyman@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com> <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com> <53FDF8D9.60103@intel.com> <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com> <53FF0765.3050509@intel.com> <CAPybu_0gf3XKsBFsxGPptq9m588K81fdh1sbOgMWM+hDVaHiWQ@mail.gmail.com> <CAPybu_1UytoxXk-t7u_3vQ6KL-5DmVUz1u5PiDLysBCvgit--A@mail.gmail.com> <53FF48B1.5090901@intel.com> <CAPybu_2rgn-DEUKfdmGsaAsFSQJ_zz6fsdnD0dHmyCPW4B-+WA@mail.gmail.com>
In-Reply-To: <CAPybu_2rgn-DEUKfdmGsaAsFSQJ_zz6fsdnD0dHmyCPW4B-+WA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 06:09 PM, Ricardo Ribalda Delgado wrote:
> Sure, but the hw leaves my desk until next monday in 30 minutes.
> 
> So unless you send the patch right now you will have to wait for
> results until next Monday
> 
> Thanks!
> 

Great, anytime you can test it is appreciated.
Added the patch to the bug:
https://bugzilla.kernel.org/show_bug.cgi?id=75521

Patch looks like this:

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c020b09..7aee5a3 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3544,6 +3544,10 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
        for (i = 1; i < 31; ++i) {
                struct xhci_virt_ep *ep = &virt_dev->eps[i];
 
+               /* reset device sets ep states to disabled, also halted ones */
+               ep->ep_state &= ~(EP_HALTED || SET_DEQ_PENDING);
+               ep->stopped_td = NULL;
+
                if (ep->ep_state & EP_HAS_STREAMS) {
                        xhci_warn(xhci, "WARN: endpoint 0x%02x has streams on device reset, freeing streams.\n",
                                        xhci_get_endpoint_address(i));


-Mathias

