Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaLVLT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:19:56 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55671 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaLVLTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:19:54 -0500
References: <1418072517-5413-1-git-send-email-jsitnicki@gmail.com> <2022256.J7VNVZ55j5@vostro.rjw.lan> <878uid5my1.fsf@frog.home>
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PNP: Switch from __check_region() to __request_region()
In-reply-to: <878uid5my1.fsf@frog.home>
Date: Mon, 22 Dec 2014 12:19:44 +0100
Message-ID: <87vbl4lynj.fsf@frog.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 08:47 AM CET, Jakub Sitnicki wrote:
> Rafael J. Wysocki <rjw@rjwysocki.net> writes:
>
>> On Monday, December 08, 2014 10:01:57 PM Jakub Sitnicki wrote:
>>> diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
>>> index 782e822..f980ff7 100644
>>> --- a/drivers/pnp/resource.c
>>> +++ b/drivers/pnp/resource.c
>>> @@ -179,8 +179,9 @@ int pnp_check_port(struct pnp_dev *dev, struct resource *res)
>>>  	/* check if the resource is already in use, skip if the
>>>  	 * device is active because it itself may be in use */
>>>  	if (!dev->active) {
>>> -		if (__check_region(&ioport_resource, *port, length(port, end)))
>>> +		if (!request_region(*port, length(port, end), "pnp"))
>>>  			return 0;
>>> +		release_region(*port, length(port, end));
>>
>> Shouldn't we also release the resource returned by request_region() if it is
>> not NULL?
>>
>
> Thanks for taking a look at this. I think we're good here. If you please
> bear with me for a moment:
>
> release_resource() removes an element from the list of resource parent's
> children (and makes it an orphan):
>
> 	p = &old->parent->child;
> 	for (;;) {
> 		tmp = *p;
> 		if (!tmp)
> 			break;
> 		if (tmp == old) {
> 			*p = tmp->sibling;
> 			old->parent = NULL;
> 			return 0;
> 		}
> 		p = &tmp->sibling;
> 	}
>
> release_region() does the same but with additional checks, and also
> frees the resource:
>
> 	p = &parent->child;
>         /* ... */
> 	for (;;) {
> 		struct resource *res = *p;
>
> 		if (!res)
> 			break;
> 		if (res->start <= start && res->end >= end) {
>                         /* ... */
> 			*p = res->sibling;
>                         /* ... */
> 			free_resource(res);
> 			return;
> 		}
> 		p = &res->sibling;
> 	}
>
> When making the change I've based on other code in the kernel which also
> make use of request_region().
>
> To quote one example, drivers/net/ethernet/8390/ne2k-pci.c cleans up its
> I/O port region when initialization fails like so:
>
> static int ne2k_pci_init_one(struct pci_dev *pdev,
> 			     const struct pci_device_id *ent)
> {
>         /* ... */
>
> 	if (request_region (ioaddr, NE_IO_EXTENT, DRV_NAME) == NULL) {
> 		dev_err(&pdev->dev, "I/O resource 0x%x @ 0x%lx busy\n",
> 			NE_IO_EXTENT, ioaddr);
> 		return -EBUSY;
> 	}
>
>         /* ... */
>
> 	dev = alloc_ei_netdev();
> 	if (!dev) {
> 		dev_err(&pdev->dev, "cannot allocate ethernet device\n");
> 		goto err_out_free_res;
> 	}
>
>         /* ... */
>
> err_out_free_res:
> 	release_region (ioaddr, NE_IO_EXTENT);
> 	return -ENODEV;
> }

Just wondering, do you have any further thoughts on this?

Thanks,
Jakub
