Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3FEVKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:10:00 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54339 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab3FEVJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:09:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130605205638.GA5816@breakpoint.cc>
References: <cover.1368431413.git.agordeev@redhat.com> <8575dc590b819892f366852fe50835efaf579f4f.1368431413.git.agordeev@redhat.com>
 <20130605205638.GA5816@breakpoint.cc>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Jun 2013 15:09:34 -0600
Message-ID: <CAErSpo5hJYhWpBfN6GpyPv-ViaYNXyyLtw96xcN59CtQjfZi6w@mail.gmail.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 2:56 PM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> On Mon, May 13, 2013 at 11:05:48AM +0200, Alexander Gordeev wrote:
>> Note, although the existing 'msi_desc::multiple' field might seem
>> redundant, in fact in does not. In general case the number of MSIs a
>> PCI device is initialized with is not necessarily the closest power-
>> of-two value of the number of MSIs the device will send. Thus, in
>> theory it would not be always possible to derive the former from the
>> latter and we need to keep them both, to stress this corner case.
>> Besides, since 'msi_desc::multiple' is a bitfield, throwing it out
>> would not save us any space.
>
> The last paragraph makes me curious. The only place where 'multiple' is set is
> in do_setup_msi_irqs() and this uses the next power of two for it. And since a
> device is not enabled twice, it is not overridden.
> So it should be possible to compute 'multiple' out of 'nvec' but it saves
> cycles not do to so. I agree to keep 'multiple' but your argument does not
> seem to make sense.

Alexander had an example device that advertised 16 vectors, but the
driver knew that it could only generate 6.  That's a case where we
can't compute 'multiple' from 'nvec' (assuming the driver supplies
'nvec == 6').  If we just rounded up to compute 'multiple', I think
we'd compute 8 instead of 16.

> While nitpicking, 'nvec' might deserve a better comment than 'number of
> messages' since it holds the number of allocated interrupts. :)

I did change the name 'nvec' to 'nvec_used', which should help a bit.
But I agree that it's still somewhat confusing.

BTW, the patches actually in my tree are at
http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/alexander-msi
(I tweaked this name and some comments slightly).

Bjorn
