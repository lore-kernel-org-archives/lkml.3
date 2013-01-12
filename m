Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3ALHvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 02:51:08 -0500
Received: from csamuel.org ([74.50.50.137]:33598 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab3ALHvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 02:51:06 -0500
Message-ID: <50F115CF.8050000@csamuel.org>
Date: Sat, 12 Jan 2013 18:50:39 +1100
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        dhowells@redhat.com
Subject: Re: [PATCH] MODSIGN: Warn when sign check fails due to -ENOKEY
References: <50EFDF15.4080606@csamuel.org> <CA+5PVA7F1RV3=Ynv+et=ZzOTRszop=sXY2QscuuHGO2RhLpSYg@mail.gmail.com>
In-Reply-To: <CA+5PVA7F1RV3=Ynv+et=ZzOTRszop=sXY2QscuuHGO2RhLpSYg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/13 00:49, Josh Boyer wrote:

> On Fri, Jan 11, 2013 at 4:44 AM, Chris Samuel <chris@csamuel.org> wrote:
 >
>> /* Please CC me in responses, I am not subscribed to LKML */
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 250092c..27de534 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -2443,8 +2443,10 @@ static int module_sig_check(struct load_info *info)
>>          if (err < 0 && fips_enabled)
>>                  panic("Module verification failed with error %d in FIPS
>> mode\n",
>>                        err);
>> -       if (err == -ENOKEY && !sig_enforce)
>> +       if (err == -ENOKEY && !sig_enforce) {
>> +               printk_once(KERN_DEBUG "Module verification failed, required
>> key not present, tainting kernel\n");
>>                  err = 0;
>> +       }
>>          return err;
>
> I'd suggest putting the printk in load_module where we call the
> add_taint_module function instead.

I did ponder that, but I used module_sig_check() instead as here we know 
explicitly that the failure is -ENOKEY, that information doesn't seem to 
get propagated back to load_module().

Looking at the code again though it seems that any other reason will 
make module_sig_check() return non-zero and hence cause the module to 
fail to load, so currently we can infer that the reason was -ENOKEY.

I'm happy either way, just my inner pedant thought this was better as in 
future module_sig_check() may find another reason to have to return with 
a zero status when modules aren't signed and so we can no longer tell 
the user the reason the signature failed.

Rusty, which is your preference?

> Also, you might want to make the priority a bit higher if it's meant
> to be informative.  Something like KERN_INFO.

Yup, sounds good, I see Rusty suggested KERN_NOTICE so I'll use that.

cheers,
Chris
-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
