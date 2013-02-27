Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859Ab3B0L4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:56:19 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:19888
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759801Ab3B0L4R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:56:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Stuart Yoder <b08248@gmail.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Joerg Roedel <joro@8bytes.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>
Subject: RE: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Topic: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Index: AQHODdfbgGU1NqcYVkONwLkDSaaXgpiMxtiAgADRg2A=
Date: Wed, 27 Feb 2013 11:56:08 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D3C2691@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
	<1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
 <CALRxmdBBO2AoAnKSTNNTYhHZ9fitJKWWeZMUj1ObtFhsZS5iSw@mail.gmail.com>
In-Reply-To: <CALRxmdBBO2AoAnKSTNNTYhHZ9fitJKWWeZMUj1ObtFhsZS5iSw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stuart Yoder [mailto:b08248@gmail.com]
> Sent: Wednesday, February 27, 2013 4:03 AM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; Wood Scott-B07421; Joerg Roedel; Yoder
> Stuart-B08248
> Subject: Re: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU
> API implementation.
> 
> Have not got through the entire file, but have a few comments...
> 
> +/*
> + * Set the PAACE type as primary and set the coherency required domain
> + * attribute
> + */
> +static void pamu_setup_default_xfer_to_host_ppaace(struct paace
> +*ppaace) {
> +       set_bf(ppaace->addr_bitfields, PAACE_AF_PT, PAACE_PT_PRIMARY);
> +
> +       set_bf(ppaace->domain_attr.to_host.coherency_required,
> PAACE_DA_HOST_CR,
> +              PAACE_M_COHERENCE_REQ);
> +}
> +
> +/*
> + * Set the PAACE type as secondary and set the coherency required
> +domain
> + * attribute.
> + */
> +static void pamu_setup_default_xfer_to_host_spaace(struct paace
> +*spaace) {
> +       set_bf(spaace->addr_bitfields, PAACE_AF_PT, PAACE_PT_SECONDARY);
> +       set_bf(spaace->domain_attr.to_host.coherency_required,
> PAACE_DA_HOST_CR,
> +              PAACE_M_COHERENCE_REQ);
> +}
> 
> Can we change the names of the above functions...   I know there is some
> history
> with the name, but "xfer_to_host" is confusing.
> 
> Maybe just call them:
> 
> pamu_init_paace()
> pamu_init_spaace()
> 
[Sethi Varun-B16395] ok, will change the function names.

> > +/**
> > + * pamu_config_spaace() - Sets up SPAACE entry for specified
> > +subwindow
> > + *
> > + * @liodn:  Logical IO device number
> > + * @subwin_cnt:  number of sub-windows associated with dma-window
> > + * @subwin_addr: starting address of subwindow
> > + * @subwin_size: size of subwindow
> > + * @omi: Operation mapping index
> > + * @rpn: real (true physical) page number
> > + * @snoopid: snoop id for hardware coherency -- if ~snoopid == 0 then
> > + *                       snoopid not defined
> > + * @stashid: cache stash id for associated cpu
> > + * @enable: enable/disable subwindow after reconfiguration
> > + * @prot: sub window permissions
> > + *
> > + * Returns 0 upon success else error code < 0 returned  */ int
> > +pamu_config_spaace(int liodn, u32 subwin_cnt, u32 subwin_addr,
> > +                      phys_addr_t subwin_size, u32 omi, unsigned long
> rpn,
> > +                      u32 snoopid, u32 stashid, int enable, int prot)
> > +{
> > +       struct paace *paace;
> > +
> > +       /* setup sub-windows */
> > +       if (!subwin_cnt) {
> > +               pr_err("Invalid subwindow count\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       paace = pamu_get_ppaace(liodn);
> > +       if (subwin_addr > 0 && subwin_addr < subwin_cnt && paace) {
> 
> Why is the comparison subwin_addr < subwin_cnt?   Seems wrong...
> 
[Sethi Varun-B16395] It's actually the subwindow index. I will rename the variable.

> > +               paace = pamu_get_spaace(paace, subwin_addr - 1);
> > +
> > +               if (paace && !(paace->addr_bitfields & PAACE_V_VALID))
> {
> > +                       pamu_setup_default_xfer_to_host_spaace(paace);
> > +                       set_bf(paace->addr_bitfields, SPAACE_AF_LIODN,
> liodn);
> > +               }
> > +       }
> > +
> > +       if (!paace) {
> > +               pr_err("Invalid liodn entry\n");
> > +               return -ENOENT;
> > +       }
> > +
> > +       if (!enable && prot == PAACE_AP_PERMS_DENIED) {
> > +               if (subwin_addr > 0)
> > +                       set_bf(paace->addr_bitfields, PAACE_AF_V,
> > +                                PAACE_V_INVALID);
> > +               else
> > +                       set_bf(paace->addr_bitfields, PAACE_AF_AP,
> > +                                prot);
> > +               mb();
> > +               return 0;
> > +       }
> 
> Can you add a comment to the above if statement...when is this function
> called with PAACE_AP_PERMS_DENIED?
> 
[Sethi Varun-B16395] Actually, this piece of code is redundant in case of the window based API. I will remove this. PAACE_AP_PERMS_DENIED is primarily used for disabling the primary subwindow.

-Varun


