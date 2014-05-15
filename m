Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaEOMIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:08:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbaEOMIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:08:17 -0400
Message-ID: <5374AE24.1030302@redhat.com>
Date: Thu, 15 May 2014 13:08:04 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: mikey@neuling.org, avagin@openvz.org, oleg@redhat.com,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com> <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com> <537252C0.6090005@redhat.com> <53730326.6000400@linux.vnet.ibm.com> <53735044.5030008@redhat.com> <537479FD.2010200@linux.vnet.ibm.com>
In-Reply-To: <537479FD.2010200@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 09:25 AM, Anshuman Khandual wrote:
> On 05/14/2014 04:45 PM, Pedro Alves wrote:
>> On 05/14/14 06:46, Anshuman Khandual wrote:
>>> On 05/13/2014 10:43 PM, Pedro Alves wrote:
>>>> On 05/05/14 08:54, Anshuman Khandual wrote:
>>>>> This patch enables get and set of transactional memory related register
>>>>> sets through PTRACE_GETREGSET/PTRACE_SETREGSET interface by implementing
>>>>> four new powerpc specific register sets i.e REGSET_TM_SPR, REGSET_TM_CGPR,
>>>>> REGSET_TM_CFPR, REGSET_CVMX support corresponding to these following new
>>>>> ELF core note types added previously in this regard.
>>>>>
>>>>> 	(1) NT_PPC_TM_SPR
>>>>> 	(2) NT_PPC_TM_CGPR
>>>>> 	(3) NT_PPC_TM_CFPR
>>>>> 	(4) NT_PPC_TM_CVMX
>>>>
>>>> Sorry that I couldn't tell this from the code, but, what does the
>>>> kernel return when the ptracer requests these registers and the
>>>> program is not in a transaction?  Specifically I'm wondering whether
>>>> this follows the same semantics as the s390 port.
>>>>
>>>
>>> Right now, it still returns the saved state of the registers from thread
>>> struct. I had assumed that the user must know the state of the transaction
>>> before initiating the ptrace request. I guess its better to check for
>>> the transaction status before processing the request. In case if TM is not
>>> active on that thread, we should return -EINVAL.
>>
>> I think s390 returns ENODATA in that case.
>>
>>  https://sourceware.org/ml/gdb-patches/2013-06/msg00273.html
>>
>> We'll want some way to tell whether the system actually
>> supports this.  That could be ENODATA vs something-else (EINVAL
>> or perhaps better EIO for "request is invalid").
> 
> As Mickey has pointed out, the transaction memory support in the system can be
> checked from the HWCAP2 flags. So when the transaction is not active, we will
> return ENODATA instead for TM related ptrace regset requests.

Returning ENODATA when the transaction is not active, like
s390 is great.  Thank you.

But I think it's worth it to consider what should the kernel
return when the machine doesn't have these registers at all.

Sure, for this case we happen to have the hwcap flag.  But in
general, I don't know whether we will always have a hwcap bit
for each register set that is added.  Maybe we will, so that
the info ends up in core dumps.

Still, I think it's worth to consider this case in the
general sense, irrespective of hwcap.

That is, what should PTRACE_GETREGSET/PTRACE_SETREGSET return
when the machine doesn't have the registers at all.  We shouldn't
need to consult something elsewhere (like hwcap) to determine
what ENODATA means.  The kernel knows it right there.  I think
s390 goofed here.

Taking a look at x86, for example, we see:

	[REGSET_XSTATE] = {
		.core_note_type = NT_X86_XSTATE,
		.size = sizeof(u64), .align = sizeof(u64),
		.active = xstateregs_active, .get = xstateregs_get,
		.set = xstateregs_set
	},

Note that it installs the ".active" hook.

 24 /**
 25  * user_regset_active_fn - type of @active function in &struct user_regset
 26  * @target:     thread being examined
 27  * @regset:     regset being examined
 28  *
 29  * Return -%ENODEV if not available on the hardware found.
 30  * Return %0 if no interesting state in this thread.
 31  * Return >%0 number of @size units of interesting state.
 32  * Any get call fetching state beyond that number will
 33  * see the default initialization state for this data,
 34  * so a caller that knows what the default state is need
 35  * not copy it all out.
 36  * This call is optional; the pointer is %NULL if there
 37  * is no inexpensive check to yield a value < @n.
 38  */
 39 typedef int user_regset_active_fn(struct task_struct *target,
 40                                   const struct user_regset *regset);
 41

Note the mention of ENODEV.

I couldn't actually find any arch that currently returns -ENODEV in
the "active" hook.  I see that binfmt_elf.c doesn't handle
regset->active() returning < 0.  Guess that may be why.  Looks like
something that could be cleaned up, to me.

Anyway, notice x86's REGSET_XSTATE regset->get hook:

int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
		unsigned int pos, unsigned int count,
		void *kbuf, void __user *ubuf)
{
	int ret;

	if (!cpu_has_xsave)
		return -ENODEV;
        ^^^^^^^^^^^^^^^^^^^^^^

And then we see that xfpregs_get has a similar ENODEV case.

So in sum, it very much looks like the intention is for
PTRACE_GETREGSET/PTRACE_SETREGSET to return ENODEV in the
case the regset doesn't exist on the running machine, and then
it looks like at least x86 works that way.

-- 
Pedro Alves

