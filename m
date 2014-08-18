Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaHROWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:22:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52050 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751744AbaHROWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:22:38 -0400
Date: Mon, 18 Aug 2014 10:22:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, ChangbinX" <changbinx.du@intel.com>
cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [BUG]  usb_dev_resume returns -113 due to work items queued by
 usb on pm_wq is not executed before suspending.
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01BA7FD0@SHSMSX103.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1408181019470.1332-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014, Du, ChangbinX wrote:

> > On Fri, 15 Aug 2014, Du, ChangbinX wrote:
> > > If my analysis is correct, could you share your ideas for this issue?
> > 
> > Hasn't this already been fixed?  See commit d6236f6d1d88 (xhci: Fix runtime
> > suspended xhci from blocking system suspend).
> > 
> > Alan Stern
> 
> Hi, Stern,
> These are two different issues. Commit d6236f6d1d88 fixes issue that xhci runtime
> pm logical blocks system suspend. But the issue we are encountering is usb device
> resuming fail and lead to device reset.

Yes, the issues are different, but I think the fix is the same.  You
should test a kernel that includes commit d6236f6d1d88.

> This issue can be reproduced by below steps:
> 1) Plug a usb device to usb3 host, and make sure this device can enter runtime
>   suspend state.
> 2) Wait HCD entering runtime suspend state.( xhci_suspend() will be called)
> 3) Make system starts system suspending. On this step, PM core freeze threads and
>   resume hcd & the usb device to runtime active state(xhci_resume() will be called, 
>   and roothub resuming work item is queued). Then calls the suspend callbacks of devices'.

Commit d6236f6d1d88 prevents the roothub resuming work item from being
queued.

> 4) We force system suspending process aborted (by modifying code) just after the usb
>   Device suspend callback is invoked.
> 5) Then PM core will call resume callback of the usb device to recovery. On this step
>   usb_dev_resume() invokes and it return -113 error. Because the can_submit flag of
>   root hub is 0. Root hub resuming work item is still pending.

I still think that commit has already fixed your problem.

Alan Stern

