Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaA1GnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:43:05 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:53324 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaA1GnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:43:02 -0500
MIME-Version: 1.0
In-Reply-To: <52E742A0.8000209@intel.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
 <1390727338-20487-3-git-send-email-qiaowei.ren@intel.com> <52E6C33C.8050706@amacapital.net>
 <52E72573.9090108@intel.com> <CALCETrW0L79gjXRD5J5RZQTiZT+MYDYHQ0u7hoeKP=XVqDT5HA@mail.gmail.com>
 <52E742A0.8000209@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 27 Jan 2014 22:42:41 -0800
Message-ID: <CALCETrUr9FxtmB03XcAFCtWfbfVzLEPmSUZD9HnTqTinS+aWuQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] x86, mpx: hook #BR exception handler to allocate
 bound tables
To: Ren Qiaowei <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 9:39 PM, Ren Qiaowei <qiaowei.ren@intel.com> wrote:
> On 01/28/2014 01:21 PM, Andy Lutomirski wrote:
>>
>> On Mon, Jan 27, 2014 at 7:35 PM, Ren Qiaowei <qiaowei.ren@intel.com>
>> wrote:
>>>
>>> On 01/28/2014 04:36 AM, Andy Lutomirski wrote:
>>>>>
>>>>>
>>>>> +       bd_entry = status & MPX_BNDSTA_ADDR_MASK;
>>>>> +       if ((bd_entry >= bd_base) && (bd_entry < bd_base + bd_size))
>>>>> +               allocate_bt(bd_entry);
>>>>
>>>>
>>>>
>>>> What happens if this fails?  Retrying forever isn't very nice.
>>>>
>>> If allocation of the bound table fail, the related entry in the bound
>>> directory is still invalid. The following access to this entry still
>>> produce
>>> #BR fault.
>>>
>>
>> By the "following access" I think you mean the same instruction that
>> just trapped -- it will trap again because the exception hasn't been
>> fixed up.  Then mmap will fail again, and you'll retry again, leading
>> to an infinite loop.
>>
> I don't mean the same instruction that just trapped.

I haven't dug to the right page of the docs, I guess.  What is RIP set
to when an MPX instruction causes #BR?

It's *certainly* not okay to fail the fixup and skip the offending instruction.

>
>
>> I think that failure to fix up the exception should either let the
>> normal bounds error through or should raise SIGBUS.
>>
> Maybe we need HPA help answer this question. Peter, what do you think about
> it? If allocation of the bound table fail, what should we do?
>
>
>>>
>>>>> +       if (!user_mode(regs)) {
>>>>> +               if (!fixup_exception(regs)) {
>>>>> +                       tsk->thread.error_code = error_code;
>>>>> +                       tsk->thread.trap_nr = X86_TRAP_BR;
>>>>> +                       die("bounds", regs, error_code);
>>>>> +               }
>>>>
>>>>
>>>>
>>>> Why the fixup?  Unless I'm missing something, the kernel has no business
>>>> getting #BR on access to a user address.
>>>>
>>>> Or are you adding code to allow the kernel to use MPX itself?  If so,
>>>> shouldn't this use an MPX-specific fixup to allow normal C code to use
>>>> this stuff?
>>>>
>>> It checks whether #BR come from user-space. You can see
>>> do_trap_no_signal().
>>
>>
>> Wasn't #BR using do_trap before?  do_trap doesn't call
>> fixup_exception.  I don't see why it should do it now.  (I also don't
>> think it should come from kernel space until someone adds kernel-mode
>> MPX support.)
>>
> do_trap() -> do_trap_no_signal() call similar code to check if the fault
> occurred in userspace or kernel space. You can see previous discussion for
> the first version of this patchset.

I just read it.  do_trap_no_signal presumably calls fixup_exception
because #UD uses it and #UD needs that handling.  (I'm guessing that
there is actually a legitimate use for a kernel fixup on #UD somewhere
-- there's probably something that isn't covered by cpuid.)

There should not be a #BR from the kernel using the fixup mechanism.
IMO if the exception comes from the kernel, it should unconditionally
call die.

At some point there might be legitimate #BR faults from the kernel due
to actual in-kernel use of the MPX translation table.  This is a whole
different story.

(Presumably the right thing to do is to have gcc support for wide
pointers that contain their own bounds.)

--Andy
