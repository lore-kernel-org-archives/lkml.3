Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3KGAhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:37:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:58755 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab3KGAhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:37:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="317984489"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "tj@kernel.org" <tj@kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] devres: Freeing the drs after all release() are called
Thread-Topic: [PATCH] devres: Freeing the drs after all release() are called
Thread-Index: AQHO21DJG9qpfyZgDEOCvuaDoE+mA5oY6wLw
Date: Thu, 7 Nov 2013 00:36:56 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B866C7@SHSMSX101.ccr.corp.intel.com>
References: <1383720018.3650.37.camel@cliu38-desktop-build>
 <20131106085859.GB9487@kroah.com>
 <27240C0AC20F114CBF8149A2696CBE4A01B86696@SHSMSX101.ccr.corp.intel.com>
 <20131107002959.GA32200@mtj.dyndns.org>
In-Reply-To: <20131107002959.GA32200@mtj.dyndns.org>
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



> -----Original Message-----
> From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of tj@kernel.org
> Sent: Thursday, November 07, 2013 8:30 AM
> To: Liu, Chuansheng
> Cc: Greg KH; dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
> 
> Hello, Liu.
> 
> On Thu, Nov 07, 2013 at 12:27:56AM +0000, Liu, Chuansheng wrote:
> > The driver code is as below:
> > _INIT() {
> >
> > A = devm_kzalloc();
> > B= devm_request_threaded_irq(isr_handler);
> > C = devm_kzalloc();
> > }
> >
> > When driver _EXIT, the devres_release_all () will be called.
> > The C will be kfreed before B, but when freeing irq B, the pending isr_handler()
> possibly
> > will access the memory B which has been freed.
> > Then the memory corruption occurred.
> >
> > This patch can solve this scenario.
> 
> Isn't the bug there IRQ being requested before all its resources are
> allocated?  The proposed change just masks the underlying issue or
> incorrectly ordered operations.
Yes, I knew I can put the code always like below:
A = devm_kzalloc();
C = devm_kzalloc();
...
B= devm_request_threaded_irq(isr_handler);

But, the above is just one simple coding prototype, if there are many calling:
E -- > F -- > D -- >... then to devm_kzalloc().

To be honest, it will make code too hard to always adapt the rule?
And I trying to find out every potential devm_kzalloc() before irq requesting.
