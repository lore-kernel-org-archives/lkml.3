Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3DAGE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:04:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43066 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455Ab3DAGE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:04:26 -0400
Message-ID: <5159234E.8080105@ti.com>
Date: Mon, 1 Apr 2013 11:33:58 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] davinci: vpif: add pm_runtime support
References: <1364460632-21697-1-git-send-email-prabhakar.csengg@gmail.com> <1650338.UonQ4LqB70@avalon> <CA+V-a8uMaNKBXF-tJRtOMaYpjA1PsMA9qhG6MgwORTU8YRvDbQ@mail.gmail.com> <3365178.uRYh2rr3nD@avalon> <CA+V-a8sWCx1CpDbtDHVZKGpW2z1FrPpY1o3UJaoU6nEK9RN=Ug@mail.gmail.com>
In-Reply-To: <CA+V-a8sWCx1CpDbtDHVZKGpW2z1FrPpY1o3UJaoU6nEK9RN=Ug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/2013 3:50 PM, Prabhakar Lad wrote:
> Hi Laurent,
> 
> On Thu, Mar 28, 2013 at 3:40 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Prabhakar,
>>
>> On Thursday 28 March 2013 15:36:11 Prabhakar Lad wrote:
>>> On Thu, Mar 28, 2013 at 2:39 PM, Laurent Pinchart wrote:
>>>> On Thursday 28 March 2013 14:20:32 Prabhakar lad wrote:
>>>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>>
>>>>> Add pm_runtime support to the TI Davinci VPIF driver.
>>>>> Along side this patch replaces clk_get() with devm_clk_get()
>>>>> to simplify the error handling.
>>>>>
>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>> ---
>>>>>
>>>>>  drivers/media/platform/davinci/vpif.c |   21 +++++++++++----------
>>>>>  1 files changed, 11 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/davinci/vpif.c
>>>>> b/drivers/media/platform/davinci/vpif.c index 28638a8..7d14625 100644
>>>>> --- a/drivers/media/platform/davinci/vpif.c
>>>>> +++ b/drivers/media/platform/davinci/vpif.c
>>
>> [snip]
>>
>>>>> @@ -439,12 +440,17 @@ static int vpif_probe(struct platform_device *pdev)
>>>>>               goto fail;
>>>>>       }
>>>>>
>>>>> -     vpif_clk = clk_get(&pdev->dev, "vpif");
>>>>> +     vpif_clk = devm_clk_get(&pdev->dev, "vpif");
>>>>>       if (IS_ERR(vpif_clk)) {
>>>>>               status = PTR_ERR(vpif_clk);
>>>>>               goto clk_fail;
>>>>>       }
>>>>>
>>>>> -     clk_prepare_enable(vpif_clk);
>>>>> +     clk_put(vpif_clk);
>>>>
>>>> Why do you need to call clk_put() here ?
>>>
>>> The above check is to see if the clock is provided, once done
>>> we free it using clk_put().
>>
>> In that case you shouldn't use devm_clk_get(), otherwise clk_put() will be
>> called again automatically at remove() time.
>>
> Yes agreed it should be clk_get() only.
> 
>>>>> +     pm_runtime_enable(&pdev->dev);
>>>>> +     pm_runtime_resume(&pdev->dev);
>>>>> +
>>>>> +     pm_runtime_get(&pdev->dev);
>>>>
>>>> Does runtime PM automatically handle your clock ? If so can't you remove
>>>> clock handling from the driver completely ?
>>>
>>> Yes  pm runtime take care of enabling/disabling the clocks
>>> so that we don't have to do it in drivers. I believe clock
>>> handling is removed with this patch, with just  devm_clk_get() remaining ;)
>>
>> When is the clk_get() call expected to fail ? If the clock is provided by the
>> SoC and always available, can't the check be removed completely ?
>>
> Yes I agree with you it can be removed completely assuming the clock
> is always available from the Soc.
> But may be I need feedback from others Hans/Sekhar what do you suggest ?

Unless you need the clk handle to get the clock rate or something, you
should simply rely on runtime PM calls to enable clocks for you and not
have any clk API call at all in your driver.

Thanks,
Sekhar
