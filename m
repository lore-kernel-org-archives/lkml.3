Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3ALBRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 20:17:33 -0500
Received: from ozlabs.org ([203.10.76.45]:53486 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab3ALBRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 20:17:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@gmail.com>, Chris Samuel <chris@csamuel.org>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH] MODSIGN: Warn when sign check fails due to -ENOKEY
In-Reply-To: <CA+5PVA7F1RV3=Ynv+et=ZzOTRszop=sXY2QscuuHGO2RhLpSYg@mail.gmail.com>
References: <50EFDF15.4080606@csamuel.org> <CA+5PVA7F1RV3=Ynv+et=ZzOTRszop=sXY2QscuuHGO2RhLpSYg@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sat, 12 Jan 2013 11:00:02 +1030
Message-ID: <87vcb3z1it.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@gmail.com> writes:

> On Fri, Jan 11, 2013 at 4:44 AM, Chris Samuel <chris@csamuel.org> wrote:
>> /* Please CC me in responses, I am not subscribed to LKML */
>>
>> Currently if a signature check fails on module load due to not having
>> the appropriate key (-ENOKEY) and we are not doing strict checking
>> there is no information provided to the user other than the lock debug
>> taint warning:
>>
>> Disabling lock debugging due to kernel taint
>>
>> This patch causes a single warning to be emitted to explain why the
>> kernel is being tainted, before the above taint warning occurs.
>>
>> Module verification failed, required key not present, tainting kernel
>>
>> Found whilst trying to work out why all the 3.8 development kernels
>> I was building and testing were warning about taints and why all modules
>> were listed as forced load (F) in /proc/modules when that wasn't the
>> case in the 3.5, 3.6 or 3.7 kernels I'd tried.
>>
>> Signed-off-by: Christopher Samuel <chris@csamuel.org>
>> ---
>>  kernel/module.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 250092c..27de534 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -2443,8 +2443,10 @@ static int module_sig_check(struct load_info *info)
>>         if (err < 0 && fips_enabled)
>>                 panic("Module verification failed with error %d in FIPS
>> mode\n",
>>                       err);
>> -       if (err == -ENOKEY && !sig_enforce)
>> +       if (err == -ENOKEY && !sig_enforce) {
>> +               printk_once(KERN_DEBUG "Module verification failed, required
>> key not present, tainting kernel\n");
>>                 err = 0;
>> +       }
>>         return err;
>
> I'd suggest putting the printk in load_module where we call the
> add_taint_module function instead.  Also, you might want to make the
> priority a bit higher if it's meant to be informative.  Something like
> KERN_INFO.

Agreed.  KERN_NOTICE, I think: we really want to see if someone's
inserting an unsigned module!

Cheers,
Rusty.
