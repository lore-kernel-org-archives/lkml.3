Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaIPTd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:33:27 -0400
Received: from mail-bl2on0128.outbound.protection.outlook.com ([65.55.169.128]:44128
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754788AbaIPTdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:33:25 -0400
Date: Tue, 16 Sep 2014 14:28:06 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: "J. German Rivera" <German.Rivera@freescale.com>,
        <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <agraf@suse.de>, <linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex
 APIs
Message-ID: <20140916142806.f255250be8df08c56241580f@freescale.com>
In-Reply-To: <1410841881.24184.499.camel@snotra.buserror.net>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	<20140915184451.962a3a19c4940792d182f10a@freescale.com>
	<1410841881.24184.499.camel@snotra.buserror.net>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51404002)(51704005)(24454002)(164054003)(377424004)(199003)(77156001)(88136002)(23726002)(84676001)(87936001)(89996001)(90102001)(46406003)(50226001)(4396001)(81542003)(81342003)(87286001)(62966002)(79102003)(46102003)(95666004)(77982003)(74502003)(80022003)(85852003)(83072002)(74662003)(86362001)(93886004)(99396002)(102836001)(92726001)(105606002)(100306002)(93916002)(97736003)(92566001)(106466001)(33646002)(68736004)(50466002)(104166001)(50986999)(104016003)(76176999)(85306004)(107046002)(76482001)(47776003)(26826002)(31966008)(21056001)(36756003)(20776003)(83322001)(19580405001)(6806004)(44976005)(19580395003)(64706001)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB321;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2014 23:31:21 -0500
Scott Wood <scottwood@freescale.com> wrote:

> On Mon, 2014-09-15 at 18:44 -0500, Kim Phillips wrote:
> > On Thu, 11 Sep 2014 12:34:21 -0500
> > "J. German Rivera" <German.Rivera@freescale.com> wrote:
> > 
> > > +int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
> > > +{
> > > +	struct mc_command cmd = { 0 };
> > 
> > we can save some cycles if this initialization is not absolutely
> > necessary: is it?  i.e., does the h/w actually look at the params
> > section when doing a get_version?  not sure to what other commands
> > this comment would apply to...at least get_container_id, but maybe
> > more - all of them?
> 
> Do you really want to open that can of worms, much less to speed up
> something that doesn't look performance critical?  Have fun debugging it
> if it turns out the hardware does look at something you didn't
> initialize.

point taken.

> > > diff --git a/drivers/bus/fsl-mc/fsl_mc_sys.c b/drivers/bus/fsl-mc/fsl_mc_sys.c
> > 
> > > +/**
> > > + * Map an MC portal in the kernel virtual address space
> > > + */
> > > +static int map_mc_portal(phys_addr_t mc_portal_phys_addr,
> > > +			 uint32_t mc_portal_size,
> > > +			 void __iomem **new_mc_portal_virt_addr)
> > > +{
> > > +	void __iomem *mc_portal_virt_addr = NULL;
> > > +	struct resource *res = NULL;
> > > +	int error = -EINVAL;
> > > +
> > > +	res =
> > > +	    request_mem_region(mc_portal_phys_addr, mc_portal_size,
> > > +			       "mc_portal");
> > > +	if (res == NULL) {
> > > +		pr_err("request_mem_region() failed for MC portal %#llx\n",
> > > +		       mc_portal_phys_addr);
> > > +		error = -EBUSY;
> > > +		goto error;
> > > +	}
> > > +
> > > +	mc_portal_virt_addr = ioremap_nocache(mc_portal_phys_addr,
> > > +					      mc_portal_size);
> > > +	if (mc_portal_virt_addr == NULL) {
> > > +		pr_err("ioremap_nocache() failed for MC portal %#llx\n",
> > > +		       mc_portal_phys_addr);
> > > +		error = -EFAULT;
> > > +		goto error;
> > > +	}
> > > +
> > > +	*new_mc_portal_virt_addr = mc_portal_virt_addr;
> > > +	return 0;
> > > +error:
> > > +	if (mc_portal_virt_addr != NULL)
> > > +		iounmap(mc_portal_virt_addr);
> > > +
> > > +	if (res != NULL)
> > > +		release_mem_region(mc_portal_phys_addr, mc_portal_size);
> > > +
> > > +	return error;
> > > +}
> > 
> > unnecessary initializations, bad error codes (both should be
> > -ENOMEM),
> 
> Why should the first one be -ENOMEM?  It's not allocating memory, but
> rather reserving I/O space.

I was going with what most of the drivers are already doing, but I
see EFAULT is 'Bad address', which, you're right, is probably more
appropriate.

> >  unnecessarily complicated error path, plus a simpler
> > implementation can be made if fn can return the mapped address, like
> > so:
> > 
> > static void __iomem *map_mc_portal(phys_addr_t mc_portal_phys_addr,
> >                                    uint32_t mc_portal_size)
> > { 
> >         struct resource *res;
> >         void __iomem *mapped_addr;
> > 
> >         res = request_mem_region(mc_portal_phys_addr, mc_portal_size, 
> >                                  "mc_portal");
> >         if (!res) 
> >                 return NULL;
> > 
> >         mapped_addr = ioremap_nocache(mc_portal_phys_addr,
> >                                       mc_portal_size);
> >         if (!mapped_addr)
> >                 release_mem_region(mc_portal_phys_addr, mc_portal_size);
> > 
> >         return mapped_addr;
> > }
> > 
> > the callsite can return -ENOMEM to its caller if returned NULL.
> 
> -ENOMEM would only be appropriate for one of these errors.

in that case, ERR_PTR() can be used to return the specific error.

> > > +#define ioread64(_p)	    readq(_p)
> > > +#define iowrite64(_v, _p)   writeq(_v, _p)
> > 
> > these definitions have names that are too generic to belong in a FSL
> > h/w header: conflicts will be introduced once the existing
> > io{read,write}32 functions get promoted.  Either use readq/writeq
> > directly, or, if you can justify it, patch a more generic io.h.
> > 
> > Also, is there a reason the 'relaxed' versions of the i/o accessors
> > aren't being used?
> 
> Raw accessors should only be used in performance critical sections where
> it's worth the effort to implement and verify manual synchronization.
> My understanding is that the entire management complex is related to
> setup, not on the I/O fast path.

ok.

Thanks,

Kim
