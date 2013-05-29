Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965209Ab3E2Ifk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:35:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965196Ab3E2Ifi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:35:38 -0400
Date: Wed, 29 May 2013 10:36:52 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
Message-ID: <20130529083652.GA25971@dhcp-26-207.brq.redhat.com>
References: <CAErSpo7onNaU5mquJ_a7kwGPgzs3Q_7U89__HT9DbJFkUX4fsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7onNaU5mquJ_a7kwGPgzs3Q_7U89__HT9DbJFkUX4fsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 03:51:52PM -0600, Bjorn Helgaas wrote:
> On Mon, May 13, 2013 at 3:05 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> 
> The subject would make more sense as "Allocate *only* as many MSIs as
> requested."

1.

> > When multiple MSIs are enabled with pci_enable_msi_block(), the
> > requested number of interrupts 'nvec' is rounded up to the nearest
> > power-of-two value.
> 
> This rounding is just a consequence of the encodings of the Multiple
> Message Enable field in the Message Control register (PCI spec r3.0,
> sec 6.8.1.3), isn't it?

Yes, it is.

> > The result is then used for setting up the
> > number of MSI messages in the PCI device and allocation of
> > interrupt resources in the operating system (i.e. vector numbers).
> > Thus, in cases when a device driver requests some number of MSIs
> > and this number is not a power-of-two value, the extra operating
> > system resources (allocated as the result of rounding) are wasted.
> >
> > This fix introduces 'msi_desc::nvec' field to address the above
> > issue. When non-zero, it will report the actual number of MSIs the
> > device will send, as requested by the device driver. This value
> > should be used by architectures to properly set up and tear down
> > associated interrupt resources.
> 
> This name needs a little more context, like "nvec_used" or something.

I chose "nvec" to indicate it is what was passed to pci_enable_msi_block().
I can resend with "nvec_used", along with subject change [1], if you want.

> I think the idea is that the Message Control register can only tell
> the OS that the device requires 1, 2, 4, 8, 16, or 32 vectors, and
> similarly the OS can only tell the device that 1, 2, 4, 8, 16, or 32
> vectors are assigned.  If a device can only make use of 18 vectors, it
> must advertise the next larger value (32 vectors).  As far as I can
> tell, a device *could* advertise 32 vectors in Multiple Message
> Capable even if it can only use 1 vector.

Yes, that is what we have with i.e. ICH AHCI device - it advertises
16 vectors while makes use of 6 only. I tried to explain this in my
changelog's last paragraph (below).

> These patches are to avoid allocating resources for the unused
> vectors, i.e., the ones between the last one the driver requested and
> the last one advertised in Multiple Message Capable.

Almost :) Rather ...between the last one the driver requested and
the last one *written* in Multiple Message *Enable*, not Capable.
IOW, between the last one the driver requested and the closest power
of two - which will be written to the device.

As of now, neither pci_enable_msi_block(), nor pci_enable_msi_block_auto()
are able to address the case you described, but if we decide to change
that then 'msi_desc::nvec' is what would be used. Again, the last paragraph
(may be too subtly) implies that.

> The driver might
> request fewer than the maximum either because it knows the device
> isn't capable of using them all, or because the driver author decided
> not to use them all.

Exactly. (I assume here "or the driver author decided not to use them all"
means the author can tell the device how many interrupts to use by means
other than Multiple Message Enable - otherwise it would be a bug).

> (Sorry, just thinking out loud above, let me know if I'm not
> understanding this correctly.)
> 
> > Note, although the existing 'msi_desc::multiple' field might seem
> > redundant, in fact in does not. In general case the number of MSIs a
> > PCI device is initialized with is not necessarily the closest power-
> > of-two value of the number of MSIs the device will send. Thus, in
> > theory it would not be always possible to derive the former from the
> > latter and we need to keep them both, to stress this corner case.
> > Besides, since 'msi_desc::multiple' is a bitfield, throwing it out
> > would not save us any space.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
