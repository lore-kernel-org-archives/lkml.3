Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaACSaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:30:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:48291 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaACSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:30:14 -0500
X-IronPort-AV: E=Sophos;i="4.95,599,1384300800"; 
   d="scan'208";a="87429104"
Date: Fri, 3 Jan 2014 18:29:25 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v12 15/18] xen/pvh: Piggyback on PVHVM for
 grant driver (v2)
In-Reply-To: <20140103181459.GG27019@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1401031827570.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com> <52C59483.5030607@citrix.com> <20140102185023.GG3021@pegasus.dumpdata.com> <52C6A4E5.3080904@citrix.com>
 <20140103144409.GC27019@phenom.dumpdata.com> <52C6DA3F.7070509@citrix.com> <20140103154820.GA20976@andromeda.dapyr.net> <alpine.DEB.2.02.1401031659230.8667@kaball.uk.xensource.com> <20140103181459.GG27019@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, Konrad Rzeszutek Wilk wrote:
> On Fri, Jan 03, 2014 at 05:20:54PM +0000, Stefano Stabellini wrote:
> > On Fri, 3 Jan 2014, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Jan 03, 2014 at 03:41:51PM +0000, David Vrabel wrote:
> > > > On 03/01/14 14:44, Konrad Rzeszutek Wilk wrote:
> > > > > On Fri, Jan 03, 2014 at 11:54:13AM +0000, David Vrabel wrote:
> > > > >> On 02/01/14 18:50, Konrad Rzeszutek Wilk wrote:
> > > > >>> On Thu, Jan 02, 2014 at 04:32:03PM +0000, David Vrabel wrote:
> > > > >>>> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > > > >>>>> @@ -1320,4 +1323,4 @@ static int __gnttab_init(void)
> > > > >>>>>  	return gnttab_init();
> > > > >>>>>  }
> > > > >>>>>  
> > > > >>>>> -core_initcall(__gnttab_init);
> > > > >>>>> +core_initcall_sync(__gnttab_init);
> > > > >>>>
> > > > >>>> Why has this become _sync?
> > > > >>>
> > > > >>> It needs to run _after_ the xen_pvh_gnttab_setup has run (which is
> > > > >>> at gnttab_init):
> > > > >>
> > > > >>
> > > > >> The use of core_initcall_sync() doesn't imply any ordering to me.  Can't
> > > > > 
> > > > > It has a clear ordering property.
> > > > 
> > > > This really isn't obvious to me.  Can you point to the docs/code the
> > > > guarantee this?  I couldn't find it.
> > > 
> > > include/linux/init.h
> > > > 
> > > > >> you call xen_pvh_gnttab_setup() from within __gnttab_init() ?
> > > > > 
> > > > > No. That is due to the fact that __gnttab_init() is in drivers/xen and is
> > > > > also used by the ARM code.
> > > > > 
> > > > > Stefano in his previous review mentioned he would like PVH specific
> > > > > code in arch/x86:
> > > > > 
> > > > > https://lkml.org/lkml/2013/12/18/507
> > > > 
> > > > Call it xen_arch_gnttab_setup() and add weak stub for other architectures?
> > > 
> > > Stefano, thoughts?
> > 
> > I think that you can safely move __gnttab_init to postcore_initcall if
> > it works correctly for the PV and PVH cases, because HVM and ARM are
> > unaffected by it.  In fact they don't initialize the grant table via
> > __gnttab_init at all. See:
> 
> The 'xenbus_init' is called in postcore_initcall. I don't actually
> know if it is OK to call that _before_ gnttab_init is called.

No, xenbus_init needs to be called after gnttab_init, however the
alphabetical order would enforce it.
Not that I would want to rely on it :-)
