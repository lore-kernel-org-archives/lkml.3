Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3FNOLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:11:10 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34613 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3FNOLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:11:05 -0400
Date: Fri, 14 Jun 2013 08:11:01 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
Message-ID: <20130614141101.GA29452@google.com>
References: <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
 <CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
 <CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
 <CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
 <20130401235256.GA31966@google.com>
 <CAE9FiQV8cPh-s6=EQu_cZTtn86+NwZE5KuGMhf43aOhzkL=hwA@mail.gmail.com>
 <CAErSpo7Jni1ZSf_W=vB3kqsucPpoepa2Q5g=77a6D3FaPwe9LA@mail.gmail.com>
 <CAE9FiQWjQXwiTWju6cBc_o25jy_wmZ1u+Pifh1wdnxtV=i5ENw@mail.gmail.com>
 <CAErSpo7=a-wX6BLbm_O1nUMMrQHOgtSm3xZHKuRqaz8rnKSbRA@mail.gmail.com>
 <CAE9FiQUbw7OUhRB+gKMxkuE9+nm9097+mwZ2z4adO8Hv_NjF1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUbw7OUhRB+gKMxkuE9+nm9097+mwZ2z4adO8Hv_NjF1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 12:41:42PM -0700, Yinghai Lu wrote:
> On Wed, Jun 12, 2013 at 10:05 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> current code from acpi_pci_root_add we have
> >>   1. pci_acpi_scan_root
> >>          ==> pci devices enumeration and bus scanning.
> >>              ==> pci_alloc_child_bus
> >>                  ==> pcibios_add_bus
> >>                      ==> acpi_pci_add_bus
> >>                          ==> acpiphp_enumerate_slots
> >>                              ==> ...==> register_slot
> >>                                   ==> device_is_managed_by_native_pciehp
> >>                                         ==> check osc_set with
> >> OSC_PCI_EXPRESS_NATIVE_HP_CONTROL
> >>    2. _OSC set request
> >>
> >> so we always have acpiphp hotplug slot registered at first.
> >>
> >> so either we need to
> >> A. revert reverting about _OSC
> >> B. move pcibios_add_bus down to pci_bus_add_devices()
> >>     as acpiphp and apci pci slot driver are some kind of drivers for pci_bus
> >> C. A+B
> >
> > It doesn't surprise me at all that there are problems in the _OSC code
> > and the acpiphp/pciehp interaction.  That whole area is a complete
> > disaster.  It'd really be nice if somebody stepped up and reworked it
> > so it makes sense.
> >
> > But this report is useless to me.  I don't have time to work out what
> > the problem is and how it affects users and come up with a fix.
> 
> effects: without fix the problem, user can not use pcie native hotplug
> if their system's firmware support acpihp and pciehp.
> And make it worse, that acpiphp have to be built-in, so they have no
> way to blacklist acpiphp in config.
> 
> >
> > My advice is to simplify the path first, and worry about fixing the
> > bug afterwards.  We've already done several iterations of fiddling
> > with things, and I think all we're doing is playing "whack-a-mole" and
> > pushing the bugs around from one place to another.
> 
> We need to address regression at first.
> my suggestion is : revert the reverting and apply my -v3 version that will fix
> regression that Roman Yepishev met.
> 
> please check attached two patches, hope it could save your some time.

Here are some of my notes from trying to sort this out, in chronological
order:

    29594404 v3.7
      Bus scanned before requesting _OSC control
      pre-1.1 ath5k has ASPM disabled (works fine)

    8c33f51d "request _OSC control before scanning bus"

    19f949f5 v3.8
      _OSC control requested before scanning bus
      Now pre-1.1 ath5k has ASPM enabled and doesn't work
      https://bugzilla.kernel.org/show_bug.cgi?id=55211 opened

    b8178f13 "revert 'request _OSC control before scanning bus' (8c33f51d)"
      Bus now scanned before requesting _OSC control (as in v3.7)

    c1be5a5b v3.9
      pciehp claims slots first, even when both pciehp & acpiphp are
      built-in, because pciehp module_init precedes acpiphp module_init
      in link order

    6037a803 "Convert acpiphp to be builtin only"
      This also adds "acpiphp.disable" boot option

    3b63aaa7 "Do not use ACPI PCI subdriver mechanism"
      Now acpiphp claims slots first because we call
      acpiphp_enumerate_slots() from pcibios_add_bus() during PCI device
      enumeration.  This happens before pciehp, which still uses
      module_init.

    f722406f v3.10-rc1

    ........ "Revert reverting of 'request _OSC control before scanning bus' (b8178f13)"
      _OSC control requested before scanning bus (as in v3.8)
      pre-1.1 ath5k probably has ASPM enabled and doesn't work

    ........ "Remove not needed check in disable aspm link"
      Now pci_disable_link_state() unconditionally disables ASPM,
      even when BIOS hasn't given us ASPM control


1) The problem you're trying to fix is that when both acpiphp and
pciehp are supported for the same slot, acpiphp claims the slot first
and pciehp will not claim it.  I think this problem was introduced by
3b63aaa7, which was merged after v3.9.  Therefore, v3.9 should work
correctly, and this regression appeared in v3.10-rc1.

2) As you say, acpiphp cannot be a module, so the user would have to
rebuild the kernel to remove it.  However, 6037a803 *did* add a
"acpiphp.disable" boot option, so that should be a workaround that
allows pciehp to claim the slot.

3) I think your "revert reverting" patch gets us back to the same
situation we had after 8c33f51d, i.e., Roman's pre-1.1 ath5k device
will have ASPM enabled and won't work.  I don't want to leave the tree
in this broken state, even though you intend to fix it in the next
patch.  If you can reorder your patches so the ASPM fix is first, that
would be better.

4) Your "Remove not needed check in disable aspm link" patch makes
pci_disable_link_state() disable ASPM even when the OS doesn't have
permission to control ASPM.  I think this is a mistake.  I proposed a
similar change in [1], but Rafael and Matthew thought it was too
risky, and I agree.

Bjorn

[1] https://lkml.kernel.org/r/20130510225257.GA10847@google.com
