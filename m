Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3J1Oue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:50:34 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:33046 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab3J1Ou3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:50:29 -0400
Message-ID: <526E79A2.9080303@t-online.de>
Date: Mon, 28 Oct 2013 15:50:10 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request during
 shutdown
References: <525BD08C.2080101@t-online.de> <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com> <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com> <alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de> <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com> <20131026114303.GA24067@gmail.com>
In-Reply-To: <20131026114303.GA24067@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: ZASTkyZXrhUr34CKahQmpCe15l1HuRKhWcZ1icE+nStsFxnszfmd-y2ptF-Z9NPgSy
X-TOI-MSGID: 307d3a79-6ae3-49a5-b73f-9ae0e1ea9973
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.10.2013 13:43, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Fri, Oct 25, 2013 at 11:23 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>> Enable DEBUG_OBJECTS, DEBUG_OBJECTS_FREE, DEBUG_OBJECTS_TIMERS
>> Yes, but nobody has actually been able to trigger it with those.
>> It's pretty rare, and the debug options are so expensive that they
>> aren't reasonable to enable generally...
>>
>> So we need to try to figure out how to trigger it, or narrow
>> things down some way..
> If it's timing then maybe the 1 seconds delay isn't enough
> (especially if it's boot related, where we have a couple of delays
> already) - the patch below triples it.
>
> (If the bug goes away due to some other side effect then this patch
> won't make a difference to reproducability.)

I tried that patch, together with all the kobj debug options enabled.
With that kernel configuration I was unable to reproduce the problem
during  500 typical workload / reboot cycles. Without the debug
options  I was able to reproduce the last reported panic after 91 cycles.
The debug options seem to change timing sufficiently to mask the bug ;-(

Knut

> Thanks,
>
> 	Ingo
>
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 084f7b1..124188f 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -595,7 +595,7 @@ static void kobject_release(struct kref *kref)
>   	pr_info("kobject: '%s' (%p): %s, parent %p (delayed)\n",
>   		 kobject_name(kobj), kobj, __func__, kobj->parent);
>   	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
> -	schedule_delayed_work(&kobj->release, HZ);
> +	schedule_delayed_work(&kobj->release, 3*HZ);
>   #else
>   	kobject_cleanup(kobj);
>   #endif
>

