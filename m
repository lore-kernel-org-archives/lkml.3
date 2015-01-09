Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbbAITS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 14:18:56 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:41544 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755274AbbAITSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:55 -0500
Message-ID: <1420831129.4160.78.camel@linaro.org>
Subject: Re: [PATCH v20 08/11] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Wang Nan <wangnan0@huawei.com>, masami.hiramatsu.pt@hitachi.com,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 09 Jan 2015 19:18:49 +0000
In-Reply-To: <20150109175711.GA12302@n2100.arm.linux.org.uk>
References: <1420457376-77366-1-git-send-email-wangnan0@huawei.com>
	 <1420785456-21900-1-git-send-email-wangnan0@huawei.com>
	 <1420799154.4160.19.camel@linaro.org>
	 <20150109163505.GS12302@n2100.arm.linux.org.uk>
	 <1420824502.4160.62.camel@linaro.org>
	 <20150109175711.GA12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 17:57 +0000, Russell King - ARM Linux wrote:
[...]
> For me:
> 
> $ echo 'asm ("bx r2\n");' | arm-linux-gcc -x c -c -marm -march=armv4 -v - -o o.o
> 
> calls the assembler thusly:
> 
> /usr/local/lib/gcc/arm-linux-gnueabi/4.7.4/../../../../arm-linux-gnueabi/bin/as \
> -v -march=armv4 -meabi=5 --fix-v4bx -o o.o /tmp/ccB0cZgO.s
> 
> Sure enough, the object file contains:
> 
> 00000000 <.text>:
>    0:   e12fff12        bx      r2
>                         0: R_ARM_V4BX   *ABS*
> 
> so it looks like it's been told...  Then if you do:
> 
> $ arm-linux-ld --fix-v4bx -o o1.o o.o
> $ arm-linux-objdump -dr o1.o
> 
> you get:
> 
>     8074:       e1a0f002        mov     pc, r2

I get results consistent with what you get above. A bit of googling
seems to indicate the generate-BX-and-fix-it-in-the-linker came in many
years ago with AEABI support.

> Hmm, I wonder if this means we should have the kernel linker deal with
> V4BX relocations on ARMv4, converting them to their mov pc, X variant.
> 
> Also, do we need --fix-v4bx for the link of vmlinux?

I guess the answer is yes if we want to catch uses of BX in inline
assembly. A quick and not very thorough grep of arch/arm for 'bx'
doesn't seem to turn up any existing dodgy uses, except in the kprobes
test code I wrote :-(

-- 
Tixy


