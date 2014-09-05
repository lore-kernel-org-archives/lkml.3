Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaIEGNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:13:19 -0400
Received: from mx12.pku.edu.cn ([162.105.129.175]:47912 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751112AbaIEGNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:13:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.264
Date: Fri, 5 Sep 2014 14:13:00 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <501661250.62198.1409897580592.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <54094FA7.6000809@roeck-us.net>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E?=
 =?utf-8?Q?=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E=E5=A4=8D=EF=BC=9A?=
 =?utf-8?Q?_Re:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_Status_of_'?=
 =?utf-8?Q?unicore32'_architecture_in_Linux_kernel?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.136]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Guenter Roeck <linux@roeck-us.net> 写道：
> On 09/03/2014 01:32 AM, Xuetao Guan  wrote:
> >
> [ ... ]
> 
> >> Please try the following patch. That seems to do it.
> >> I am sure it can be improved, but it is a start.
> >>
> >> Thanks,
> >> Guenter
> >
> > Thanks. I'll test it.
> > BTW, Qemu codestyle is different, and tab should be replaced with blanks.
> >
> 
> Here is where I am. User space code (busybox) was compiled
> using the unicore toolchain available on the web.
> 
> ...
> serio: i8042 KBD port at 0x6eb00060,0x6eb00064 irq 22
> mousedev: PS/2 mouse device common for all mice
> Enable UniCore-F64 support.
> Warning: unable to open an initial console.
> Freeing unused kernel memory: 1156K (c0408000 - c0529000)
> 
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
> ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
> The kernel tries to execute the init program, which fails with SIGSEGV.
> I confirmed that the init program is loaded and starts to execute.
> 
> Any idea what might cause such a problem ?
> 
> Thanks,
> Guenter
> 
'slink /init             /bin/busybox 777 0 0' should be inserted in initramfs config
Also, I recommend compile busybox statically for initramfs.

I need more information, including full kmsg and initramfs configs

My qemu commands as following. Maybe useful.

qemu-new:
        @test -d $(DIR_WORKING)/qemu-unicore32 ||               \
                mkdir -p $(DIR_WORKING)/qemu-unicore32
        @echo "Remove old qemu repo ..."
        @rm -fr $(DIR_WORKING)/qemu
        @cd $(DIR_WORKING); git clone $(QEMU_GITREPO)
        @cd $(DIR_WORKING)/qemu;                                \
                git br unicore32 origin/unicore32;              \
                git co unicore32

qemu-make:
        @echo "Configure qemu ..."
        @cd $(DIR_WORKING)/qemu; ./configure                    \
                --enable-trace-backend=stderr                   \
                --target-list=$(QEMU_TARGETS)                   \
                --enable-debug                                  \
                --disable-sdl                                   \
                --interp-prefix=$(DIR_GNU_UC)                   \
                --prefix=$(DIR_WORKING)/qemu-unicore32          \
                >> $(QEMU_BUILDLOG) 2>&1
        @echo "Make qemu and make install ..."
        @make -C $(DIR_WORKING)/qemu -j4 >> $(QEMU_BUILDLOG) 2>&1
        @make -C $(DIR_WORKING)/qemu install >> $(QEMU_BUILDLOG) 2>&1

qemu-run:
        @echo "Remove old log file"
        @rm -fr $(QEMU_TRACELOG)
        @echo "Running QEMU in this tty ..."
        @$(DIR_WORKING)/qemu-unicore32/bin/qemu-system-unicore32\
                -curses                                         \
                -M puv3                                         \
                -m 512                                          \
                -icount 0                                       \
                -kernel $(DIR_WORKING)/zImage                   \
                -net nic                                        \
                -net tap,ifname=tap_$(USER),script=no,downscript=no     \
                -append "root=/dev/nfs nfsroot=192.168.200.161:/export/guestroot/,tcp rw ip=192.168.122.4"    \
                2> $(QEMU_TRACELOG)

