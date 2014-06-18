Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbaFRBNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:13:11 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43645 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbaFRBNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:13:08 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s5I1CRrX025598, This message is accepted by code: ctloc85258
Message-ID: <53A0E89F.9010006@realsil.com.cn>
Date: Wed, 18 Jun 2014 09:17:19 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>, <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 2/2] mmc: rtsx: add support for async request
References: <cover.1402037562.git.micky_ching@realsil.com.cn>	<7b58fb0b0915ea0b0838404c74ec22a3b6e5f5a8.1402037565.git.micky_ching@realsil.com.cn>	<CAPDyKFq1wYZRbuwhLjTMbwN1KYgKuNuZDb7t8FV78Pa=W85oqg@mail.gmail.com>	<539EB43B.8070707@realsil.com.cn>	<CAPDyKFqKDAqvacwCVKM8KLjxfykpBq38MS_RgWCcA7+He4_S5w@mail.gmail.com>	<539F9412.3010209@realsil.com.cn> <CAPDyKFqK8mLGc82FfEoxdHG7mioX7JmtFDO=18XZRkwQ4ykU2g@mail.gmail.com>
In-Reply-To: <CAPDyKFqK8mLGc82FfEoxdHG7mioX7JmtFDO=18XZRkwQ4ykU2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 03:45 PM, Ulf Hansson wrote:
> On 17 June 2014 03:04, micky <micky_ching@realsil.com.cn> wrote:
>> On 06/16/2014 08:40 PM, Ulf Hansson wrote:
>>> On 16 June 2014 11:09, micky <micky_ching@realsil.com.cn> wrote:
>>>> On 06/16/2014 04:42 PM, Ulf Hansson wrote:
>>>>>> @@ -36,7 +37,10 @@ struct realtek_pci_sdmmc {
>>>>>>>           struct rtsx_pcr         *pcr;
>>>>>>>           struct mmc_host         *mmc;
>>>>>>>           struct mmc_request      *mrq;
>>>>>>> +       struct workqueue_struct *workq;
>>>>>>> +#define SDMMC_WORKQ_NAME       "rtsx_pci_sdmmc_workq"
>>>>>>>
>>>>>>> +       struct work_struct      work;
>>>>> I am trying to understand why you need a work/workqueue to implement
>>>>> this feature. Is that really the case?
>>>>>
>>>>> Could you elaborate on the reasons?
>>>> Hi Uffe,
>>>>
>>>> we need return as fast as possible in mmc_host_ops request(ops->request)
>>>> callback,
>>>> so the mmc core can continue handle next request.
>>>> when next request everything is ready, it will wait previous done(if not
>>>> done),
>>>> then call ops->request().
>>>>
>>>> we can't use atomic context, because we use mutex_lock() to protect
>>> ops->request should never executed in atomic context. Is that your
>>> concern?
>> Yes.
> Okay. Unless I missed your point, I don't think you need the work/workqueue.
any other method?
>
> Because, ops->request isn't ever executed in atomic context. That's
> due to the mmc core, which handles the async mechanism, are waiting
> for a completion variable in process context, before it invokes the
> ops->request() callback.
>
> That completion variable will be kicked, from your host driver, when
> you invoke mmc_request_done(), .
Sorry, I don't understand here, how kicked?

I think the flow is:
- not wait for first req
- init mrq->done
- ops->request()                         ---         A.rtsx: start queue 
work.
- continue fetch next req
- prepare next req ok,
- wait previous done.                --- B.(mmc_request_done() may be 
called at any time from A to B)
- init mrq->done
- ops->request()                         ---         C.rtsx: start queue 
next work.
...
and seems no problem.

Best Regards.
micky.
> Kind regards
> Uffe
>
>>>
>>>> resource, and we have to hold the lock during handle request.
>>>> So I use workq, we just queue a work and return in ops->request(),
>>>> The mmc core can continue without blocking at ops->request().
>>>>
>>>> Best Regards.
>>>> micky.
>>> Kind regards
>>> Uffe
>>> .
>>>
> .
>

