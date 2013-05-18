Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab3ERC2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:28:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab3ERCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:49 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lRvs1YKdE4QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aXDi0TOdhJQA:10 a=20KFwNOVAAAA:8 a=1hDqzGiJAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=_pftua7QV6wCceYLT6EA:9 a=jEp0ucaQiEUA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021644.328474589@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Stikkolorum <d.r.stikkolorum@hhs.nl>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 016/136 ] usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the
 ctrl ep
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0016-usbfs-Always-allow-ctrl-requests-with-USB_RECIP_ENDP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1361bf4b9f9ef45e628a5b89e0fd9bedfdcb7104 ]

When usbfs receives a ctrl-request from userspace it calls check_ctrlrecip,
which for a request with USB_RECIP_ENDPOINT tries to map this to an interface
to see if this interface is claimed, except for ctrl-requests with a type of
USB_TYPE_VENDOR.

When trying to use this device: http://www.akaipro.com/eiepro
redirected to a Windows vm running on qemu on top of Linux.

The windows driver makes a ctrl-req with USB_TYPE_CLASS and
USB_RECIP_ENDPOINT with index 0, and the mapping of the endpoint (0) to
the interface fails since ep 0 is the ctrl endpoint and thus never is
part of an interface.

This patch fixes this ctrl-req failing by skipping the checkintf call for
USB_RECIP_ENDPOINT ctrl-reqs on the ctrl endpoint.

Reported-by: Dave Stikkolorum <d.r.stikkolorum@hhs.nl>
Tested-by: Dave Stikkolorum <d.r.stikkolorum@hhs.nl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/core/devio.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 7f75343..570fb4a 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -738,6 +738,8 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
 	index &= 0xff;
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
+		if ((index & ~USB_DIR_IN) == 0)
+			return 0;
 		ret = findintfep(ps->dev, index);
 		if (ret >= 0)
 			ret = checkintf(ps, ret);
-- 
1.7.10.4


