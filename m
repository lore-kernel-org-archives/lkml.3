Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbbAIR50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:57:26 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56209 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932919AbbAIR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:57:23 -0500
Date: Fri, 9 Jan 2015 17:57:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Wang Nan <wangnan0@huawei.com>, masami.hiramatsu.pt@hitachi.com,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v20 08/11] ARM: kprobes: enable OPTPROBES for ARM 32
Message-ID: <20150109175711.GA12302@n2100.arm.linux.org.uk>
References: <1420457376-77366-1-git-send-email-wangnan0@huawei.com>
 <1420785456-21900-1-git-send-email-wangnan0@huawei.com>
 <1420799154.4160.19.camel@linaro.org>
 <20150109163505.GS12302@n2100.arm.linux.org.uk>
 <1420824502.4160.62.camel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420824502.4160.62.camel@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 05:28:22PM +0000, Jon Medhurst (Tixy) wrote:
> Using objdump I can see that the BX instruction does indeed end up in
> the code, it hasn't been auto-magically turned into a MOV PC,R2.
> 
> Adding in a ".code 16" to the assembler produces "Error: selected
> processor does not support THUMB opcodes", so at least it's got that
> right. 
> 
> I have "gcc version 4.9.1 (Ubuntu/Linaro 4.9.1-16ubuntu6)"

Remember that it's binutils which issues the errors about the assembly.

> Interestingly...
> 
> $ echo 'asm ("bx r2\n");' | arm-linux-gnueabihf-gcc -x c -S -march=armv4 -
> <stdin>:1:0: warning: target CPU does not support THUMB instructions
> $

Mine doesn't do that.

> but adding -marm gets rid of that error.
> 
> $ echo 'asm ("bx r2\n");' | arm-linux-gnueabihf-gcc -x c -S -marm -march=armv4 -
> $

Yes - but check the -.s file for the output... this won't run the assembler
so the assembler won't check that the instruction is legal.

For me:

$ echo 'asm ("bx r2\n");' | arm-linux-gcc -x c -c -marm -march=armv4 -v - -o o.o

calls the assembler thusly:

/usr/local/lib/gcc/arm-linux-gnueabi/4.7.4/../../../../arm-linux-gnueabi/bin/as \
-v -march=armv4 -meabi=5 --fix-v4bx -o o.o /tmp/ccB0cZgO.s

Sure enough, the object file contains:

00000000 <.text>:
   0:   e12fff12        bx      r2
                        0: R_ARM_V4BX   *ABS*

so it looks like it's been told...  Then if you do:

$ arm-linux-ld --fix-v4bx -o o1.o o.o
$ arm-linux-objdump -dr o1.o

you get:

    8074:       e1a0f002        mov     pc, r2

Hmm, I wonder if this means we should have the kernel linker deal with
V4BX relocations on ARMv4, converting them to their mov pc, X variant.

Also, do we need --fix-v4bx for the link of vmlinux?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
