Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaGKROu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:14:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59215 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaGKROt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:14:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMxnaaX6tOobPBDVbG7v-kJTvNMLYSybZWuzTqbgMdMkP50swQ@mail.gmail.com>
References: <20140708223126.GA12035@himangi-Dell> <CAMxnaaX6tOobPBDVbG7v-kJTvNMLYSybZWuzTqbgMdMkP50swQ@mail.gmail.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Fri, 11 Jul 2014 19:14:23 +0200
Message-ID: <CAMxnaaXJ_eYvUwPV=-w_eZW-EChhe1eW5Q5ctru4mhWyt3ZhuQ@mail.gmail.com>
Subject: Re: [PATCH v3] thunderbolt: Use kcalloc and correct the argument to sizeof
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        julia.lawall@lip6.fr, Himangi Saraogi <himangi774@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, can you add this to your char-misc tree (instead of the kzalloc
patch, or do you need a rebased patch)?

Thanks,
Andreas

On Thu, Jul 10, 2014 at 6:45 PM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> On Wed, Jul 9, 2014 at 12:31 AM, Himangi Saraogi <himangi774@gmail.com> wrote:
>> nhi->rx_rings does not have type as struct tb_ring *, as it is a double
>> pointer. So, the elements of the array should have pointer type, not
>> structure type. The advantage of kcalloc is, that will prevent integer
>> overflows which could result from the multiplication of number of
>> elements and size and it is also a bit nicer to read.
>>
>> The Coccinelle semantic patch that makes the first change is as follows:
>>
>> // <smpl>
>> @disable sizeof_type_expr@
>> type T;
>> T **x;
>> @@
>>
>>   x =
>>   <+...sizeof(
>> - T
>> + *x
>>   )...+>
>> // </smpl>
>>
>> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
>> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
>> ---
>> v2: Use kcalloc
>> v3: Add maintainer in To
>>  drivers/thunderbolt/nhi.c | 10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
>> index 2054fbf..c68fe12 100644
>> --- a/drivers/thunderbolt/nhi.c
>> +++ b/drivers/thunderbolt/nhi.c
>> @@ -569,12 +569,10 @@ static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>                          nhi->hop_count);
>>         INIT_WORK(&nhi->interrupt_work, nhi_interrupt_work);
>>
>> -       nhi->tx_rings = devm_kzalloc(&pdev->dev,
>> -                                    nhi->hop_count * sizeof(struct tb_ring),
>> -                                    GFP_KERNEL);
>> -       nhi->rx_rings = devm_kzalloc(&pdev->dev,
>> -                                    nhi->hop_count * sizeof(struct tb_ring),
>> -                                    GFP_KERNEL);
>> +       nhi->tx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
>> +                                    sizeof(*nhi->tx_rings), GFP_KERNEL);
>> +       nhi->rx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
>> +                                    sizeof(*nhi->rx_rings), GFP_KERNEL);
>>         if (!nhi->tx_rings || !nhi->rx_rings)
>>                 return -ENOMEM;
>>
>> --
>> 1.9.1
>>
>
> Thanks for catching this.
> Acked-by: Andreas Noever <andreas.noever@gmail.com>
