Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbbAXNjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 08:39:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbbAXNjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 08:39:39 -0500
Message-ID: <54C3A08D.3070301@redhat.com>
Date: Sat, 24 Jan 2015 08:39:25 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: question about save_xstate_sig() - WHY DOES THIS WORK?
References: <54C2A245.4010307@redhat.com> <54C2B80B.8050501@zytor.com>
In-Reply-To: <54C2B80B.8050501@zytor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/23/2015 04:07 PM, H. Peter Anvin wrote:
> On 01/23/2015 11:34 AM, Rik van Riel wrote:
>> While working on a patch series to defer FPU state loading until 
>> kernel -> user space transition, and be more lazy with FPU state 
>> while in the kernel, I came across this code in
>> save_xstate_sig().
>> 
>> Not only is this broken with my new code, but it looks like it
>> may be broken with the current code, too...
>> 
>> Specifically, save_user_xstate() may page fault and sleep. After 
>> returning from the page fault, there is no guarantee that the FPU
>> state will be restored into the CPU, when the system is not 
>> running with eager fpu mode.
>> 
>> In that case, what prevents us from saving random FPU register
>> state to the user's stack frame?  Potentially state containing
>> data from other programs...
>> 
> 
> If the FPU state is not current, we'll have CR0.TS = 1 and the
> XSAVE will cause an #NM exception, which will cause the FPU state
> to be swapped in.

OK, so the code works as it is right now, but I still need
to have the patch in my "defer FPU state loading and CR0.TS
switching to kernel -> user space transition" patch series.

Thanks for explaining why the current code is safe, Peter.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUw6CNAAoJEM553pKExN6DIkIH/jYpLRfVSbx+JBuFtOibA6jk
wwWnwNdPRUiWf0v0lSNX4phk9f7VCy8WKbrFtC0IYdGLL0zCY94dN7us4hNYo9fE
btdb/qsvqq8w2esPuUczAgaxwipYVliDUDOHSXTRbPS2upBuLHl/CVIVb1A+HVC7
gB6GF4ZLa2P1ygcjuWDNDNtx04QWTi7K80eWtWAQ7U4OK9Y4fSgR3hOIJS79M/aJ
P9YGaTyo0zDQcKx1rFXTjl9A0slCFZ+QkAeCwLZRkXc1K9n50GANuYeg53/ATYey
7x0FjZEBD2ipX60FqZ+mYAiA7rqw4RYKgAttszy9b9bgKY/fzHy87z2YS8Umplg=
=55wt
-----END PGP SIGNATURE-----
