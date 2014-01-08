Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaAHXe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:34:57 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57917 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaAHXez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:34:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU88EO=e+CR7RKnZ6r7ofSwi9J1QisnrnDyDz6Qh367YQ@mail.gmail.com>
References: <1387485843-17403-1-git-send-email-yinghai@kernel.org>
	<1387485843-17403-3-git-send-email-yinghai@kernel.org>
	<CAErSpo5VWREGptW0MU0wLJUa3h23DXMZPGkdJFMTx5WAGL8J6Q@mail.gmail.com>
	<CAE9FiQU88EO=e+CR7RKnZ6r7ofSwi9J1QisnrnDyDz6Qh367YQ@mail.gmail.com>
Date: Wed, 8 Jan 2014 15:34:54 -0800
X-Google-Sender-Auth: Olq148JblJGLqe9sTk30-xlvvqc
Message-ID: <CAE9FiQVZ9yrcViFNx5q65ot=nNP=JBuvotpEjUis2FF11wjg6w@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] PCI: Try best to allocate pref mmio 64bit above 4g
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 22, 2013 at 5:14 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sun, Dec 22, 2013 at 4:00 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Thu, Dec 19, 2013 at 1:44 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> Let me see if I can figure out what you're trying to do here.  Please
>> correct me if I'm wrong:
>>
>>> When one of children resources does not support MEM_64, MEM_64 for
>>> bridge get reset, so pull down whole pref resource on the bridge under 4G.
>>
>> When we allocate space for a bridge's prefetchable window, we
>> currently look at the devices behind the bridge and put the window
>> below 4GB if any of those children has a 32-bit prefetchable BAR.
>>
>> This maximizes the use of prefetch, at the cost of using more 32-bit
>> address space.
>
> yes. and we have problem when we have 8 sockets or 32 sockets system,
> will have limit 32bit space.
> but we have enough above 4G 64bit mmio for prefetchable.
>
>>
>>> If the bridge support pref mem 64, will only allocate that with pref mem64 to
>>> children that support it.
>>> For children resources if they only support pref mem 32, will allocate them
>>> from non pref mem instead.
>>
>> You are changing this so that we will always try to put a bridge's
>> 64-bit prefetchable window above 4GB, regardless of what devices are
>> behind the bridge.  If a device behind the bridge has a 32-bit
>> prefetchable BAR, we will place that BAR in the bridge's 32-bit
>> non-prefetchable window.
>
> Yes. so we can keep IORESOURCE_MEM64 in the flags for PREF.
>
>>
>> This minimizes the use of the 32-bit address space, at the cost of not
>> being able to use prefetch as much.
>>
>>> If the bridge only support 32bit pref mmio, will still have all children pref
>>> mmio under that.
>>
>> Obviously, if a bridge has a prefetchable window that's only 32 bits,
>> 64-bit prefetchable BARs behind the bridge will have to be in that
>> 32-bit prefetchable window or the 32-bit non-prefetchable window.  And
>> if the bridge has no prefetchable window at all, every memory BAR
>> behind the bridge will have to be in the 32-bit non-prefetchable
>> window.
>
> Yes.
>
>>
>> I'll look at the actual patch later; I just want to make sure I
>> understand your intent first.

Hi, Bjorn,

Can you check and add this one to your pci/resource branch?
With that we can close the loop for 64bit mmio resource allocation.

Thanks

Yinghai
