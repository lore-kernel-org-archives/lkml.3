Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaB0Qby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:31:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41210 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaB0QbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:31:13 -0500
Message-ID: <530F68BE.2070505@oracle.com>
Date: Thu, 27 Feb 2014 11:33:02 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCH] xen: add support for MSI message groups
References: <1393431884-1120-1-git-send-email-roger.pau@citrix.com> <530F51E9.1070703@oracle.com> <530F5DA0.3060408@citrix.com>
In-Reply-To: <530F5DA0.3060408@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 10:45 AM, Roger Pau Monné wrote:
>>
>> @@ -291,7 +290,10 @@ static int xen_initdom_setup_msi_irqs(struct
>> pci_dev *dev, int nvec, int type)
>>                      (pci_domain_nr(dev->bus) << 16);
>>            map_irq.devfn = dev->devfn;
>>    -        if (type == PCI_CAP_ID_MSIX) {
>> +        if (type == PCI_CAP_ID_MSI && nvec > 1) {
>> +            map_irq.type = MAP_PIRQ_TYPE_MULTI_MSI;
>> +            map_irq.entry_nr = nvec;
>>
>> Are we overloading entry_nr here with a different meaning? I thought it
>> was meant to be entry number (in MSI-X table for example), not number of
>> entries.
> In the case of MSI message groups (MAP_PIRQ_TYPE_MULTI_MSI) entry_nr is
> the number of vectors to setup, so yes, it's an overloading of entry_nr.

Then I think we should at least make a note of this in physdev.h. (Or 
maybe even make entry_nr a union with nvec or some such, although that 
would look rather hacky).

> ....
>
>>
>> index 42721d1..eb13326d 100644
>> --- a/include/xen/interface/physdev.h
>> +++ b/include/xen/interface/physdev.h
>> @@ -131,6 +131,7 @@ struct physdev_irq {
>>    #define MAP_PIRQ_TYPE_GSI        0x1
>>    #define MAP_PIRQ_TYPE_UNKNOWN        0x2
>>    #define MAP_PIRQ_TYPE_MSI_SEG        0x3
>> +#define MAP_PIRQ_TYPE_MULTI_MSI        0x4
>> Formatting.
> I don't get the formatting problem, it's the same formatting that the
> other MAP_PIRQ_TYPE_* use, and if the patch is applied formatting is OK.
>

That's because my client messed up whitespaces. You can look for example 
at https://lkml.org/lkml/2014/2/26/352 to see the extra tab.

-boris
