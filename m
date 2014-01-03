Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaACPxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:53:30 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:57594 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbaACPx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:53:28 -0500
Message-ID: <1388764386.3430.10.camel@linaro1.home>
Subject: Re: [PATCH 2/5] ARM: kprobes-test: use <asm/opcodes.h> for
 instruction accesses
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-networking@linaro.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Jan 2014 15:53:06 +0000
In-Reply-To: <1387815579-15677-3-git-send-email-taras.kondratiuk@linaro.org>
References: <1387815579-15677-1-git-send-email-taras.kondratiuk@linaro.org>
	 <1387815579-15677-3-git-send-email-taras.kondratiuk@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 18:19 +0200, Taras Kondratiuk wrote:
> From: Ben Dooks <ben.dooks@codethink.co.uk>
> 
> Ensure we read instructions in the correct endian-ness by using
> the <asm/opcodes.h> helper to transform them as necessary.
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> [taras.kondratiuk@linaro.org: fix next_instruction() function]
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---

Apart from the spurious line removal (see below) then:

Acked-by: Jon Medhurst <tixy@linaro.org>

and you can include an ACK for the other patches in this series too.

Thanks.


>  arch/arm/kernel/kprobes-test.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
> index 0cd63d0..96e3dbc 100644
> --- a/arch/arm/kernel/kprobes-test.c
> +++ b/arch/arm/kernel/kprobes-test.c
> @@ -1329,7 +1329,8 @@ static void test_case_failed(const char *message)
>  static unsigned long next_instruction(unsigned long pc)
>  {
>  #ifdef CONFIG_THUMB2_KERNEL
> -	if ((pc & 1) && !is_wide_instruction(*(u16 *)(pc - 1)))
> +	if ((pc & 1) &&
> +	    !is_wide_instruction(__mem_to_opcode_thumb16(*(u16 *)(pc - 1))))
>  		return pc + 2;
>  	else
>  #endif
> @@ -1374,13 +1375,13 @@ static uintptr_t __used kprobes_test_case_start(const char *title, void *stack)
>  
>  	if (test_case_is_thumb) {
>  		u16 *p = (u16 *)(test_code & ~1);
> -		current_instruction = p[0];
> +		current_instruction = __mem_to_opcode_thumb16(p[0]);
>  		if (is_wide_instruction(current_instruction)) {
> -			current_instruction <<= 16;
> -			current_instruction |= p[1];
> +			u16 instr2 = __mem_to_opcode_thumb16(p[1]);
> +			current_instruction = __opcode_thumb32_compose(current_instruction, instr2);
>  		}
>  	} else {
> -		current_instruction = *(u32 *)test_code;
> +		current_instruction = __mem_to_opcode_arm(*(u32 *)test_code);
>  	}
>  
>  	if (current_title[0] == '.')
> @@ -1593,7 +1594,6 @@ static int run_test_cases(void (*tests)(void), const union decode_item *table)
>  	return 0;
>  }
>  
> -

I know the above blank line isn't needed but I believe the convention is
to avoid doing unrelated white-space clean-ups in patches.

>  static int __init run_all_tests(void)
>  {
>  	int ret = 0;


