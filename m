Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaHRLye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:54:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:50577 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbaHRLyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:54:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,885,1400050800"; 
   d="scan'208";a="469839593"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [BUG]  usb_dev_resume returns -113 due to work items queued by
 usb on pm_wq is not executed before suspending.
Thread-Topic: [BUG]  usb_dev_resume returns -113 due to work items queued by
 usb on pm_wq is not executed before suspending.
Thread-Index: Ac+4LQQVPRWYe0VPTy2dChNy4reeFAAI9vOAAKBVvHA=
Date: Mon, 18 Aug 2014 11:54:26 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01BA7FD0@SHSMSX103.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A01BA6392@SHSMSX103.ccr.corp.intel.com>
 <Pine.LNX.4.44L0.1408151018410.1144-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1408151018410.1144-100000@iolanthe.rowland.org>
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

> On Fri, 15 Aug 2014, Du, ChangbinX wrote:
> > If my analysis is correct, could you share your ideas for this issue?
> 
> Hasn't this already been fixed?  See commit d6236f6d1d88 (xhci: Fix runtime
> suspended xhci from blocking system suspend).
> 
> Alan Stern

Hi, Stern,
These are two different issues. Commit d6236f6d1d88 fixes issue that xhci runtime
pm logical blocks system suspend. But the issue we are encountering is usb device
resuming fail and lead to device reset.

This issue can be reproduced by below steps:
1) Plug a usb device to usb3 host, and make sure this device can enter runtime
  suspend state.
2) Wait HCD entering runtime suspend state.( xhci_suspend() will be called)
3) Make system starts system suspending. On this step, PM core freeze threads and
  resume hcd & the usb device to runtime active state(xhci_resume() will be called, 
  and roothub resuming work item is queued). Then calls the suspend callbacks of devices'.
4) We force system suspending process aborted (by modifying code) just after the usb
  Device suspend callback is invoked.
5) Then PM core will call resume callback of the usb device to recovery. On this step
  usb_dev_resume() invokes and it return -113 error. Because the can_submit flag of
  root hub is 0. Root hub resuming work item is still pending.

The sequence is:
xhci_suspend()						--->  host runtime suspend
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes
xhci_resume()						---> resume to runtime active, work item queued , 
									   but the roothub is not resumed(can_submit=0).
PM: Entering mem sleep
...									---> invoke device suspend callbacks
1-1:1.0: device suspending
...
PM: Some devices failed to suspend		---> suspending process aborted and starts recovery
....									---> call resuming callbacks for suspended devices
1-1:1.0: usb_dev_resume() -> usb_resume -> 
  usb_resume_both()->generic_resume()->
  usb_port_resume()->hub_port_status()->
  usb_control_msg()->usb_submit_urb()->
  usb_hcd_link_urb_to_ep()

int usb_hcd_link_urb_to_ep(struct usb_hcd *hcd, struct urb *urb)
{
...
	if (unlikely(!urb->dev->can_submit)) {
		rc = -EHOSTUNREACH;	  // -113
		goto done;
	}
...
}

