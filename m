Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbaD3RsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:48:02 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:56254 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaD3Rr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:47:59 -0400
MIME-Version: 1.0
In-Reply-To: <5357F310.8090600@mentor.com>
References: <53554CDA.1060806@mentor.com>
	<5357EABB.3070400@zytor.com>
	<5357F310.8090600@mentor.com>
Date: Wed, 30 Apr 2014 10:47:58 -0700
Message-ID: <CAGXu5jKqvmn++UvaYxnN+QRxezv9W4E64ZaAbfTvVJmmyi9L6Q@mail.gmail.com>
Subject: Re: randomized placement of x86_64 vdso
From: Kees Cook <keescook@google.com>
To: Nathan Lynch <Nathan_Lynch@mentor.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:06 AM, Nathan Lynch <Nathan_Lynch@mentor.com> wrote:
> On 04/23/2014 11:30 AM, H. Peter Anvin wrote:
>> On 04/21/2014 09:52 AM, Nathan Lynch wrote:
>>> Hi x86/vdso people,
>>>
>>> I've been working on adding a vDSO to 32-bit ARM, and Kees suggested I
>>> look at x86_64's algorithm for placing the vDSO at a randomized offset
>>> above the stack VMA.  I found that when the stack top occupies the
>>> last slot in the PTE (is that the right term?), the vdso_addr routine
>>> returns an address below mm->start_stack, equivalent to
>>> (mm->start_stack & PAGE_MASK).  For instance if mm->start_stack is
>>> 0x7fff3ffffc96, vdso_addr returns 0x7fff3ffff000.
>>>
>>> Since the address returned is always already occupied by the stack,
>>> get_unmapped_area detects the collision and falls back to
>>> vm_unmapped_area.  This results in the vdso being placed in the
>>> address space next to libraries etc.  While this is generally
>>> unnoticeable and doesn't break anything, it does mean that the vdso is
>>> placed below the stack when there is actually room above the stack.
>>> To me it also seems uncomfortably close to placing the vdso in the way
>>> of downward expansion of the stack.
>>>
>>> I don't have a patch because I'm not sure what the algorithm should
>>> be, but thought I would bring it up as vdso_addr doesn't seem to be
>>> behaving as intended in all cases.
>>>
>>
>> If the stack occupies the last possible page, how can you say there is
>> "space above the stack"?
>
> Sorry for being unclear.  I probably am getting terminology wrong.  What
> I'm trying to express is that if the stack top is in the last page of
> its last-level page table (which may be the last possible page, but
> that's not really the interesting case), vdso_addr returns an address
> below mm->start_stack.

It seems like this is avoidable, then? From your example, it seems
like we lose the separated randomization in this case, but we don't
need to? Do you have a suggestion for what could be done to fix this?

-Kees

>
> If you do a lot of execs with the following debug patch applied,
> you should see occasional prints like:
>
> got addr 0x7f9a2ba16000, asked 0x7fffa7bff000, start_stack=0x7fffa7bffc96
> got addr 0x7f3877ff1000, asked 0x7fffd9bff000, start_stack=0x7fffd9bffc96
> got addr 0x7f96e3637000, asked 0x7ffff39ff000, start_stack=0x7ffff39ffc96
> got addr 0x7fb70588d000, asked 0x7fff271ff000, start_stack=0x7fff271ffc96
> got addr 0x7f7957171000, asked 0x7fff71dff000, start_stack=0x7fff71dffc96
>
> Hopefully this better illustrates.
>
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 1ad102613127..06c51329d1b3 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -157,15 +157,17 @@ static int setup_additional_pages(struct linux_binprm *bprm,
>                                   unsigned size)
>  {
>         struct mm_struct *mm = current->mm;
> -       unsigned long addr;
> +       unsigned long addr, hint;
>         int ret;
>
>         if (!vdso_enabled)
>                 return 0;
>
>         down_write(&mm->mmap_sem);
> -       addr = vdso_addr(mm->start_stack, size);
> -       addr = get_unmapped_area(NULL, addr, size, 0, 0);
> +       hint = vdso_addr(mm->start_stack, size);
> +       addr = get_unmapped_area(NULL, hint, size, 0, 0);
> +       if (addr != hint)
> +               pr_info("got addr 0x%lx, asked 0x%lx\n", addr, hint);
>         if (IS_ERR_VALUE(addr)) {
>                 ret = addr;
>                 goto up_fail;
>



-- 
Kees Cook
Chrome OS Security
