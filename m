Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3ETRwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:52:41 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37848 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3ETRwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:52:40 -0400
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <CAErSpo7TvCfQLkMD+zL1W6dNEqMpHYbLtAAHqXf==zbxhE2tcQ@mail.gmail.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <CAErSpo7+AbHi_TwxwHTJunpFb=CMhwMdCni6+NjbhdA=35XhvA@mail.gmail.com>
 <5683193.Vsmy0DmceS@vostro.rjw.lan> <CAErSpo7TvCfQLkMD+zL1W6dNEqMpHYbLtAAHqXf==zbxhE2tcQ@mail.gmail.com>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Mon, 20 May 2013 12:52:19 -0500
Message-ID: <CAHrUA34CoQziRYgLyYJc5TtGw_nGL+QFLzrktDjcZ6gxsxEZ8A@mail.gmail.com>
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Zhang, LongX" <longx.zhang@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "Joseph.Liu@Emulex.Com" <Joseph.Liu@emulex.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2013 12:21, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, May 17, 2013 at 5:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Friday, May 17, 2013 05:43:33 PM Bjorn Helgaas wrote:
>>> On Fri, Apr 26, 2013 at 12:28 AM, Zhang, LongX <longx.zhang@intel.com> wrote:
>
>>> > +       /* restore cfg space for possible link reset at upstream */
>>> > +       dev->state_saved = true;
>>>
>>> "dev->state_saved == true" means that the dev->saved_config_space
>>> contains valid data.  Why do we know that's the case here?  I see that
>>> pcie_portdrv_probe() calls pci_save_state() when we first claim the
>>> port, and I guess we're assuming the state saved then is still valid.

Yes, see below.

>>> But why do we need to actually set dev->state_saved here?  Shouldn't
>>> it be already set to true anyway?
>>
>> This is a dirty trick to make pci_restore_state(dev) always work here
>> (because it checks dev->state_saved and does nothing if it isn't set).
>> I suppose.
>
> Yes, I did investigate enough to see that this is a dirty trick.  My
> question is how we know it's safe to do this dirty trick.
>
>>> > +       pci_restore_state(dev);
>>> > +       pcie_portdrv_restore_config(dev);

Lets review what is supposed to happen:

-- poweron
-- BIOS/firmware/bootloader maybe fiddles with PCI config space
-- kernel fiddles with PCI config space during boot
-- device driver sets up PCI config space correctly for normal i/o
-- PCI error occurs
-- PCI port/link is reset

At this point, we want to set the PCI config space to something
resembling what it was just before the device driver first touched it
after poweron.  Why?  Because the device driver will typically set up
DMA segments, and tweak other settings as it initializes the card.  It
needs to do almost exactly the same things again, when re-initializing
the device after the error reset.  Thus, the PCI config needs to be
appropriate for a fresh initialization of the card.

If  some other variant of PCI config was loaded here, it might contain
incorrect DMA mappings or other settings.  In particular, while the
driver is initializing the card, you risk having the card run away and
start doing things based on these incorrect settings -- provoking
another error or maybe just silently corrupting data.   The config
that you want to load should be more-or-less the same one that was
there during kernel boot, before the device-driver started touching
things.

The "dirty hack" is weird:  either there's valid data, and the flag is
set, or the data is garbage and the flag isn't set ... how could it be
otherwise?

-- Linas
