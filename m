Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaHOCTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 22:19:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:32731 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbaHOCTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 22:19:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,867,1400050800"; 
   d="scan'208";a="576977904"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "Wu, Hao" <hao.wu@intel.com>
Subject: [BUG]  usb_dev_resume returns -113 due to work items queued by usb
 on pm_wq is not executed before suspending.
Thread-Topic: [BUG]  usb_dev_resume returns -113 due to work items queued by
 usb on pm_wq is not executed before suspending.
Thread-Index: Ac+4LQQVPRWYe0VPTy2dChNy4reeFA==
Date: Fri, 15 Aug 2014 02:19:11 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01BA6392@SHSMSX103.ccr.corp.intel.com>
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

Hi, All,
As described in runtime_pm.txt for pm_wq:
The power management work queue pm_wq in which bus types and device
drivers can put their PM-related work items. It is strongly recommended that
pm_wq be used for queuing all work items related to runtime PM, because
this allows them to be synchronized with system-wide power transitions
(suspend to RAM, hibernation and resume from system sleep states).

Per my understanding, all runtime PM related works items queued on pm_wq
should be completed before suspend to RAM. So to ensure device state is
runtime active before suspending. Having checked the pm code, I found this is
not true for work items queued by drivers.

Now usb driver has used this pm_wq to run a work item that resumes root hub
(see function xhci_resume()->usb_hcd_resume_root_hub()). But sometimes
this work is not completed before usb device suspend. That is to say root hub
device may still in runtime suspend state before suspending. And this can result
in problem. One case is that as below error log shows,

[  108.046248] PM: Entering mem sleep
[  108.050487] Suspending console(s) (use no_console_suspend to debug)
[  108.426510] active wakeup source: event5-576
[  108.426529] PM: Some devices failed to suspend
[  108.426887] dpm_run_callback(): usb_dev_resume+0x0/0x20 returns -113
[  108.426918] PM: Device 1-2 failed to resume async: error -113
[  108.428299] PM: resume of devices complete after 1.755 msecs

The usb_dev_resume() return error -113, which mean host is in suspend state
when resuming a device. The scenario is:
1) Just before system suspending, pm core will run hcd runtime resume
  routine if host is in runtime suspend state.
2) Hcd runtime resume function xhci_resume() returns, and roothub resume
  worker was queued by usb_hcd_resume_root_hub().
3) system suspend continue going before roothub resume worker starts executing.
  Thus host is still in runtime suspend state.
4) One event make suspending process aborted before hcd suspended. Then pm
  core will call resume routines for just suspended device. But when resuming
  a usb device it find the host is in suspended. Then return error -113.

If my analysis is correct, could you share your ideas for this issue?

Regards and Thanks!
Du, Changbin

