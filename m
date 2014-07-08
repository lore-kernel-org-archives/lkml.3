Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaGHJUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:20:31 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:34200 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaGHJU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:20:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140708094149.0ad6ab13@free-electrons.com>
References: <20140703135146.GA6898@luxor.wired.org>
	<53B5C61D.2060308@free-electrons.com>
	<53B5CA26.7050405@free-electrons.com>
	<1936558.QaAG1bYMuD@avalon>
	<20140705150308.GA28791@arch.cereza>
	<20140705205951.GB3678@kroah.com>
	<20140707105818.GA1101@arch.cereza>
	<20140707183002.GA5947@kroah.com>
	<20140707233758.GA1456@arch.cereza>
	<20140708094149.0ad6ab13@free-electrons.com>
Date: Tue, 8 Jul 2014 11:20:28 +0200
Message-ID: <CAMmgNdY-BZvGQL=1_7ANgSbV0TJfcqFRXgmLgyYCk+nAnNkT7w@mail.gmail.com>
Subject: Re: 3.16rc3 multiplatform, Armada 370 and IOMMU: unbootable kernel
From: Paolo Pisati <p.pisati@gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Joerg Roedel <joro@8bytes.org>, Hiroshi.DOYU@nokia.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 9:41 AM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:
> Dear Ezequiel Garcia,
>
> On Mon, 7 Jul 2014 20:37:58 -0300, Ezequiel Garcia wrote:
>
>> It seems bus_register_notifier() is been called for platform and pci devices
>> with the *same* notifier block. Haven't looked close enough, but you mentioned
>> that could cause trouble?
>>
>> This patch fixes the issue here:
>>
>> diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
>> index 477202f..2bdc323 100644
>> --- a/arch/arm/mach-mvebu/coherency.c
>> +++ b/arch/arm/mach-mvebu/coherency.c
>> @@ -292,6 +292,10 @@ static struct notifier_block mvebu_hwcc_nb = {
>>       .notifier_call = mvebu_hwcc_notifier,
>>  };
>>
>> +static struct notifier_block mvebu_hwcc_pci_nb = {
>> +     .notifier_call = mvebu_hwcc_notifier,
>> +};
>> +
>>  static void __init armada_370_coherency_init(struct device_node *np)
>>  {
>>       struct resource res;
>> @@ -427,7 +431,7 @@ static int __init coherency_pci_init(void)
>>  {
>>       if (coherency_available())
>>               bus_register_notifier(&pci_bus_type,
>> -                                    &mvebu_hwcc_nb);
>> +                                    &mvebu_hwcc_pci_nb);
>>       return 0;
>>  }
>>
>> Paolo, can you apply it and confirm it fixes the problem?
>>
>> Greg, can you confirm using the same notifier block pointer
>> for two different bus types makes the bus notifier go nuts?
>
> Looking at how notifier_chain_register() is implemented (which gets
> called by bus_register_notifier() ->
> blocking_notifier_chain_register()), I indeed don't see how a single
> 'struct notifier_block' can be registered on multiple notifier chains,
> so I believe your patch is correct.
>

yes, i confim this patch fixes my issue, thanks!

-- 
bye,
p.
