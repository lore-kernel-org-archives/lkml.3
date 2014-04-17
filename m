Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaDQAYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:24:15 -0400
Received: from dliviu.plus.com ([80.229.23.120]:58469 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359AbaDQAYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:24:10 -0400
From: "Liviu Dudau" <liviu@dudau.co.uk>
Date: Thu, 17 Apr 2014 01:20:42 +0100
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Rob Herring <robherring2@gmail.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20140417002041.GE4858@bart>
Mail-Followup-To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Rob Herring <robherring2@gmail.com>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
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
 <20140416170545.GD4858@bart>
 <20140416212104.GA3469@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140416212104.GA3469@obsidianresearch.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Apr 17 01:24:08 2014
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 13,534f1f282981448816842
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 03:21:04PM -0600, Jason Gunthorpe wrote:
> On Wed, Apr 16, 2014 at 06:05:45PM +0100, Liviu Dudau wrote:
> 
> > I have found out that we cannot pasd the config ranges from the DT into the
> > pci_host_bridge structure as the PCI framework doesn't have a resource type
> > for config resources. Leaving the translation between range flags and
> > resource type as is (filtered through the IORESOURCE_TYPE_BITS) will lead
> > to a resource type of value zero, which is not recognised by any resource
> > handling API so bridge configuration and bus scanning will barf.
> > 
> > I'm looking for suggestions here, as Jason Gunthorpe suggested that we
> > should be able to parse config ranges if they conform to the ECAM part
> > of the PCI standard.
> 
> The thinking here is the ranges should be well defined and general, it
> isn't a dumping ground for driver specific stuff.
> 
> No spec says you can put config space into the ranges at all, nobody
> should be doing that today, obviously some cases were missed during
> review..

ePAPR documents allows that when ss == 00.

> 
> The comment about ECAM was intended as a general guidance on what
> config space in ranges could/should be used for.
> 
> Right now config space shouldn't propagate out side any driver, so you
> can probably just filter it in your generic code, and make it very hard
> and obviously wrong for a driver to parse ranges for config space, so
> we don't get more usages.

OK, this goes slightly against your email from 26th March:

"When we talked about this earlier on the DT bindings list the
consensus seemed to be that configuration MMIO ranges should only be
used if the underlying memory was exactly ECAM, and was not to be used
for random configuration related register blocks.

The rational being that generic code, upon seeing that ranges entry,
could just go ahead and assume ECAM mapping."

What I'm saying is that the only code that will see this ranges entry will
be the parsing code as if we try to create a resource out of the range
and add it to the host bridge structure (not driver) we will confuse the
rest of the pci_host_bridge API. So we cannot do any ECAM accesses (yet?).


Best regards,
Liviu

> 
> Jason
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

