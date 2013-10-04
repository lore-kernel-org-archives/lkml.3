Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3JDWMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:12:46 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48594 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3JDWMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:12:44 -0400
MIME-Version: 1.0
In-Reply-To: <20131004011806.GE20450@dangermouse.emea.sgi.com>
References: <20131004011806.GE20450@dangermouse.emea.sgi.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 Oct 2013 16:11:12 -0600
Message-ID: <CAErSpo6aE-vxhOHk_mgyWMYrgkG0Juuy8Bs-S2Hjb_7k8S=n8Q@mail.gmail.com>
Subject: Re: Commit 07f9b61 breaks systems that don't implement a _CBA method
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ethan Zhao <ethan.zhao@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 7:18 PM, Hedi Berriche <hedi@sgi.com> wrote:
> Chaps,
>
> The following failure was encountered on hardware that does *not*
> implement a _CBA method which is AFAICT (and confirmed to me by BIOS
> chaps) optional.

_CBA is definitely optional.

> [    1.230647] PCI: MMCONFIG for domain 0000 [bus 00-0c] at [mem 0x80000000-0x80cfffff] (base 0x80000000)
> [    1.241046] PCI: MMCONFIG for domain 0001 [bus 00-02] at [mem 0xff84000000-0xff842fffff] (base 0xff84000000)
> [    1.252025] PCI: MMCONFIG for domain 1000 [bus 3f-3f] at [mem 0xff83f00000-0xff83ffffff] (base 0xff80000000)
> [    1.263006] PCI: MMCONFIG for domain 1001 [bus 3f-3f] at [mem 0xff87f00000-0xff87ffffff] (base 0xff84000000)
> [    1.273984] PCI: MMCONFIG at [mem 0x80000000-0x80cfffff] reserved in E820
> [    1.281564] PCI: MMCONFIG at [mem 0xff84000000-0xff842fffff] reserved in E820
> [    1.289535] PCI: MMCONFIG at [mem 0xff83f00000-0xff83ffffff] reserved in E820
> [    1.297505] PCI: MMCONFIG at [mem 0xff87f00000-0xff87ffffff] reserved in E820
>
> <snip>
>
> [    1.427926] ACPI: PCI Root Bridge [I001] (domain 0001 [bus 00-3d])
> [    1.434968] acpi PNP0A08:00: fail to add MMCONFIG information, can't access PCI configuration space under this host bridge.
> [    1.447405] acpi PNP0A08:00: Bus 0001:00 not present in PCI namespace
...

> Bisection points to this commit (included in full given its brevity):
>
> commit 07f9b61c3915e8eb156cb4461b3946736356ad02
> Author: ethan.zhao <ethan.zhao@oracle.com>
> Date:   Fri Jul 26 11:21:24 2013 -0600
>
>     x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at address zero
>
>     We can check for addr being zero earlier and thus avoid the mutex_unlock()
>     cleanup path.
>
>     [bhelgaas: drop warning printk]
>     Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Acked-by: Yinghai Lu <yinghai@kernel.org>
...

> So the question is should commit
>
>         07f9b61 x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at address zero
>
> be reverted? or am I missing something?

I think we should revert it.  As far as I can tell, it was only a
cleanup and it did not fix anything itself.  So since it did break
something, we should revert it.

It's regrettable that the code is so subtle.  The obvious thing to do
would be to check for _CBA, and if it doesn't exist, look for an MCFG
entry.  But for various historical reasons, the code is a mess, and we
haven't figured out how to safely simplify it.

Ethan, Yinghai, any objections to reverting 07f9b61?

Bjorn
