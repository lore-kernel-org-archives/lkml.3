Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3BGQdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:33:02 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:39477 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab3BGQdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:33:00 -0500
Message-ID: <5113D739.5070402@msgid.tls.msk.ru>
Date: Thu, 07 Feb 2013 20:32:57 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Transparent Huge Pages
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm trying to understand how to use transparent huge pages
(currently in x86).  Before I used "explicit" huge pages
alot (mostly about hugetlbfs), but it looked like THP should
be easier so I gave it a try.

This tiny program:

----- cut -----
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <errno.h>
#include <string.h>

int main(int argc, char **argv) {
   void *ptr;
   size_t len = argv[1] ? atoi(argv[1]) : 1024*1024*1024;
   /* no error checking! */
   posix_memalign(&ptr, 2048*1024, len);
   madvise(ptr, len, MADV_HUGEPAGE);
   memset(ptr, 0, len);
   usleep(500); /* let khugepagesd do its work */
   system("grep ^AnonHugePages: /proc/meminfo");
   return 0;
}
----- cut -----

which just tries to allocate some amount of RAM (1Gb by default)
aligned to 2Mb, uses madvise(HUGEPAGE) on it, and checks
/proc/meminfo for AnonHugePages.

The problem is: I've never seen any value for AnonHugePages
larger than about 16Mb.  Usually it is around 10Mb or 8Mb,
no matter how large the requested memory size is, including
the default 1Gb.

The question, obviously, is: why so small?

My system (which is a few years old now) has 6Gb of RAM,
it uses AMD Athlon II X2 260 CPU, and is running 3.2
kernel.

Original question comes from grounds of of QEMU, which is
supposed to use THP for guest memory, but it also does not
use more than these ~10Mb, when allocating 1Gb to the guest.

Thanks!

/mjt
