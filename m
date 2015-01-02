Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbbABJqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:46:36 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:37884 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbABJqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:46:31 -0500
Date: Fri, 2 Jan 2015 10:46:25 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chen Gang <gang.chen@sunrus.com.cn>
Cc: schwidefsky@de.ibm.com, linux390@de.ibm.com, holzheu@linux.vnet.ibm.com,
        linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: include: timex: Use macro CLOCK_STORE_SIZE instead
 of hard code number
Message-ID: <20150102094625.GA4059@osiris>
References: <54A55954.6000002@sunrus.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A55954.6000002@sunrus.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010209-0025-0000-0000-0000032600D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 10:27:32PM +0800, Chen Gang wrote:
> For C language, it treats array parameter as a pointer, so sizeof for an
> array parameter is equal to sizeof for a pointer, which causes compiler
> warning (with allmodconfig by gcc 5):
> 
>     CC      arch/s390/kernel/asm-offsets.s
>   In file included from include/linux/timex.h:65:0,
>                    from include/linux/sched.h:19,
>                    from include/linux/kvm_host.h:15,
>                    from arch/s390/kernel/asm-offsets.c:10:
>   ./arch/s390/include/asm/timex.h: In function 'get_tod_clock_ext':
>   ./arch/s390/include/asm/timex.h:76:32: warning: 'sizeof' on array function parameter 'clk' will return size of 'char *' [-Wsizeof-array-argument]
>     typedef struct { char _[sizeof(clk)]; } addrtype;
>                                   ^
> 
> Can use macro CLOCK_STORE_SIZE instead of all related hard code numbers,
> which also can avoid this warning. And also add a tab to CLOCK_TICK_RATE
> definition to match coding styles.
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Thanks. I applied the slightly changed version below.

>From 77e1e6fd8f5ce0d96c035056f9e963ca7d9198b2 Mon Sep 17 00:00:00 2001
From: Chen Gang <gang.chen@sunrus.com.cn>
Date: Thu, 1 Jan 2015 22:27:32 +0800
Subject: [PATCH] s390/timex: fix get_tod_clock_ext() inline assembly

For C language, it treats array parameter as a pointer, so sizeof for an
array parameter is equal to sizeof for a pointer, which causes compiler
warning (with allmodconfig by gcc 5):

  ./arch/s390/include/asm/timex.h: In function 'get_tod_clock_ext':
  ./arch/s390/include/asm/timex.h:76:32: warning: 'sizeof' on array function parameter 'clk' will return size of 'char *' [-Wsizeof-array-argument]
    typedef struct { char _[sizeof(clk)]; } addrtype;
                                  ^
Can use macro CLOCK_STORE_SIZE instead of all related hard code numbers,
which also can avoid this warning. And also add a tab to CLOCK_TICK_RATE
definition to match coding styles.

[heiko.carstens@de.ibm.com]:
Chen's patch actually fixes a bug within the get_tod_clock_ext() inline assembly
where we incorrectly tell the compiler that only 8 bytes of memory get changed
instead of 16 bytes.
This would allow gcc to generate incorrect code. Right now this doesn't seem to
be the case.
Also slightly changed the patch a bit.
- renamed CLOCK_STORE_SIZE to STORE_CLOCK_SIZE
- changed get_tod_clock_ext() to receive a char pointer parameter

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/hypfs/hypfs_vm.c    |  2 +-
 arch/s390/include/asm/timex.h | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/s390/hypfs/hypfs_vm.c b/arch/s390/hypfs/hypfs_vm.c
index 32040ace00ea..99a3e6b395ab 100644
--- a/arch/s390/hypfs/hypfs_vm.c
+++ b/arch/s390/hypfs/hypfs_vm.c
@@ -231,7 +231,7 @@ failed:
 struct dbfs_d2fc_hdr {
 	u64	len;		/* Length of d2fc buffer without header */
 	u16	version;	/* Version of header */
-	char	tod_ext[16];	/* TOD clock for d2fc */
+	char	tod_ext[STORE_CLOCK_SIZE]; /* TOD clock for d2fc */
 	u64	count;		/* Number of VM guests in d2fc buffer */
 	char	reserved[30];
 } __attribute__ ((packed));
diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 8beee1cceba4..582be106ab4a 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -67,20 +67,22 @@ static inline void local_tick_enable(unsigned long long comp)
 	set_clock_comparator(S390_lowcore.clock_comparator);
 }
 
-#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
+#define CLOCK_TICK_RATE		1193180 /* Underlying HZ */
+#define STORE_CLOCK_SIZE	16	/* number of bytes store clock writes */
 
 typedef unsigned long long cycles_t;
 
-static inline void get_tod_clock_ext(char clk[16])
+static inline void get_tod_clock_ext(char *clk)
 {
-	typedef struct { char _[sizeof(clk)]; } addrtype;
+	typedef struct { char _[STORE_CLOCK_SIZE]; } addrtype;
 
 	asm volatile("stcke %0" : "=Q" (*(addrtype *) clk) : : "cc");
 }
 
 static inline unsigned long long get_tod_clock(void)
 {
-	unsigned char clk[16];
+	unsigned char clk[STORE_CLOCK_SIZE];
+
 	get_tod_clock_ext(clk);
 	return *((unsigned long long *)&clk[1]);
 }
-- 
1.8.5.6

