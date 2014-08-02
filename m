Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaHBGho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 02:37:44 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50384 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaHBGhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 02:37:43 -0400
Message-ID: <53DC8730.30706@hitachi.com>
Date: Sat, 02 Aug 2014 15:37:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Skip kretprobe hit in NMI context
 to avoid deadlock
References: <20140801084254.12330.64728.stgit@kbuild-fedora.novalocal> <20140801110029.GA31286@gmail.com>
In-Reply-To: <20140801110029.GA31286@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/01 20:00), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Skip kretprobe hit in NMI context, because if an NMI happens
>> inside the critical section protected by kretprobe_table.lock
>> and another(or same) kretprobe hit, pre_kretprobe_handler
>> tries to lock kretprobe_table.lock again.
>> Normal interrupts have no problem because they are disabled
>> with the lock.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> ---
>>  kernel/kprobes.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index 734e9a7..a537029 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -1778,6 +1778,12 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
>>  	unsigned long hash, flags = 0;
>>  	struct kretprobe_instance *ri;
>>  
>> +	/* To avoid deadlock, prohibit return probing in NMI context */
>> +	if (in_nmi()) {
> 
> Should be unlikely()?

Ah, Indeed.

> 
>> +		rp->nmissed++;
>> +		return 0;
> 
> In another place in this function we do:
> 
>         } else {
>                 rp->nmissed++;
>                 raw_spin_unlock_irqrestore(&rp->lock, flags);
>         }
> 
> Is it safe to modify rp-> without locking?

Yes, rp->nmissed is just for noticing the fault to users,
not for controlling.:) If we need more accurate value, we'd
better make it atomic_t.

Thank you,

> 
>> +	}
>> +
>>  	/*TODO: consider to only swap the RA after the last pre_handler fired */
> 
> Nit: That comment is oddly formatted.
> 
> Thanks,
> 
> 	Ingo
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


