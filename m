Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3FNQd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:33:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64390 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3FNQdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVr-OWeqEHFXn0MjNiSD0WM=FNO_DFo6m9UbbG60uonpw@mail.gmail.com>
References: <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
 <CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
 <CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
 <CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
 <20130401235256.GA31966@google.com> <CAE9FiQV8cPh-s6=EQu_cZTtn86+NwZE5KuGMhf43aOhzkL=hwA@mail.gmail.com>
 <CAErSpo7Jni1ZSf_W=vB3kqsucPpoepa2Q5g=77a6D3FaPwe9LA@mail.gmail.com>
 <CAE9FiQWjQXwiTWju6cBc_o25jy_wmZ1u+Pifh1wdnxtV=i5ENw@mail.gmail.com>
 <CAErSpo7=a-wX6BLbm_O1nUMMrQHOgtSm3xZHKuRqaz8rnKSbRA@mail.gmail.com>
 <CAE9FiQUbw7OUhRB+gKMxkuE9+nm9097+mwZ2z4adO8Hv_NjF1Q@mail.gmail.com>
 <20130614141101.GA29452@google.com> <CAE9FiQVr-OWeqEHFXn0MjNiSD0WM=FNO_DFo6m9UbbG60uonpw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 14 Jun 2013 10:33:34 -0600
Message-ID: <CAErSpo7grN-93zZfBJOHZH-pR1wDYrojTwt=B=++QqA0rPb3Rg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:17 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jun 14, 2013 at 7:11 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Here are some of my notes from trying to sort this out, in chronological
>> order:
>>
>>     29594404 v3.7
>>       Bus scanned before requesting _OSC control
>>       pre-1.1 ath5k has ASPM disabled (works fine)
>>
>>     8c33f51d "request _OSC control before scanning bus"
>>
>>     19f949f5 v3.8
>>       _OSC control requested before scanning bus
>>       Now pre-1.1 ath5k has ASPM enabled and doesn't work
>>       https://bugzilla.kernel.org/show_bug.cgi?id=55211 opened
>>
>>     b8178f13 "revert 'request _OSC control before scanning bus' (8c33f51d)"
>>       Bus now scanned before requesting _OSC control (as in v3.7)
>>
>>     c1be5a5b v3.9
>>       pciehp claims slots first, even when both pciehp & acpiphp are
>>       built-in, because pciehp module_init precedes acpiphp module_init
>>       in link order
>>
>>     6037a803 "Convert acpiphp to be builtin only"
>>       This also adds "acpiphp.disable" boot option
>>
>>     3b63aaa7 "Do not use ACPI PCI subdriver mechanism"
>>       Now acpiphp claims slots first because we call
>>       acpiphp_enumerate_slots() from pcibios_add_bus() during PCI device
>>       enumeration.  This happens before pciehp, which still uses
>>       module_init.
>>
>>     f722406f v3.10-rc1
>>
>>     ........ "Revert reverting of 'request _OSC control before scanning bus' (b8178f13)"
>>       _OSC control requested before scanning bus (as in v3.8)
>>       pre-1.1 ath5k probably has ASPM enabled and doesn't work
>>
>>     ........ "Remove not needed check in disable aspm link"
>>       Now pci_disable_link_state() unconditionally disables ASPM,
>>       even when BIOS hasn't given us ASPM control
>>
>>
>> 1) The problem you're trying to fix is that when both acpiphp and
>> pciehp are supported for the same slot, acpiphp claims the slot first
>> and pciehp will not claim it.  I think this problem was introduced by
>> 3b63aaa7, which was merged after v3.9.  Therefore, v3.9 should work
>> correctly, and this regression appeared in v3.10-rc1.
>>
>> 2) As you say, acpiphp cannot be a module, so the user would have to
>> rebuild the kernel to remove it.  However, 6037a803 *did* add a
>> "acpiphp.disable" boot option, so that should be a workaround that
>> allows pciehp to claim the slot.
>
> How about the same system that some slots need to be handled by acpiphp
> and some others need to be handled by pciehp ?
>
> for example: laptop that have dock that will need acpiphp, and also have
> pci express card that need pciehp.
>
>>
>> 3) I think your "revert reverting" patch gets us back to the same
>> situation we had after 8c33f51d, i.e., Roman's pre-1.1 ath5k device
>> will have ASPM enabled and won't work.  I don't want to leave the tree
>> in this broken state, even though you intend to fix it in the next
>> patch.  If you can reorder your patches so the ASPM fix is first, that
>> would be better.
>
> yes.
>
> We could apply your patch in [1] at first, and revert the reverting.
> and do not touch pcie_clear_aspm now.
>
>>
>> 4) Your "Remove not needed check in disable aspm link" patch makes
>> pci_disable_link_state() disable ASPM even when the OS doesn't have
>> permission to control ASPM.  I think this is a mistake.  I proposed a
>> similar change in [1], but Rafael and Matthew thought it was too
>> risky, and I agree.
>
> before all those changes, and in current state:
> quirk disable aspm is before _osc support and control are set.

Can you please refer to specific function names?  I can't read your mind.

You might be referring to quirk_disable_aspm_l0s().  This is a
pci_fixup_final quirk that calls pci_disable_link_state().  In the
current tree, we enumerate devices before requesting _OSC control.
However, pci_fixup_final quirks are not run until the
pci_apply_final_quirks() fs_initcall, which is after we request _OSC
control.

As far as I can tell, we never call pci_disable_link_state() before
calling pcie_no_aspm().

> aka in pci_acpi_scan_root will allocate all link state struct, and quirk
> call pci_disable_link_state, and later will _osc support or control can
> not be set, pcie_no_aspm is called, can will block all aspm operation.
>
> That is risky too?, why booting path quirk could do that, but driver
> and hot-add quirk path can not do that ?
>
> or we can have another pci_disable_link_state always work on quirk path only?
>
> Yinghai
