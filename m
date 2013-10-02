Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3JBB6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:58:44 -0400
Received: from blu0-omc1-s32.blu0.hotmail.com ([65.55.116.43]:12373 "EHLO
	blu0-omc1-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860Ab3JBB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:58:41 -0400
X-TMN: [kvig5lNb5sDR0/RvOuXAKqCb/zhMCTH9]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP14B0EBB3853FE8B06192DB97160@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1380667842.2081.33.camel@dabdike>
Subject: Re: [PATCH] [workqueue] check values of pwq and wq in print_worker_info() before use
References: <20131001203520.GA8248@p100.box> <20131001204352.GA27149@mtj.dyndns.org> <1380663645.2081.29.camel@dabdike> <524B47A8.1010701@gmx.de> <1380667842.2081.33.camel@dabdike>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Tue, 1 Oct 2013 21:58:23 -0400
CC: Helge Deller <deller@gmx.de>, Tejun Heo <tj@kernel.org>,
        Libin <huawei.libin@huawei.com>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 02 Oct 2013 01:58:39.0776 (UTC) FILETIME=[EA131A00:01CEBF12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1-Oct-13, at 6:50 PM, James Bottomley wrote:

> On Wed, 2013-10-02 at 00:07 +0200, Helge Deller wrote:
>> On 10/01/2013 11:40 PM, James Bottomley wrote:
>>> On Tue, 2013-10-01 at 16:43 -0400, Tejun Heo wrote:
>>>> Hello,
>>>>
>>>> On Tue, Oct 01, 2013 at 10:35:20PM +0200, Helge Deller wrote:
>>>>> print_worker_info() includes no validity check on the pwq and wq
>>>>> pointers before handing them over to the probe_kernel_read()  
>>>>> functions.
>>>>>
>>>>> It seems that most architectures don't care about that, but at  
>>>>> least on
>>>>> the parisc architecture this leads to a kernel crash since  
>>>>> accesses to
>>>>> page zero are protected by the kernel for security reasons.
>>>>>
>>>>> Fix this problem by verifying the contents of pwq and wq before  
>>>>> usage.
>>>>> Even if probe_kernel_read() usually prevents such crashes by  
>>>>> disabling
>>>>> page faults, clean code should always include such checks.
>>>>>
>>>>> Without this fix issuing "echo t > /proc/sysrq-trigger" will  
>>>>> immediately
>>>>> crash the Linux kernel on the parisc architecture.
>>>>
>>>> Hmm... um had similar problem but the root cause here is that the  
>>>> arch
>>>> isn't implementing probe_kernel_read() properly.  We really have no
>>>> idea what the pointer value may be at the dump point and that's  
>>>> why we
>>>> use probe_kernel_read().  If something like the above is  
>>>> necessary for
>>>> the time being, the correct place would be the arch
>>>> probe_kernel_read() implementation.  James, would it be difficult
>>>> implement proper probe_kernel_read() on parisc?
>>>
>>> The problem seems to be that some traps bypass our exception table
>>> handling.
>>
>> Yes, that's correct.
>> It's trap #26 and we directly call parisc_terminate() for  
>> fault_space==0
>> without checking the exception table.
>> See my patch I posted a few hours ago which fixes this:
>> https://patchwork.kernel.org/patch/2971701/
>
> That doesn't quite look right ... I guessed it was probably access
> rights, so we should do an exception table fixup, so isn't this the  
> fix?
> because we shouldn't call do_page_fault if there's no exception table.
>
> James
>
> ---
> diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
> index 04e47c6..25a088a 100644
> --- a/arch/parisc/kernel/traps.c
> +++ b/arch/parisc/kernel/traps.c
> @@ -684,6 +684,8 @@ void notrace handle_interruption(int code,  
> struct pt_regs *regs)
> 		/* Fall Through */
> 	case 26:
> 		/* PCXL: Data memory access rights trap */
> +		if (!user_mode(regs) && fixup_exception(regs))
> +			return;
> 		fault_address = regs->ior;
> 		fault_space   = regs->isr;
> 		break;


With this change, boot on rp3440 hangs here:

Freeing unused kernel memory: 256K (000000004079c000 - 00000000407dc000)
Loading, please wait...

Dave
--
John David Anglin	dave.anglin@bell.net



