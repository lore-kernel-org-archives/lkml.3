Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbaGION0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:13:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50319 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbaGIONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:13:24 -0400
Date: Wed, 9 Jul 2014 10:01:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/7] xen/pciback: Don't deadlock when unbinding.
Message-ID: <20140709140106.GE21837@laptop.dumpdata.com>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
 <1404845909-13563-3-git-send-email-konrad@kernel.org>
 <53BD33B8.9020901@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD33B8.9020901@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 01:21:12PM +0100, David Vrabel wrote:
> On 08/07/14 19:58, konrad@kernel.org wrote:
> > --- a/drivers/xen/xen-pciback/pci_stub.c
> > +++ b/drivers/xen/xen-pciback/pci_stub.c
> > @@ -277,10 +277,15 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
> >  	 * (so it's ready for the next domain)
> >  	 */
> >  
> > -	/* This is OK - we are running from workqueue context
> > -	 * and want to inhibit the user from fiddling with 'reset'
> > +	/* We might be holding the PCI lock (see comment at the top of the
> > +	 * function) - as such try lock and if we can't then don't worry -
> > +	 * as either:
> > +	 *  - we are 'unbind' in which case 'pcistub_device_release' gets
> > +	 *    called which does the locked version of this.
> > +	 *  - the toolstack has the smarts to do it and has done the
> > +	 *    reset on SysFS before assigning this device to another guest.
> >  	 */
> > -	pci_reset_function(dev);
> > +	pci_try_reset_function(dev);
> 
> Why not use __pci_reset_function_locked() and ensure all callers of
> pcistub_put_pci_dev() are holding the device lock?

That could also be done.
> 
> >  	pci_restore_state(dev);
> 
> If we didn't reset the device there is no need to restore its state.

<nods>
> 
> David
