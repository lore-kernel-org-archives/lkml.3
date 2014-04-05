Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaDEPtI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 11:49:08 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:53669 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaDEPtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 11:49:01 -0400
Message-ID: <534025D9.7030204@ahsoftware.de>
Date: Sat, 05 Apr 2014 17:48:41 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Optimising IS_ERR_OR_NULL
References: <20140405144337.GA5727@linux.intel.com>
In-Reply-To: <20140405144337.GA5727@linux.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.04.2014 16:43, schrieb Matthew Wilcox:
>
> (4 days too late for April Fools ... oh well :-)
>
> I don't like the look of IS_ERR_OR_NULL.  It does two tests when (due to
> the bit patterns used to represent errors and NULL pointers) it could
> use just one:
>
> #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
>
> static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
> {
> 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
> }
>
> It needs some performance testing to be sure that it's a win, but I'm
> essentially suggesting this:
>
> +++ b/include/linux/err.h
> @@ -34,10 +34,8 @@ static inline long __must_check IS_ERR(__force const void *pt
>          return IS_ERR_VALUE((unsigned long)ptr);
>   }
>
> -static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
> -{
> -       return !ptr || IS_ERR_VALUE((unsigned long)ptr);
> -}
> +#define IS_ERR_OR_NULL(ptr) \
> +       unlikely(((unsigned long)PTR_ERR(ptr) + MAX_ERRNO) <= MAX_ERRNO)
>
>   /**
>    * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
>
> (deliberately whitespace-damaged to ensure it doesn't get applied
> without thought).
>
> Comments, before I go off and run some perf tests?
>

(... x86 asm)

> Now that's a genuine improvement; we saved one instruction (lea, cmp,
> jbe vs test, je, cmp, ja), and due to various alignment / padding / etc.
> we ended up saving 4 bytes on the length of the function which turns
> into 16 bytes due to function alignment.

A first comment, if that really will be changed, please leave to old 
function as comment for the lazy reader. The new one is pretty ugly and 
needs a turned on brain to understand (besides that the new one discards 
the __must_check, but I would assume that no one uses IS_ERR_OR_NULL() 
without checking the return value).

As I just was a bit bored, here's what happens on ARM so that others 
don't have to compile it on ARM:

armv5 old:

000011e0 <kern_unmount>:
     11e0:       e92d4010        push    {r4, lr}
     11e4:       e2504000        subs    r4, r0, #0
     11e8:       0a000007        beq     120c <kern_unmount+0x2c>
     11ec:       e3740a01        cmn     r4, #4096       ; 0x1000
     11f0:       8a000005        bhi     120c <kern_unmount+0x2c>
     11f4:       e3a03000        mov     r3, #0
     11f8:       e5843064        str     r3, [r4, #100]  ; 0x64
     11fc:       ebfffffe        bl      0 <synchronize_rcu>
     1200:       e1a00004        mov     r0, r4
     1204:       e8bd4010        pop     {r4, lr}
     1208:       eafffffe        b       c78 <mntput>
     120c:       e8bd8010        pop     {r4, pc}

armv5 new:

00000c98 <kern_unmount>:
      c98:       e2803eff        add     r3, r0, #4080   ; 0xff0
      c9c:       e283300f        add     r3, r3, #15
      ca0:       e3530a01        cmp     r3, #4096       ; 0x1000
      ca4:       e92d4010        push    {r4, lr}
      ca8:       e1a04000        mov     r4, r0
      cac:       3a000005        bcc     cc8 <kern_unmount+0x30>
      cb0:       e3a03000        mov     r3, #0
      cb4:       e5803064        str     r3, [r0, #100]  ; 0x64
      cb8:       ebfffffe        bl      0 <synchronize_rcu>
      cbc:       e1a00004        mov     r0, r4
      cc0:       e8bd4010        pop     {r4, lr}
      cc4:       eafffffe        b       c78 <mntput>
      cc8:       e8bd8010        pop     {r4, pc}

And armv7 old:

00000e60 <kern_unmount>:
      e60:       e92d4010        push    {r4, lr}
      e64:       e2504000        subs    r4, r0, #0
      e68:       08bd8010        popeq   {r4, pc}
      e6c:       e3740a01        cmn     r4, #4096       ; 0x1000
      e70:       88bd8010        pophi   {r4, pc}
      e74:       e3a03000        mov     r3, #0
      e78:       e5843064        str     r3, [r4, #100]  ; 0x64
      e7c:       ebfffffe        bl      0 <synchronize_sched>
      e80:       e1a00004        mov     r0, r4
      e84:       e8bd4010        pop     {r4, lr}
      e88:       eafffffe        b       a3c <mntput>

armv7 new:

00000a5c <kern_unmount>:
      a5c:       e2803eff        add     r3, r0, #4080   ; 0xff0
      a60:       e283300f        add     r3, r3, #15
      a64:       e3530a01        cmp     r3, #4096       ; 0x1000
      a68:       e92d4010        push    {r4, lr}
      a6c:       e1a04000        mov     r4, r0
      a70:       38bd8010        popcc   {r4, pc}
      a74:       e3a03000        mov     r3, #0
      a78:       e5803064        str     r3, [r0, #100]  ; 0x64
      a7c:       ebfffffe        bl      0 <synchronize_sched>
      a80:       e1a00004        mov     r0, r4
      a84:       e8bd4010        pop     {r4, lr}
      a88:       eafffffe        b       a3c <mntput>

Unfortunately I'm bad in interpreting assembler (I prefer higher 
languages like C++), therefor I don't even try it and leave further 
comments on the ARM assembler to other people. ;)

Regards,

Alexander Holler
