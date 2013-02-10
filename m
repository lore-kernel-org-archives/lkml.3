Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096Ab3BJEgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 23:36:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47329 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761080Ab3BJEf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 23:35:59 -0500
Message-ID: <5117236D.5000607@zytor.com>
Date: Sat, 09 Feb 2013 20:34:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 2/5 -v2.1] x86: Detect CPUID support early at boot
References: <20130209231351.GB5556@pd.tnic> <1360451762-10175-1-git-send-email-bp@alien8.de>
In-Reply-To: <1360451762-10175-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2013 03:16 PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
>
> We detect CPUID function support on each CPU and save it for later use,
> obviating the need to play the toggle EFLAGS.ID game every time. C code
> is looking at ->cpuid_level anyway.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>   arch/x86/kernel/head_32.S | 48 +++++++++++++++++++++++------------------------
>   1 file changed, 23 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index f4d919e2cd2b..534397ba226c 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -318,30 +318,37 @@ default_entry:
>   	movl %eax,%cr0
>
>   /*
> - *	New page tables may be in 4Mbyte page mode and may
> - *	be using the global pages.
> + * Initialize EFLAGS. Some BIOSes leave bits like NT set. This would confuse the
> + * debugger if this code is traced. Best to initialize before switching to
> + * protected mode. As a side effect, we clear DF too because GCC expects it so.
> + */
> +	pushl $0
> +	popfl
> +

I wouldn't really call it a "side effect".  Perhaps the right thing here 
is to say something like "we want to start out with %eflags 
unambiguously clear".

(Note also we have had to CLD earlier because we have already copied the 
command line.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

