Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaFDO7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:59:16 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:55566 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaFDO7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:59:13 -0400
MIME-Version: 1.0
In-Reply-To: <538F1936.4000905@linaro.org>
References: <cover.1401841482.git.luto@amacapital.net> <1f7b2a25440561e49fb6d0bace3532b5df832ffd.1401841482.git.luto@amacapital.net>
 <538F1936.4000905@linaro.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Jun 2014 07:58:52 -0700
Message-ID: <CALCETrWW15tK8eYr74OhKfWTxWn3xj4C5moyLP_TFxN3DaVcng@mail.gmail.com>
Subject: Re: [PATCH 3/6] sched,idle: Clarify where TIF_NRFLAG_POLLING is set
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 6:03 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 06/04/2014 02:29 AM, Andy Lutomirski wrote:
>>
>> This doesn't change functionality at all, but I've misread this code
>> so many times that I want to make it a bit more obvious.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>   kernel/sched/idle.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
>> index 25b9423..2ec9f47 100644
>> --- a/kernel/sched/idle.c
>> +++ b/kernel/sched/idle.c
>> @@ -67,6 +67,10 @@ void __weak arch_cpu_idle(void)
>>    * cpuidle_idle_call - the main idle function
>>    *
>>    * NOTE: no locks or semaphores should be used here
>> + *
>> + * On archs that support TIF_POLLING_NRFLAG, is called with polling
>> + * set, and it returns with polling set.  If it ever stops polling, it
>> + * must clear the polling bit.
>>    */
>>   static void cpuidle_idle_call(void)
>>   {
>> @@ -178,7 +182,14 @@ exit_idle:
>>    */
>>   static void cpu_idle_loop(void)
>>   {
>> +       __current_set_polling();
>> +
>>         while (1) {
>> +               /*
>> +                * Invariant: polling is set here (assuming that the arch
>> +                * has a polling bit.
>> +                */
>> +
>
>
> nit : extra line
>

It was intentional: the comment is about this point in the loop, not
about the tick_nohz_idle_enter call.  I'm not attached to it, though.

>
>>                 tick_nohz_idle_enter();
>>
>>                 while (!need_resched()) {
>> @@ -239,7 +250,6 @@ void cpu_startup_entry(enum cpuhp_state state)
>>          */
>>         boot_init_stack_canary();
>>   #endif
>> -       __current_set_polling();
>
>
> I don't get the connection with the patch description.
>

In retrospect, I think I can just fold this patch with the one after
it.  I wrote this because I could never remember who is responsible
for setting polling in the first place.

--Andy
