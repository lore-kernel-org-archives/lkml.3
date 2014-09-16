Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaIPEqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 00:46:51 -0400
Received: from mail-by2on0123.outbound.protection.outlook.com ([207.46.100.123]:3585
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751055AbaIPEqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 00:46:50 -0400
Message-ID: <1410841881.24184.499.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
CC: "J. German Rivera" <German.Rivera@freescale.com>,
        <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <agraf@suse.de>, <linuxppc-release@linux.freescale.net>
Date: Mon, 15 Sep 2014 23:31:21 -0500
In-Reply-To: <20140915184451.962a3a19c4940792d182f10a@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:996e:3fd3:8a64:f678]
X-ClientProxiedBy: BN1PR02CA0022.namprd02.prod.outlook.com (10.141.56.22) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(189002)(377424004)(51404002)(199003)(21056001)(76482001)(90102001)(101416001)(23676002)(104166001)(99396002)(110136001)(88136002)(62966002)(42186005)(77156001)(76176999)(103116003)(85306004)(106356001)(47776003)(20776003)(4396001)(83072002)(95666004)(85852003)(102836001)(50226001)(105586002)(83322001)(92566001)(97736003)(19580395003)(19580405001)(64706001)(89996001)(87976001)(93916002)(107046002)(31966008)(87286001)(50466002)(86362001)(92726001)(77096002)(50986999)(33646002)(81542003)(81342003)(77982003)(79102003)(80022003)(46102003)(74502003)(74662003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:996e:3fd3:8a64:f678];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 18:44 -0500, Kim Phillips wrote:
> On Thu, 11 Sep 2014 12:34:21 -0500
> "J. German Rivera" <German.Rivera@freescale.com> wrote:
> 
> > +int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
> > +{
> > +	struct mc_command cmd = { 0 };
> 
> we can save some cycles if this initialization is not absolutely
> necessary: is it?  i.e., does the h/w actually look at the params
> section when doing a get_version?  not sure to what other commands
> this comment would apply to...at least get_container_id, but maybe
> more - all of them?

Do you really want to open that can of worms, much less to speed up
something that doesn't look performance critical?  Have fun debugging it
if it turns out the hardware does look at something you didn't
initialize.

> > diff --git a/drivers/bus/fsl-mc/fsl_mc_sys.c b/drivers/bus/fsl-mc/fsl_mc_sys.c
> 
> > +/**
> > + * Map an MC portal in the kernel virtual address space
> > + */
> > +static int map_mc_portal(phys_addr_t mc_portal_phys_addr,
> > +			 uint32_t mc_portal_size,
> > +			 void __iomem **new_mc_portal_virt_addr)
> > +{
> > +	void __iomem *mc_portal_virt_addr = NULL;
> > +	struct resource *res = NULL;
> > +	int error = -EINVAL;
> > +
> > +	res =
> > +	    request_mem_region(mc_portal_phys_addr, mc_portal_size,
> > +			       "mc_portal");
> > +	if (res == NULL) {
> > +		pr_err("request_mem_region() failed for MC portal %#llx\n",
> > +		       mc_portal_phys_addr);
> > +		error = -EBUSY;
> > +		goto error;
> > +	}
> > +
> > +	mc_portal_virt_addr = ioremap_nocache(mc_portal_phys_addr,
> > +					      mc_portal_size);
> > +	if (mc_portal_virt_addr == NULL) {
> > +		pr_err("ioremap_nocache() failed for MC portal %#llx\n",
> > +		       mc_portal_phys_addr);
> > +		error = -EFAULT;
> > +		goto error;
> > +	}
> > +
> > +	*new_mc_portal_virt_addr = mc_portal_virt_addr;
> > +	return 0;
> > +error:
> > +	if (mc_portal_virt_addr != NULL)
> > +		iounmap(mc_portal_virt_addr);
> > +
> > +	if (res != NULL)
> > +		release_mem_region(mc_portal_phys_addr, mc_portal_size);
> > +
> > +	return error;
> > +}
> 
> unnecessary initializations, bad error codes (both should be
> -ENOMEM),

Why should the first one be -ENOMEM?  It's not allocating memory, but
rather reserving I/O space.

>  unnecessarily complicated error path, plus a simpler
> implementation can be made if fn can return the mapped address, like
> so:
> 
> static void __iomem *map_mc_portal(phys_addr_t mc_portal_phys_addr,
>                                    uint32_t mc_portal_size)
> { 
>         struct resource *res;
>         void __iomem *mapped_addr;
> 
>         res = request_mem_region(mc_portal_phys_addr, mc_portal_size, 
>                                  "mc_portal");
>         if (!res) 
>                 return NULL;
> 
>         mapped_addr = ioremap_nocache(mc_portal_phys_addr,
>                                       mc_portal_size);
>         if (!mapped_addr)
>                 release_mem_region(mc_portal_phys_addr, mc_portal_size);
> 
>         return mapped_addr;
> }
> 
> the callsite can return -ENOMEM to its caller if returned NULL.

-ENOMEM would only be appropriate for one of these errors.

> > +#define ioread64(_p)	    readq(_p)
> > +#define iowrite64(_v, _p)   writeq(_v, _p)
> 
> these definitions have names that are too generic to belong in a FSL
> h/w header: conflicts will be introduced once the existing
> io{read,write}32 functions get promoted.  Either use readq/writeq
> directly, or, if you can justify it, patch a more generic io.h.
> 
> Also, is there a reason the 'relaxed' versions of the i/o accessors
> aren't being used?

Raw accessors should only be used in performance critical sections where
it's worth the effort to implement and verify manual synchronization.
My understanding is that the entire management complex is related to
setup, not on the I/O fast path.

-Scott


