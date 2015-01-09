Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbbAIR2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:28:30 -0500
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:47394 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755069AbbAIR23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:28:29 -0500
Message-ID: <1420824502.4160.62.camel@linaro.org>
Subject: Re: [PATCH v20 08/11] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Wang Nan <wangnan0@huawei.com>, masami.hiramatsu.pt@hitachi.com,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 09 Jan 2015 17:28:22 +0000
In-Reply-To: <20150109163505.GS12302@n2100.arm.linux.org.uk>
References: <1420457376-77366-1-git-send-email-wangnan0@huawei.com>
	 <1420785456-21900-1-git-send-email-wangnan0@huawei.com>
	 <1420799154.4160.19.camel@linaro.org>
	 <20150109163505.GS12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 16:35 +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 09, 2015 at 10:25:54AM +0000, Jon Medhurst (Tixy) wrote:
> > On Fri, 2015-01-09 at 14:37 +0800, Wang Nan wrote:
> > > +			"	and	r4, sp, #4\n"
> > > +			"	sub	sp, sp, r4\n"
> > > +#if __LINUX_ARM_ARCH__ >= 5
> > > +			"	blx	r2\n"
> > > +#else
> > > +			"	mov     lr, pc\n"
> > > +			"	bx	r2\n"
> > 
> > I think the BX instruction is not supported for ARMv4 chips that don't
> > have Thumb support (e.g. SA110), at least an old ARM ARM I have says BX
> > is supported on "Version 5 and above, and T variants of version 4".
> 
> Correct.
> 
> > Though building assabet_defconfig with kprobes enabled doesn't produce
> > an error for the BX instruction (!?)
> 
> Which config are you using?  Does it have CONFIG_CPU_32v4 enabled?

Yes

> That should result in "-D__LINUX_ARM_ARCH__=4 -march=armv4" being
> passed to the compiler (please check with make V=1).

I does have that, the arguments for compiling this source file
include...

-mno-thumb-interwork -marm -D__LINUX_ARM_ARCH__=4 -march=armv4 -mtune=strongarm1100

Using objdump I can see that the BX instruction does indeed end up in
the code, it hasn't been auto-magically turned into a MOV PC,R2.

Adding in a ".code 16" to the assembler produces "Error: selected
processor does not support THUMB opcodes", so at least it's got that
right. 

I have "gcc version 4.9.1 (Ubuntu/Linaro 4.9.1-16ubuntu6)"

Interestingly...

$ echo 'asm ("bx r2\n");' | arm-linux-gnueabihf-gcc -x c -S -march=armv4 -
<stdin>:1:0: warning: target CPU does not support THUMB instructions
$

but adding -marm gets rid of that error.

$ echo 'asm ("bx r2\n");' | arm-linux-gnueabihf-gcc -x c -S -marm -march=armv4 -
$

-- 
Tixy


