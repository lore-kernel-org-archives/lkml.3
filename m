Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaEFMWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:22:14 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:1906
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751094AbaEFMWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:22:11 -0400
From: Bryan Evenson <bevenson@melinkcorp.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtc: rtc-at91rm9200: fix lost ACKUPD interrupt
Thread-Topic: [PATCH] rtc: rtc-at91rm9200: fix lost ACKUPD interrupt
Thread-Index: AQHPaJ/f7r6faF+fSUiFpt/iOZTHKZszc39g
Date: Tue, 6 May 2014 12:22:07 +0000
Message-ID: <94c06375c1b44c8eb5233b0ccf2e4b13@BY2PR05MB048.namprd05.prod.outlook.com>
References: <55cab9fba2ea4eed8f73591b37cc874b@BLUPR05MB037.namprd05.prod.outlook.com>
 <1399321388-15148-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1399321388-15148-1-git-send-email-boris.brezillon@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-vipre-scanned: 002D59370070F6002D5A84
x-originating-ip: [98.100.91.242]
x-forefront-prvs: 0203C93D51
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(51704005)(189002)(199002)(377454003)(2656002)(87936001)(83322001)(74662001)(99396002)(50986999)(76176999)(54356999)(92566001)(83072002)(76576001)(85852003)(15975445006)(74502001)(19580405001)(19580395003)(74316001)(31966008)(81542001)(80022001)(66066001)(33646001)(81342001)(15202345003)(77982001)(64706001)(76482001)(21056001)(101416001)(46102001)(4396001)(79102001)(86362001)(20776003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR05MB047;H:BY2PR05MB048.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=bevenson@melinkcorp.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: melinkcorp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

> -----Original Message-----
> From: Boris BREZILLON [mailto:boris.brezillon@free-electrons.com]
> Sent: Monday, May 05, 2014 4:23 PM
> To: Bryan Evenson
> Cc: Andrew Victor; Nicolas Ferre; Jean-Christophe Plagniol-Villard; linux-arm-
> kernel@lists.infradead.org; Alessandro Zummo; rtc-
> linux@googlegroups.com; linux-kernel@vger.kernel.org; Boris BREZILLON
> Subject: [PATCH] rtc: rtc-at91rm9200: fix lost ACKUPD interrupt
> 
> If an alarm interrupt raises just after the CR register is written and before the
> ACKUPD is unmasked the ACKUPD bit might be cleaned up without waking
> up the waiting thread.
> 
> Unmask the ACKUPD interrupt before writing the CR register so that the
> ACKUPD cannot be lost.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
> ---
> Hello Bryan,
> 
> Could you try to apply this patch and tell me if it fixes your bug ?
> 

I have a little more information for you.  On my system hwclock is part of Busybox (version 1.20.2 of Busybox).  On my build I do not have CONFIG_ENABLE_FEATURE_CLEAN_UP enabled for Busybox, so it does not close the file descriptor to the RTC after it is done with it.  Here is the relevant section in the Busybox code that is setting the RTC time: http://git.busybox.net/busybox/tree/util-linux/hwclock.c?h=1_20_stable#n224.  Per a suggestion from someone on the Busybox forum, I applied a patch which added a flock() with LOCK_EX on the file descriptor and I still had the same issue.  Running two instances of the previously mentioned test scripts in the background, here are the two strace outputs from the point when one access hung:

Instance #1
----------
1256  execve("/sbin/hwclock", ["/sbin/hwclock", "-w", "-u"], [/* 13 vars */]) = 0
1256  brk(0)                            = 0x9c000
1256  uname({sys="Linux", node="at91sam9x5ek", ...}) = 0
1256  access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
1256  open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
1256  fstat64(3, {st_mode=S_IFREG|0644, st_size=7053, ...}) = 0
1256  mmap2(NULL, 7053, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6f47000
1256  close(3)                          = 0
1256  open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
1256  read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\354\225JJ4\0\0\0"..., 512) = 512
1256  fstat64(3, {st_mode=S_IFREG|0755, st_size=1245200, ...}) = 0
1256  mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f46000
1256  mmap2(0x4a490000, 1284496, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x4a490000
1256  mprotect(0x4a5bc000, 32768, PROT_NONE) = 0
1256  mmap2(0x4a5c4000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x12c) = 0x4a5c4000
1256  mmap2(0x4a5c8000, 6544, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x4a5c8000
1256  close(3)                          = 0
1256  mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f45000
1256  set_tls(0xb6f454c0, 0xb6f45b98, 0x4a487058, 0xb6f454c0, 0x4a487058) = 0
1256  mprotect(0x4a5c4000, 8192, PROT_READ) = 0
1256  mprotect(0x4a486000, 4096, PROT_READ) = 0
1256  munmap(0xb6f47000, 7053)          = 0
1256  getuid32()                        = 0
1256  open("/dev/rtc", O_WRONLY|O_LARGEFILE) = 3
1256  gettimeofday({1399376901, 241610}, NULL) = 0
1256  brk(0)                            = 0x9c000
1256  brk(0xbd000)                      = 0xbd000
1256  open("/etc/localtime", O_RDONLY|O_CLOEXEC) = 4
1256  fcntl64(4, F_GETFD)               = 0x1 (flags FD_CLOEXEC)
1256  fstat64(4, {st_mode=S_IFREG|0644, st_size=3519, ...}) = 0
1256  fstat64(4, {st_mode=S_IFREG|0644, st_size=3519, ...}) = 0
1256  mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f48000
1256  read(4, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\4\0\0\0\4\0\0\0\0"..., 4096) = 3519
1256  _llseek(4, -24, [3495], SEEK_CUR) = 0
1256  read(4, "\nEST5EDT,M3.2.0,M11.1.0\n", 4096) = 24
1256  close(4)                          = 0
1256  munmap(0xb6f48000, 4096)          = 0
1256  flock(3, LOCK_EX)                 = 0
1256  ioctl(3, RTC_SET_TIME, {tm_sec=21, tm_min=48, tm_hour=11, tm_mday=6, tm_mon=4, tm_year=114, ...}) = 0
1256  flock(3, LOCK_UN)                 = 0
1256  exit_group(0)                     = ?
1256  +++ exited with 0 +++
----------

Instance #2
----------
1261  execve("/sbin/hwclock", ["/sbin/hwclock", "-w", "-u"], [/* 13 vars */]) = 0
1261  brk(0)                            = 0x9c000
1261  uname({sys="Linux", node="at91sam9x5ek", ...}) = 0
1261  access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
1261  open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
1261  fstat64(3, {st_mode=S_IFREG|0644, st_size=7053, ...}) = 0
1261  mmap2(NULL, 7053, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6f4b000
1261  close(3)                          = 0
1261  open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
1261  read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\354\225JJ4\0\0\0"..., 512) = 512
1261  fstat64(3, {st_mode=S_IFREG|0755, st_size=1245200, ...}) = 0
1261  mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f4a000
1261  mmap2(0x4a490000, 1284496, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x4a490000
1261  mprotect(0x4a5bc000, 32768, PROT_NONE) = 0
1261  mmap2(0x4a5c4000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x12c) = 0x4a5c4000
1261  mmap2(0x4a5c8000, 6544, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x4a5c8000
1261  close(3)                          = 0
1261  mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f49000
1261  set_tls(0xb6f494c0, 0xb6f49b98, 0x4a487058, 0xb6f494c0, 0x4a487058) = 0
1261  mprotect(0x4a5c4000, 8192, PROT_READ) = 0
1261  mprotect(0x4a486000, 4096, PROT_READ) = 0
1261  munmap(0xb6f4b000, 7053)          = 0
1261  getuid32()                        = 0
1261  open("/dev/rtc", O_WRONLY|O_LARGEFILE) = 3
1261  gettimeofday({1399376901, 655559}, NULL) = 0
1261  brk(0)                            = 0x9c000
1261  brk(0xbd000)                      = 0xbd000
1261  open("/etc/localtime", O_RDONLY|O_CLOEXEC) = 4
1261  fcntl64(4, F_GETFD)               = 0x1 (flags FD_CLOEXEC)
1261  fstat64(4, {st_mode=S_IFREG|0644, st_size=3519, ...}) = 0
1261  fstat64(4, {st_mode=S_IFREG|0644, st_size=3519, ...}) = 0
1261  mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f4c000
1261  read(4, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\4\0\0\0\4\0\0\0\0"..., 4096) = 3519
1261  _llseek(4, -24, [3495], SEEK_CUR) = 0
1261  read(4, "\nEST5EDT,M3.2.0,M11.1.0\n", 4096) = 24
1261  close(4)                          = 0
1261  munmap(0xb6f4c000, 4096)          = 0
1261  flock(3, LOCK_EX)                 = 0
1261  ioctl(3, RTC_SET_TIME, {tm_sec=21, tm_min=48, tm_hour=11, tm_mday=6, tm_mon=4, tm_year=114, ...}
----------

For the second instance, I had to "cat" the file that is still open by the strace process that has not yet returned.  If I open the strace output file with vi, the ioctl() call is not present.  If I understand flock() correctly, I think we can assume one ioctl() completes before the other ioctl() begins.  Is it possible there is something else going on in which the RTC is not yet ready for time to be set again?  Or is it a problem with setting the RTC to the same time twice?

If there is a different kernel version you would like me to try, or if you would like my kernel binary for your testing, let me know.

Regards,
Bryan

> Best Regards,
> 
> Boris
> 
>  drivers/rtc/rtc-at91rm9200.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c index
> 3281c90..c16c423 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -163,9 +163,9 @@ static int at91_rtc_settime(struct device *dev, struct
> rtc_time *tm)
> 
>  	/* Stop Time/Calendar from counting */
>  	cr = at91_rtc_read(AT91_RTC_CR);
> +	at91_rtc_write_ier(AT91_RTC_ACKUPD);
>  	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL |
> AT91_RTC_UPDTIM);
> 
> -	at91_rtc_write_ier(AT91_RTC_ACKUPD);
>  	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD
> interrupt */
>  	at91_rtc_write_idr(AT91_RTC_ACKUPD);
> 
> --
> 1.8.3.2

