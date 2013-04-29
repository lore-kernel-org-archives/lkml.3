Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab3D2Rtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:49:45 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:64667 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab3D2Rto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:49:44 -0400
MIME-Version: 1.0
In-Reply-To: <517AFC38.5090500@zytor.com>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org>
	<1367003005-5560-3-git-send-email-keescook@chromium.org>
	<517AF5D6.1040800@zytor.com>
	<517AFC38.5090500@zytor.com>
Date: Mon, 29 Apr 2013 10:49:43 -0700
X-Google-Sender-Auth: ilxcv0yIfXg3WlMt0T34D61WpAU
Message-ID: <CAGXu5jJ8983fmX-hE4mUBpBvRvaEcvFGup7CaSbY=gp34MGeZQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] x86: kaslr: move CPU flags out of cpucheck
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 3:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/26/2013 02:47 PM, H. Peter Anvin wrote:
>> On 04/26/2013 12:03 PM, Kees Cook wrote:
>>> +
>>> +static inline void cpuid(u32 id, u32 *a, u32 *b, u32 *c, u32 *d)
>>> +{
>>> +    /* Handle x86_32 PIC using ebx. */
>>> +    asm volatile("movl %%ebx, %%edi \n\t"
>>> +                 "cpuid             \n\t"
>>> +                 "xchgl %%edi, %%ebx\n\t"
>>> +                : "=a" (*a),
>>> +                  "=D" (*b),
>>> +                  "=c" (*c),
>>> +                  "=d" (*d)
>>> +                : "a" (id)
>>> +    );
>>> +}
>>
>> Please don't constrain registers unnecessarily.
>>
>> You can use "=r" there and let gcc assign whatever free register it pleases.
>>
>> You can also limit that to only:
>>
>> #if defined(__i386__) && defined(__PIC__)
>>
>
> How is this for a "beauty":
>
>
> #if defined(__i386__) && defined (__PIC__)
> # define EBX_REG "=r"
> #else
> # define EBX_REG "=b"
> #endif
>
>   asm volatile(".ifnc %%ebx,%3 ; movl %%ebx,%3 ; .endif ; "
>                "cpuid ; "
>                ".ifnc %%ebx,%3 ; xchgl %%ebx,%3 ; .endif"
>                : "=a" (*a), "=c" (*c), "=d" (*d),
>                  EBX_REG (*b)
>                : "a" (leaf), "c" (subleaf));
>

Oh, very nice on the ifnc and register define! Is the leaf/subleaf
stuff needed there? That piece doesn't make sense to me.

-Kees

--
Kees Cook
Chrome OS Security
