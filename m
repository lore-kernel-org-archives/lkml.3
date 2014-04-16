Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaDPRGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:06:41 -0400
Received: from dliviu.plus.com ([80.229.23.120]:56755 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaDPRGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:06:40 -0400
From: "Liviu Dudau" <liviu@dudau.co.uk>
Date: Wed, 16 Apr 2014 18:05:45 +0100
To: Rob Herring <robherring2@gmail.com>
Cc: Tanmay Inamdar <tinamdar@apm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>
Subject: Re: [PATCH v5 2/4] arm64: dts: APM X-Gene PCIe device tree nodes
Message-ID: <20140416170545.GD4858@bart>
Mail-Followup-To: Rob Herring <robherring2@gmail.com>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@apm.com" <patches@apm.com>,
	"jcm@redhat.com" <jcm@redhat.com>
References: <1395270762-6055-1-git-send-email-tinamdar@apm.com>
 <1395270762-6055-3-git-send-email-tinamdar@apm.com>
 <CAL_Jsq+XxAtUeNKFi0hH=ehb_fhFvkM0U1Zm_j1LdtQZbvSzfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+XxAtUeNKFi0hH=ehb_fhFvkM0U1Zm_j1LdtQZbvSzfA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Apr 16 18:06:39 2014
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 13,534eb89e2988058717537
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 09:28:42AM -0500, Rob Herring wrote:
> On Wed, Mar 19, 2014 at 6:12 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> > This patch adds the device tree nodes for APM X-Gene PCIe controller and
> > PCIe clock interface. Since X-Gene SOC supports maximum 5 ports, 5 dts
> > nodes are added.
> 
> [snip]
> 
> > +               pcie0: pcie@1f2b0000 {
> > +                       status = "disabled";
> > +                       device_type = "pci";
> > +                       compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
> > +                       #interrupt-cells = <1>;
> > +                       #size-cells = <2>;
> > +                       #address-cells = <3>;
> > +                       reg = < 0x00 0x1f2b0000 0x0 0x00010000   /* Controller registers */
> > +                               0xe0 0xd0000000 0x0 0x00200000>; /* PCI config space */
> 

Resurecting an old thread as this is relevant to what I'm doing at the moment:

> Where is the right place for config space? This binding has it here
> and others have it in ranges. Given that config space type is defined
> for ranges, I would think that is the right place. But Liviu's patches
> do not process config space entries in ranges. Perhaps we need a
> config space resource populated in the bridge struct.

I have found out that we cannot pasd the config ranges from the DT into the
pci_host_bridge structure as the PCI framework doesn't have a resource type
for config resources. Leaving the translation between range flags and
resource type as is (filtered through the IORESOURCE_TYPE_BITS) will lead
to a resource type of value zero, which is not recognised by any resource
handling API so bridge configuration and bus scanning will barf.

I'm looking for suggestions here, as Jason Gunthorpe suggested that we
should be able to parse config ranges if they conform to the ECAM part
of the PCI standard.

Best regards,
Liviu

> 
> Rob
> 
> 
> > +                       reg-names = "csr", "cfg";
> > +                       ranges = <0x01000000 0x00 0x00000000 0xe0 0x00000000 0x00 0x00010000   /* io */
> > +                                 0x02000000 0x00 0x10000000 0xe0 0x10000000 0x00 0x80000000>; /* mem */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

