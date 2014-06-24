Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaFXS0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:26:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54862 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaFXS0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:26:37 -0400
Message-ID: <53A9C2C3.7050508@zytor.com>
Date: Tue, 24 Jun 2014 11:26:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/vdso: Discard the __bug_table section
References: <2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net> <tip-5f56e7167e6d438324fcba87018255d81e201383@git.kernel.org> <20140622084754.GA15094@gmail.com> <CALCETrW_U7z7RC-D5+Ji+PQd73nR-=xQGH5uieb7y3Z7yzYPRw@mail.gmail.com> <CALCETrXohybf=Lk70j=hVG1zaAQ-mw8CVo6P59xjM2qsc-p+Gg@mail.gmail.com>
In-Reply-To: <CALCETrXohybf=Lk70j=hVG1zaAQ-mw8CVo6P59xjM2qsc-p+Gg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 11:19 AM, Andy Lutomirski wrote:
>>>
>>> One of the recent x86/urgent vdso commits causes this build failure:
>>>
>>>  Error: too many copied sections (max = 13)
>>
>> I can't reproduce this with your config, which suggestes a binutils
>> issue, which is annoying.  Can you tell me what version of ld you're
>> using and send me the output of:
>>
>> for i in arch/x86/vdso/*.so.dbg; do echo $i; eu-readelf -S $i; done
> 
> Ping!
> 
> The current state of this is obviously not so good, but I don't know
> how to proceed.
> 

We used to have this kind of problems with PHDRs, where ld would guess
how much space it would need, somehow guess wrong, and fall on its face.

I think we want to actually print the number that we are trying to copy
in addition to the maximum, and I also noticed the test looks wrong.
Thus I would like to propose the following patch as a diagnostic:

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index f42e2ddc663d..94158e100f26 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -99,8 +99,9 @@ static void BITSFUNC(copy_section)(struct
BITSFUNC(fake_sections) *out,
        if (!copy)
                return;

-       if (out->count >= out->max_count)
-               fail("too many copied sections (max = %d)\n",
out->max_count);
+       if (out->count > out->max_count)
+               fail("too many copied sections (max = %d, need = %d)\n",
+                    out->max_count, out->count);

        if (in_idx == out->in_shstrndx)
                out->out_shstrndx = out->count;

Does anyone have any objection?  Andy, I presume I am correct that =>
should be > there?

	-hpa
