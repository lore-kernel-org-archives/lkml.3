Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838AbaJUVwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:52:19 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34421 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbaJUVwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:52:17 -0400
Message-ID: <54465FBA.8070007@roeck-us.net>
Date: Tue, 21 Oct 2014 06:29:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGhpbGlwcGUgUsOpdG9ybmF6?= <philippe.retornaz@gmail.com>,
        linux-kernel@vger.kernel.org
CC: linux-pm@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-2-git-send-email-linux@roeck-us.net> <54460140.50805@gmail.com>
In-Reply-To: <54460140.50805@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020207.5446D591.01A0,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 9
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 9
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 11:46 PM, Philippe Rétornaz wrote:
> Hello
>
> [...]
>> - Use raw notifiers protected by spinlocks instead of atomic notifiers
> [...]
>
>> +/**
>> + *    do_kernel_power_off - Execute kernel poweroff handler call chain
>> + *
>> + *    Calls functions registered with register_power_off_handler.
>> + *
>> + *    Expected to be called from machine_power_off as last step of
>> + *    the poweroff sequence.
>> + *
>> + *    Powers off the system immediately if a poweroff handler function
>> + *    has been registered. Otherwise does nothing.
>> + */
>> +void do_kernel_power_off(void)
>> +{
>> +    spin_lock(&power_off_handler_lock);
>> +    raw_notifier_call_chain(&power_off_handler_list, 0, NULL);
>> +    spin_unlock(&power_off_handler_lock);
>> +}
>
> I don't get it. You are still in atomic context inside the poweroff callback
> since you lock it with a spinlock.
>
> It does not change much from the atomic notifier which was doing exactly the
> same thing but with RCU:
>
>     rcu_read_lock();
>     ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
>     rcu_read_unlock();
>
> Why not using the blocking_notifier_* family ?
> It will lock with a read-write semaphore under which you can sleep.
>
> For instance, twl4030_power_off will sleep, since it is doing I2C access.
> So you cannot call it in atomic context.
>

Learning something new all the time. I assumed that spin_lock (unlike
spin_lock_irqsafe) would not run in atomic context.

I did not want to use a sleeping lock because I am not sure if that
works for all architectures; some disable (local) interrupts before
calling the function (eg arm and arm64), and I don't want to change
that semantics.

I have another idea how to get there without changing the lock situation
while executing the call chain - just set a flag indicating that it is
running and execute it without lock. Would that work ?

Guenter

