Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab3FMQtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:49:24 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:53599
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756653Ab3FMQtX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:49:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Thu, 13 Jun 2013 11:49:17 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
To: Rojhalat Ibrahim <imr@rtschenk.de>
CC: Michael Guntsche <michael.guntsche@it-loops.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
References: <1370971739.18413.27@snotra> <34279395.MbRViMjbAR@pcimr>
	<1371073826.18413.52@snotra> <7706620.VNI3PE9pqO@pcimr>
In-Reply-To: <7706620.VNI3PE9pqO@pcimr> (from imr@rtschenk.de on Thu Jun 13
	02:21:24 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1371142157.2028.9@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 02:21:24 AM, Rojhalat Ibrahim wrote:
> On Wednesday 12 June 2013 16:50:26 Scott Wood wrote:
> > On 06/12/2013 03:19:30 AM, Rojhalat Ibrahim wrote:
> > > On Tuesday 11 June 2013 12:28:59 Scott Wood wrote:
> > > > Yes, I figured it was non-PCIe because the code change that you  
> said
> > > > helped was on the non-PCIe branch of the if/else.  Generally  
> it's
> > >
> > > good
> > >
> > > > to explicitly mention the chip you're using, though.
> > > >
> > > > fsl_setup_indirect_pci should be renamed to  
> fsl_setup_indirect_pcie.
> > > > Your patch above should be applied, and fsl_setup_indirect_pcie
> > >
> > > should
> > >
> > > > be moved into the booke/86xx ifdef to avoid an unused function
> > >
> > > warning.
> > >
> > > > -Scott
> > >
> > > How about this patch? It uses setup_indirect_pci for the PCI case  
> in
> > > mpc83xx_add_bridge. Additionally it adds a check in
> > > fsl_setup_indirect_pci
> > > to only use the modified read function in case of PCIe.
> >
> > If we're adding the check to fsl_setup_indirect_pci, there's no  
> need to
> > change the 83xx call back to setup_indirect_pci.  I see that 85xx is
> > also callirng fsl_setup_indirect_pci for both; it'd be good to be
> > consistent.
> >
> > In any case, can you send a proper patch with a signoff and commit
> > message?
> >
> > -Scott
> 
> Where is it called for 85xx? As far as I can tell  
> fsl_setup_indirect_pci is
> called exactly once in fsl_add_bridge and nowhere else (after  
> applying the
> proposed patch).

fsl_add_bridge() is where it's called for 85xx.

> For 83xx the decision between PCI and PCIe has already been made at
> the point where the setup function is called. So IMO it doesn't make  
> sense
> to call fsl_setup_indirect_pci and do the check again. Moreover PCIe  
> on 83xx
> uses a completely different set of functions.

My concern is consistency.  E.g. if 85xx is using  
fsl_setup_indirect_pci for both, but 83xx isn't, then a developer using  
83xx could end up breaking 85xx by introducing another PCIe dependency  
in fsl_setup_indirect_pci.  Or an 85xx developer could put something  
non-PCIe-related in fsl_setup_indirect_pci that 83xx would benefit from.

Alternatively, you could call it fsl_setup_indirect_pcie, and move the  
PCIe check into fsl_add_bridge().

-Scott
