Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaHENtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:49:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43104 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHENtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:49:41 -0400
Date: Tue, 5 Aug 2014 09:49:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: David Vrabel <david.vrabel@citrix.com>, gregkh@linuxfoundation.org,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v5] Fixes to Xen pciback for 3.17.
Message-ID: <20140805134930.GE13057@laptop.dumpdata.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
 <53DBB27D.2040203@citrix.com>
 <20140804184318.GB9009@laptop.dumpdata.com>
 <75613802.20140805104438@eikelenboom.it>
 <53E0A45C.4050400@citrix.com>
 <1985206568.20140805114433@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1985206568.20140805114433@eikelenboom.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 11:44:33AM +0200, Sander Eikelenboom wrote:
> 
> Tuesday, August 5, 2014, 11:31:08 AM, you wrote:
> 
> > On 05/08/14 09:44, Sander Eikelenboom wrote:
> >> 
> >> Monday, August 4, 2014, 8:43:18 PM, you wrote:
> >> 
> >>> On Fri, Aug 01, 2014 at 04:30:05PM +0100, David Vrabel wrote:
> >>>> On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
> >>>>> Greg: goto GHK
> >>>>>
> >>>>> This is v5 version of patches to fix some issues in Xen PCIback.
> >>>>
> >>>> Applied to devel/for-linus-3.17.
> >> 
> >>> Thank you.
> >>>>
> >>>> I dropped the stable Cc for #2 pending a final decision on whether it
> >>>> really is a stable candidate.
> >> 
> >>> OK.
> >>>>
> >>>> David
> >> 
> >> Hi Konrad / David,
> >> 
> >> This series still lacks a resolution on the sysfs /do_flr /reset,
> >> as a result the pci devices are not reset after shutdown of a guest.
> >> (no more pciback 0000:xx:xx.x: restoring config space at offset xxx)
> >> 
> >> So this series now introduces a regression to 3.16, which causes devices to malfunction 
> >> after a guest reboot or after assigning the devices to another guest.
> 
> > I don't follow what you're saying.  The lack of a device reset for PCI
> > devices with no FLR method isn't a regression as this has never worked.
> >  Can you explain in more detail what the regression is and which patch
> > caused it?
> 
> I haven't bisected it to a specific patch in this series,
> but this patch series (when pulled on top of 3.16) cause the following:
> 
> - Do a system start and HVM guest start
> - HVM guest with pci passthrough, devices work fine
> - shutdown the HVM guest
> - "pciback 0000:xx:xx.x: restoring config space at offset xxx" messages do not
>   appear anymore when shutting down the HVM guest (as they do with vanilla 3.16)
> - Starting the HVM guest again with the same devices passed through.
> - Devices malfunction (for example a USB host controller will fail a simple 
>   "lsusb"
> - And this all works fine on vanilla 3.16.  

Hm, the only patch that makes code changes is 63fc5ec97cc54257d1c4ee49ed2131f754a5ff9b
"xen/pciback: Don't deadlock when unbinding."
but it does not change any of that code path. Only figures out whether
to take a lock or not.

I will try it out on my box and see if I can reproduce it.

And just to be 100% sure - you are using vanilla Xen? No changes on top
of it?

Thanks!
> 
> >> Apart from that .. i can't resist to remind the other issue with removing pci
> >> devices passed through to HVM guests related to the signaling via xenstore,
> >> described in:
> >> 
> >> http://lists.xen.org/archives/html/xen-devel/2014-07/msg01875.html
> 
> > I don't remember seeing you posting a patch...?

I was going to, but I think we need to figure out the 'do_flr' mechanism
first.
> 
> > David
> 
> 
