Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaCKWGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:06:34 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36603 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaCKWGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXEuZ4HzXWB_Pf1+UZtQS3N70OeLuxDL+pwViwsT8URhA@mail.gmail.com>
References: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140311174249.23084.66300.stgit@bhelgaas-glaptop.roam.corp.google.com> <CAE9FiQXEuZ4HzXWB_Pf1+UZtQS3N70OeLuxDL+pwViwsT8URhA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Mar 2014 16:06:12 -0600
Message-ID: <CAErSpo5EX0eZRAoff=wN7K3oSiF_mYMgTjLe-uPKXGUngG35aA@mail.gmail.com>
Subject: Re: [PATCH 2/5] resources: Set type in __request_region()
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 3:44 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Mar 11, 2014 at 10:42 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> We don't set the type (I/O, memory, etc.) of resources added by
>> __request_region(), which leads to confusing messages like this:
>>
>>     address space collision: [io  0x1000-0x107f] conflicts with ACPI CPU throttle [??? 0x00001010-0x00001015 flags 0x80000000]
>>
>> Set the type of a new resource added by __request_region() (used by
>> request_region() and request_mem_region()) to the type of its parent.  This
>> makes the resource tree internally consistent and fixes messages like the
>> above, where the ACPI CPU throttle resource really is an I/O port region,
>> but request_region() didn't fill in the type, so %pR didn't know how to
>> print it.
>>
>> Sample dmesg showing the issue at the link below.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=71611
>> Reported-by: Paul Bolle <pebolle@tiscali.nl>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> ---
>>  kernel/resource.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/resource.c b/kernel/resource.c
>> index a8344dda7049..ae1f742c860c 100644
>> --- a/kernel/resource.c
>> +++ b/kernel/resource.c
>> @@ -945,8 +945,8 @@ struct resource * __request_region(struct resource *parent,
>>         res->name = name;
>>         res->start = start;
>>         res->end = start + n - 1;
>> -       res->flags = IORESOURCE_BUSY;
>> -       res->flags |= flags;
>> +       res->flags = parent->flags;
>
> can we use (parent->flags & IORESOURCE_TYPE_BITS) instead?

Yep, that seems like a good idea.  I changed it to:

+       res->flags = resource_type(parent);

Bjorn

>> +       res->flags |= IORESOURCE_BUSY | flags;
>>
>>         write_lock(&resource_lock);
>>
>>
