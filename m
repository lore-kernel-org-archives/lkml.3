Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab3IRJqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:46:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3IRJqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:46:11 -0400
Date: Wed, 18 Sep 2013 11:48:00 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
References: <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org>
 <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917143022.GA7707@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 12:30:23AM +1000, Michael Ellerman wrote:
> How about no?
> 
> We have a small number of MSIs available, limited by hardware &
> firmware, if we don't impose a quota then the first device that probes
> will get most/all of the MSIs and other devices miss out.

Out of curiosity - how pSeries has had done it without quotas before
448e2ca ("powerpc/pseries: Implement a quota system for MSIs")?

> Anyway I don't see what problem you're trying to solve? I agree the
> -ve/0/+ve return value pattern is ugly, but it's hardly the end of the
> world.

Well, the interface recently has been re-classified from "ugly" to
"unnecessarily complex and actively harmful" in Tejun's words ;)

Indeed, I checked most of the drivers and it is incredible how people
are creative in misusing the interface: from innocent pci_disable_msix()
calls when if pci_enable_msix() failed to assuming MSI-Xs were enabled
if pci_enable_msix() returned a positive value (apparently untested).

Roughly third of the drivers just do not care and bail out once
pci_enable_msix() has not succeeded. Not sure how many of these are
mandated by the hardware.

Another quite common pattern is a call to pci_enable_msix() to figure out
the number of MSI-Xs available and a repeated call of pci_enable_msix()
to enable those MSI-Xs, this time.

The last pattern makes most of sense to me and could be updated with a more
clear sequence - a call to (bit modified) pci_msix_table_size() followed
by a call to pci_enable_msix(). I think this pattern can effectively
supersede the currently recommended "loop" practice.

But as pSeries quota is still required I propose to introduce a new interface
pci_get_msix_limit() that combines pci_msix_table_size() and (also new)
arch_get_msix_limit(). The latter would check the quota thing in case of
pSeries and none in case of all other architectures.

The recommended practice would be:

	/*
	 * Retrieving 'nvec' by means other than pci_msix_table_size()
	 */

	rc = pci_get_msix_limit(pdev);
	if (rc < 0)
		return rc;

	/*
	 * nvec = min(rc, nvec);
	 */

	for (i = 0; i < nvec; i++)
		msix_entry[i].entry = i;

	rc = pci_enable_msix(pdev, msix_entry, nvec);
	if (rc)
		return rc;

Thoughts?

> cheers

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
