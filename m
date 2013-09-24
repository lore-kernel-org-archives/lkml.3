Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3IXAsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:48:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:25090 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab3IXAsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:48:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,967,1371106800"; 
   d="scan'208";a="400013151"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
Thread-Topic: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
Thread-Index: AQHOsJQAl34IB1lxyU2PFiwcEyBhepnEW9mAgAF8/4CAAa8jcIAACnDA///u0ACAAYYsQIAAE4oAgAr8WKA=
Date: Tue, 24 Sep 2013 00:47:56 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880246596B@SHSMSX101.ccr.corp.intel.com>
References: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
 <1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
 <1AE640813FDE7649BE1B193DEA596E880246367A@SHSMSX101.ccr.corp.intel.com>
 <20130915065151.GK7393@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024639E4@SHSMSX101.ccr.corp.intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802463A46@SHSMSX101.ccr.corp.intel.com>
 <20130916081048.GM7393@intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802463D85@SHSMSX101.ccr.corp.intel.com>
 <20130917083712.GS7393@intel.com>
In-Reply-To: <20130917083712.GS7393@intel.com>
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

> From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> Sent: Tuesday, September 17, 2013 4:37 PM
> 
> On Mon, Sep 16, 2013 at 11:35:56PM +0000, Zheng, Lv wrote:
> > > From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> > > Sent: Monday, September 16, 2013 4:11 PM
> > >
> > > On Mon, Sep 16, 2013 at 01:21:53AM +0000, Zheng, Lv wrote:
> > > > > A pseudo device may be created to access the GPIO operation region fields provided by one GPIO device.
> > > > > The pseudo device may have other functions to access other GPIO operation region fields provided by other GPIO devices, or even
> worse
> > > to
> > > > > access other ACPI provided value-adds.
> > > > > So hierarchically the pseudo device only requires CPU, thus should not be under the GPIO device, which means the GPIO operation
> > > regions
> > > > > have nothing to do with the GPIO devices' ACPI handle.
> > > >
> > > > Sorry for the wording.
> > > > It's better to say the GPIO operation region users haven't strict
> > > > relationship to the GPIO operation region providers.
> > > > As the installation is to provide GPIO operation regions to the users, it
> > > > shouldn't relate to the providers' ACPI handle.
> > >
> > > If I understand you correctly you mean that there might be multiple users
> > > (different devices) for the same GPIO operation region, right?
> >
> > No, this is not what I meant.
> > Can one vendor device uses two or more GPIO pins from different GPIO ports?
> 
> Yes.

So how can such a device under one of these GPIO ports?
It can only be under one particular GPIO port device, right?

Thus I believe such device will appear below other devices rather than below a GPIO port device in the ACPI namespace.


> 
> > > That shouldn't be a problem as far as I can tell.
> > >
> > > What comes to the hierarchy you refer, I'm not sure if that is a problem
> > > either (unless I'm missing something). The GPIO can be used anywhere in the
> > > ASL, it doesn't have to be descendant of the GPIO device. You only need to
> > > do something like this:
> > >
> > > 	// Assert the GPIO
> > > 	Store(1, \_SB.PCI0.SHD3)
> > >
> > > In other words, use the fully qualified name.
> >
> > Yes, which means this line of code can be everywhere in the namespace.
> > It is not required to be under one particular GPIO device as long as there is an operation region defined in that scope.
> >
> > The problem is the installation, the first parameter for
> > acpi_install_address_space_handler() is a namespace node, the function
> > will call _REG for all OperationRegions below the scope whose top most
> > node is the specified node.
> > The nodes out of this scope are not affected.  So if an OperationRegion
> > is defined out of this scope, problem happens.
> 
> I suppose for that operation region another GPIO device should be
> introduced then, no?

I believe the answer is no.

> So if we don't have a GPIO driver for the given operation region, what can
> we do? We don't want the ASL code to erroneusly think that there is an
> operation region available when it is not.

I think GPIO "address_space_handler" should be provided by an ACPI GPIO address space module rather than provided by a particular GPIO driver.

Actually, without the readiness of the GPIO driver, currently ASL code can still access the GPIO fields, though it just results in "handler not found" ACPICA error message.
If the "setup" callback is implemented, then the proper GPIO driver can be matched in this "setup" callback.
If the GPIO driver hasn't been loaded by Linux and thus not matched in the "setup" callback, from users' point of view, the result is just changing the error message from "handler not found" to "driver not found".

Thanks and best regards
-Lv
