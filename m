Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3HZCAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:00:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25599 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3HZCAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:00:23 -0400
Message-ID: <521AB6B3.7050609@oracle.com>
Date: Mon, 26 Aug 2013 10:00:19 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: Re: [PATCH 2/3 v2] Refactor msi/msix restore code Part2
References: <51FF527F.7080904@oracle.com> <CAErSpo5JCpJ0=vcTAwjz4VjZ4imBJxM8TP9RWrmiee3VQnjY=w@mail.gmail.com> <20130823171538.GB14096@phenom.dumpdata.com>
In-Reply-To: <20130823171538.GB14096@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-08-24 01:15, Konrad Rzeszutek Wilk wrote:
> On Thu, Aug 22, 2013 at 03:14:34PM -0600, Bjorn Helgaas wrote:
>> On Mon, Aug 5, 2013 at 1:21 AM, Zhenzhong Duan
>> <zhenzhong.duan@oracle.com>  wrote:
>>> xen_initdom_restore_msi_irqs trigger a hypercall to restore addr/data/mask
>>> in dom0. It's better to do the same in default_restore_msi_irqs for baremetal.
>>>
>>> Move restore of mask in default_restore_msi_irqs, this could avoid mask
>>> restored twice in dom0, and the logic for baremetal keep same.
>>>
>>> First mask restore is in xen_initdom_restore_msi_irqs->PHYSDEVOP_restore_msi,
>>> Second restore is __pci_restore_msix_state->msix_mask_irq.
>>>
>>> Mask bits are under full control of xen, and the entry->masked in dom0 kernel
>>> is invalid. restore an invalid value to mask register could mask the msix
>>> interrupt.
>>>
>>> Without fix, qlcnic driver calling pci_reset_function will lost interrupt
>>> in dom0.
>> Konrad, this changelog still doesn't make any sense to me, but if you
>> ack this, I guess I can apply it.
> Hey Bjorn,
>
> Zhenzhong is patiently working to rewrite up the commit message based on
> my naive questions and emails back and forth. Once it is good shape he
> will post it. The code will look the same but the commit message will
> be a bit more verbose and clear.
>
> Is there an ETA when you would like these? I recall the merge window
> is just around the corner - so when is your comfortable cut-off-day
> so that you can make a go/no-go decision?
>
>> I guess there are also:
>>
>>    Jul 24  [PATCH 1/3] Refactor msi/msix restore code Part1
>>    Jul 30  [PATCH 3/3 v2] Update x86_msi.restore_msi_irqs API param
>>
>> and all three should be applied as a series?
> <scratches his head>.
>
> I think the
>     Jul 30  [PATCH 3/3 v2] Update x86_msi.restore_msi_irqs API param
>
> can go in anytime. That is mostly a cosmetic fixup in the API.
> Zhenzhong - right?
Yes, 3rd patch doesn't depend on the first two.
One effect is making code looks consistent. But my main purpose is 
optimizing
msix restore code in initial domain.
Before patch, dom0 calls PHYSDEVOP_restore_msi hypercall for every entry in
dev->msi_list, now it calls PHYSDEVOP_restore_msi hypercall once.
