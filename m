Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3DZQvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:51:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55058 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751420Ab3DZQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:51:34 -0400
Date: Fri, 26 Apr 2013 12:51:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ZhenHua <zhen-hual@hp.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
In-Reply-To: <517A31A9.5070504@hp.com>
Message-ID: <Pine.LNX.4.44L0.1304261247490.1075-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, ZhenHua wrote:

> There is a function  wait_for_HP() in uhci-hub.c. In this
> patch, it is used in suspend_rh(),  I think this can be a
> solution. And I have tested this patch, it can fix the bug.
> 
> I think there is another patch needed. As Alan said in another
> mail, in the UHCI_RH_RUNNING_NODEVS case, it should not be stopped
> if the uhci device is HP iLo virtual usb.

I believe that if you change the UHCI_RH_RUNNING_NODEVS case, you will 
find that this patch (calling wait_for_HP) isn't needed.

In fact, the patch is so easy that I am including it below.  Please 
test this (without either of your patches) to see if it works.

Alan Stern




Index: usb-3.9/drivers/usb/host/uhci-hub.c
===================================================================
--- usb-3.9.orig/drivers/usb/host/uhci-hub.c
+++ usb-3.9/drivers/usb/host/uhci-hub.c
@@ -225,7 +225,8 @@ static int uhci_hub_status_data(struct u
 		/* auto-stop if nothing connected for 1 second */
 		if (any_ports_active(uhci))
 			uhci->rh_state = UHCI_RH_RUNNING;
-		else if (time_after_eq(jiffies, uhci->auto_stop_time))
+		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
+				!uhci->wait_for_hp)
 			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
 		break;
 

