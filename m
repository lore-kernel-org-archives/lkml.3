Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaHTMbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:31:34 -0400
Received: from dliviu.plus.com ([80.229.23.120]:60728 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbaHTMbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:31:32 -0400
Date: Wed, 20 Aug 2014 13:31:12 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers: pci: convert generic host controller to DT host
 bridge creation API
Message-ID: <20140820123112.GG13147@bart.dudau.co.uk>
References: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
 <201408201327.57376.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201408201327.57376.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Aug 20 13:31:30 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,53f495223123282415815
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 01:27:57PM +0200, Arnd Bergmann wrote:
> On Tuesday 12 August 2014, Liviu Dudau wrote:
> > +       return of_create_pci_host_bridge(dev, 0, 0xff, &gen_pci_ops,
> > +                                       gen_pci_setup, pci);
> 
> I had not noticed it earlier, but the setup callback is actually a feature
> of the arm32 PCI code that I had hoped to avoid when moving to the
> generic API. Can we do this as a more regular sequence of
> 
> 
> 	ret = of_create_pci_host_bridge(dev, 0, 0xff, &gen_pci_ops, pci);
> 	if (ret)
> 		return ret;
> 
> 	ret = gen_pci_setup(pci);
> 	if (ret)
> 		pci_destroy_host_bridge(dev, pci);
> 	return ret;
> 
> ?
> 
> 	Arnd

Hi Arnd,

That has been the general approach of my patchset up to v9. But, as Bjorn has
mentioned in his v8 review and I have put in my cover letter, the regular
aproach means that architectures that use pci_scan_root_bus() will have to
drop their one liner and replace it with the more verbose of_create_pci_host_bridge()
followed by pci_scan_child_bus() and pci_bus_add_devices() (basically, the content
of pci_scan_root_bus()). For those architectures it will lead to a net increase of
lines of code.

The patch for pci-host-generic.c is the first to use the callback setup function, but
not the only one. My PCI host bridge driver for Juno has the same need, and I'm betting
all other host bridge controllers will use it as it will be the only opportunity to
finish the controller setup before we start scanning the child busses. I'm trying to
balance ease of read vs ease of use here and it is the best version I've come up with
so far.

Best regards,
Liviu

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

