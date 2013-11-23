Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3KWSkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 13:40:18 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57243 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3KWSkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 13:40:16 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5290F68C.4060900@roeck-us.net>
Date: Sat, 23 Nov 2013 10:40:12 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: New build failures in v3.13-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building arm:allmodconfig ... failed
--------------
Error log:
arch/arm/crypto/aesbs-glue.c:13:32: fatal error: crypto/ablk_helper.h: No such file or directory
compilation terminated.
make[1]: *** [arch/arm/crypto/aesbs-glue.o] Error 1

ablk_helper.h only exists in arch/x86/include/asm/crypto/ablk_helper.h,
so I am not entirely sure how this is supposed to work for arm.

Introduced by commit e4e7f10bfc (ARM: add support for bit sliced AES using NEON instructions).
Possibly resolved with the pending crypto update from Herbert Xu.

======================

Building ia64:defconfig ... failed
--------------
Error log:
arch/ia64/kernel/built-in.o: In function `skip_rbs_switch':
(.text+0xef2): undefined reference to `preempt_schedule_irq'

Caused by commit aa0d5326 (ia64: Use preempt_schedule_irq).

Reverting that commit fixes the problem.
Problem is known (https://lkml.org/lkml/2013/11/20/444) and being addressed.

======================

Building powerpc:allmodconfig ... failed
--------------
Error log:
<stdin>:1:0: error: -mcall-aixdesc must be big endian (several)
scripts/gcc-version.sh: line 31: printf: #: invalid number (several)
scripts/mod/empty.c:1:0: error: -mcall-aixdesc must be big endian

make[2]: *** [scripts/mod/empty.o] Error 1
make[1]: *** [scripts/mod] Error 2

According to Stephen introduced by commit 7c105b63b (powerpc: Add CONFIG_CPU_LITTLE_ENDIAN kernel config option).

Reverting that commit fixes this problem, but unveils another.

drivers/tty/ehv_bytechan.c:363:1: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]

Not really surprising as console_initcall() is not defined for modules.
I am a bit at loss why this is only seen now, though.

=======================

Building sparc64:allmodconfig ... failed
--------------
Error log:
arch/sparc/kernel/kgdb_64.c: In function 'kgdb_trap':
arch/sparc/kernel/kgdb_64.c:162:7: error: implicit declaration of function 'exception_enter' [-Werror=implicit-function-declaration]
arch/sparc/kernel/kgdb_64.c:176:2: error: implicit declaration of function 'exception_exit' [-Werror=implicit-function-declaration]
cc1: all warnings being treated as errors
make[2]: *** [arch/sparc/kernel/kgdb_64.o] Error 1

Introduced by commit 812cb83a5 (sparc64: Implement HAVE_CONTEXT_TRACKING).

Reverting that commit fixes the problem.

======================

Building xtensa:allmodconfig ... failed
--------------
Error log:
drivers/built-in.o:(.init.literal+0xd88): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `sram_probe':
sram.c:(.text+0x58f14): undefined reference to `devm_regmap_init_i2c'
drivers/built-in.o: In function `as3722_i2c_probe':
/opt/buildbot/slave/stable-queue-master/build/drivers/mfd/as3722.c:372: undefined reference to `devm_regmap_init_i2c'
drivers/built-in.o: In function `as3722_i2c_driver_init':
/opt/buildbot/slave/stable-queue-master/build/drivers/mfd/as3722.c:444: undefined reference to `i2c_register_driver'
make: *** [vmlinux] Error 1

A patch fixing this problem is pending (http://lkml.indiana.edu/hypermail/linux/kernel/1311.2/00669.html).

---

Guenter
