Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaFTQTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:19:11 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58950 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaFTQTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:19:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Vasut <marex@denx.de>, tony@atomide.com,
        Mohit Kumar <mohit.kumar@st.com>, jg1.han@samsung.com,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rob.herring@linaro.org,
        Andrew Murray <Andrew.Murray@arm.com>
Subject: Re: [PATCH v2 04/18] PCI: designware: use untranslated address while programming ATU
Date: Fri, 20 Jun 2014 18:18:23 +0200
Message-ID: <5173253.SQfLkZY3Wx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53A1571B.7080806@ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-5-git-send-email-kishon@ti.com> <53A1571B.7080806@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CB6TQiKpJqvYcfEMaOnsoYxSP74IUd28kWs4xPxaJw5
 lFKphjaL4LHLE42m1Ab8HAB26FroCAc0XhcUKDlM/5mmO6HV+J
 hOhszS57Z13Xq5/98KLIBn8asVLppP5UB2Uzg3xt7AFSlnAFqi
 GdG2ut+sRWw59CvgNMPYq5TYAzYCiWB3TJBpRkbrGs9idV89sI
 92GjtjnabEIr4mctOcZ9hnT/vZWYF3fu6JCUfpTQXEfUPjiqJB
 vZZ0OhdZqKeHNMUj58Og1ylp3EFd+dBrpYKNdNhalWLvSbGVAP
 IesLuHOCSnHE2gwjSJ4Kd8LGuBvfRIJxJVaCvPd4YnIFi5ggeN
 eXKIX5behA61oTXmpQvg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2014 14:38:43 Kishon Vijay Abraham I wrote:
> On Thursday 29 May 2014 12:08 PM, Kishon Vijay Abraham I wrote:
> > 
> > Here the CPU address for configuration space is 0x20013000 and the controller
> > address for configuration space is 0x13000. The controller address should be
> > used while programming the ATU (in order for translation to happen properly in
> > DRA7xx).
> 
> I've fixed this up with what you suggested in the v1 of the series. Do you
> think this is fine?

Hi Kishon,

Yes, I think this will work and do the right thing in all cases. I'm not
completely sure if the change should be generalized into the range
parser or better kept in the pcie-designware driver as you do it here:

> > @@ -406,6 +413,12 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >               pp->config.cfg1_size = resource_size(cfg_res)/2;
> >               pp->cfg0_base = cfg_res->start;
> >               pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
> > +
> > +             /* Find the untranslated configuration space address */
> > +             index = of_property_match_string(np, "reg-names", "config");
> > +             addrp = of_get_address(np, index, false, false);
> > +             pp->cfg0_mod_addr = of_read_number(addrp, ns);
> > +             pp->cfg1_mod_addr = pp->cfg0_mod_addr + pp->config.cfg0_size;

I think I've recently seen some objections to hand-parsing standard
properties in driver code.

> >       } else {
> >               dev_err(pp->dev, "missing *config* reg space\n");
> >       }
> > @@ -431,12 +444,20 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >                       pp->config.io_size = resource_size(&pp->io);
> >                       pp->config.io_bus_addr = range.pci_addr;
> >                       pp->io_base = range.cpu_addr;
> > +
> > +                     /* Find the untranslated IO space address */
> > +                     pp->io_mod_addr = of_read_number(parser.range -
> > +                                                      parser.np + na, ns);
> >               }

So the of_read_number() call could be moved into of_pci_range_to_resource(),
with another field added to struct of_pci_range to carry the address on
the parent bus. Any other thoughts on this? Maybe Rob Herring or Andrew
Murray have a strong opinion on this.


	Arnd
