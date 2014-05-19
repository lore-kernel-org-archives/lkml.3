Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaESWsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:48:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38729 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaESWsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:48:07 -0400
Message-ID: <537A8A03.8060604@zytor.com>
Date: Mon, 19 May 2014 15:47:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@kernel.org>
CC: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [GIT PULL] EFI changes for v3.16
References: <20140503130447.GW26088@console-pimps.org> <20140519105129.GF4798@console-pimps.org>
In-Reply-To: <20140519105129.GF4798@console-pimps.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 03:51 AM, Matt Fleming wrote:
> On Sat, 03 May, at 02:04:47PM, Matt Fleming wrote:
>> Folks, please queue the following change for v3.16 from Borislav that
>> uses the more strict kernel_fpu_{begin,end}() instead of the __*
>> verisons that won't catch buggy use in interrupt context.
>>
>> The following changes since commit e33655a386ed3b26ad36fb97a47ebb1c2ca1e928:
>>
>>   efivars: Add compatibility code for compat tasks (2014-04-17 13:53:53 +0100)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
>>
>> for you to fetch changes up to baa916f39b50ad91661534652110df40396acda0:
>>
>>   x86/efi: Check for unsafe dealing with FPU state in irq ctxt (2014-05-03 06:39:25 +0100)
>>
>> ----------------------------------------------------------------
>>  * Use the more strict FPU handling functions before invoking EFI
>>    services to catch misuse in irq context - Borislav Petkov
> 
> Ping?
> 

>     efi_call can happen in an irq context (pstore) and there we really need
>     to make sure we're not scribbling over FPU state while we've interrupted
>     a thread or kernel mode with a live FPU state. Therefore, use the
>     kernel_fpu_begin/end() variants which do that check.

How on earth does this solve anything?  The only thing we add here is a
WARN_ON_ONCE()... but the above text already tells us we have a problem.

It seems, rather, that we need to figure out how to deal with a pstore
in this case.  There are a few possibilities:

1. We could keep an XSAVE buffer area around for this particular use.
   I am *assuming* we don't let more than one CPU into EFI, because I
   cannot for my life imagine that this is safe in typical CPUs.

2. Drop the pstore on the floor if !irq_fpu_usable().

3. Allow the pstore, then die (on the assumption that we're dead
   anyway.)

Comments?

	-hpa

