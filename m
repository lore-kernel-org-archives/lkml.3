Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbaFILge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:36:34 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42939 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407AbaFILgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:36:32 -0400
Message-ID: <53959C3B.3010000@redhat.com>
Date: Mon, 09 Jun 2014 13:36:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests1/2] x86: emulator: additional smsw test-case
References: <53908C66.20600@redhat.com> <1402012613-29891-1-git-send-email-namit@cs.technion.ac.il> <1402012613-29891-2-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1402012613-29891-2-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/06/2014 01:56, Nadav Amit ha scritto:
> An additional test case for the emulator was added to test smsw which is
> trapped by the emulator.  The other existing test-cases occur in the guest (at
> least on VMX), since the values are read directly from the CR0 read shadow.
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  x86/emulator.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 20e3a45..033f246 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -336,7 +336,7 @@ void test_incdecnotneg(void *mem)
>      report("lock notb", *mb == vb);
>  }
>
> -void test_smsw(void)
> +void test_smsw(uint64_t *h_mem)
>  {
>  	char mem[16];
>  	unsigned short msw, msw_orig, *pmsw;
> @@ -355,6 +355,12 @@ void test_smsw(void)
>  		if (i != 4 && pmsw[i])
>  			zero = 0;
>  	report("smsw (2)", msw == pmsw[4] && zero);
> +
> +	/* Trigger exit on smsw */
> +	*h_mem = 0x12345678abcdeful;
> +	asm volatile("smsw %0" : "=m"(*h_mem));
> +	report("smsw (3)", msw == (unsigned short)*h_mem &&
> +		(*h_mem & ~0xfffful) == 0x12345678ab0000ul);
>  }
>
>  void test_lmsw(void)
> @@ -998,7 +1004,7 @@ int main()
>
>  	test_cr8();
>
> -	test_smsw();
> +	test_smsw(mem);
>  	test_lmsw();
>  	test_ljmp(mem);
>  	test_stringio();
>

Thanks, applying all after the end of the merge window.

Paolo
