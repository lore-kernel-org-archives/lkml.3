Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbaLJOel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:34:41 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52479 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaLJOej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:34:39 -0500
Date: Wed, 10 Dec 2014 22:34:28 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marek =?iso-8859-1?Q?Kord=EDk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Clear all bridge res MEM_64 if host bridge has non
 mem64
Message-ID: <20141210143428.GB12497@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1418160871-5605-1-git-send-email-yinghai@kernel.org>
 <CAErSpo5tZU=zBKNDt2UtUE_AMG3zzrdq2CX2A4ZL7tdLELXgqA@mail.gmail.com>
 <CAE9FiQWLaNSsFTWEpWRFR4xTd0hKOwENdQR7N6T=K65VM+vDQg@mail.gmail.com>
 <20141210141537.GA9298@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210141537.GA9298@richard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121014-0029-0000-0000-000000C9B21B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My mutt hang, in case the mail isn't sent out, I resend it.

On Wed, Dec 10, 2014 at 10:15:37PM +0800, Wei Yang wrote:
>On Tue, Dec 09, 2014 at 03:13:49PM -0800, Yinghai Lu wrote:
>>On Tue, Dec 9, 2014 at 1:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> On Tue, Dec 9, 2014 at 2:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> +       list_for_each_entry(window, &bridge->windows, list) {
>>>> +               res = window->res;
>>>> +               if (resource_type(res) == IORESOURCE_MEM ||
>>>> +                   res->end > 0xffffffff) {
>>>> +                       bridge->has_mem64_res = true;
>>>
>>> This is an interesting idea, but I think you're checking CPU addresses
>>> here, and you need to check PCI bus addresses.
>>
>>Looks like those IBM platforms have res > 4g, but pci bus address < 4g.
>>If we check pci bus address, and then we would break those platforms.
>>

Hi, Yinghai

I did some test with patch on my machine. It looks good.

While as Bjorn mentioned, I think we could change it a little. The pci space
on our machine is like this:

        cpu address                               pci address
  MEM   0x00003ff280000000..0x00003ff2fffeffff -> 0x00000000 8000 0000
  MEM64 0x00003d5000000000..0x00003d5fffffffff -> 0x00003d50 0000 0000

Each root bridge has two MMIO window. From this output we could see the pci
address for 64-bit window is above 4G.

I did a little change on your code, like this

        list_for_each_entry(window, &bridge->windows, list) {
                res = window->res;
                if (resource_type(res) == IORESOURCE_MEM ||
-                   res->end > 0xffffffff) {
+                   (res->end - window->offset) > 0xffffffff) {
                        bridge->has_mem64_res = true;
                        break;
                }
        }

This also works on my machine.

One more question, with this patch, do we still need previous patch for
Marek's problem?

>>Yinghai
>
>-- 
>Richard Yang
>Help you, Help me

-- 
Richard Yang
Help you, Help me

