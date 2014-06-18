Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966127AbaFRLDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:03:34 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:48444 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966104AbaFRLDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <53A16517.7050705@realsil.com.cn>
References: <cover.1402037562.git.micky_ching@realsil.com.cn>
	<7b58fb0b0915ea0b0838404c74ec22a3b6e5f5a8.1402037565.git.micky_ching@realsil.com.cn>
	<CAPDyKFq1wYZRbuwhLjTMbwN1KYgKuNuZDb7t8FV78Pa=W85oqg@mail.gmail.com>
	<539EB43B.8070707@realsil.com.cn>
	<CAPDyKFqKDAqvacwCVKM8KLjxfykpBq38MS_RgWCcA7+He4_S5w@mail.gmail.com>
	<539F9412.3010209@realsil.com.cn>
	<CAPDyKFqK8mLGc82FfEoxdHG7mioX7JmtFDO=18XZRkwQ4ykU2g@mail.gmail.com>
	<53A0E89F.9010006@realsil.com.cn>
	<CAPDyKFqBy2jamW3EwMk64Cj85RvUmvAtE-ZFef-8R-Jt1Wu40Q@mail.gmail.com>
	<53A16517.7050705@realsil.com.cn>
Date: Wed, 18 Jun 2014 13:03:31 +0200
Message-ID: <CAPDyKFog22CiW5PqfOiikuz2JcYArj2qB0YvoK5FiQqrJfA3oQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: rtsx: add support for async request
From: Ulf Hansson <ulf.hansson@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 June 2014 12:08, micky <micky_ching@realsil.com.cn> wrote:
> On 06/18/2014 03:39 PM, Ulf Hansson wrote:
>>
>> On 18 June 2014 03:17, micky <micky_ching@realsil.com.cn> wrote:
>>>
>>> On 06/17/2014 03:45 PM, Ulf Hansson wrote:
>>>>
>>>> On 17 June 2014 03:04, micky <micky_ching@realsil.com.cn> wrote:
>>>>>
>>>>> On 06/16/2014 08:40 PM, Ulf Hansson wrote:
>>>>>>
>>>>>> On 16 June 2014 11:09, micky <micky_ching@realsil.com.cn> wrote:
>>>>>>>
>>>>>>> On 06/16/2014 04:42 PM, Ulf Hansson wrote:
>>>>>>>>>
>>>>>>>>> @@ -36,7 +37,10 @@ struct realtek_pci_sdmmc {
>>>>>>>>>>
>>>>>>>>>>            struct rtsx_pcr         *pcr;
>>>>>>>>>>            struct mmc_host         *mmc;
>>>>>>>>>>            struct mmc_request      *mrq;
>>>>>>>>>> +       struct workqueue_struct *workq;
>>>>>>>>>> +#define SDMMC_WORKQ_NAME       "rtsx_pci_sdmmc_workq"
>>>>>>>>>>
>>>>>>>>>> +       struct work_struct      work;
>>>>>>>>
>>>>>>>> I am trying to understand why you need a work/workqueue to implement
>>>>>>>> this feature. Is that really the case?
>>>>>>>>
>>>>>>>> Could you elaborate on the reasons?
>>>>>>>
>>>>>>> Hi Uffe,
>>>>>>>
>>>>>>> we need return as fast as possible in mmc_host_ops
>>>>>>> request(ops->request)
>>>>>>> callback,
>>>>>>> so the mmc core can continue handle next request.
>>>>>>> when next request everything is ready, it will wait previous done(if
>>>>>>> not
>>>>>>> done),
>>>>>>> then call ops->request().
>>>>>>>
>>>>>>> we can't use atomic context, because we use mutex_lock() to protect
>>>>>>
>>>>>> ops->request should never executed in atomic context. Is that your
>>>>>> concern?
>>>>>
>>>>> Yes.
>>>>
>>>> Okay. Unless I missed your point, I don't think you need the
>>>> work/workqueue.
>>>
>>> any other method?
>>>
>>>> Because, ops->request isn't ever executed in atomic context. That's
>>>> due to the mmc core, which handles the async mechanism, are waiting
>>>> for a completion variable in process context, before it invokes the
>>>> ops->request() callback.
>>>>
>>>> That completion variable will be kicked, from your host driver, when
>>>> you invoke mmc_request_done(), .
>>>
>>> Sorry, I don't understand here, how kicked?
>>
>> mmc_request_done()
>>      ->mrq->done()
>>          ->mmc_wait_done()
>>              ->complete(&mrq->completion);
>>
>>> I think the flow is:
>>> - not wait for first req
>>> - init mrq->done
>>> - ops->request()                         ---         A.rtsx: start queue
>>> work.
>>> - continue fetch next req
>>> - prepare next req ok,
>>> - wait previous done.                --- B.(mmc_request_done() may be
>>> called
>>> at any time from A to B)
>>> - init mrq->done
>>> - ops->request()                         ---         C.rtsx: start queue
>>> next work.
>>> ...
>>> and seems no problem.
>>
>> Right, I don't think there are any _problem_ by using the workqueue as
>> you have implemented, but I am questioning if it's correct. Simply
>> because I don't think there are any reasons to why you need a
>> workqueue, it doesn't solve any problem for you - it just adds
>> overhead.
>
> Hi Uffe,
>
> we have two driver under mfd, the rtsx-mmc and rtsx-ms,
> we use mutex lock(pcr_mutex) to protect resource,
> when we handle mmc request, we need hold the mutex until we finish the
> request,
> so it will not interruptted by rtsx-ms request.

Ahh, I see. Now, _that_ explains why you want the workqueue. :-) Thanks!

>
> If we not use workq, once the request hold the mutex, we have to wait until
> the request finish,
> then release mutex, so the mmc core is blocking at here.
> To implement nonblocking request, we have to use workq.

One minor suggestion below, please consider this as an optimization
which goes outside the context of this patch.

There are cases when I think you should be able to skip the overhead
from scheduling the work from ->request(). Those cases can be
described as when the mutex are available which can be tested by using
mutex_trylock().

Kind regards
Uffe
