Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3F2M1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 08:27:40 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43078 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3F2M1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 08:27:37 -0400
Message-ID: <51CED2B5.9090707@kernel.org>
Date: Sat, 29 Jun 2013 13:27:33 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Otavio Salvador <otavio@ossystems.com.br>
CC: linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: Fwd: mxs-lradc oops when unloading module
References: <CAP9ODKof+yv27-zHSO9MTLC9Wv6F6Ya-Ot-vW7OK7kwadYK8Xg@mail.gmail.com> <CAP9ODKq92LW-xQyiHkVe6AkwaaYV11nt92DxCEzUioEVARTZXw@mail.gmail.com> <51C5847C.7030100@kernel.org> <CAP9ODKohhQVTwj40K-h1LDAqjk6+nO1r=Fq404Xy1DUZWfwRxg@mail.gmail.com>
In-Reply-To: <CAP9ODKohhQVTwj40K-h1LDAqjk6+nO1r=Fq404Xy1DUZWfwRxg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 01:30 PM, Otavio Salvador wrote:
> On Sat, Jun 22, 2013 at 8:03 AM, Jonathan Cameron <jic23@kernel.org> wrote:
>>> From what I could grasp, it might be related to the IIO subsystem but
>>> I couldn't find the culprit.
>>>
>>> It seems "iio_device_unregister_trigger_consumer", as:
>>>
>>> void iio_device_unregister_trigger_consumer(struct iio_dev *indio_dev)
>>> {
>>> /* Clean up an associated but not attached trigger reference */
>>> if (indio_dev->trig)
>>> iio_trigger_put(indio_dev->trig);
>>> }
>>>
>>> and , as:
>>>
>>> static inline void iio_trigger_put(struct iio_trigger *trig)
>>> {
>>> module_put(trig->ops->owner);
>>> put_device(&trig->dev);
>>> }
>>>
>>> so, somehow the trig->ops is NULL here.
>>>
>>> Do someone has a clue?
>>>
>> I think the issue is more core to iio trigger handling than that, you
>> have just been unlucky enough to hit a bug that has been there a while.
>>
>> In iio_trigger_unregister we call
>> iio_device_unregister which in turn calls device_del (as intended) and
>> device_put (as not!).  Then we get an additional device_put from
>> iio_trigger_free giving us one more than we should have an resulting
>> in a double attempt to free the device.
>>
>> Could you try the following change and see if it solves the problem?
>> (the comment abov is 'interesting' and stupid given I've long ago
>> forgotten what it refers to, but it could be related to this issue...)
>>
>> From 238faf76acaa9214b0eb607742dd14b134469328 Mon Sep 17 00:00:00 2001
>> From: Jonathan Cameron <jic23@kernel.org>
>> Date: Sat, 22 Jun 2013 12:00:04 +0100
>> Subject: [PATCH] iio:trigger: device_unregister->device_del to avoid double
>>  free
>>
>> iio_trigger unregistration and freeing has been separated in this
>> code for some time, but it looks like the calls to the device
>> handling were not appropriately updated.
>>
>> Signed-off-by: Jonathan Cameron <jic23@kernel.org>
>> ---
>>  drivers/iio/industrialio-trigger.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
>> index 4d6c7d8..ea8a414 100644
>> --- a/drivers/iio/industrialio-trigger.c
>> +++ b/drivers/iio/industrialio-trigger.c
>> @@ -104,7 +104,7 @@ void iio_trigger_unregister(struct iio_trigger *trig_info)
>>
>>         ida_simple_remove(&iio_trigger_ida, trig_info->id);
>>         /* Possible issue in here */
>> -       device_unregister(&trig_info->dev);
>> +       device_del(&trig_info->dev);
>>  }
>>  EXPORT_SYMBOL(iio_trigger_unregister);
> 
> Tested-by: Otavio Salvador <otavio@ossystems.com.br>
> 
> It does fix the Oops for me.
applied to the fixes-togreg branch of iio.git
Given timing these will probably go in after the merge window closes in a couple of
weeks.

Thanks,
> 
> --
> Otavio Salvador                             O.S. Systems
> http://www.ossystems.com.br        http://projetos.ossystems.com.br
> Mobile: +55 (53) 9981-7854            Mobile: +1 (347) 903-9750
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
