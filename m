Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3LDK7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:59:50 -0500
Received: from smtp.citrix.com ([66.165.176.89]:8419 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab3LDK7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:59:47 -0500
X-IronPort-AV: E=Sophos;i="4.93,824,1378857600"; 
   d="scan'208";a="80444947"
Message-ID: <1386154783.17466.14.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] xen/pvhvm: If xen_platform_pci=0 is set don't blow up.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <leosilva@linux.vnet.ibm.com>, <ashley@ashleylai.com>,
        <peterhuewe@gmx.de>, <mail@srajiv.net>, <tpmdd@selhorst.net>,
        <tpmdd@sirrix.com>, <dmitry.torokhov@gmail.com>, <bhelgaas@google.com>,
        <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>,
        <tpmdd-devel@lists.sourceforge.net>, <linux-input@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Date: Wed, 4 Dec 2013 10:59:43 +0000
In-Reply-To: <alpine.DEB.2.02.1312041049310.7093@kaball.uk.xensource.com>
References: <1386105246-14337-1-git-send-email-konrad.wilk@oracle.com>
	 <1386149848.13256.86.camel@kazak.uk.xensource.com>
	 <alpine.DEB.2.02.1312041049310.7093@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 10:51 +0000, Stefano Stabellini wrote:
> On Wed, 4 Dec 2013, Ian Campbell wrote:
> > > +bool xen_has_pv_devices(void)
> > > +{
> > > +	if (!xen_domain())
> > > +		return false;
> > > +
> > > +	if (xen_hvm_domain()) {
> > > +		/* User requested no unplug, so no PV drivers. */
> > > +		if (xen_emul_unplug & XEN_UNPLUG_NEVER)
> > > +			return false;
> > 
> > I think you need
> > 		if (xen_emul_unpug & XEN_UNPLUG_UNNECESSARY)
> > 			return true;
> > don't you?
> 
> XEN_UNPLUG_UNNECESSARY was introduced to enable the platform PCI device
> even if it didn't respond properly to the unplug protocol.
> The corresponding parameter is called "unnecessary" because if you pass
> it to the kernel you mean that it is unnecessary to unplug the emulated
> devices but you can use the pv devices anyway.
> 
> So no, we shouldn't check for XEN_UNPLUG_UNNECESSARY here.

Oh, we will eventually fall through to the return true, so it does
actually work out OK.

I'd still be in favour of handling each option explicitly, for clarity.
Which means checking for XEN_UNPLUG_UNNECESSARY.

> > > +		/* And user has xen_platform_pci=0 set in guest config as
> > > +		 * driver did not modify the value. */
> > > +		if (!xen_platform_pci_unplug)
> > > +			return false;

I assume this check doesn't trigger if unnecessary has been specified?

> > > +	}
> > > +	return true;
> > > +}
> > > +EXPORT_SYMBOL_GPL(xen_has_pv_devices);
> > > +
> > >  void xen_unplug_emulated_devices(void)
> > >  {
> > >  	int r;
> > 
> > 


