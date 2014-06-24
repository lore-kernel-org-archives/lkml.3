Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaFXShf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:37:35 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51548 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaFXSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:37:30 -0400
MIME-Version: 1.0
In-Reply-To: <53A9C2C3.7050508@zytor.com>
References: <2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net>
 <tip-5f56e7167e6d438324fcba87018255d81e201383@git.kernel.org>
 <20140622084754.GA15094@gmail.com> <CALCETrW_U7z7RC-D5+Ji+PQd73nR-=xQGH5uieb7y3Z7yzYPRw@mail.gmail.com>
 <CALCETrXohybf=Lk70j=hVG1zaAQ-mw8CVo6P59xjM2qsc-p+Gg@mail.gmail.com> <53A9C2C3.7050508@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 24 Jun 2014 11:37:08 -0700
Message-ID: <CALCETrX8xJQwm=Cp63xSWsmsF1EXB9pPkZ46rX1u49f0oCfxfw@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/vdso: Discard the __bug_table section
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:26 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/24/2014 11:19 AM, Andy Lutomirski wrote:
>>>>
>>>> One of the recent x86/urgent vdso commits causes this build failure:
>>>>
>>>>  Error: too many copied sections (max = 13)
>>>
>>> I can't reproduce this with your config, which suggestes a binutils
>>> issue, which is annoying.  Can you tell me what version of ld you're
>>> using and send me the output of:
>>>
>>> for i in arch/x86/vdso/*.so.dbg; do echo $i; eu-readelf -S $i; done
>>
>> Ping!
>>
>> The current state of this is obviously not so good, but I don't know
>> how to proceed.
>>
>
> We used to have this kind of problems with PHDRs, where ld would guess
> how much space it would need, somehow guess wrong, and fall on its face.
>
> I think we want to actually print the number that we are trying to copy
> in addition to the maximum, and I also noticed the test looks wrong.
> Thus I would like to propose the following patch as a diagnostic:
>
> diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
> index f42e2ddc663d..94158e100f26 100644
> --- a/arch/x86/vdso/vdso2c.h
> +++ b/arch/x86/vdso/vdso2c.h
> @@ -99,8 +99,9 @@ static void BITSFUNC(copy_section)(struct
> BITSFUNC(fake_sections) *out,
>         if (!copy)
>                 return;
>
> -       if (out->count >= out->max_count)
> -               fail("too many copied sections (max = %d)\n",
> out->max_count);
> +       if (out->count > out->max_count)
> +               fail("too many copied sections (max = %d, need = %d)\n",
> +                    out->max_count, out->count);
>

I think the old test was correct: we haven't incremented count yet
(it's a couple lines below), so count is the zero-based index to which
we're writing.

I thought of doing the need = %d thing, but I think that the output is
a foregone conclusion: count == max_count + 1 when this fails.  A list
of all the section names would be more interesting, but eu-readelf -S
will tell is that.

--Andy
