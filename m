Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3FXR1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:27:25 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:33905 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3FXR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:27:22 -0400
MIME-Version: 1.0
In-Reply-To: <1371764634.30572.47.camel@ul30vt.home>
References: <20130607162732.7733.17758.stgit@bling.home> <20130607163441.7733.23221.stgit@bling.home>
 <20130618170926.GA9203@google.com> <1371580735.22681.216.camel@ul30vt.home>
 <CAErSpo75R26gqO=muqrR28igNkMay4NNRW-VJWPt3xQCqp1YBQ@mail.gmail.com>
 <1371595667.22659.53.camel@ul30vt.home> <CAErSpo7Z9v1QPQZLpfNAUPiq3w4ZfmzS1PStJW+SgJ_DmjjFvg@mail.gmail.com>
 <1371764634.30572.47.camel@ul30vt.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 24 Jun 2013 11:27:02 -0600
Message-ID: <CAErSpo6JU-PUvZRxwgJ3McpFno-d0Apae4fLq+856y89XoCPRA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] pci: Fix flaw in pci_acs_enabled()
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 3:43 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Tue, 2013-06-18 at 20:30 -0600, Bjorn Helgaas wrote:
>> On Tue, Jun 18, 2013 at 4:47 PM, Alex Williamson
>> <alex.williamson@redhat.com> wrote:
>> > On Tue, 2013-06-18 at 16:10 -0600, Bjorn Helgaas wrote:
>> >> On Tue, Jun 18, 2013 at 12:38 PM, Alex Williamson
>> >> <alex.williamson@redhat.com> wrote:
>> >> > On Tue, 2013-06-18 at 11:09 -0600, Bjorn Helgaas wrote:
>> >> >> On Fri, Jun 07, 2013 at 10:34:41AM -0600, Alex Williamson wrote:
>> > ...
>> >> >> >   * pci_acs_enabled - test ACS against required flags for a given device
>> >> >> >   * @pdev: device to test
>> >> >> > @@ -2364,8 +2377,7 @@ void pci_enable_acs(struct pci_dev *dev)
>> >> >> >   */
>> >> >> >  bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
>> >> >>
>> >> >> I know you didn't change the *name* of this function, but I think it
>> >> >> would be easier to follow if you did change the name to something more
>> >> >> descriptive, e.g., something to do with the actual property you're
>> >> >> interested in, which has to do with routing peer-to-peer DMA.
>> >> >>
>> >> >> That property makes sense even for the excluded devices, while the
>> >> >> idea of an ACS capability that doesn't even exist is implicitly
>> >> >> enabled, really doesn't.
>> >> >
>> >> > I think we also don't want to put the complexity at the caller for
>> >> > understanding what capabilities are applicable to a given device.  It's
>> >> > also convenient to use the set of ACS flags.  Given that, the current
>> >> > naming came about.  It's a little awkward, but it's easy to use.
>> >> > Suggestions for a better name?
>> >>
>> >> 100% agreed the caller shouldn't have to worry about different device
>> >> types.  I was thinking something like "pci_enforces_peer_isolation()"
>> >> or "pci_peer_dma_routed_upstream()".  Or maybe it should be
>> >> "pci_dev_...()".
>> >
>> > Ok, I'll play with those.  I'm worried that there are nuances to each
>> > flag bit that don't all fit under such a broad description.
>>
>> It's true that they might be overly broad.  On the other hand, the set
>> of flags we look for is always the same: PCI_ACS_SV | PCI_ACS_RR |
>> PCI_ACS_CR | PCI_ACS_UF, so what's the point in making a completely
>> general-purpose interface?  I'm not sure it's even worth passing the
>> flags around if the code would be clearer without that.
>>
>> > Do you want
>> > to gate this series on a rename of an existing function?

OK, forget about the name.  I'm happy with the existing name as long
as we add a comment about the routing implications.  The spec
references are good, but they don't really help understand what's
going on in the hardware.

>> >> Hmm...  What *is* the correct behavior for a bridge?  You return
>> >> "true," i.e., you're saying that a PCIe-to-PCI bridge will always
>> >> route peer-to-peer transactions from PCI devices upstream to its PCIe
>> >> link.  But that seems wrong: a PCI DMA transaction can target a peer
>> >> on the same PCI bus, and it's not even possible for the bridge to
>> >> validate the transaction or forward it upstream.
>> >>
>> >> I suspect the "ACS is never applicable to a PCI Express to PCI Bridge
>> >> Function" statement in 6.12.1 just means "it's impossible for ACS to
>> >> isolate the devices below the bridge from each other, so it would be
>> >> misleading to implement the capability."
>> >
>> > Note that we never consider ACS to be enabled for a conventional PCI
>> > device.  I suppose we could have cases where it's the only device on a
>> > bus, but for the most part, it's not worth the trouble (it may be the
>> > only device now, then a hotplug occurs).  So really saying the bridge
>> > does or doesn't support ACS doesn't matter to the devices behind it.
>>
>> > What does matter is the fan-out of that isolation group of the
>> > conventional devices beyond the bridge.  If the spec is indicating that
>> > a bridge cannot do peer-to-peer with other devices  then all of the
>> > conventional devices behind it are in an isolation domain so long as the
>> > path between the bridge and the RC supports ACS.  If the bridge can do
>> > peer-to-peer and it is a multifunction device, then the isolation domain
>> > grows to include the other functions and subordinates of the other
>> > functions.  I took the assumption that a bridge probably needs to
>> > forward transaction upstream.  Do you have an alternate opinion?
>>
>> I think you're talking about a multi-function device with several
>> PCIe-to-PCI bridges (e.g., Option A of Figure 1-4, p. 29, of the PCIe
>> bridge spec 1.0), and the question is whether the bridge can forward a
>> transaction between bus X and bus Y without forwarding it upstream.
>
> Right, or the second function may not be a bridge, it could be anything
> that could accept a p2p DMA.
>
>> I don't see any mention of forwarding transactions between functions
>> of a multi-ported bridge, so the conservative assumption would be that
>> a bridge is allowed to do that.  I would expect a conventional
>> multi-port PCI-PCI bridge to forward between functions, because in
>> conventional PCI there would be no reason to forward it upstream, so
>> I'd think PCIe-PCI bridges, at least those designed pre-ACS, would be
>> similar.  And I don't think the ACS capability is expressive enough to
>> say "peer-to-peer transactions between functions must be forwarded
>> upstream, but peer-to-peer transactions below a single function may
>> not be."
>
> The best I can find is the statement that the bridge must forward
> transactions from the secondary interface to the primary interface.  We
> could infer that that means upstream, but we can't rule out some switch
> logic in a multifunction package that could do a re-route from that
> statement.  However then why would the PCIe spec forbid a PCIe-to-PCI
> bridge from implementing ACS?
>
> ACS doesn't need to be expressive enough for what you're describing.  We
> know that there's no protection against p2p on conventional PCI.

My point was that if a PCIe-to-PCI bridge did implement ACS, it would
be hard to interpret it.  Setting the R bit would have to mean
something like "peer-to-peer transactions between devices below
separate bridge functions must be forwarded upstream, but peer-to-peer
transactions between devices below a single bridge function are not."
Those are pretty complicated semantics, and that could be enough of a
reason to disallow it.

>  The
> PCIe bridge spec even indicates that transactions within the bridge
> apertures should not be forwarded to the primary interface (which should
> really be a big red flag that we shouldn't even attempt to support
> assignment of such devices).  The question is whether a transaction
> going out the primary interface is necessarily headed upstream or if it
> can go directly to a peer device.  In that case, I can't figure out why
> ACS is precluded from PCIe-to-PCI bridges.  If anything this is an
> example of why we need a user override, then we could it to the more
> conservative value pending further information and let the user change
> it.  Thanks,

Getting back to the point, I think we should return "false" for
PCIe-to-PCI bridges (and probably event collectors, though it probably
doesn't matter there), not "true."  I just don't see a convincing
argument otherwise.

Bjorn
