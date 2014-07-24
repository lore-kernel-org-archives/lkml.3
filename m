Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbaGXMKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:10:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbaGXMKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:10:11 -0400
Message-ID: <53D0F793.5000207@redhat.com>
Date: Thu, 24 Jul 2014 14:09:55 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, nadav.amit@gmail.com
Subject: Re: [PATCH kvm-unit-tests] x86: Test rflags.rf is set upon faults
References: <53CD06AC.1000408@redhat.com> <1406202943-5427-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1406202943-5427-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/07/2014 13:55, Nadav Amit ha scritto:
> This patch tests whether rflags.rf is set upon #UD and #GP faults as it should,
> according to Intel SDM 17.3.1.1.  The patch saves rflags.rf in an unused bit of
> the value which is saved during exception handling to save rflags.rf.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  lib/x86/desc.c | 16 ++++++++++++----
>  lib/x86/desc.h |  1 +
>  x86/idt_test.c | 13 +++++++++----
>  3 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 9a80f48..7fbe774 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -36,8 +36,8 @@ static void check_exception_table(struct ex_regs *regs)
>      struct ex_record *ex;
>      unsigned ex_val;
>  
> -    ex_val = regs->vector | (regs->error_code << 16);
> -
> +    ex_val = regs->vector | (regs->error_code << 16) |
> +		(((regs->rflags >> 16) & 1) << 8);
>      asm("mov %0, %%gs:4" : : "r"(ex_val));
>  
>      for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
> @@ -173,9 +173,9 @@ void setup_idt(void)
>  
>  unsigned exception_vector(void)
>  {
> -    unsigned short vector;
> +    unsigned char vector;
>  
> -    asm("mov %%gs:4, %0" : "=rm"(vector));
> +    asm("movb %%gs:4, %0" : "=q"(vector));
>      return vector;
>  }
>  
> @@ -187,6 +187,14 @@ unsigned exception_error_code(void)
>      return error_code;
>  }
>  
> +bool exception_rflags_rf(void)
> +{
> +    unsigned char rf_flag;
> +
> +    asm("movb %%gs:5, %b0" : "=q"(rf_flag));
> +    return rf_flag & 1;
> +}
> +
>  static char intr_alt_stack[4096];
>  
>  #ifndef __x86_64__
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index 553bce9..bd4293e 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -144,6 +144,7 @@ extern tss64_t tss;
>  
>  unsigned exception_vector(void);
>  unsigned exception_error_code(void);
> +bool exception_rflags_rf(void);
>  void set_idt_entry(int vec, void *addr, int dpl);
>  void set_idt_sel(int vec, u16 sel);
>  void set_gdt_entry(int sel, u32 base,  u32 limit, u8 access, u8 gran);
> diff --git a/x86/idt_test.c b/x86/idt_test.c
> index ecb76bb..349aade 100644
> --- a/x86/idt_test.c
> +++ b/x86/idt_test.c
> @@ -1,15 +1,16 @@
>  #include "libcflat.h"
>  #include "desc.h"
>  
> -int test_ud2(void)
> +int test_ud2(bool *rflags_rf)
>  {
>      asm volatile(ASM_TRY("1f")
>                   "ud2 \n\t"
>                   "1:" :);
> +    *rflags_rf = exception_rflags_rf();
>      return exception_vector();
>  }
>  
> -int test_gp(void)
> +int test_gp(bool *rflags_rf)
>  {
>      unsigned long tmp;
>  
> @@ -18,19 +19,23 @@ int test_gp(void)
>  		 "mov %0, %%cr4\n\t"
>                   "1:"
>                   : "=a"(tmp));
> +    *rflags_rf = exception_rflags_rf();
>      return exception_vector();
>  }
>  
>  int main(void)
>  {
>      int r;
> +    bool rflags_rf;
>  
>      printf("Starting IDT test\n");
>      setup_idt();
> -    r = test_gp();
> +    r = test_gp(&rflags_rf);
>      report("Testing #GP", r == GP_VECTOR);
> -    r = test_ud2();
> +    report("Testing #GP rflags.rf", rflags_rf);
> +    r = test_ud2(&rflags_rf);
>      report("Testing #UD", r == UD_VECTOR);
> +    report("Testing #UD rflags.rf", rflags_rf);
>  
>      return report_summary();
>  }
> 

Thanks, applying to kvm-unit-tests.

Paolo
