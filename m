Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbaGEUrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:47:15 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63879 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156AbaGEUrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:47:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robherring2@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Sinan Kaya <okaya@codeaurora.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Will Deacon <Will.Deacon@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v8 4/9] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Sat, 05 Jul 2014 22:46:09 +0200
Message-ID: <6122131.ozzYjjjRQi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqJNfB_jynFQK0Ov6A3wqk6LF3abUFEUjhmzipak26sU5w@mail.gmail.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <1404240214-9804-5-git-send-email-Liviu.Dudau@arm.com> <CAL_JsqJNfB_jynFQK0Ov6A3wqk6LF3abUFEUjhmzipak26sU5w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2Sr1JqkR+QOvS6uqBTJ91rGDpu/XmNjREZ4SKqJ0A79
 fc2qkDZxrzz03MOHE4YHKqzt7lFQGl4OAnmy+ob71wHPxP0jmo
 oVmBn9DxukEonwP+yW90/vLAfJpjaVHsqewpbJCtfxi4cy1dPA
 2BKG7dhXniNTZpXqIfPJ3T6npIMp5Pn4ASHcTYAXalS+AtNbe8
 xBdnNyfEGSXb94yuEYexsdmf4jKIGGH0uo1qTTrkvqie/rK6Bw
 tamNtkva0w+6DkO5anN9c1evIIhrJuass/XH+NRsm3gMYHsHWF
 RUAHl7fggK+yE8Lg5tl4tOmLNJpgl5rMvDENY+hwIY8241q2mv
 g2PtPfmoh6lAaUjK+ZVQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 July 2014 14:25:52 Rob Herring wrote:
> On Tue, Jul 1, 2014 at 1:43 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > The ranges property for a host bridge controller in DT describes
> > the mapping between the PCI bus address and the CPU physical address.
> > The resources framework however expects that the IO resources start
> > at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
> > The conversion from pci ranges to resources failed to take that into account.
> 
> I don't think this change is right. There are 2 resources: the PCI bus
> addresses and cpu addresses. This function deals with the cpu
> addresses. Returning pci addresses for i/o and cpu addresses for
> memory is going to be error prone. We probably need both cpu and pci
> resources exposed to host controllers.
> 
> Making the new function only deal with i/o bus resources and naming it
> of_pci_range_to_io_resource would be better.

I think you are correct that this change by itself is will break existing
drivers that rely on the current behavior of of_pci_range_to_resource,
but there is also something wrong with the existing implementation:

of_pci_range_to_resource() at the moment returns a the address in
cpu address space (i.e. IORESOURCE_MEM) but sets the res->flags
value to IORESOURCE_IO, which means it doesn't fit into the resource
tree. Liviu's version gets that part right, and it would be nice
to fix that eventually, however we do it here.

	Arnd
