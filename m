Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaA1FWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 00:22:07 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:53200 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaA1FWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 00:22:05 -0500
MIME-Version: 1.0
In-Reply-To: <52E72573.9090108@intel.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
 <1390727338-20487-3-git-send-email-qiaowei.ren@intel.com> <52E6C33C.8050706@amacapital.net>
 <52E72573.9090108@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 27 Jan 2014 21:21:43 -0800
Message-ID: <CALCETrW0L79gjXRD5J5RZQTiZT+MYDYHQ0u7hoeKP=XVqDT5HA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] x86, mpx: hook #BR exception handler to allocate
 bound tables
To: Ren Qiaowei <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 7:35 PM, Ren Qiaowei <qiaowei.ren@intel.com> wrote:
> On 01/28/2014 04:36 AM, Andy Lutomirski wrote:
>>>
>>> +       bd_entry = status & MPX_BNDSTA_ADDR_MASK;
>>> +       if ((bd_entry >= bd_base) && (bd_entry < bd_base + bd_size))
>>> +               allocate_bt(bd_entry);
>>
>>
>> What happens if this fails?  Retrying forever isn't very nice.
>>
> If allocation of the bound table fail, the related entry in the bound
> directory is still invalid. The following access to this entry still produce
> #BR fault.
>

By the "following access" I think you mean the same instruction that
just trapped -- it will trap again because the exception hasn't been
fixed up.  Then mmap will fail again, and you'll retry again, leading
to an infinite loop.

I think that failure to fix up the exception should either let the
normal bounds error through or should raise SIGBUS.

>
>>> +       if (!user_mode(regs)) {
>>> +               if (!fixup_exception(regs)) {
>>> +                       tsk->thread.error_code = error_code;
>>> +                       tsk->thread.trap_nr = X86_TRAP_BR;
>>> +                       die("bounds", regs, error_code);
>>> +               }
>>
>>
>> Why the fixup?  Unless I'm missing something, the kernel has no business
>> getting #BR on access to a user address.
>>
>> Or are you adding code to allow the kernel to use MPX itself?  If so,
>> shouldn't this use an MPX-specific fixup to allow normal C code to use
>> this stuff?
>>
> It checks whether #BR come from user-space. You can see do_trap_no_signal().

Wasn't #BR using do_trap before?  do_trap doesn't call
fixup_exception.  I don't see why it should do it now.  (I also don't
think it should come from kernel space until someone adds kernel-mode
MPX support.)

>
>
>>> +               goto exit;
>>> +       }
>>> +
>>> +       if (!boot_cpu_has(X86_FEATURE_MPX)) {
>>> +               do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code,
>>> NULL);
>>> +               goto exit;
>>
>>
>> This, as well as the status == 0 case, should probably document that the
>> exception is from BOUND, not MPX.
>>
> Ok. I will add one comment for this.
>
>
>
>>> +               break;
>>> +
>>> +       case 1: /* Bound violation. */
>>> +       case 0: /* No MPX exception. */
>>> +               do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code,
>>> NULL);
>>> +               break;
>>
>>
>> What does "No Intel MPX exception" mean?  Surely that has business
>> sending #BR.
>>
> Oh. It comes from spec, and just mean it is not from MPX. :) I will change
> it to be accurate.
>
>
>>> +
>>> +       default:
>>> +               break;
>>
>>
>> What does status 3 mean?  The docs say "reserved".  Presumably this
>> should log and kill the process.
>
> I guess it should be a good suggestion.
>
> Thanks,
> Qiaowei
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
