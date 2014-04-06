Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaDFPxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 11:53:23 -0400
Received: from mout.gmx.net ([212.227.17.22]:57579 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbaDFPxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 11:53:21 -0400
Message-ID: <5341784E.1020008@gmx.de>
Date: Sun, 06 Apr 2014 17:52:46 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michele Ballabio <barra_cuda@katamail.com>, linux-kernel@vger.kernel.org
CC: fweisbec@gmail.com, mingo@kernel.org, peterz@infradead.org
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
References: <5341707F.5000406@katamail.com>
In-Reply-To: <5341707F.5000406@katamail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:t2/FvKwOkRBeZNGC6yK7uUACTSwzwYAdJxQxaHFSp/1+8RLhaO6
 rSw7Gy4C+6ekLrXmGq39vnBPcJvQFDgzseZYCOM0BitoUzgUh30wA/iYxCdu7+pVncdKVeS
 rlE1cGGypOCwQ3ZJ6PKdSlwaEJftDNjsoIxK5njaTHtjNpCBJXUDCw+PaiOWv6sFRR5jVJk
 PFkBjoOu91DZizGyTcTiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 04/06/2014 05:19 PM, Michele Ballabio wrote:
> Toralf Förster reported this in
>   http://article.gmane.org/gmane.linux.kernel/1662567
>   http://article.gmane.org/gmane.linux.kernel/1658422
>   http://article.gmane.org/gmane.linux.kernel/1657962
> 
>   "The issue happens here at a 32 bit stable Gentoo Linux if
>    I try to start a KVM image. Kernels 3.12.X works fine,
>    kernel >= v3.13 will hang shortly after I started the image
>    with the virtual-manager. The last syslog messages are
>    something like:
>    Feb 28 16:22:00 n22 kernel: INFO: rcu_sched detected stalls
>        on CPUs/tasks: {} (detected by 2, t=60002 jiffies,
>        g=14689, c=14688, q=21051)
>    Feb 28 16:22:00 n22 kernel: INFO: Stall ended before state
>        dump start"
> 
> He correctly pointed out that the bisection blamed the merge
> commit 37bf06375c90a42fe07b9bebdb07bc316ae5a0ce
> "Merge tag 'v3.12-rc4' into sched/core".
> 
> This bug is obviously caused by at least two patches, one
> on each side of the merge, that only when combined together
> (at that merge point) cause the bug in kvm. By rebasing
> the "sched/core" branch on "master" before the merge and
> going on with the bisection, I found commit
> 3e8e42c69bb7d9fc12ebc23ff308e8523a2a59a0
> "sched: Revert need_resched() to look at TIF_NEED_RESCHED"
> as one of the causes. The other patch that contributes to the
> bug is commit ded797547548a5b8e7b92383a41e4c0e6b0ecb7f
> "irq: Force hardirq exit's softirq processing on its own stack".
> 
> Reverting either one of them solves the problem reported with kvm,
> but revert is probably not the correct answer.
> 
> I wonder if the solution is as simple as this:
> 
> --->8---
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 0af5250..f3b985d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -126,6 +126,7 @@ config X86
>  	select RTC_LIB
>  	select HAVE_DEBUG_STACKOVERFLOW
>  	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
> +	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_32
>  	select HAVE_CC_STACKPROTECTOR
> 
>  config INSTRUCTION_DECODER
> ---8<---
> 
applied both to 3.13.9 and 3.14.0 - issue does not happened any longer

Thanks !



P.S..
	'By rebasing the "sched/core" branch on "master" before the merge and going on with the bisection'

Probably off-topic but I'm really interested what did you do in detail ? I'm asking b/c using git for my own and to bisect a remote tree, but I'm not too familiar in bisecting bugs of this kind. Furthermore probably worth an own section in one of the TODO's ?


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlNBeE4ACgkQxOrN3gB26U4zpgD/bEaIS17/FIxmsyHZvL15RoX6
Z0dLwOoPcIRJyi2pn44A/0qh9YmB9Bv2yIf7qsUaEZA+lpJ+ikWMZSVEW2JtZMV0
=QOaP
-----END PGP SIGNATURE-----
