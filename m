Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935052AbaEaDqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 23:46:45 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33458 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbaEaDqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 23:46:44 -0400
Message-ID: <538950A6.6020300@linaro.org>
Date: Fri, 30 May 2014 22:46:46 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, mporter@linaro.org,
        bcm@fixthebug.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] clk: kona: allow nested ccu_write_enable() requests
References: <1401483188-5395-1-git-send-email-elder@linaro.org> <1401483188-5395-2-git-send-email-elder@linaro.org> <20140530232822.10062.26597@quantum>
In-Reply-To: <20140530232822.10062.26597@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 06:28 PM, Mike Turquette wrote:
> Quoting Alex Elder (2014-05-30 13:53:02)
>> Use a counter rather than a Boolean to track whether write access to
>> a CCU has been enabled or not.  This will allow more than one of
>> these requests to be nested.
>>
>> Note that __ccu_write_enable() and __ccu_write_disable() calls all
>> come in pairs, and they are always surrounded immediately by calls
>> to ccu_lock() and ccu_unlock().
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  drivers/clk/bcm/clk-kona.c | 14 ++++----------
>>  drivers/clk/bcm/clk-kona.h |  2 +-
>>  2 files changed, 5 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
>> index 95af2e6..ee8e988 100644
>> --- a/drivers/clk/bcm/clk-kona.c
>> +++ b/drivers/clk/bcm/clk-kona.c
>> @@ -170,13 +170,8 @@ static inline void ccu_unlock(struct ccu_data *ccu, unsigned long flags)
>>   */
>>  static inline void __ccu_write_enable(struct ccu_data *ccu)
> 
> Per Documentation/CodingStyle, chapter 15, "the inline disease", it
> might be best to not inline these functions.

This was not intentional.  I normally only inline things
defined in header files, and maybe this is an artifact of
having been in a header at one time.  I don't know, I'll get
rid of the inline.

> 
>>  {
>> -       if (ccu->write_enabled) {
>> -               pr_err("%s: access already enabled for %s\n", __func__,
>> -                       ccu->name);
>> -               return;
>> -       }
>> -       ccu->write_enabled = true;
>> -       __ccu_write(ccu, 0, CCU_ACCESS_PASSWORD | 1);
>> +       if (!ccu->write_enabled++)
>> +               __ccu_write(ccu, 0, CCU_ACCESS_PASSWORD | 1);
>>  }
>>  
>>  static inline void __ccu_write_disable(struct ccu_data *ccu)
>> @@ -186,9 +181,8 @@ static inline void __ccu_write_disable(struct ccu_data *ccu)
>>                         ccu->name);
>>                 return;
>>         }
>> -
>> -       __ccu_write(ccu, 0, CCU_ACCESS_PASSWORD);
>> -       ccu->write_enabled = false;
>> +       if (!--ccu->write_enabled)
>> +               __ccu_write(ccu, 0, CCU_ACCESS_PASSWORD);
> 
> What happens if calls to __ccu_write_enable and __ccu_write_disable are
> unbalanced? It would be better to catch that case and throw a WARN:

You can't see it in the diff, but that's what happens
(well, it's a pr_err(), not a WARN()).   I think a WARN()
is probably right in this case though.

> 	if (WARN_ON(ccu->write_enabled == 0))
> 		return;
> 
> 	if (--ccu->write_enabled > 0)
> 		return;
> 
> 	__ccu_write(ccu, 0, CCU_ACCESS_PASSWORD);
> 
>>  }
>>  
>>  /*
>> diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
>> index 2537b30..e9a8466 100644
>> --- a/drivers/clk/bcm/clk-kona.h
>> +++ b/drivers/clk/bcm/clk-kona.h
>> @@ -478,7 +478,7 @@ struct ccu_policy {
>>  struct ccu_data {
>>         void __iomem *base;     /* base of mapped address space */
>>         spinlock_t lock;        /* serialization lock */
>> -       bool write_enabled;     /* write access is currently enabled */
>> +       u32 write_enabled;      /* write access enable count */
> 
> Why u32? An unsigned int will do just nicely here.

That's a preference of mine.  I almost always favor
using u32, etc. because they are compact, and explicit
about the size and signedness.  I "know" an int is 32
bits, but I still prefer being explicit.

I'll interpret this as a preference on your part for
unsigned int, and I have no problem making that change.

					-Alex

> Regards,
> Mike
> 
>>         struct ccu_policy policy;
>>         struct list_head links; /* for ccu_list */
>>         struct device_node *node;
>> -- 
>> 1.9.1
>>

