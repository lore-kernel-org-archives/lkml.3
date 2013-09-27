Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3I0QBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:01:20 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57846 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3I0QBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:01:17 -0400
MIME-Version: 1.0
In-Reply-To: <1380270519.27811.10.camel@pasglop>
References: <1380270519.27811.10.camel@pasglop>
Date: Fri, 27 Sep 2013 09:01:16 -0700
X-Google-Sender-Auth: dpcZtDE6a8QgOHN87LdQIsWpuDY
Message-ID: <CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 1:28 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> Hi Linus, Yinghai !
>
> Please consider reverting:
>
> 928bea964827d7824b548c1f8e06eccbbc4d0d7d
> PCI: Delay enabling bridges until they're needed
>
> (I'd suggest to revert now and maybe merge a better patch later)
>
> This breaks PCI on the PowerPC "powernv" platform (which is booted via
> kexec) and probably x86 as well under similar circumstances. It will
> basically break PCIe if the bus master bit of the bridge isn't set at
> boot (by the firmware for example, or because kexec'ing cleared it).
>
> The reason is that the PCIe port driver will call pci_enable_device() on
> the bridge (on everything under the sun actually), which will marked the
> device enabled (but will not do a set_master).
>
> Because of that, pci_enable_bridge() later on (called as a result of the
> child device driver doing pci_enable_device) will see the bridge as
> already enabled and will not call pci_set_master() on it.
>
> Now, this could probably be fixed by simply doing pci_set_master() in
> the PCIe port driver, but I find the whole logic very fragile (anything
> that "enables" the bridge without setting master or for some reason
> clears master will forever fail to re-enable it).
>
> Maybe a better option is to unconditionally do pci_set_mater() in
> pci_enable_bridge(), ie, move the call to before the enabled test.
>
> However I am not too happy with that either. My experience with bridges
> is that if bus master isn't set, they will also fail to report AER
> errors and other similar upstream transactions. We might want to get
> these reported properly even if no downstream device got successfully
> enabled.
>
> So I think the premises of the patches are flawed, at least on PCI
> express, and we should stick to always enabling bridges (at least the
> bus master bit on them).

there is pci_set_master everywhere in pci drivers.

So i would like to use the first way that you suggest : call pci_set_master
PCIe port driver.

Thanks

Yinghai
