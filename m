Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3HXB5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 21:57:37 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42518 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3HXB5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 21:57:35 -0400
Date: Fri, 23 Aug 2013 21:57:08 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Fix osc flag setup ordering to allow pcie hotplug
 use when available
Message-ID: <20130824015707.GA9684@neilslaptop.think-freely.org>
References: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com>
 <3958698.Gm9Wz19SSi@vostro.rjw.lan>
 <CAErSpo5JhCQsYHgFdp+vK9=wLzHert1r5vTe7_ZCPh-4kM80zQ@mail.gmail.com>
 <4634097.MXvnqpQKZr@vostro.rjw.lan>
 <CAErSpo7pZaA4x2f7LUDCOnox1zPCk2qh0nNT=iN4frrWGqn6=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7pZaA4x2f7LUDCOnox1zPCk2qh0nNT=iN4frrWGqn6=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 04:04:59PM -0600, Bjorn Helgaas wrote:
> On Fri, Aug 23, 2013 at 3:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, August 23, 2013 02:46:23 PM Bjorn Helgaas wrote:
> >> On Fri, Aug 23, 2013 at 2:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Friday, August 23, 2013 04:05:11 PM Neil Horman wrote:
> >> >> On Fri, Aug 23, 2013 at 09:38:18PM +0200, Rafael J. Wysocki wrote:
> >> >> > [CCs added]
> >> >> >
> >> >> > Please always send PCI-related material to linux-pci in the first place.
> >> >> >
> >> >> Sorry, I ran get_maintainers and it seemed to think linux-acpi was sufficient.
> >> >>
> >> >> > The change that broke things for you was actually intentional:
> >> >> >
> >> >> > commit b8178f130e25c1bdac1c33e0996f1ff6e20ec08e
> >> >> > Author: Bjorn Helgaas <bhelgaas@google.com>
> >> >> > Date:   Mon Apr 1 15:47:39 2013 -0600
> >> >> >
> >> >> >     Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"
> >> >> >
> >> >> >     This reverts commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6.
> >> >> >
> >> >> > so I think we'll need to clean up the ASMP initialization after all.
> >> >> >
> >> >> Crud.  Reading over the revert commit, it seems like the problem boils down to
> >> >> the odering of checking aspm_disabled.  It seems to me that the simple fix is to
> >> >> track the desire for acpi to disable aspm separately from the users desire to
> >> >> disable aspm (aspm_disabled).  Then we just turn the points where we check the
> >> >> aspm_disabled into the appropriate or of two variables, except for
> >> >> pcie_asmp_sanity_check, which remains sensitive to just the user disable option.
> >> >>
> >> >> Or is there more to this?
> >> >
> >> > No, I think you're right.
> >> >
> >> > Bjorn, what do you think?
> >>
> >> My opinion is that the _OSC/ASPM state management is ridiculously
> >> complicated already, and this would make it slightly more complicated.
> >>  That's why my preference would be to attempt a more radical cleanup
> >> and simplification instead of adding another wart.
> >
> > Well, do you have anything specific in mind?
> 
> If I had a specific fix in mind, I would just post it, but I've never
> had time to work through it all.  What I mean by complicated is that
> every time I have to look at ASPM, I have to start by trying to figure
> out the relationships between these variables:
> 
>     aspm_policy                 # default 0 (POLICY_DEFAULT)
>                                   or POLICY_PERFORMANCE
>                                   or POLICY_POWERSAVE depending on config
>     aspm_disabled               # default 0
>     aspm_force                  # default 0
>     aspm_support_enabled        # default true
> 
> plus the _OSC-related code in acpi_pci_root_add(), which honestly is a
> rat's nest.
> 
I agree, I've only looked at it for an hour, and it looks pretty hairy.

> It sounds like Neil's fix (while probably correct) would tangle that
> nest a little more.  But I guess it would make sense to see the actual
No argument, it would add complexity to something thats already very complex.
That said, I think this needs to be fixed.  Currently there are several systems
that are reporting conflicts between ACPI and PCIE hotplug.  While that means
theres lots of griping, theres several people willing to test, so I think we
have an opportunity to fix this.

> patch and the justification (a regression fix, I suppose, but the
> details weren't clear to me) before deciding.
> 
Agreed.  A larger cleanup would be preferable at this point, but I'm not
sufficiently versed in the code to do that right now, so I'll try write an
appropriate for this particular bug, and see what you think on monday.


Regards
Neil

