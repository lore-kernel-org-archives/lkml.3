Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaLSTaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:30:22 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:61710 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaLSTaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:30:21 -0500
MIME-Version: 1.0
In-Reply-To: <54945C1E020000780005114E@mail.emea.novell.com>
References: <54945C1E020000780005114E@mail.emea.novell.com>
Date: Fri, 19 Dec 2014 11:30:20 -0800
X-Google-Sender-Auth: 67SZCzc20NjcXFr3Rq4ix01RCUo
Message-ID: <CAE9FiQW7Eu+tcysOdHPjStt1uhNjDDU__THPBEG2h0FbtBsCjQ@mail.gmail.com>
Subject: Re: [PATCH] x86: fix step size adjustment during initial memory mapping
From: Yinghai Lu <yinghai@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 8:10 AM, Jan Beulich <JBeulich@suse.com> wrote:
> The old scheme can lead to failure in certain cases - the problem is
> that after bumping step_size the next (non-final) iteration is only
> guaranteed to make available a memory block the size of what step_size
> was before. E.g. for a memory block [0,3004600000) we'd have
>
> iter    start           end             step            amount
> 1       3004400000      30045fffff       2M               2M
> 2       3004000000      30043fffff      64M               4M
> 3       3000000000      3003ffffff       2G              64M
> 4       2000000000      2fffffffff      64G              64G
>
> Yet to map 64G with 4k pages (as happens e.g. under PV Xen) we need
> slightly over 128M, but the first three iterations made only about 70M
> available.
>
> The condition (new_mapped_ram_size > mapped_ram_size) for bumping
> step_size is just not suitable. Instead we want to bump it when we know
> we have enough memory available to cover a block of the new step_size.
> And rather than making that condition more complicated than needed,
> simply adjust step_size by the largest possible factor we know we can
> cover at that point - which is shifting it left by one less than the
> difference between page table level shifts. (Interestingly the original
> STEP_SIZE_SHIFT definition had a comment hinting at that having been
> the intention, just that it should have been PUD_SHIFT-PMD_SHIFT-1
> instead of (PUD_SHIFT-PMD_SHIFT)/2, and of course for non-PAE 32-bit we
> can't really use these two constants as they're equal there.)

Acked-by: Yinghai Lu <yinghai@kernel.org>
