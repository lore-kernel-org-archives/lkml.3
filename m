Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaE3BkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:40:05 -0400
Received: from dliviu.plus.com ([80.229.23.120]:39489 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaE3BkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:40:01 -0400
From: "Liviu Dudau" <liviu@dudau.co.uk>
Date: Fri, 30 May 2014 02:41:17 +0100
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kumar Gala <galak@codeaurora.org>, Rob Herring <robherring2@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH] of: treat PCI config space as IORESOURCE_MEM type
Message-ID: <20140530014116.GF1677@bart.dudau.co.uk>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	Kumar Gala <galak@codeaurora.org>,
	Rob Herring <robherring2@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Grant Likely <grant.likely@linaro.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	linux-arm-msm <linux-arm-msm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Kishon Vijay Abraham I <kishon@ti.com>
References: <1401379426-9701-1-git-send-email-galak@codeaurora.org>
 <CAL_JsqLPFDwtd-QYDqCwx1JVj1Aa8=nof-e0P6R9CZra+fXHfw@mail.gmail.com>
 <47B1E3D0-4336-4529-80B0-172F4ACA5C97@codeaurora.org>
 <20140530005602.GE1677@bart.dudau.co.uk>
 <CAErSpo7qEhJyUAu58R8g6+AEhRGo_+Vv0EMgkK+3ZQOU9+jmhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo7qEhJyUAu58R8g6+AEhRGo_+Vv0EMgkK+3ZQOU9+jmhg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri May 30 02:39:59 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,5387e16f3031089253836
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 07:29:31PM -0600, Bjorn Helgaas wrote:
> On Thu, May 29, 2014 at 6:56 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
> > On Thu, May 29, 2014 at 03:51:28PM -0500, Kumar Gala wrote:
> >>
> >> On May 29, 2014, at 3:44 PM, Rob Herring <robherring2@gmail.com> wrote:
> >>
> >> > On Thu, May 29, 2014 at 11:03 AM, Kumar Gala <galak@codeaurora.org> wrote:
> >> >> If we have a PCI config space specified in something like a ranges
> >> >> property we should treat it as memory type resource.
> >> >
> >> > Config space should not be in ranges[1]. We have some cases that are,
> >> > but we don't want new ones.
> >>
> >> For the cases we have I agree, however an ECAM based cfg seems completely legit.
> >>
> >> >> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> >> >> ---
> >> >> drivers/of/address.c | 3 +++
> >> >> 1 file changed, 3 insertions(+)
> >> >>
> >> >> diff --git a/drivers/of/address.c b/drivers/of/address.c
> >> >> index cb4242a..4e7ee59 100644
> >> >> --- a/drivers/of/address.c
> >> >> +++ b/drivers/of/address.c
> >> >> @@ -122,6 +122,9 @@ static unsigned int of_bus_pci_get_flags(const __be32 *addr)
> >> >>        u32 w = be32_to_cpup(addr);
> >> >>
> >> >>        switch((w >> 24) & 0x03) {
> >> >> +       case 0x00: /* cfg space */
> >> >> +               flags |= IORESOURCE_MEM;
> >> >> +               break;
> >> >
> >> > How would you then distinguish actual memory ranges?
> >>
> >> One assumes you are still looking at pci_space as part of of_pci_range
> >
> > That doesn't happen when you start scanning the bus. The existing code will
> > use the IORESOURCE_MEM for allocating memory space for devices, which is
> > not what you want. Did you test your patch on any PCI system? I'm pretty
> > sure that with my patch series that tries to make a generic framework for
> > host controllers this will fail.
> >
> > We really need a IORESOURCE_CFG flag for this space.
> 
> Maybe, but I'm not convinced yet.  The existing IORESOURCE_TYPE_BITS
> types are for things that are mutually exclusive address spaces.  I
> think this discussion is about ECAM, where the CPU side is definitely
> in the same address space (IORESOURCE_MEM) as RAM, APICs, host bridge
> apertures, device MMIO, etc.  The ECAM area must appear in the
> iomem_resource tree so we avoid it when allocating other areas.

Agree, I'm only concerned that if this ECAM config space gets added to
the list of pci_host_bridge windows it will be indistinguishable from
IORESOURCE_MEM resources and pci_create_root_bus() will add it to the
bus and allow devices present on that bus to be assigned addresses from
that range. Which might not be what one wants for certain BARs.

I've had an aborted attempt to parse ECAM ranges in one version of my
series (granted, I was trying to hack the IORESOURCE_TYPE_BITS as well)
and things got horribly wrong quickly. I could give this patch a go with
my series tomorrow when I'm in the office and report back.

Best regards,
Liviu

> 
> >> > [1] http://www.spinics.net/lists/linux-pci/msg30585.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

