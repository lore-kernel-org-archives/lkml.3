Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaKQXnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:43:08 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33889 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaKQXnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:43:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141111035902.GC28161@google.com>
References: <1414865479-25792-1-git-send-email-prarit@redhat.com> <20141111035902.GC28161@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Nov 2014 16:42:44 -0700
Message-ID: <CAErSpo7q1U_HpEeB_pMWJPae3a+oysEwR660m2bV5KdZ7oCr0w@mail.gmail.com>
Subject: Re: [PATCH] pci, add FW_BUG warning to pci= kernel option
To: Prarit Bhargava <prarit@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Myron Stowe <mstowe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 8:59 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc lkml, linux-arch, Linus]
>
> On Sat, Nov 01, 2014 at 02:11:19PM -0400, Prarit Bhargava wrote:
>> The kernel should boot PCI without the use of kernel parameters.  Display
>> a FW_BUG warning when pci= is used.
>>
>> Cc: Myron Stowe <mstowe@redhat.com>
>> Cc: linux-pci@vger.kernel.org
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>> ---
>>  drivers/pci/pci.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 625a4ac..5172060b 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -4515,6 +4515,8 @@ static int __init pci_setup(char *str)
>>               }
>>               str = k;
>>       }
>> +     add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
>> +     pr_crit(FW_BUG "The PCI configuration has been overridden thorugh the use of pci=.  Please report the issue you are attempting to resolve to your hardware vendor.\n");
>
> My goal is to be able to boot without any "pci=" parameters, so from that
> perspective, I like this.
>
> When people have a problem booting Linux, they often try a variety of
> things like "pci=assign-busses", "pci=nocrs", "pci=nomsi", "pci=nommconf",
> "pci=noacpi", etc.  If they find something that works, there's a tendency
> to treat that as a "solution."  I'd rather that they report it, so we can
> try to fix the bug or add a quirk so the *next* person won't have to figure
> out the right parameters to use.
>
> My worry is that there are a few things where Linux isn't smart enough to
> do the right thing automatically, and I don't think we'll have a good
> solution in the near future.  For example:
>
>     pci=norom
>     pci=pcie_bus_perf,pcie_bus_safe,etc.
>     pci=cbiosize=...
>     pci=cbmemsize=...
>     pci=resource_alignment=...
>     pci=hpiosize=...
>     pci=hpmemsize=...
>     pci=realloc
>
> I don't like the fact that these options exist, but I suspect there are
> users that do depend on them and might find this warning too aggressive.
>
> So I'm interested in opinions on whether this is a good idea at all and
> whether we should exclude some options from the warning/tainting.

Hi Prarit,

We didn't get any nibbles :)

I don't think we can realistically taint the kernel for *all* "pci="
options.  So if you want to pursue this, maybe you could enhance this
so we can have a whitelist of options that we will support without
tainting.  Then we can argue about what should be on the list and go
from there.  Does that seem reasonable?

This is a somewhat more aggressive use of tainting than we've had in
the past, so we might have to iterate on this a bit.

Bjorn
