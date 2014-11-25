Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaKYU3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:29:12 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:48055 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKYU3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:29:09 -0500
Message-ID: <5474E68D.4010707@de.ibm.com>
Date: Tue, 25 Nov 2014 21:29:01 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-x86_64@vger.kernel.org, linux-s390@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCHv2 04/10] x86/spinlock: Replace ACCESS_ONCE with READ_ONCE/ASSIGN_ONCE
References: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com> <1416919117-50652-5-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1416919117-50652-5-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112520-0005-0000-0000-000002395CF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.11.2014 um 13:38 schrieb Christian Borntraeger:
> ACCESS_ONCE does not work reliably on non-scalar types. For
> example gcc 4.6 and 4.7 might remove the volatile tag for such
> accesses during the SRA (scalar replacement of aggregates) step
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
> 
> Change the spinlock code to replace ACCESS_ONCE with READ_ONCE
> and ASSIGN_ONCE.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/x86/include/asm/spinlock.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 9295016..af6e673 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -92,7 +92,7 @@ static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
>  		unsigned count = SPIN_THRESHOLD;
> 
>  		do {
> -			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
> +			if (ASSIGN_ONCE(inc.tail, lock->tickets.head))

As Mike pointed out: this should be 
			if (READ_ONCE(lock->tickets.head) == inc.tail)
of course.


