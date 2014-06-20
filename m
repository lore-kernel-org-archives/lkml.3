Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaFTTLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:11:22 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:63317 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaFTTLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:11:21 -0400
Message-ID: <53A48855.2010102@savoirfairelinux.com>
Date: Fri, 20 Jun 2014 15:15:33 -0400
From: Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        "Steven J. Hill" <Steven.Hill@imgtec.com>,
        John Crispin <blogic@openwrt.org>,
        Qais Yousef <Qais.Yousef@imgtec.com>
CC: linux-kernel@vger.kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Subject: Re: [PATCH 1/1] MIPS: APRP: Fix an issue when device_create() fails.
References: <1403209823-6376-1-git-send-email-sebastien.bourdelin@savoirfairelinux.com> <53A4702D.3090503@imgtec.com>
In-Reply-To: <53A4702D.3090503@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

correct me if i'm wrong, but if we pre-decrement, it will decrement
before evaluate and the channel 0 will never be destroy.
So the while condition must change too accordingly.
In any case inside the while loop, "i" will be "i - 1" so we destroy the
previously device.
I think it's correct like this.

On 06/20/2014 01:32 PM, Deng-Cheng Zhu wrote:
> On 06/19/2014 01:30 PM, Sebastien Bourdelin wrote:
>> If a call to device_create() fails for a channel during the initialize
>> loop, we need to clean the devices entries already created before
>> leaving.
>>
>> Signed-off-by: Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
>> ---
>>   arch/mips/kernel/rtlx-cmp.c | 3 +++
>>   arch/mips/kernel/rtlx-mt.c  | 3 +++
>>   2 files changed, 6 insertions(+)
>>
>> diff --git a/arch/mips/kernel/rtlx-cmp.c b/arch/mips/kernel/rtlx-cmp.c
>> index 758fb3c..d26dcc4 100644
>> --- a/arch/mips/kernel/rtlx-cmp.c
>> +++ b/arch/mips/kernel/rtlx-cmp.c
>> @@ -77,6 +77,9 @@ int __init rtlx_module_init(void)
>>   		dev = device_create(mt_class, NULL, MKDEV(major, i), NULL,
>>   				    "%s%d", RTLX_MODULE_NAME, i);
>>   		if (IS_ERR(dev)) {
>> +			while (i--)
> --i?
>
>> +				device_destroy(mt_class, MKDEV(major, i));
>> +
>>   			err = PTR_ERR(dev);
>>   			goto out_chrdev;
>>   		}
>> diff --git a/arch/mips/kernel/rtlx-mt.c b/arch/mips/kernel/rtlx-mt.c
>> index 5a66b97..cb95470 100644
>> --- a/arch/mips/kernel/rtlx-mt.c
>> +++ b/arch/mips/kernel/rtlx-mt.c
>> @@ -103,6 +103,9 @@ int __init rtlx_module_init(void)
>>   		dev = device_create(mt_class, NULL, MKDEV(major, i), NULL,
>>   				    "%s%d", RTLX_MODULE_NAME, i);
>>   		if (IS_ERR(dev)) {
>> +			while (i--)
> Same here.
>
>> +				device_destroy(mt_class, MKDEV(major, i));
>> +
>>   			err = PTR_ERR(dev);
>>   			goto out_chrdev;
>>   		}
>
>
> Deng-Cheng
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

