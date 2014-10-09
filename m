Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaJIOUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:20:31 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:61512 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaJIOUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:20:22 -0400
MIME-Version: 1.0
Date: Thu, 9 Oct 2014 19:50:21 +0530
Message-ID: <CAFdej03rGT45spDTWzR64=h0gMiK+9XWox-n==mentWxPqEOfQ@mail.gmail.com>
Subject: ASLR on arm64
From: Arun Chandran <achandran@mvista.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Booted latest kernel on arm64 board with
"/proc/sys/kernel/randomize_va_space" = 2
and running the below code(aarch64-linux-gnu-gcc -fPIE -pie aslr.c -o aslr).


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv)
{
    int val = 0 ;
    char *d = malloc(10);
    FILE *fp;
    char buf[128];

    char *mmap = malloc(1024*1024);

    printf("printf = %p\n", printf);
    printf("main = %p\n", main);
    printf("stack = %p\n", &val);
    printf("alloc = %p (%lx)\n", d,
        ((unsigned long) d) - ((unsigned long) main));

    printf("mmap = %p\n", mmap);

    fp = fopen("/proc/self/maps","r");
    if (fp) {
        while (fgets(buf,128,fp)) {
            if (strstr(buf,"[vdso]\n"))
                printf("vdso = %s", buf);
        }
        fclose(fp);
    }
    return 0;
}

# for i in 1 2 3 4 5; do ./aslr; done | sort
alloc = 0x557518e010 (11ca4520)
alloc = 0x5589c73010 (1f289520)
alloc = 0x55923ba010 (1a8d2520)
alloc = 0x55b482a010 (3a595520)
alloc = 0x55c9ed9010 (394e5520)
main = 0x55634e9af0
main = 0x556a9e9af0
main = 0x5577ae7af0
main = 0x557a294af0
main = 0x55909f3af0
mmap = 0x7f7de14010
mmap = 0x7f7ec28010
mmap = 0x7f837de010
mmap = 0x7f8bfa0010
mmap = 0x7f8d9be010
printf = 0x7f7df633f8
printf = 0x7f7ed773f8
printf = 0x7f8392d3f8
printf = 0x7f8c0ef3f8
printf = 0x7f8db0d3f8
stack = 0x7fcd590d74
stack = 0x7fdbfada14
stack = 0x7fdf519794
stack = 0x7fe3ffe784
stack = 0x7fee7db824
vdso = 7f7e085000-7f7e086000 r-xp 00000000 00:00 0
         [vdso]
vdso = 7f7ee99000-7f7ee9a000 r-xp 00000000 00:00 0
         [vdso]
vdso = 7f83a4f000-7f83a50000 r-xp 00000000 00:00 0
         [vdso]
vdso = 7f8c211000-7f8c212000 r-xp 00000000 00:00 0
         [vdso]
vdso = 7f8dc2f000-7f8dc30000 r-xp 00000000 00:00 0
         [vdso]

Now after doing "ulimit -s unlimited" or "echo 1 >
/proc/sys/vm/legacy_va_layout"

# for i in 1 2 3 4 5; do ./aslr; done | sort
alloc = 0x558251b010 (1c28f520)
alloc = 0x55873f8010 (ffe8520)
alloc = 0x558ba94010 (20794520)
alloc = 0x5592053010 (37a1a520)
alloc = 0x55b095b010 (2f2d8520)
main = 0x555a638af0
main = 0x556628baf0
main = 0x556b2ffaf0
main = 0x557740faf0
main = 0x5581682af0
mmap = 0x2000174010
mmap = 0x2000174010
mmap = 0x2000174010
mmap = 0x2000174010
mmap = 0x2000174010
printf = 0x200007b3f8
printf = 0x200007b3f8
printf = 0x200007b3f8
printf = 0x200007b3f8
printf = 0x200007b3f8
stack = 0x7fc9609554
stack = 0x7fcfd5e3a4
stack = 0x7fe0f006c4
stack = 0x7fea07bd44
stack = 0x7ff1d22724
vdso = 200001c000-200001d000 r-xp 00000000 00:00 0
         [vdso]
vdso = 200001c000-200001d000 r-xp 00000000 00:00 0
         o]
vdso = 200001c000-200001d000 r-xp 00000000 00:00 0
         [vdso]
vdso = 200001c000-200001d000 r-xp 00000000 00:00 0
         [vdso]
vdso = 200001c000-200001d000 r-xp 00000000 00:00 0
         [vdso]

ie. randomisation disappears for vdso, mmap and for printf.

Is this the expected behavior?

--Arun
