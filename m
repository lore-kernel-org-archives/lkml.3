Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3GYQka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:40:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab3GYQk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:40:28 -0400
Message-ID: <51F154F2.20400@redhat.com>
Date: Fri, 26 Jul 2013 00:40:18 +0800
From: Zhouping Liu <zliu@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [s390x] build error: undefined reference to `sie_exit'
References: <209887675.5191065.1374718087774.JavaMail.root@redhat.com> <1999182864.5191140.1374718153443.JavaMail.root@redhat.com> <20130725092123.GD4288@osiris>
In-Reply-To: <20130725092123.GD4288@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 05:21 PM, Heiko Carstens wrote:
> On Wed, Jul 24, 2013 at 10:09:13PM -0400, Zhouping Liu wrote:
>> Hello All,
>>
>> I met the below error on b3a3a9c441 with s390x arch:
>> arch/s390/built-in.o: In function `sys_call_table_emu':
>> (.rodata+0x2b98): undefined reference to `sie_exit'
>> arch/s390/built-in.o: In function `sys_call_table_emu':
>> (.rodata+0x2ba0): undefined reference to `sie_exit'
>> make: *** [vmlinux] Error 1
> Thanks for reporting, I just committed the patch below to our
> local branch:
>
>  From c073dc1f474094b5610739e752d83bcb547b1d7d Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Thu, 25 Jul 2013 11:16:48 +0200
> Subject: [PATCH] s390/perf: fix compile error (undefined reference sie_exit)
>
> The perf_event code references sie_exit even if KVM is not available.
> So add proper ifdefs to fix this one:
>
> arch/s390/built-in.o: In function `sys_call_table_emu':
> (.rodata+0x2b98): undefined reference to `sie_exit'
> arch/s390/built-in.o: In function `sys_call_table_emu':
> (.rodata+0x2ba0): undefined reference to `sie_exit'
> make: *** [vmlinux] Error 1

The patch is good for me.

Tested-by: Zhouping Liu <zliu@redhat.com>

Thanks,
Zhouping

> Reported-by: Zhouping Liu <zliu@redhat.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>   arch/s390/kernel/perf_event.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/s390/kernel/perf_event.c b/arch/s390/kernel/perf_event.c
> index a6fc037..500aa10 100644
> --- a/arch/s390/kernel/perf_event.c
> +++ b/arch/s390/kernel/perf_event.c
> @@ -52,12 +52,13 @@ static struct kvm_s390_sie_block *sie_block(struct pt_regs *regs)
>   
>   static bool is_in_guest(struct pt_regs *regs)
>   {
> -	unsigned long ip = instruction_pointer(regs);
> -
>   	if (user_mode(regs))
>   		return false;
> -
> -	return ip == (unsigned long) &sie_exit;
> +#if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
> +	return instruction_pointer(regs) == (unsigned long) &sie_exit;
> +#else
> +	return false;
> +#endif
>   }
>   
>   static unsigned long guest_is_user_mode(struct pt_regs *regs)

