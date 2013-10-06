Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab3JFGBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 02:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab3JFGBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 02:01:41 -0400
Date: Sun, 6 Oct 2013 08:02:44 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, linux-pci@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux390@de.ibm.com, linux-s390@vger.kernel.org, x86@kernel.org,
        linux-ide@vger.kernel.org, iss_storagedev@hp.com,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement
 pattern
Message-ID: <20131006060243.GB28142@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
 <1380840585.3419.50.camel@bwh-desktop.uk.level5networks.com>
 <20131004082920.GA4536@dhcp-26-207.brq.redhat.com>
 <1380922156.3214.49.camel@bwh-desktop.uk.level5networks.com>
 <20131005142054.GA11270@dhcp-26-207.brq.redhat.com>
 <1381009586.645.141.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381009586.645.141.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 08:46:26AM +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2013-10-05 at 16:20 +0200, Alexander Gordeev wrote:
> > So my point is - drivers should first obtain a number of MSIs they *can*
> > get, then *derive* a number of MSIs the device is fine with and only then
> > request that number. Not terribly different from memory or any other type
> > of resource allocation ;)
> 
> What if the limit is for a group of devices ? Your interface is racy in
> that case, another driver could have eaten into the limit in between the
> calls.

Well, the another driver has had a better karma ;) But seriously, the
current scheme with a loop is not race-safe wrt to any other type of
resource which might exhaust. What makes the quota so special so we
should care about it and should not care i.e. about lack of msi_desc's?

Yeah, I know the quota might hit more likely. But why it is not addressed
right now then? Not a single function in chains...
  rtas_msi_check_device() -> msi_quota_for_device() -> traverse_pci_devices()
  rtas_setup_msi_irqs() -> msi_quota_for_device() -> traverse_pci_devices()
...is race-safe. So if it has not been bothering anyone until now then
no reason to start worrying now :)

In fact, in the current design to address the quota race decently the
drivers would have to protect the *loop* to prevent the quota change
between a pci_enable_msix() returned a positive number and the the next
call to pci_enable_msix() with that number. Is it doable?

> Ben.
> 
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
