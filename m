Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523Ab3GRWRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:17:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:38782 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932956Ab3GRWRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:17:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,696,1367996400"; 
   d="scan'208";a="333556320"
Message-ID: <51E8696A.7090406@intel.com>
Date: Fri, 19 Jul 2013 00:17:14 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak <ak@linux.intel.com>,
        rjw@rjwysocki.net
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>  <1374098936.22432.322.camel@schen9-DESK>  <201307180347.r6I3l5e9077577@www262.sakura.ne.jp> <1374181200.22432.350.camel@schen9-DESK>
In-Reply-To: <1374181200.22432.350.camel@schen9-DESK>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6IMHTOR006586

On 7/18/2013 11:00 PM, Tim Chen wrote:
> On Thu, 2013-07-18 at 12:47 +0900, Tetsuo Handa wrote:
>> Tim Chen wrote:
>>>>> Your approach is quite complicated.  I think something simpler like the
>>>>> following will work:
>>>> We cannot benefit from PCLMULQDQ. Is it acceptable for you?
>>>
>>> The following code in crct10dif-pclmul_glue.c
>>>
>>> static const struct x86_cpu_id crct10dif_cpu_id[] = {
>>>          X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
>>>          {}
>>> };
>>> MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
>>>
>>> will put the module in the device table and get the module
>>> loaded, as long as the cpu support PCLMULQDQ. So we should be able
>>> to benefit.
>> Excuse me, how can crct10dif-pclmul.ko get loaded automatically?
>> Did you test CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m with below debug message?
> The code:
>
> static const struct x86_cpu_id crct10dif_cpu_id[] = {
>           X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
>           {}
> };
> MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
>
> causes the following line to be added to modules.alias file:
>
> alias x86cpu:vendor:*:family:*:model:*:feature:*0081* crct10dif_pclmul
>
> This should cause udev to load the crct10dif_pclml module when cpu
> support the PCLMULQDQ (feature code 0081).  I did my testing during
> development on 3.10 and the module was indeed loaded.
>
> However, I found that the following commit under 3.11-rc1 broke
> the mechanism after some bisection.
>
> commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Fri May 3 00:26:22 2013 +0200
>
>      ACPI / processor: Use common hotplug infrastructure
>      
>      Split the ACPI processor driver into two parts, one that is
>      non-modular, resides in the ACPI core and handles the enumeration
>      and hotplug of processors and one that implements the rest of the
>      existing processor driver functionality.
>      
> Rafael, can you check and see if this can be fixed so those optimized
> crypto modules for Intel cpu that support them can be loaded?

I think this is an ordering issue between udev startup and the time when 
devices are registered.

I wonder what happens if you put those modules into the initramfs image?

Rafael


> Herbert, we had a discussion earlier on a separate issue regarding the
> module load order.  We wanted to load all supported crypto t10dif modules
> before the crc-t10dif module.  You mentioned that the MODULE_ALIAS also
> need some fixing and wonder if those changes have been merged into
> 3.11-rc1?  See https://lkml.org/lkml/2013/5/21/216 .  Theoretically, that
> fix should also get all the crypto modules support t10dif be loaded.
>
> Thanks.
>
> Tim
>
>> diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
>> index 7845d7f..a8a95aa 100644
>> --- a/arch/x86/crypto/crct10dif-pclmul_glue.c
>> +++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
>> @@ -129,9 +129,10 @@ MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
>>   
>>   static int __init crct10dif_intel_mod_init(void)
>>   {
>> +	printk(KERN_WARNING "********** Checking for X86_FEATURE_PCLMULQDQ\n");
>>   	if (!x86_match_cpu(crct10dif_cpu_id))
>>   		return -ENODEV;
>> -
>> +	printk(KERN_WARNING "********** Registering crct10dif-pclmul\n");
>>   	return crypto_register_shash(&alg);
>>   }
>>
>> As far as I tested, crct10dif-pclmul.ko will not be loaded unless manually
>> adding "modprobe crct10dif-pclmul" to initramfs's /init or choosing
>> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y.
>>
>>> So as long as the crct10dif.ko and crct10dif-pclmul.ko are loaded,
>>> the pclmulqdq t10dif will have a higher priority and get allocated
>>> and used.
>> What I'm talking are
>>
>>    (1) Since mkinitramfs is unable to know that crct10dif-pclmul.ko has higher
>>        priority than crct10dif.ko , mkinitramfs will not include
>>        "modprobe crct10dif-pclmul" line in the generated initramfs.
>>
>>    (2) In order to get benefit from PCLMULQDQ, users have to manually make sure
>>        that "modprobe crct10dif-pclmul" is called before crc-t10dif.ko (which is
>>        loaded before sd_mod.ko is loaded) is loaded by their initramfs's /init
>>        script.
>>
>>    (3) The cause of (1) is that crct10dif-pclmul.ko will not be loaded
>>        automatically unless choosing CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y.
>>
>>    (4) The cause of (3) is that modules.dep does not describe that users will
>>        benefit by loading crct10dif-pclmul.ko before loading crc-t10dif.ko .
>>
>>    (5) Currently crct10dif-pclmul.ko cannot be loaded if PCLMULQDQ is not
>>        supported. This leads to boot failure (since sd_mod.ko cannot be loaded)
>>        if modules.dep says that "crct10dif-pclmul.ko is required by
>>        crc-t10dif.ko".
>>
>>    (6) To solve (4) and (5), modules.dep should say "crct10dif-pclmul.ko is
>>        preferred for crc-t10dif.ko but is not required by crc-t10dif.ko".
>>        But there is no such mechanism. Thus, currently available choice is
>>        "allow loading crct10dif-pclmul.ko even if PCLMULQDQ is not supported"
>>        or "ignore errors by built-in the crct10dif-pclmul.ko module".
>>
>> My patch (b) seems to be complicated but is required in order to solve (4)
>> without asking users to manually add "modprobe crct10dif-pclmul" into their
>> initramfs. If we choose patch (b) rather than patch (a), we need to solve (5).
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
