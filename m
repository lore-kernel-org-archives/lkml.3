Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943AbaJUW51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:57:27 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34353 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933503AbaJUW5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:57:24 -0400
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: [RFC PATCH] coredump: fix incomplete core file created when dump_skip was used last
Date: Tue, 21 Oct 2014 15:57:07 -0700
Message-Id: <1413932228-27642-1-git-send-email-victor.kamensky@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During gdb testsuite testing in arm V7 LE rootfs running on
top of ARM V8 kernel bigcore.exp test exposed issue in kernel 
user land core file writing logic. The issue is that for 
certain memory layout of crashed process upper address memory
pages were not available so dump_skip with llseek was used
but there was no subsequent write. As result core file was
truncated. Proposed RFC patch follows this cover letter. In
the proposed patch code tracks whether last operation was llseek
and writes one last byte at the end of core file to force write
into the file of skipped pages. Below is more details on issue
analysis and test case to reproduce similar issue on x86 box.

Thanks,
Victor

Appendix 1 Original issue analysis
----------------------------------

During test huge core file was created and when loaded into
gdb, gdb complained about mismatch in core file size:

BFD: Warning: /var/volatile/tmp/./core is truncated: expected core file size >= 4293058560, found: 4293038080.

i.e (0xffe2e000 - 0xffe29000 = 0x5000) 5 pages were missing in
core file. 

Last 'Program Headers' entry in core file:

  LOAD           0xffe1f000 0xffff1000 0x00000000 0x0f000 0x0f000 RW  0x1000

Size of core file

root@genericarmv7a:/tmp# ls -al core
-rw------- 1 root root 4293038080 Oct 14 23:20 core

debug printk from elf_core_dump showing that for the
last 5 page get_dump_page returned 0 and as result
dump_skip was called last 5 times. In 

addr = 0xffffa000, page = 0xffffffbeedb6a920
addr = 0xffffb000, page = 0x          (null)
addr = 0xffffc000, page = 0x          (null)
addr = 0xffffd000, page = 0x          (null)
addr = 0xffffe000, page = 0x          (null)
addr = 0xfffff000, page = 0x          (null)

In dump_skip llseek was executed in the file, but because
there were not subsequent writes after that resulting file
is missing those 5 pages.

Appendix 2 Test case for x86
----------------------------

Here is test that illustrates the issue on x86_64 machine.
Test should be compiled in 32bit mode, because in 64bit
mode [vsyscall] is at highest address entry and it always
dumped into core so issue is not reproduced.
 
Test creates MAP_FIXED mapping at upper addresses above
stack (i.e 0xfff00000 address works on my FC20) with mapping
size more than one page. Only first page in the mapping is
touched. Remaining pages in mapping will not have backing
memory so when process crashes it will create truncated core,
since dump_skip will be used for those not backed pages.

In below output note gdb complains about truncated core
file.

[kamensky@coreos-lnx2 bc]$ ls
brokencore.c
[kamensky@coreos-lnx2 bc]$ cat brokencore.c
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>

char *
create_mapping(void *addr, size_t size)
{
    char *buffer = NULL;
    
    buffer = mmap(addr, size,
                  PROT_READ|PROT_WRITE,
                  MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED,
                  0, 0);
    if (buffer == MAP_FAILED) {
        perror("mmap failed\n");
    }
    return buffer;
}

int
touch_memory (char *buffer, int size, int stride)
{
    int retval = 0;
    int i;
    for (i = 0; i < size; i += stride) {
        if (buffer[i] != 0) {
            retval = 1;
        }
        buffer[i] = 1;
    }
    return retval;
}

int
main (int argc, char **argv)
{
    size_t size;
    void *addr;
    int alloc_all = 0;
    
    char *buffer;

    
    if (argc > 2) {
        addr = (void *) strtoul(argv[1], NULL, 16);
        size = strtoul(argv[2], NULL, 10);
        if (size <= 4096) {
            printf("Size must be more than one page\n");
        }
    } else {
        printf("Usage: %s hex_addr dec_size [commit_all]\n", argv[0]);
    }

    if (argc > 3) {
        /*
         * Will touch all memory pages in allocation,
         * core file will be complete.
         */
        alloc_all = 1;
    }
    
    buffer = create_mapping(addr, size);
    if (buffer) {
        /*
         * Touch first page, so core file will have segment with
         * entry for this mapping with FileSiz != 0
         */
        touch_memory(buffer, 4096, 1024);
        if (alloc_all) {
            touch_memory(buffer, size, 1024);
        }
    } else {
        printf("failed to do mmap\n");
    }

    /* crash */
    *(char *)0 = 0;
    return 0;    
}
[kamensky@coreos-lnx2 bc]$ gcc -m32 -g -o brokencore brokencore.c 
[kamensky@coreos-lnx2 bc]$ ulimit -c unlimited
[kamensky@coreos-lnx2 bc]$ ./brokencore 0xfff00000 409600
Segmentation fault (core dumped)
[kamensky@coreos-lnx2 bc]$ ls -l
total 92
-rwxrwxr-x. 1 kamensky kamensky   8936 Oct 21 15:02 brokencore
-rw-rw-r--. 1 kamensky kamensky   1655 Oct 21 15:02 brokencore.c
-rw-------. 1 kamensky kamensky 221184 Oct 21 15:03 core.12944
[kamensky@coreos-lnx2 bc]$ gdb brokencore -core=./core.12944
GNU gdb (GDB) Fedora 7.7.1-19.fc20
Copyright (C) 2014 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from brokencore...done.
BFD: Warning: /home/kamensky/tmp/bc/./core.12944 is truncated: expected core file size >= 626688, found: 221184.
[New LWP 12944]
Core was generated by `./brokencore 0xfff00000 409600'.
Program terminated with signal SIGSEGV, Segmentation fault.
#0  0x0804868e in main (argc=3, argv=0xffbce1e4) at brokencore.c:77
77	    *(char *)0 = 0;
(gdb) 

Victor Kamensky (1):
  coredump: fix incomplete core file created when dump_skip was used
    last

 fs/coredump.c           | 25 +++++++++++++++++++++++++
 include/linux/binfmts.h |  6 ++++++
 2 files changed, 31 insertions(+)

-- 
1.8.1.4

