Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbbAUGSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:18:45 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:56595 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbbAUGSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:18:42 -0500
MIME-Version: 1.0
In-Reply-To: <1421811437-2787-1-git-send-email-bhe@redhat.com>
References: <1421811437-2787-1-git-send-email-bhe@redhat.com>
Date: Tue, 20 Jan 2015 22:18:41 -0800
X-Google-Sender-Auth: F_T43n_wqKNGFQ10_JBIubwj0ws
Message-ID: <CAGXu5jK_yT5cf5pJ7AHTAuyDN0tNhN8sN3mi+-nQEoPGqY8HQA@mail.gmail.com>
Subject: Re: [PATCH 0/6] randomize kernel physical address and virtual address separately
From: Kees Cook <keescook@chromium.org>
To: Baoquan He <bhe@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 7:37 PM, Baoquan He <bhe@redhat.com> wrote:
> Currently kaslr only randomize physical address of kernel loading, then add the delta
> to virtual address of kernel text mapping. Because kernel virtual address can only be
> from __START_KERNEL_map to LOAD_PHYSICAL_ADDR+CONFIG_RANDOMIZE_BASE_MAX_OFFSET, namely
> [0xffffffff80000000, 0xffffffffc0000000], so physical address can only be randomized
> in region [LOAD_PHYSICAL_ADDR, CONFIG_RANDOMIZE_BASE_MAX_OFFSET], namely [16M, 1G].
>
> So hpa and Vivek suggested the randomization should be done separately for both physical
> and virtual address. In this patchset I tried it. And after randomization, relocation
> handling only depends on virtual address changing, means I only check whether virtual
> address is randomized to other position, if yes relocation need be handled, if no just
> skip the relocation handling though physical address is randomized to different place.
> Now physical address can be randomized from 16M to 4G, virtual address offset can be
> from 16M to 1G.

This looks really great! Thanks for working on it! I'll wait to see
what you find out about the #PF handler, and then I can start doing
some testing too.

-Kees

>
> Leftover problem:
>     hpa want to see the physical randomization can cover the whole physical memory. I
> checked code and found it's hard to do. Because in arch/x86/boot/compressed/head_64.S
> an identity mapping of 4G is built and then kaslr and decompressing are done. The #PF
> handler solution which he suggested is only available after jump into decompressed
> kernel, namely in arch/x86/kernel/head_64.S. I didn't think of a way to do the whole
> memory covering for physical address randomization, any suggestion or idea?
>
> Baoquan He (6):
>   remove a unused function parameter
>   a bug that relocation can not be handled when kernel is loaded above
>     2G
>   Introduce a function to randomize the kernel text mapping address
>   adapt choose_kernel_location to add the kernel virtual address
>     randomzation
>   change the relocations behavior for kaslr on x86_64
>   extend the upper limit of kernel physical address randomization to 4G
>
>  arch/x86/boot/compressed/aslr.c | 69 ++++++++++++++++++++++++++++-------------
>  arch/x86/boot/compressed/misc.c | 34 +++++++++++++-------
>  arch/x86/boot/compressed/misc.h | 20 ++++++------
>  3 files changed, 82 insertions(+), 41 deletions(-)
>
> --
> 1.9.3
>



-- 
Kees Cook
Chrome OS Security
