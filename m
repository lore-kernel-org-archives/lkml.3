Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaJPTp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:45:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaJPTpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:45:25 -0400
Message-ID: <1413488723.2539.72.camel@zim.stowe>
Subject: Re: [PATCH] pci, add sysfs numa_node write function
From: Myron Stowe <mstowe@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myron Stowe <mstowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Thu, 16 Oct 2014 13:45:23 -0600
In-Reply-To: <543FBAEF.7030905@redhat.com>
References: <1413399924-599-1-git-send-email-prarit@redhat.com>
	 <CAErSpo6Oy1S1OECirp6=tz+pQWUtkFE6p1LTzNaYtzxoX73FWw@mail.gmail.com>
	 <543ECF6F.2030705@redhat.com>
	 <CAErSpo76g-EPsUsMjhBpnnbKD3QufHz1xkvYaqXd8hYtgQ5u1g@mail.gmail.com>
	 <543FBAEF.7030905@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 08:32 -0400, Prarit Bhargava wrote:
> 
> On 10/15/2014 05:20 PM, Bjorn Helgaas wrote:
> > On Wed, Oct 15, 2014 at 1:47 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> >> On 10/15/2014 03:23 PM, Bjorn Helgaas wrote:
> >>> Hi Prarit,
> >>>
> >>> On Wed, Oct 15, 2014 at 1:05 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> >>>> Consider a multi-node, multiple pci root bridge system which can be
> >>>> configured into one large node or one node/socket.  When configuring the
> >>>> system the numa_node value for each PCI root bridge is always set
> >>>> incorrectly to -1, or NUMA_NO_NODE, rather than to the node value of each
> >>>> socket.  Each PCI device inherits the numa value directly from it's parent
> >>>> device, so that the NUMA_NO_NODE value is passed through the entire PCI
> >>>> tree.
> >>>>
> >>>> Some new drivers, such as the Intel QAT driver, drivers/crypto/qat,
> >>>> require that a specific node be assigned to the device in order to
> >>>> achieve maximum performance for the device, and will fail to load if the
> >>>> device has NUMA_NO_NODE.
> >>>
> >>> It seems ... unfriendly for a driver to fail to load just because it
> >>> can't guarantee maximum performance.  Out of curiosity, where does
> >>> this actually happen?  I had a quick look for NUMA_NO_NODE and
> >>> module_init() functions in drivers/crypto/qat, and I didn't see the
> >>> spot.
> >>
> >> The whole point of the Intel QAT driver is to guarantee max performance.  If
> >> that is not possible the driver should not load (according to the thread
> >> mentioned below)
> >>
> >>>
> >>>> The driver would load if the numa_node value
> >>>> was equal to or greater than -1 and quickly hacking the driver results in
> >>>> a functional QAT driver.
> >>>>
> >>>> Using lspci and numactl it is easy to determine what the numa value should
> >>>> be.  The problem is that there is no way to set it.  This patch adds a
> >>>> store function for the PCI device's numa_node value.
> >>>
> >>> I'm not familiar with numactl.  It sounds like it can show you the
> >>> NUMA topology?  Where does that information come from?
> >>
> >> You can map at least what nodes are available (although I suppose you can get
> >> the same information from dmesg).  You have to do a bit of hunting through the
> >> PCI tree to determine the root PCI devices, but you can determine which root
> >> device is connected to which node.
> > 
> > Is numactl reading SRAT?  SLIT?  SMBIOS tables?  Presumably the kernel
> > has access to whatever information you're getting from numactl and
> > lspci, and if so, maybe we can do the workaround automatically in the
> > kernel.
> 
> I'll go figure that out ...
> 
> > 
> >>>> To use this, one can do
> >>>>
> >>>> echo 3 > /sys/devices/pci0000:ff/0000:ff:1f.3/numa_node
> >>>>
> >>>> to set the numa node for PCI device 0000:ff:1f.3.
> >>>
> >>> It definitely seems wrong that we don't set the node number correctly.
> >>> pci_acpi_scan_root() sets the node number by looking for a _PXM method
> >>> that applies to the host bridge.  Why does that not work in this case?
> >>>  Does the BIOS not supply _PXM?
> >>
> >> Yeah ... unfortunately the BIOS is broken in this case.  And I know what you're
> >> thinking ;) -- why not get the BIOS fixed?  I'm through relying on BIOS fixes
> >> which can take six months to a year to appear in a production version... I've
> >> been bitten too many times by promises of BIOS fixes that never materialize.
> > 
> > Yep, I understand.  The question is how we implement a workaround so
> > it doesn't become the accepted way to do things.  Obviously we don't
> > want people manually grubbing through numactl/lspci output or writing
> > shell scripts to do things that *should* happen automatically.
> > 
> >> We have systems that only have a support cycle of 3 years, and things like ACPI
> >> _PXM updates are at the bottom of the list :/.
> > 
> 
> > 
> > Somewhere in the picture there needs to be a feedback loop that
> > encourages the vendor to fix the problem.  I don't see that happening
> > yet.  Having QAT fail because the platform didn't supply the
> > information required to make it work would be a nice loop.  I don't
> > want to completely paper over the problem without providing some other
> > kind of feedback at the same time.
> 
> Okay -- I see what you're after here and I completely agree with it.  But
> sometimes I feel like I banging on a silent drum with some of these companies
> about this stuff :(  My frustration with these companies is starting to show I
> guess...
> 
> > 
> > You're probably aware of [1], which was the same problem.  Apparently
> > it was originally reported to RedHat as [2] (which is private, so I
> > can't read it).  That led to a workaround hack for some AMD systems
> > [3, 4].
> 
> Yeah ... part of me was thinking that maybe I should do something like
> the above but I didn't know how you'd feel about expanding that hack.  I'll look
> into it.  I'd prefer it to be opt-in with a kernel parameter.

I believe the point was to not consider expanding upon the AMD chip-set
specific driver, or some similar tactic, and to investigate how
'numactl' obtains such information in order to see if that is a possible
solution that could be used going forward.  It's good to see that the
latest discussions with Alexander seem to suggest that is the direction
being taken now.


Pursuing something like the AMD scenario, where a chip-set specific
driver reads internal registers, is an untenable dead end.  It leads to
a perpetual cycle in which the driver has to constantly be updated as
new platform chip-sets are introduced.  To solve such situations,
architecture independent mechanisms are thought up, formalized, and put
in place - in this case ACPI's _PXM methods and/or SRAT, SLIT tables.

Chip-set specific drivers like 'amd_bus.c' perpetuate circumventing
architected solutions, more often than not introducing subsequent issues
themselves.

The previous NUMA info issue that Bjorn referenced is a prime example of
both: it "snoops" out proximity info from the chip-set when the BIOS has
not supplied ACPI _PXM method(s) (i.e. the circumvention) and in doing
such, had at least three sub-issues; all of which can be understood by
carefully reading the chain of events from the PCI list's thread [1].

As a result, the 'amd_bus.c' patch was pared down from a substantial
re-factoring and update effort to its bare minimum - at one point there
was even discussion about removing the driver completely as was done
with 'intel_bus.c' (note that the NUMA related proximity "snooping"
capability only exists for AMD based platforms, there is no equivalent
for Intel based platforms).

In that particular instance the end result was that the customer impact
was significant enough financially that it forced the vendor to updated
there BIOS to include the necessary _PXM methods.


Introducing kernel parameters is a similar scenario.  Customers should
not need to know about, nor utilize, kernel parameters in their normal
day-to-day activities.  Yes, such capabilities are invaluable for those
of us that work with the kernel but customers just should not be
expected to have to resort to such.


[1] https://lkml.org/lkml/2014/3/5/898


Myron

> 
> P.


