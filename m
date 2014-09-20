Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbaITSmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:42:54 -0400
Received: from services.gouders.net ([141.101.32.176]:36626 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbaITSmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:42:53 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <20140919183943.GD19374@google.com> (Bjorn Helgaas's message of
	"Fri, 19 Sep 2014 12:39:43 -0600")
References: <CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
	<gh4mwcef0r.fsf@quad.gouders.net>
	<CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
	<ghoaukcx6b.fsf@quad.gouders.net>
	<CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
	<ghk358crbe.fsf@quad.gouders.net>
	<CAE9FiQUeP84585-4b+Y6WBVD3zqOi7ch_OXytsTmKEz9AyZ3Vg@mail.gmail.com>
	<20140913040716.GA28080@google.com> <gh8ulnn9yo.fsf@quad.gouders.net>
	<gh8uln71g1.fsf@lena.gouders.net> <20140919183943.GD19374@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sat, 20 Sep 2014 20:41:46 +0200
Message-ID: <ghvboit9qt.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

> On Sat, Sep 13, 2014 at 09:41:34PM +0200, Dirk Gouders wrote:
>> So, I did some tests on the VX50 which probably wasn't the worst idea,
>> because it behaves different than the test machine.
>> 
>> Summary:
>> 
>> 1) Bjorn's back pocket patch works on the VX50.
>> 
>>    On the test machine it causes a trace, mount_root has to do with
>>    it.  I tried to use netconsole but it complained the interface were
>>    not ready.
>
> OK, that's good.  I put this revert patch in for-linus for v3.17.  I regard
> this as a temporary fix, not the real solution.  My guess is the test
> machine doesn't boot because you're missing a driver, so not related to the
> revert patch.

I assumed my limit-host-bridge-aperture-and-ignore-bridges-patch on top
of your patch caused this, so I took a closer look.

Your patch works fine with current rc5+ on the test machine -- with and
without my additional patch.

rc2 and "make oldconfig" somehow caused that the root partition couldn't
be mounted.  With rc5+ everything is fine, again, without touching the
configuration myself.

Other various today's test results (VX50) will be appended to bugzilla
in a few moments.

Dirk

>> 3) Reset with Bjorn's commands
>> 
>>    DEV=00:0e.0
>>    setpci -s$DEV BRIDGE_CONTROL.W=0x0040
>>    sleep 1
>>    setpci -s$DEV BRIDGE_CONTROL.W=0x0000
>>    sleep 1
>>    echo 1 > /sys/bus/pci/rescan
>> 
>>    let the FC adapter appear but there are errors that I cannot really
>>    interpret.
>> 
>> 4) Reset with Yinghai's patches and 
>> 
>>    echo 1 > /sys/bus/pci/devices/0000\:00\:0e.0/pcie_link_disable
>>    echo 0 > /sys/bus/pci/devices/0000\:00\:0e.0/pcie_link_disable
>>    echo 1 > /sys/bus/pci/rescan
>> 
>>    gives a similar resut to 3).
>
> Resetting the device or simply disabling and re-enabling the link was
> enough to fix things from the device's perspective.  In both cases, it
> responded as one would expect:
>
>   pci_scan_child_bus: pci_bus 0000:06: scanning bus
>   pci 0000:06:00.0: [1000:0646] type 00 class 0x0c0400
>   pci 0000:06:00.0: reg 0x10: [io  0x0000-0x00ff] 
>   pci 0000:06:00.0: reg 0x14: [mem 0x00000000-0x00003fff 64bit]
>   pci 0000:06:00.0: reg 0x1c: [mem 0x00000000-0x0000ffff 64bit]
>   pci 0000:06:00.0: reg 0x30: [mem 0x00000000-0x000fffff pref]
>
> Linux tried to assign MMIO space to the device, but failed:
>
>   pci 0000:06:00.0: BAR 6: assigned [mem 0xd4200000-0xd42fffff pref]
>   pci 0000:06:00.0: BAR 3: no space for [mem size 0x00010000 64bit]
>   pci 0000:06:00.0: BAR 3: failed to assign [mem size 0x00010000 64bit]
>   pci 0000:06:00.0: BAR 1: no space for [mem size 0x00004000 64bit]
>   pci 0000:06:00.0: BAR 1: failed to assign [mem size 0x00004000 64bit]
>
> The upstream bridge windows are:
>
>   pci 0000:00:0e.0: PCI bridge to [bus 06]	# was originally to bus 0a
>   pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff] 
>   pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
>
> So the ROM BAR (reg 0x30/BAR 6) takes up the whole window, leaving nothing
> for BARs 1 and 3.  This is something that Linux could do better.  For
> example, we could assign normal BARs first, followed by ROM BARs, since the
> normal ones are more important.  It's possible we could also try to expand
> the bridge window so all the BARs would fit.
>
> In any case, resetting the device is not a simple fix all by itself.  So
> our possibilities are:
>
>   1) Quirk to work around _CRS bug.  This works but requires us to maintain
>      CPU-specific code that I really don't want.
>
>   2) Reset device when changing bus number.  This works from the device
>      point of view, but would require additional Linux changes.
>
>   3) Revert 1820ffdccb9b.  This works but is ugly because we're ignoring
>      some of what _CRS tells us.
>
> Bjorn
