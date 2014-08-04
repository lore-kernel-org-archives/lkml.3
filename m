Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaHDSm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:42:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31727 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaHDSm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:42:56 -0400
Date: Mon, 4 Aug 2014 14:42:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: gregkh@linuxfoundation.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 2/6] xen/pciback: Don't deadlock when unbinding.
Message-ID: <20140804184247.GA9009@laptop.dumpdata.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
 <1405354736-7358-3-git-send-email-konrad.wilk@oracle.com>
 <53D64AF3.4080202@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D64AF3.4080202@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 02:06:59PM +0100, David Vrabel wrote:
> On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
> > As commit 0a9fd0152929db372ff61b0d6c280fdd34ae8bdb
> > 'xen/pciback: Document the entry points for 'pcistub_put_pci_dev''
> > explained there are four entry points in this function.
> > Two of them are when the user fiddles in the SysFS to
> > unbind a device which might be in use by a guest or not.
> > 
> > Both 'unbind' states will cause a deadlock as the the PCI lock has
> > already been taken, which then pci_device_reset tries to take.
> > 
> > We can simplify this by requiring that all callers of
> > pcistub_put_pci_dev MUST hold the device lock. And then
> > we can just call the lockless version of pci_device_reset.
> > 
> > To make it even simpler we will modify xen_pcibk_release_pci_dev
> > to quality whether it should take a lock or not - as it ends
> > up calling xen_pcibk_release_pci_dev and needs to hold the lock.
> > 
> > CC: stable@vger.kernel.org
> 
> This deadlock is for a rather specific and uncommon use case (manually
> unbinding a PCI while it is passed-through). Is this critical enough to
> warrant a stable backport?

We seem to trip over it frequently when rebooting a server.

That is the VF's end up being unbinded while the guests
are being shutdown. And depending on the timing we end up in a deadlock.

> 
> > Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> 
> David
