Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaAHDtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 22:49:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:22394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbaAHDtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 22:49:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,621,1384329600"; 
   d="scan'208";a="463270283"
From: "Tang, Jianqiang" <jianqiang.tang@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        David Cohen <david.a.cohen@linux.intel.com>
CC: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tang, Jianqiang" <jianqiang.tang@intel.com>
Subject: RE: [RFC/PATCH] usb/xhci: avoid kernel panic on xhci_suspend()
Thread-Topic: [RFC/PATCH] usb/xhci: avoid kernel panic on xhci_suspend()
Thread-Index: AQHPDBJ99T9rFpPtLkGMfdW0+qXylZp5iLCAgACgZtA=
Date: Wed, 8 Jan 2014 03:49:07 +0000
Message-ID: <08C00E7DCA84054D93A5BD962777345A01E2EE3E@SHSMSX102.ccr.corp.intel.com>
References: <1389145466-8302-1-git-send-email-david.a.cohen@linux.intel.com>
 <20140108014639.GB7823@kroah.com>
In-Reply-To: <20140108014639.GB7823@kroah.com>
Accept-Language: zh-CN, en-US
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

Hi,
 1) I met this issue one time just boot up our Linux Platform(Kernel3.10) with XHCI driver, then kernel panic happen.

   And this issue reported once by other internal team.

   Nothing special of reproduce step and do not need special Hardware I think.

   Just random issue which will happen when meet the timing condition.

 2) This issue is introduced by this patch:

     https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=596d789a211d134dc5f94d1e5957248c204ef850

   which set all hub autosuspend delay to 0.

   This causes race condition during XHCI driver initialization,

    After USB2 hcd and USB2 root hub finish the initialization, USB2 root hub is functional and auto suspend right now, hence trigger XHCI runtime suspend flow;

    At the same time, XHCI driver continue to initialize the USB3 hcd and assign to xhci->shared_hcd after finish the initialization;
    
    Since xhci_suspend() use the xhci->shared_hcd, so there is race condition that when XHCI runtime suspend called, xhci->shared_hcd still NULL.

    I think this patch is a fix solution since before XHCI finish the whole initialization, USB2 root hub triggered runtime suspend is mean less and do not need to handle.


Thanks!

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Wednesday, January 08, 2014 9:47 AM
To: David Cohen
Cc: stern@rowland.harvard.edu; sarah.a.sharp@linux.intel.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Tang, Jianqiang
Subject: Re: [RFC/PATCH] usb/xhci: avoid kernel panic on xhci_suspend()

On Tue, Jan 07, 2014 at 05:44:26PM -0800, David Cohen wrote:
> From: jianqian <jianqiang.tang@intel.com>
> 
> There is a possible kernel panic faced on xhci_suspend().
> Due to kernel modified the hub autosupend_delay to 0s, after usb1 root 
> hub finishes initialization, it will trigger runtime_suspend and then 
> it will trigger xhci runtime suspend. But at that time, if
> xhci->shared_hcd is still doing initialization, it is possible to face
> null pointer kernel panic in xhci_suspend() function.
> 
> This patch checks if xhci->shared_hcd is null to avoid panic.
> 
> Signed-off-by: jianqian <jianqiang.tang@intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
> 
> This is the kernel panic. The bug was discovered on current LTS kernel 
> 3.10, as showed on logs. But the problem does not seem to be fixed so far.
> Maybe we should consider apply it on kernel >= 3.10?

How do you trigger this?  I've never seen anyone report this problem before, is there something different in the hardware you are using that enables this to be triggered easier?

thanks,

greg k-h
