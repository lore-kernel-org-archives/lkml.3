Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3COWAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:00:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38277 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab3COWAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:00:20 -0400
Message-ID: <5143990B.9000007@zytor.com>
Date: Fri, 15 Mar 2013 14:56:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Moore <pmoore@redhat.com>
CC: x86@kernel.org, keescook@chromium.org, linux-kernel@vger.kernel.org,
        coreyb@linux.vnet.ibm.com, wad@chromium.org,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH] x86: remove the x32 syscall bitmask from syscall_get_nr()
References: <20130215172143.12549.10292.stgit@localhost> <2012624.RMfkAO316Z@sifl> <1674827.FAh5HIjCC0@sifl>
In-Reply-To: <1674827.FAh5HIjCC0@sifl>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 02:15 PM, Paul Moore wrote:
> On Tuesday, February 26, 2013 03:58:23 PM Paul Moore wrote:
>> On Friday, February 15, 2013 12:21:43 PM Paul Moore wrote:
>>> Commit fca460f95e928bae373daa8295877b6905bc62b8 simplified the x32
>>> implementation by creating a syscall bitmask, equal to 0x40000000, that
>>> could be applied to x32 syscalls such that the masked syscall number
>>> would be the same as a x86_64 syscall.  While that patch was a nice
>>> way to simplify the code, it went a bit too far by adding the mask to
>>> syscall_get_nr(); returning the masked syscall numbers can cause
>>> confusion with callers that expect syscall numbers matching the x32
>>> ABI, e.g. unmasked syscall numbers.
>>>
>>> This patch fixes this by simply removing the mask from syscall_get_nr()
>>> while preserving the other changes from the original commit.  While
>>> there are several syscall_get_nr() callers in the kernel, most simply
>>> check that the syscall number is greater than zero, in this case this
>>> patch will have no effect.  Of those remaining callers, they appear
>>> to be few, seccomp and ftrace, and from my testing of seccomp without
>>> this patch the original commit definitely breaks things; the seccomp
>>> filter does not correctly filter the syscalls due to the difference in
>>> syscall numbers in the BPF filter and the value from syscall_get_nr().
>>> Applying this patch restores the seccomp BPF filter functionality on
>>> x32.
>>>
>>> I've tested this patch with the seccomp BPF filters as well as ftrace
>>> and everything looks reasonable to me; needless to say general usage
>>> seemed fine as well.
>>
>> I just wanted to check and see where things stood with this patch.  I'm not
>> overly concerned about how this problem is solved, just that it is solved. 
>> If someone else has a better approach that is fine with me; I'll even make
>> the offer to do additional testing if needed.
> 
> Anyone?  The seccomp filter bits are completely broken on x32 and I'd like to 
> get this fixed, if not with this patch then something else - I'm more than 
> happy to test/verify/etc whatever solution is deemed best ...
> 

Seems good to me -- H.J., do you seen any problem with this?

	-hpa

>>> Signed-off-by: Paul Moore <pmoore@redhat.com>
>>> Cc: stable@vger.kernel.org
>>> Cc: Will Drewry <wad@chromium.org>
>>> Cc: H. Peter Anvin <hpa@zytor.com>
>>> ---
>>>
>>>  arch/x86/include/asm/syscall.h |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/syscall.h
>>> b/arch/x86/include/asm/syscall.h index 1ace47b..2e188d6 100644
>>> --- a/arch/x86/include/asm/syscall.h
>>> +++ b/arch/x86/include/asm/syscall.h
>>> @@ -29,13 +29,13 @@ extern const unsigned long sys_call_table[];
>>>
>>>   */
>>>  
>>>  static inline int syscall_get_nr(struct task_struct *task, struct pt_regs
>>>
>>> *regs) {
>>> -	return regs->orig_ax & __SYSCALL_MASK;
>>> +	return regs->orig_ax;
>>>
>>>  }
>>>  
>>>  static inline void syscall_rollback(struct task_struct *task,
>>>  
>>>  				    struct pt_regs *regs)
>>>  
>>>  {
>>>
>>> -	regs->ax = regs->orig_ax & __SYSCALL_MASK;
>>> +	regs->ax = regs->orig_ax;
>>>
>>>  }
>>>  
>>>  static inline long syscall_get_error(struct task_struct *task,

