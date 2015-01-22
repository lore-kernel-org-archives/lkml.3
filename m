Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbbAVOxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:53:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47329 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbAVOxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:53:30 -0500
Message-ID: <54C10ED0.1010302@oracle.com>
Date: Thu, 22 Jan 2015 09:53:04 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, James Dingwall <james@dingwall.me.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.18.2 / xen 4.4.1 dom0 - microcode oops
References: <20150122055242.GA11089@dingwall.me.uk> <20150122082003.GA3441@pd.tnic> <54C10DB6.2050708@oracle.com>
In-Reply-To: <54C10DB6.2050708@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 09:48 AM, Boris Ostrovsky wrote:
> On 01/22/2015 03:20 AM, Borislav Petkov wrote:
>> Hmm,
>>
>> and I thought we fixed all that fun. It seems not :-\
>>
>> Boris, this paravirt_enabled() thing doesn't seem to work or why are we
>> even calling microcode_exit()?
>
> Looks like something is unloading microcode driver (init scripts 
> perhaps) and so we are trying to unregister device that we never 
> registered (because we had early return from microcode_init() when we 
> loaded it).
>
> I actually suspect the same bug would be triggered if dis_ucode_ldr is 
> true on baremetal.
>
> So we need something like:
>
> --- a/arch/x86/kernel/cpu/microcode/core.c
> +++ b/arch/x86/kernel/cpu/microcode/core.c
> @@ -625,6 +625,9 @@ static void __exit microcode_exit(void)
>  {
>         struct cpuinfo_x86 *c = &cpu_data(0);
>
> +       if (paravirt_enabled() || dis_ucode_ldr)
> +               return 0;

Plain 'return', of course.

Alternatively, we could return an error (-EINVAL?) from microcode_init() 
when either of these two conditions is true.

-boris

> +
>         microcode_dev_exit();
>
>         unregister_hotcpu_notifier(&mc_cpu_notifier);
>
>

