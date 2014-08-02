Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaHBGl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 02:41:58 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46311 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaHBGl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 02:41:56 -0400
Message-ID: <53DC8822.9030901@gmail.com>
Date: Sat, 02 Aug 2014 14:41:38 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Richard Weinberger <richard@sigma-star.at>
CC: open list <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>
Subject: Re: [PATCH 18/43] score: Use get_signal() signal_setup_done()
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>	<1405951409-16953-19-git-send-email-richard@sigma-star.at> <CAF0htA4XuN035oYR5-13bzLnpHB1kUbe+igVstJ5QZXULbz58A@mail.gmail.com>
In-Reply-To: <CAF0htA4XuN035oYR5-13bzLnpHB1kUbe+igVstJ5QZXULbz58A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was merged into Score's git tree, and it will show in the next PULL 
request.

Best,
Lennox

Lennox Wu 於 2014/7/21 下午 10:47 寫道:
> I am picking up some missed patches and merging them into our git
> tree. If the patch is missed, we will merge it.
>
> Best,
> Lennox
>
> 2014-07-21 22:03 GMT+08:00 Richard Weinberger <richard@sigma-star.at>:
>> From: Richard Weinberger <richard@nod.at>
>>
>> Use the more generic functions get_signal() signal_setup_done()
>> for signal delivery.
>>
>> Acked-by: Lennox Wu <lennox.wu@gmail.com>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>   arch/score/kernel/signal.c | 43 ++++++++++++++++++-------------------------
>>   1 file changed, 18 insertions(+), 25 deletions(-)
>>
>> diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
>> index a00fba3..1651807 100644
>> --- a/arch/score/kernel/signal.c
>> +++ b/arch/score/kernel/signal.c
>> @@ -173,15 +173,15 @@ badframe:
>>          return 0;
>>   }
>>
>> -static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
>> -               int signr, sigset_t *set, siginfo_t *info)
>> +static int setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs,
>> +                         sigset_t *set)
>>   {
>>          struct rt_sigframe __user *frame;
>>          int err = 0;
>>
>> -       frame = get_sigframe(ka, regs, sizeof(*frame));
>> +       frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
>>          if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
>> -               goto give_sigsegv;
>> +               return -EFAULT;
>>
>>          /*
>>           * Set up the return code ...
>> @@ -194,7 +194,7 @@ static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
>>          err |= __put_user(0x80008002, frame->rs_code + 1);
>>          flush_cache_sigtramp((unsigned long) frame->rs_code);
>>
>> -       err |= copy_siginfo_to_user(&frame->rs_info, info);
>> +       err |= copy_siginfo_to_user(&frame->rs_info, &ksig->info);
>>          err |= __put_user(0, &frame->rs_uc.uc_flags);
>>          err |= __put_user(NULL, &frame->rs_uc.uc_link);
>>          err |= __save_altstack(&frame->rs_uc.uc_stack, regs->regs[0]);
>> @@ -202,26 +202,23 @@ static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
>>          err |= __copy_to_user(&frame->rs_uc.uc_sigmask, set, sizeof(*set));
>>
>>          if (err)
>> -               goto give_sigsegv;
>> +               return -EFAULT;
>>
>>          regs->regs[0] = (unsigned long) frame;
>>          regs->regs[3] = (unsigned long) frame->rs_code;
>> -       regs->regs[4] = signr;
>> +       regs->regs[4] = ksig->sig;
>>          regs->regs[5] = (unsigned long) &frame->rs_info;
>>          regs->regs[6] = (unsigned long) &frame->rs_uc;
>> -       regs->regs[29] = (unsigned long) ka->sa.sa_handler;
>> -       regs->cp0_epc = (unsigned long) ka->sa.sa_handler;
>> +       regs->regs[29] = (unsigned long) ksig->ka.sa.sa_handler;
>> +       regs->cp0_epc = (unsigned long) ksig->ka.sa.sa_handler;
>>
>>          return 0;
>> -
>> -give_sigsegv:
>> -       force_sigsegv(signr, current);
>> -       return -EFAULT;
>>   }
>>
>> -static void handle_signal(unsigned long sig, siginfo_t *info,
>> -       struct k_sigaction *ka, struct pt_regs *regs)
>> +static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>>   {
>> +       int ret;
>> +
>>          if (regs->is_syscall) {
>>                  switch (regs->regs[4]) {
>>                  case ERESTART_RESTARTBLOCK:
>> @@ -229,7 +226,7 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
>>                          regs->regs[4] = EINTR;
>>                          break;
>>                  case ERESTARTSYS:
>> -                       if (!(ka->sa.sa_flags & SA_RESTART)) {
>> +                       if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
>>                                  regs->regs[4] = EINTR;
>>                                  break;
>>                          }
>> @@ -245,17 +242,14 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
>>          /*
>>           * Set up the stack frame
>>           */
>> -       if (setup_rt_frame(ka, regs, sig, sigmask_to_save(), info) < 0)
>> -               return;
>> +       ret = setup_rt_frame(ksig, regs, sigmask_to_save());
>>
>> -       signal_delivered(sig, info, ka, regs, 0);
>> +       signal_setup_done(ret, ksig, 0);
>>   }
>>
>>   static void do_signal(struct pt_regs *regs)
>>   {
>> -       struct k_sigaction ka;
>> -       siginfo_t info;
>> -       int signr;
>> +       struct ksignal ksig;
>>
>>          /*
>>           * We want the common case to go fast, which is why we may in certain
>> @@ -265,10 +259,9 @@ static void do_signal(struct pt_regs *regs)
>>          if (!user_mode(regs))
>>                  return;
>>
>> -       signr = get_signal_to_deliver(&info, &ka, regs, NULL);
>> -       if (signr > 0) {
>> +       if (get_signal(&ksig)) {
>>                  /* Actually deliver the signal.  */
>> -               handle_signal(signr, &info, &ka, regs);
>> +               handle_signal(&ksig, regs);
>>                  return;
>>          }
>>
>> --
>> 1.8.4.5
>>
