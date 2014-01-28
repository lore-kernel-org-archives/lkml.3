Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaA1Dk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 22:40:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:25696 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbaA1Dkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 22:40:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,733,1384329600"; 
   d="scan'208";a="445595533"
Message-ID: <52E72573.9090108@intel.com>
Date: Tue, 28 Jan 2014 11:35:15 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-3-git-send-email-qiaowei.ren@intel.com> <52E6C33C.8050706@amacapital.net>
In-Reply-To: <52E6C33C.8050706@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 04:36 AM, Andy Lutomirski wrote:
>> +	bd_entry = status & MPX_BNDSTA_ADDR_MASK;
>> +	if ((bd_entry >= bd_base) && (bd_entry < bd_base + bd_size))
>> +		allocate_bt(bd_entry);
>
> What happens if this fails?  Retrying forever isn't very nice.
>
If allocation of the bound table fail, the related entry in the bound 
directory is still invalid. The following access to this entry still 
produce #BR fault.

>> +	if (!user_mode(regs)) {
>> +		if (!fixup_exception(regs)) {
>> +			tsk->thread.error_code = error_code;
>> +			tsk->thread.trap_nr = X86_TRAP_BR;
>> +			die("bounds", regs, error_code);
>> +		}
>
> Why the fixup?  Unless I'm missing something, the kernel has no business
> getting #BR on access to a user address.
>
> Or are you adding code to allow the kernel to use MPX itself?  If so,
> shouldn't this use an MPX-specific fixup to allow normal C code to use
> this stuff?
>
It checks whether #BR come from user-space. You can see do_trap_no_signal().

>> +		goto exit;
>> +	}
>> +
>> +	if (!boot_cpu_has(X86_FEATURE_MPX)) {
>> +		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
>> +		goto exit;
>
> This, as well as the status == 0 case, should probably document that the
> exception is from BOUND, not MPX.
>
Ok. I will add one comment for this.


>> +		break;
>> +
>> +	case 1: /* Bound violation. */
>> +	case 0: /* No MPX exception. */
>> +		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
>> +		break;
>
> What does "No Intel MPX exception" mean?  Surely that has business
> sending #BR.
>
Oh. It comes from spec, and just mean it is not from MPX. :) I will 
change it to be accurate.

>> +
>> +	default:
>> +		break;
>
> What does status 3 mean?  The docs say "reserved".  Presumably this
> should log and kill the process.
I guess it should be a good suggestion.

Thanks,
Qiaowei

