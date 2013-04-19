Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3DSHEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:04:23 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:40319 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755979Ab3DSHEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:04:22 -0400
In-Reply-To: <5170AFAC.9050602@linux.intel.com>
References: <OF79A40956.94F46B9C-ON48257B50.00320F73-48257B50.0036925D@zte.com.cn> <516EAF31.8000107@linux.intel.com> <516EBF23.2090600@sr71.net> <516EC508.6070200@linux.intel.com> <OF7B3DF162.973A9AD7-ON48257B51.00299512-48257B51.002C7D65@zte.com.cn> <51700475.7050102@linux.intel.com> <OFD8FA3C9D.ACFCFB28-ON48257B52.0008A691-48257B52.000C4DFB@zte.com.cn> <5170AFAC.9050602@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
MIME-Version: 1.0
X-KeepSent: B0184060:7A1CE1DA-48257B52:0020A880;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFB0184060.7A1CE1DA-ON48257B52.0020A880-48257B52.0026D4EA@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Fri, 19 Apr 2013 15:03:28 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-04-19 15:03:23,
	Serialize complete at 2013-04-19 15:03:23
Content-Type: text/plain; charset="GB2312"
X-MAIL: mse01.zte.com.cn r3J73iJ2026198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3J74Xcn021899

Darren Hart <dvhart@linux.intel.com> wrote on 2013/04/19 10:45:00:

> > 
> > BTW, have you seen the testcase in my other mail?  It seems to be 
> > rejected by LKML.
> > 
> 
> I did not receive it, did you also CC me?
> 
> -- 
> Darren Hart
> Intel Open Source Technology Center
> Yocto Project - Technical Lead - Linux Kernel


Ok£¨ I found that the previous mail was rejected because it had Chinese 
characters.
I paste it below:

diff -uprN functional/futex_hugepage.c functional/futex_hugepage.c
--- functional/futex_hugepage.c 1970-01-01 00:00:00.000000000 +0000
+++ functional/futex_hugepage.c 2013-04-18 16:55:44.119239404 +0000
@@ -0,0 +1,188 @@
+/*********************************************************************
+ *   This program is free software;  you can redistribute it and/or 
+ *   modify it under the terms of the GNU General Public License as 
+ *   published by the Free Software Foundation; either version 2 of 
+ *   the License, or (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ *   MA 02111-1307 USA
+ * NAME
+ *      futex_hugepage.c
+ *
+ * DESCRIPTION
+ *      Testing futex when using huge page
+ *
+ * AUTHOR
+ *      Zhang Yi <zhang.yi20@zte.com.cn>
+ *
+ * HISTORY
+ *      2013-4-18: Initial version by Zhang Yi <zhang.yi20@zte.com.cn>
+ *
+ ********************************************************************/
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <errno.h>
+#include <sys/time.h>
+#include <signal.h>
+
+#include "futextest.h"
+#include "logging.h"
+
+#define DEFAULT_FILE_NAME "/mnt/hugepagefile"
+#define MAX_FILENAME_LEN 128
+
+#define DEFAULT_HUGE_SIZE (2 * 1024 * 1024)
+
+#define PROTECTION (PROT_READ | PROT_WRITE)
+
+/* Only ia64 requires this */
+#ifdef __ia64__
+#define ADDR (void *)(0x8000000000000000UL)
+#define FLAGS (MAP_SHARED | MAP_FIXED)
+#else
+#define ADDR (void *)(0x0UL)
+#define FLAGS (MAP_SHARED)
+#endif
+
+
+futex_t *futex1, *futex2;
+
+unsigned long th2_wait_time;
+int th2_wait_done;
+
+void usage(char *prog)
+{
+       printf("Usage: %s\n", prog);
+       printf("  -f    hugetlbfs file path\n");
+       printf("  -l    hugepage size\n");
+}
+
+int gettid(void)
+{
+       return syscall(SYS_gettid);
+}
+
+void *wait_thread1(void *arg)
+{
+       futex_wait(futex1, *futex1, NULL, 0);
+       return NULL;
+}
+
+
+void *wait_thread2(void *arg)
+{
+       struct timeval tv;
+
+       gettimeofday(&tv, NULL);
+       th2_wait_time = tv.tv_sec;
+       futex_wait(futex2, *futex2, NULL, 0);;
+       th2_wait_done = 1;
+
+       return NULL;
+}
+
+int huge_futex_test(char *file_path, unsigned long huge_size)
+{
+       void *addr;
+       int fd, pgsz, wait_max_time = 30;
+       int ret = RET_PASS;
+       pthread_t th1, th2;
+       struct timeval tv;
+ 
+       fd = open(file_path, O_CREAT | O_RDWR, 0755);
+       if (fd < 0) {
+               perror("Open failed");
+               exit(1);
+       }
+ 
+       /*map hugetlbfs file*/
+       addr = mmap(ADDR, huge_size, PROTECTION, FLAGS, fd, 0);
+       if (addr == MAP_FAILED) {
+               perror("mmap");
+               unlink(file_path);
+               exit(1);
+       }
+
+       pgsz = getpagesize();
+       printf("page size is %d\n", pgsz);
+ 
+       /*apply the first subpage to futex1*/
+       futex1 = addr;
+       *futex1 = FUTEX_INITIALIZER ;
+       /*apply the second subpage to futex2*/
+       futex2 = addr + pgsz;
+       *futex2 = FUTEX_INITIALIZER ;
+ 
+
+       /*thread1 block on futex1 first,then thread2 block on futex2*/
+       pthread_create(&th1, NULL, wait_thread1, NULL);
+       sleep(2);
+       pthread_create(&th2, NULL, wait_thread2, NULL);
+       sleep(2);
+
+       /*try to wake up thread2*/
+       futex_wake(futex2, 1, 0);
+
+       /*see if thread2 can be woke up*/
+       while(!th2_wait_done) {
+               gettimeofday(&tv, NULL);
+               /*thread2 block over 30 secs, test fail*/
+               if(tv.tv_sec > (th2_wait_time + wait_max_time)) {
+                       printf("wait_thread2 wait for %ld secs\n", 
+                                   tv.tv_sec - th2_wait_time);
+                       ret = RET_FAIL;
+                       break;
+               }
+               sleep(2);
+       }
+
+       munmap(addr, huge_size);
+       close(fd);
+       unlink(file_path);
+
+       return ret;
+}
+
+int main(int argc, char *argv[])
+{
+       unsigned long huge_size = DEFAULT_HUGE_SIZE;
+       char file_path[MAX_FILENAME_LEN];
+       int ret, c;
+
+       strcpy(file_path, DEFAULT_FILE_NAME);
+
+       while ((c = getopt(argc, argv, "cf:l:")) != -1) {
+               switch(c) {
+               case 'c':
+                       log_color(1);
+               case 'f':
+                       strcpy(file_path, optarg);
+                       break;
+               case 'l':
+                       huge_size = atoi(optarg) * 1024 * 1024;
+                       break;
+               default:
+                       usage(basename(argv[0]));
+                       exit(1);
+               }
+       }
+ 
+       ret = huge_futex_test(file_path, huge_size);
+
+       print_result(ret);
+
+       return ret;
+}
+
diff -uprN functional/run.sh functional/run.sh
--- functional/run.sh   2013-04-18 06:39:56.000000000 +0000
+++ functional/run.sh   2013-04-18 16:55:59.447240286 +0000
@@ -89,3 +89,6 @@ echo
 echo
 ./futex_wait_uninitialized_heap $COLOR
 ./futex_wait_private_mapped_file $COLOR
+
+echo
+./futex_hugepage $COLOR
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
