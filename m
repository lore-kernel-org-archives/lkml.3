Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbaISRYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:24:35 -0400
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:52640
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757276AbaISRYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:24:33 -0400
Date: Fri, 19 Sep 2014 12:19:12 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: German Rivera <German.Rivera@freescale.com>
CC: Alexander Graf <agraf@suse.de>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<stuart.yoder@freescale.com>" <stuart.yoder@freescale.com>,
        "<scottwood@freescale.com>" <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex
 APIs
Message-ID: <20140919121912.197b15bd3b79fb90d7f97602@freescale.com>
In-Reply-To: <541B9D5F.20008@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	<20140915184451.962a3a19c4940792d182f10a@freescale.com>
	<541A5CF1.8000409@freescale.com>
	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	<20140918152233.41647ee517393816bb35b72a@freescale.com>
	<541B9D5F.20008@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(52314003)(479174003)(199003)(377454003)(51704005)(189002)(46102003)(74662003)(84676001)(6806004)(46406003)(76482002)(95666004)(104166001)(44976005)(19580395003)(50466002)(33646002)(93916002)(50986999)(104016003)(36756003)(79102003)(47776003)(83322001)(74502003)(90102001)(69596002)(83072002)(77982003)(87286001)(93886004)(102836001)(81542003)(50226001)(95246002)(64706001)(68736004)(105606002)(4396001)(77156001)(110136001)(15975445006)(85852003)(31966008)(81156004)(85306004)(81342003)(97736003)(19580405001)(20776003)(100306002)(92726001)(80022003)(62966002)(88136002)(21056001)(92566001)(99396002)(76176999)(107046002)(26826002)(87936001)(86362001)(89996001)(106466001)(23726002)(95446003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0749;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014 22:05:03 -0500
German Rivera <German.Rivera@freescale.com> wrote:

> On 09/18/2014 03:22 PM, Kim Phillips wrote:
> > On Thu, 18 Sep 2014 15:14:03 +0200
> 
> >>> unnecessarily complicated error path, plus a simpler
> >>>> implementation can be made if fn can return the mapped address, like
> >>>> so:
> >>>>
> >>>> static void __iomem *map_mc_portal(phys_addr_t mc_portal_phys_addr,
> >>>>                                     uint32_t mc_portal_size)
> >>>> {
> >>>>          struct resource *res;
> >>>>          void __iomem *mapped_addr;
> >>>>
> >>>>          res = request_mem_region(mc_portal_phys_addr, mc_portal_size,
> >>>>                                   "mc_portal");
> >>>>          if (!res)
> >>>>                  return NULL;
> >>>>
> >>>>          mapped_addr = ioremap_nocache(mc_portal_phys_addr,
> >>>>                                        mc_portal_size);
> >>>>          if (!mapped_addr)
> >>>>                  release_mem_region(mc_portal_phys_addr, mc_portal_size);
> >>>>
> >>>>          return mapped_addr;
> >>>> }
> >>>>
> >>>> the callsite can return -ENOMEM to its caller if returned NULL.  This
> >>>> can be improved even further if devm_ functions are used:  this is
> >>>> just an example of how to simplify the code using early returns
> >>>> instead of goto error.
> >>>
> >>> I disagree. Having a common error return point is more maintainable than having multiple returns as having the clean-up logic in one place is more maintainable and makes the min path (non-error) more readable.
> >
> > my comment is not that much different from Joe's here:
> >
> > https://lkml.org/lkml/2014/9/17/381
> >
> > but hopefully all this will change with a devm_ based implementation.
> >
> I will refactor this function to use devm_ functions, to simplify the 
> error cleanup logic as you suggested, but still keep the current
> signature of the function, as I don't think it is a good practice
> to just return NULL in case of error, hiding the actual cause of the 
> error. Also, mixing returning a valid pointer and an error encoded
> as an invalid pointer is not clean and can be error-prone for callers, 
> if some caller just checks for NULL instead of using IS_ERR() ir
> IS_ERR_OR_NULL().

we'll make sure callers don't do that then :)

> >>>>> +void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
> >>>>> +{
> >>>>> +    if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
> >>>>> +        return;
> >>>>> +
> >>>>> +    if (mc_io->portal_virt_addr != NULL) {
> >>>>> +        unmap_mc_portal(mc_io->portal_phys_addr,
> >>>>> +                mc_io->portal_size, mc_io->portal_virt_addr);
> >>>>
> >>>> unmap_mc_portal already checks for virt_addr, this is another
> >>>> example where the code goes too far checking for NULL.
> >>> I disagree. Having the extra check is harmless and more importantly makes the intent explicit that we should only call unmap_mc_portal if we called map_mc_portal earlier.
> >
> > the code is doing this:
> >
> >          if (mc_io->portal_virt_addr != NULL) {
> > 	        if (WARN_ON(mc_portal_virt_addr == NULL))
> >          	        return;
> >
> > which is redundant and therefore makes it unnecessarily complicated,
> > after all, a stack trace will occur if mc_portal_virt_addr is
> > referenced anyway, making the WARN_ON clause redundant, too.
> >
> All this will be gone with the refactoring to use devm_ APIs.

sounds good.

> >>>>> +        mc_io->portal_virt_addr = NULL;
> >>>>> +    }
> >>>>> +
> >>>>> +    mc_io->magic = 0x0;
> >>>>> +    kfree(mc_io);
> >>>>> +}
> >
> > btw, what's the point of zeroing out things that are being freed?
> >
> In this particular case, this comment doe snot apply anymore, as
> the magic filed will be removed.

it still applies for portal_virt_addr.

> >>>>> +/**
> >>>>> + * @brief    Management Complex firmware version information
> >>>>> + */
> >>>>> +#define MC_VER_MAJOR 2
> >>>>> +#define MC_VER_MINOR 0
> >>>>
> >>>> code should be adjusted to run on all *compatible* versions of h/w,
> >>>> not strictly the one set in these defines.
> >>> This comment is not precise enough be actionable.
> >>> What exactly you want to be changed  here?
> >>
> >> I think the easy thing to do is to convert the exact version check into a ranged version check: have minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the version at all - or only for the major version and guarantee that the major version indicates backwards compatibility.
> >
> > yes, this was my point: elsewhere I noticed the code denies to run
> > iff those defines are not matched exactly: that code should change
> > to run as Alex describes.
> >
> As I mentioned in the reply to Alex, I will remove the minor version check.

the code should be able to run on all subsequent versions of the
h/w, even in the major version case.

Kim
