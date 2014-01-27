Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaA0BkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 20:40:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:51788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbaA0BkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 20:40:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,726,1384329600"; 
   d="scan'208";a="444957530"
Message-ID: <52E5B7AA.9060205@intel.com>
Date: Mon, 27 Jan 2014 09:34:34 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86, mpx: extend siginfo structure to include
 bound violation information
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.02.1401252010400.10325@chino.kir.corp.google.com> <52E4919B.8050408@intel.com> <alpine.DEB.2.02.1401261335400.26515@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401261335400.26515@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 05:38 AM, David Rientjes wrote:
> On Sun, 26 Jan 2014, Ren Qiaowei wrote:
>
>>> arch/x86/kernel/mpx.c: In function ‘do_mpx_bounds’:
>>> arch/x86/kernel/mpx.c:407:3: warning: cast to pointer from integer of
>>> different size [-Wint-to-pointer-cast]
>>> arch/x86/kernel/mpx.c:409:3: warning: cast to pointer from integer of
>>> different size [-Wint-to-pointer-cast]
>>>
>>> and the documentation says you explicitly want to support this config.
>>>
>>> These types of warnings are usually indicative of real problems when
>>> you're storing upper and lower bits in 32-bit fields after casting them
>>> from 64-bit values.
>>>
>>> I'm also not sure if the added fields to the generic struct siginfo can be
>>> justified for this.
>>>
>> According to MPX spec, for 32-bit case, the upper 32-bits of 64-bits bound
>> register are ignored, and so casting to pointer from 64-bit values should be
>> not produce any problems.
>>
>
> Ok, so this is intended per the spec which nobody reading the code is
> going to know and people who report the compile warnings are going to
> continue to question it.
>
> How are you planning on suppressing the warnings?  It will probably
> require either
>
>   - separate 64-bit and 32-bit helper functions to do_mpx_bounds() to
>     do appropriate casts before casting to a pointer, or
>
>   - a macro defined as a no-op for 64-bit and as a cast to 32-bit value
>     for 32-bit configs that will be used in do_mpx_bounds() and casted
>     to the pointer.
>
I agree with you and we should suppress all the warnings as possible. If 
I use (unsgined long) to cast like the following code, what do you think 
about it? sizeof(long) will be 4 for 32-bit.

     info->si_lower = (void __user *)(unsigned long)
         (xsave_buf->bndregs.bndregs[2*bndregno]);
     info->si_upper = (void __user *)(unsigned long)
	(~xsave_buf->bndregs.bndregs[2*bndregno+1]);

Thanks,
Qiaowei
