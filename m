Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3GBRmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:42:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:56301 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3GBRmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:42:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,982,1363158000"; 
   d="scan'208";a="339431580"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <CAErSpo7GQ8M1rpWnez+=SByR_wmyAnJH7wfqdY20ZcvXW9_90Q@mail.gmail.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-6-git-send-email-mika.westerberg@linux.intel.com>
 <20130702104406.4473EE0090@blue.fi.intel.com>
 <CAErSpo7GQ8M1rpWnez+=SByR_wmyAnJH7wfqdY20ZcvXW9_90Q@mail.gmail.com>
Subject: Re: [PATCH 5/6] PCI: acpiphp: look _RMV method a bit deeper in the
 hierarhcy
Content-Transfer-Encoding: 7bit
Message-Id: <20130702174542.18099E0090@blue.fi.intel.com>
Date: Tue,  2 Jul 2013 20:45:42 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Tue, Jul 2, 2013 at 4:44 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Mika Westerberg wrote:
> >> The acpiphp driver finds out whether the device is hotpluggable by checking
> >> whether it has _RMV method behind it (and if it returns 1). However, at
> >> least Acer Aspire S5 with Thunderbolt host router has this method placed
> >> behind device called EPUP (endpoint upstream port?) and not directly behind
> >> the root port as can be seen from the ASL code below:
> >>
> >> Device (RP05)
> >> {
> >>       ...
> >>       Device (HRUP)
> >>       {
> >>               Name (_ADR, Zero)
> >>               Name (_PRW, Package (0x02)
> >>               {
> >>                       0x09,
> >>                       0x04
> >>               })
> >>               Device (HRDN)
> >>               {
> >>                       Name (_ADR, 0x00040000)
> >>                       Name (_PRW, Package (0x02)
> >>                       {
> >>                               0x09,
> >>                               0x04
> >>                       })
> >>                       Device (EPUP)
> >>                       {
> >>                               Name (_ADR, Zero)
> >>                               Method (_RMV, 0, NotSerialized)
> >>                               {
> >>                                       Return (One)
> >>                               }
> >>                       }
> >>               }
> >>       }
> >>
> >> If we want to support such machines we must look for the _RMV method a bit
> >> deeper in the hierarchy. Fix this by changing pcihp_is_ejectable() to check
> >> few more devices down from the root port.
> >
> > We found that this approach is broken. We've got false positive: host
> > bridge itself was detected as hotplugable slot %) I think it's not
> > acceptable.
> >
> > Mika has tried few more approaches, but we haven't found anything better
> > then hardcoded path like in original workaround patch[1]. It's not generic
> > at all, but safe from false positives.
> >
> > Any thoughts?
> >
> > [1] http://article.gmane.org/gmane.linux.kernel.pci/19102
> 
> The changelog of this patch ([1]) says "Correct ACPI PCI hotplug
> implementation should have _RMV method in a PCI slot (device under pci
> bridge). In Acer Aspire S5 case we have it deeper in hierarchy ..."
> 
> This is exactly what I mean about acpiphp being brittle because of the
> assumptions it makes about the ACPI namespace.  Is there actually
> something in the spec that requires the _RMV method to be where
> pcihp_is_ejectable() expects it?

Spec says that _RMV indicates the device which can be removed.
Rest, I believe, are assumptions: if the device is removable, then parent
must be a hotpluggable slot.

It looks reasonable, but doesn't work in this case. And it's not obvious
how we can generalize the assumption to cover the case.

> I'm not 100% dead-set against merging the workaround with hard-coded
> path, but I still don't think it's a good idea.  It "fixes" it for one
> particular machine, but there will likely be other machines that
> require similar fixes in the future.  It makes it harder for somebody
> to clean up the design later, because that person won't have an Aspire
> S5 to test.  It makes it less likely that somebody *will* clean it up
> later, because "everything is already working."
> 
> That's why my preference (given infinite resources) would be to rework
> acpiphp now, while people are interested and can test it.  I'm sure
> this would be a major redesign of acpiphp and its interaction with
> pciehp, but I think it's something we're going to have to do at some
> point.

Basically, we run out of ideas. Any input is welcome! :)

For now we can post new version of patchset without the workaround and
come back later with workaround (or proper solution if we'll find any).

Does it work for you? Or you prefer everything in one patchset?

-- 
 Kirill A. Shutemov
