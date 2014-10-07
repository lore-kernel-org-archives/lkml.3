Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaJGInr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:43:47 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:33064 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaJGInm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:43:42 -0400
Message-ID: <5433A7BB.1090207@imgtec.com>
Date: Tue, 7 Oct 2014 09:43:39 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>, <Zubair.Kakakhel@imgtec.com>,
        <peterz@infradead.org>, <paul.gortmaker@windriver.com>,
        <davidlohr@hp.com>, <macro@linux-mips.org>, <chenhc@lemote.com>,
        <zajec5@gmail.com>, <keescook@chromium.org>, <alex@alex-smith.me.uk>,
        <tglx@linutronix.de>, <blogic@openwrt.org>, <jchandra@broadcom.com>,
        <paul.burton@imgtec.com>, <qais.yousef@imgtec.com>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <manuel.lauss@gmail.com>, <akpm@linux-foundation.org>,
        <lars.persson@axis.com>, <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <libc-alpha@sourceware.org>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] MIPS: Allow FPU emulator to use non-stack area.
References: <1412626317-4128-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1412626317-4128-1-git-send-email-ddaney.cavm@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 06/10/14 21:11, David Daney wrote:
> Any userspace thread desiring a non-executable stack,
> must allocate a 4-byte aligned area at least 8 bytes long

<snip>

> +SYSCALL_DEFINE1(set_fpuemul_xol_area, unsigned long, addr)
> +{
> +	struct thread_info *ti = task_thread_info(current);
> +
> +	ti->fpu_emul_xol = addr;
> +	return 0;
> +}
> +

<snip>

> -	/* Ensure that the two instructions are in the same cache line */
> -	fr = (struct emuframe __user *)
> -		((regs->regs[29] - sizeof(struct emuframe)) & ~0x7);
> +	if (ti->fpu_emul_xol != ~0ul)
> +		fr = (struct emuframe *)ti->fpu_emul_xol;
> +	else
> +		/* Ensure that the two instructions are in the same cache line */
> +		fr = (struct emuframe __user *)
> +			((regs->regs[29] - sizeof(struct emuframe)) & ~0x7);

I know your patch was more an RFC, but on a technical note, this
comment/code seems to imply that the address should be 8 byte aligned
(rather than 4 byte) so they both land in the same cache line. Also, I
think the alignment should be validated in the syscall.

Cheers
James
