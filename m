Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbaCDLlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:41:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:59239 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952AbaCDLlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:41:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,584,1389772800"; 
   d="scan'208";a="485740167"
Message-ID: <5315BE1F.8020100@linux.intel.com>
Date: Tue, 04 Mar 2014 13:50:55 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, dan.j.williams@intel.com,
        stable@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH v3 1/1] xhci: Prevent runtime pm from autosuspending during
 initialization
References: <1393867817-10389-1-git-send-email-mathias.nyman@linux.intel.com> <1393867817-10389-2-git-send-email-mathias.nyman@linux.intel.com> <20140303183733.GA13926@kroah.com>
In-Reply-To: <20140303183733.GA13926@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 08:37 PM, Greg KH wrote:
> On Mon, Mar 03, 2014 at 07:30:17PM +0200, Mathias Nyman wrote:
>> xHCI driver has its own pci probe function that will call usb_hcd_pci_probe
>> to register its usb-2 bus, and then continue to manually register the
>> usb-3 bus. usb_hcd_pci_probe does a pm_runtime_put_noidle at the end and
>> might thus trigger a runtime suspend before the usb-3 bus is ready.
>
> What is the result if that happens?

Crashes. Null pointer dereference in xhci_suspend() when touching 
xhci->shared_hcd before it's initialized. More info here:

http://marc.info/?l=linux-usb&m=138914518219334&w=2

>
> Is this a regression from 3.13?  Or something new for 3.14?
>

According to reporter its been around since 3.7

commit 596d789a211d134dc5f94d1e5957248c204ef850
USB: set hub's default autosuspend delay as 0

But nobody else than the reporter is able to trigger it.

> What platform(s) are affected by this?

David, the reporter (added to cc), mentioned
"This bug happened in a platform with 1 usb3 host controller + 1 usb3 
OTG controller" run by some Intel internal group

http://marc.info/?l=linux-usb&m=138915969822029&w=2

David, can you elaborate on the platform?

>> xhci-platform driver is not using usb_hcd_pci_probe to set up
>> busses and should not need to have it's usage count increased during probe.
>
> I didn't think we had any in-kernel users of the xhci-platform driver,
> has that changed and I missed a new platform being added?
>

Not that I'm aware of. I just wanted to point out that this issue is 
only a matter on pci enumerated xhci hosts.

-Mathias

