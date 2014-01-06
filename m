Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaAFUAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:00:31 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:53829 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaAFUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:00:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1401031749340.8667@kaball.uk.xensource.com>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
	<1388707565-16535-17-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1401031749340.8667@kaball.uk.xensource.com>
Date: Mon, 6 Jan 2014 12:00:28 -0800
X-Google-Sender-Auth: TlH_aYZoagsUgjBq8Okqrxj0u7Y
Message-ID: <CAE9FiQVba9K_3LDkHTP4YZJ-FzwE_mF3h6iiXEFb1shUUmhGpg@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH v5 16/33] xen, irq: Call irq_alloc_reserved_desc_at()
 at first
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Xen Devel <xen-devel@lists.xensource.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 9:50 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:

>>  drivers/xen/events.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
>> index 4035e83..020cd77 100644
>> --- a/drivers/xen/events.c
>> +++ b/drivers/xen/events.c
>> @@ -508,8 +508,12 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
>>       /* Legacy IRQ descriptors are already allocated by the arch. */
>>       if (gsi < NR_IRQS_LEGACY)
>>               irq = gsi;
>> -     else
>> -             irq = irq_alloc_desc_at(gsi, -1);
>> +     else {
>> +             /* for x86, irq already get reserved for gsi */
>> +             irq = irq_alloc_reserved_desc_at(gsi, -1);
>> +             if (irq < 0)
>> +                     irq = irq_alloc_desc_at(gsi, -1);
>> +     }
>
> This is common code. On ARM I get:
>
> drivers/xen/events.c: In function 'xen_allocate_irq_gsi':
> drivers/xen/events.c:513:3: error: implicit declaration of function 'irq_alloc_reserved_desc_at' [-Werror=implicit-function-declaration]
>    irq = irq_alloc_reserved_desc_at(gsi, -1);
>    ^
> cc1: some warnings being treated as errors

It's strange.

that is defined with irq_alloc_desc_at in parallel in
include/linux/irq.h and kernel/irq/irqdesc.c.

Did you try the whole tree, or just this patch?

Thanks

Yinghai
