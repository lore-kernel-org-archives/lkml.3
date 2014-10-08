Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaJHKSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:18:41 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40017 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbaJHKSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <20141007163856.GE16469@dtor-ws>
References: <1412667049-6128-1-git-send-email-pramod.gurav@smartplayin.com>
	<20141007163856.GE16469@dtor-ws>
Date: Wed, 8 Oct 2014 15:48:37 +0530
Message-ID: <CAMf-jS=jvo2hzULv_MtvbeAq_A2z0aJS2F=1Zx5tPonKsJTrNg@mail.gmail.com>
Subject: Re: [PATCH] Input: adp5588-keys: cancel workqueue in failure path
From: Pramod Gurav <pramod.gurav.etc@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, Oct 7, 2014 at 10:08 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Oct 07, 2014 at 01:00:49PM +0530, Pramod Gurav wrote:
>> This change introduces a label to call cancel_delayed_work_sync in
>> failure path.
>>
>> Cc: Michael Hennerich <michael.hennerich@analog.com>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Cc: linux-input@vger.kernel.org
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>> ---
>>  drivers/input/keyboard/adp5588-keys.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
>> index 5ef7fcf..b494062 100644
>> --- a/drivers/input/keyboard/adp5588-keys.c
>> +++ b/drivers/input/keyboard/adp5588-keys.c
>> @@ -559,7 +559,7 @@ static int adp5588_probe(struct i2c_client *client,
>>       error = input_register_device(input);
>>       if (error) {
>>               dev_err(&client->dev, "unable to register input device\n");
>> -             goto err_free_mem;
>> +             goto err_delayed_work;
>>       }
>>
>>       error = request_irq(client->irq, adp5588_irq,
>> @@ -592,6 +592,8 @@ static int adp5588_probe(struct i2c_client *client,
>>   err_unreg_dev:
>>       input_unregister_device(input);
>>       input = NULL;
>> + err_delayed_work:
>> +     cancel_delayed_work_sync(&kpad->work);
>
> We do not need to have a separate label, just need to cancel workqueue
> after freeing interrupt. I adjusted the patch and applied.
>
Thanks. I saw the change in your tree. Shouldn't
cancel_delayed_work_sync(&kpad->work) be called under label
err_free_mem so that it will executed in case adp5588_read,
input_register_device, request_irq etc.
Or else we will still have workqueue instance hanging around.

> Thanks.
>
> --
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
