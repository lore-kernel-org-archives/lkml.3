Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbaGAQi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:38:26 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58001 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137AbaGAQiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:38:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Pinski <apinski@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/24] ARM64:ILP32: Use a seperate syscall table as a few syscalls need to be using the compat syscalls.
Date: Tue, 01 Jul 2014 18:38:12 +0200
Message-ID: <4268617.3t49DXZOBa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <800835FF-E10A-4C0C-A68F-0ED1434F1CE2@caviumnetworks.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com> <20140701150539.GA18309@arm.com> <800835FF-E10A-4C0C-A68F-0ED1434F1CE2@caviumnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0KQnlMWYovqF9iZ2cJIxGbZD3Q6+Tkv8F3Vgf+FBWOi
 Q07P3UzM27ZfV9povvCQENHFhVesRElLrKwKrq8gT0bnivVTVf
 uNO9AWw0ntSCAGYDAIYWKJz2Uhf+HYRytEHHd4NsdI2mp/lQ+O
 tZf3/2ccFdBb6RegNULpNK/+tD2mnufQeMFiXZPOaKjBgBqkMq
 dq6uQp6XGc0x0Zogb9CuQqqsTtKpwaV6cbbJjQZ3rF3K1MNMHW
 yBAfqw81fz+FAKiq2cLG4LFGuqh2XKgmpz493GVPHvic3n6Coh
 oPq2377kP3DJXdh0yAXAcdWN696ymjTzCIYvrUj29NC61d+F5C
 kQrgcXzrGBF7+TKYYWaA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 15:30:51 Pinski, Andrew wrote:
> > On Jul 1, 2014, at 8:07 AM, "Catalin Marinas" <catalin.marinas@arm.com> wrote:
> >> On Sat, May 24, 2014 at 12:02:17AM -0700, Andrew Pinski wrote:
> >> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> >> index 1e1ebfc..8241ffe 100644
> >> --- a/arch/arm64/kernel/entry.S
> >> +++ b/arch/arm64/kernel/entry.S
> >> @@ -620,9 +620,14 @@ ENDPROC(ret_from_fork)
> >>  */
> >>    .align    6
> >> el0_svc:
> >> -    adrp    stbl, sys_call_table        // load syscall table pointer
> >>    uxtw    scno, w8            // syscall number in w8
> >>    mov    sc_nr, #__NR_syscalls
> >> +#ifdef CONFIG_ARM64_ILP32
> >> +    get_thread_info tsk
> >> +    ldr    x16, [tsk, #TI_FLAGS]
> >> +    tbnz    x16, #TIF_32BIT_AARCH64, el0_ilp32_svc // We are using ILP32
> >> +#endif
> >> +    adrp    stbl, sys_call_table        // load syscall table pointer
> > 
> > This adds a slight penalty on the AArch64 SVC entry path. I can't tell
> > whether that's visible or not but I think the x86 guys decided to set an
> > extra bit to the syscall number to distinguish it from native calls.

IIRC the intention on x86 was that you should always be able to call
any of the three syscall ABIs (x86-32, x86-64, x32) from any process
by passing the right number, for flexibility.

	Arnd
