Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaCXMDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:03:39 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2043 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaCXMDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:03:37 -0400
X-IronPort-AV: E=Sophos;i="4.97,720,1389772800"; 
   d="scan'208";a="21274641"
Message-ID: <53301F11.9030305@broadcom.com>
Date: Mon, 24 Mar 2014 13:03:29 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>,
        Monam Agarwal <monamagarwal123@gmail.com>
CC: <rcj@linux.vnet.ibm.com>, <mhcerri@linux.vnet.ibm.com>,
        <fin@linux.vnet.ibm.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/crypto: Use RCU_INIT_POINTER(x, NULL) in nx/nx-842.c
References: <1395603064-16537-1-git-send-email-monamagarwal123@gmail.com> <20140324111606.GB19368@hmsreliant.think-freely.org>
In-Reply-To: <20140324111606.GB19368@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/14 12:16, Neil Horman wrote:
> On Mon, Mar 24, 2014 at 01:01:04AM +0530, Monam Agarwal wrote:
>> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
>>
>> The rcu_assign_pointer() ensures that the initialization of a structure
>> is carried out before storing a pointer to that structure.
>> And in the case of the NULL pointer, there is no structure to initialize.
>> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)
>>
>> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
>> ---
>>   drivers/crypto/nx/nx-842.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
>> index 1e5481d..c4fcbf4 100644
>> --- a/drivers/crypto/nx/nx-842.c
>> +++ b/drivers/crypto/nx/nx-842.c
>> @@ -1234,7 +1234,7 @@ static int __exit nx842_remove(struct vio_dev *viodev)
>>   	old_devdata = rcu_dereference_check(devdata,
>>   			lockdep_is_held(&devdata_mutex));
>>   	of_reconfig_notifier_unregister(&nx842_of_nb);
>> -	rcu_assign_pointer(devdata, NULL);
>> +	RCU_INIT_POINTER(devdata, NULL);
>>   	spin_unlock_irqrestore(&devdata_mutex, flags);
>>   	synchronize_rcu();
>>   	dev_set_drvdata(&viodev->dev, NULL);
>> @@ -1285,7 +1285,7 @@ static void __exit nx842_exit(void)
>>   	spin_lock_irqsave(&devdata_mutex, flags);
>>   	old_devdata = rcu_dereference_check(devdata,
>>   			lockdep_is_held(&devdata_mutex));
>> -	rcu_assign_pointer(devdata, NULL);
>> +	RCU_INIT_POINTER(devdata, NULL);
>>   	spin_unlock_irqrestore(&devdata_mutex, flags);
>>   	synchronize_rcu();
>>   	if (old_devdata)
>
> This really does't seem right.  rcu_assign_pointer users ACCESS_ONCE to protect
> against multiple loads that allow for concurrent read/write use with parallel
> rcu_dereference calls, whereas RCU_INIT_POINTER does not.  It also just doesn't
> look right.  We've already initalized the pointerin nx842_init, we don't need to
> re-initalize it here, we need to assign it to NULL.

I was being cautious as well, but Paul gave me an explanation [1]

Hope it helps you as well ;-)

But I think I also saw a patch that modifies rcu_assign_pointer to 
handle NULL assignment. Don't recall the thread.

Regards,
Arend

[1] http://mid.gmane.org/20140320150601.GK4405@linux.vnet.ibm.com

>
> Neil
>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

