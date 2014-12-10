Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaLJSTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:19:00 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34670 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaLJSS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:18:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141210143428.GB12497@richard>
References: <1418160871-5605-1-git-send-email-yinghai@kernel.org>
	<CAErSpo5tZU=zBKNDt2UtUE_AMG3zzrdq2CX2A4ZL7tdLELXgqA@mail.gmail.com>
	<CAE9FiQWLaNSsFTWEpWRFR4xTd0hKOwENdQR7N6T=K65VM+vDQg@mail.gmail.com>
	<20141210141537.GA9298@richard>
	<20141210143428.GB12497@richard>
Date: Wed, 10 Dec 2014 10:18:58 -0800
X-Google-Sender-Auth: qQpciRP62GetUdEmxaiFZHmKVPw
Message-ID: <CAE9FiQVDkWSrm0Z9N+zW=Pb2gL6CW9EBj7CcOfKD=1uizRqP6Q@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear all bridge res MEM_64 if host bridge has non mem64
From: Yinghai Lu <yinghai@kernel.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 6:34 AM, Wei Yang <weiyang@linux.vnet.ibm.com> wrote:
> My mutt hang, in case the mail isn't sent out, I resend it.
>
> On Wed, Dec 10, 2014 at 10:15:37PM +0800, Wei Yang wrote:
>>On Tue, Dec 09, 2014 at 03:13:49PM -0800, Yinghai Lu wrote:
>>>On Tue, Dec 9, 2014 at 1:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>> On Tue, Dec 9, 2014 at 2:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>>> +       list_for_each_entry(window, &bridge->windows, list) {
>>>>> +               res = window->res;
>>>>> +               if (resource_type(res) == IORESOURCE_MEM ||
>>>>> +                   res->end > 0xffffffff) {
>>>>> +                       bridge->has_mem64_res = true;
>>>>
>>>> This is an interesting idea, but I think you're checking CPU addresses
>>>> here, and you need to check PCI bus addresses.
>>>
>>>Looks like those IBM platforms have res > 4g, but pci bus address < 4g.
>>>If we check pci bus address, and then we would break those platforms.
>>>
>
> Hi, Yinghai
>
> I did some test with patch on my machine. It looks good.
>
> While as Bjorn mentioned, I think we could change it a little. The pci space
> on our machine is like this:
>
>         cpu address                               pci address
>   MEM   0x00003ff280000000..0x00003ff2fffeffff -> 0x00000000 8000 0000
>   MEM64 0x00003d5000000000..0x00003d5fffffffff -> 0x00003d50 0000 0000


>
> Each root bridge has two MMIO window. From this output we could see the pci
> address for 64-bit window is above 4G.

>
> I did a little change on your code, like this
>
>         list_for_each_entry(window, &bridge->windows, list) {
>                 res = window->res;
>                 if (resource_type(res) == IORESOURCE_MEM ||
> -                   res->end > 0xffffffff) {
> +                   (res->end - window->offset) > 0xffffffff) {
>                         bridge->has_mem64_res = true;
>                         break;
>                 }
>         }

good, then we should change to compare region end.

>
> This also works on my machine.
>
> One more question, with this patch, do we still need previous patch for
> Marek's problem?

Only need this to make Marek's working.

but does not help on Zermond's

Thanks

Yinghai
