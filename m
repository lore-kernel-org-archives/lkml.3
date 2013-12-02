Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3LBMaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:30:24 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:36057 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3LBMaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:30:17 -0500
Message-ID: <529C7D48.9010307@c-s.fr>
Date: Mon, 02 Dec 2013 13:30:00 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [BUG] perf closing stdin
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiled without libelf/libdwarf, the perf tool has a invalid 
behaviour: it closes stdin (fd 0), then wrongly tries to do things on 
that fd which is not stdin anymore.

strace output below, issue is at 11:51:28.054136


694   11:51:12.936558 execve("/usr/sbin/perf", ["perf", "top"], [/* 10 
vars */]) = 0
694   11:51:12.956708 brk(0)            = 0x1018d000
694   11:51:12.964304 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No 
such file or directory)
694   11:51:12.975806 open("/usr/lib/tls/ppc823/libpthread.so.0", 
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
694   11:51:12.983845 stat64("/usr/lib/tls/ppc823", 0x7fa85958) = -1 
ENOENT (No such file or directory)
694   11:51:12.989126 open("/usr/lib/tls/libpthread.so.0", 
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
694   11:51:12.994848 stat64("/usr/lib/tls", 0x7fa85958) = -1 ENOENT (No 
such file or directory)
694   11:51:13.000487 open("/usr/lib/ppc823/libpthread.so.0", 
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
694   11:51:13.005859 stat64("/usr/lib/ppc823", 0x7fa85958) = -1 ENOENT 
(No such file or directory)
694   11:51:13.012262 open("/usr/lib/libpthread.so.0", 
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
694   11:51:13.017631 stat64("/usr/lib", {st_mode=S_IFDIR|0755, 
st_size=2664, ...}) = 0
694   11:51:13.025144 open("/lib/tls/ppc823/libpthread.so.0", 
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
694   11:51:13.031651 stat64("/lib/tls/ppc823", 0x7fa85958) = -1 ENOENT 
(No such file or directory)
694   11:51:13.037677 open("/lib/tls/libpthread.so.0", 
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
694   11:51:13.044123 stat64("/lib/tls", 0x7fa85958) = -1 ENOENT (No 
such file or directory)
694   11:51:13.050471 open("/lib/ppc823/libpthread.so.0", 
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
694   11:51:13.056608 stat64("/lib/ppc823", 0x7fa85958) = -1 ENOENT (No 
such file or directory)
694   11:51:13.062849 open("/lib/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
694   11:51:13.070860 read(3, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\0Rt\0\0\0004"..., 
512) = 512
694   11:51:13.077325 fstat64(3, {st_mode=S_IFREG|0755, st_size=123901, 
...}) = 0
694   11:51:13.084394 mmap(0xffc6000, 169732, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xffc6000
694   11:51:13.093025 mprotect(0xffdd000, 61440, PROT_NONE) = 0
694   11:51:13.099079 mmap(0xffec000, 8192, 
PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 
0x16000) = 0xffec000
694   11:51:13.105645 mmap(0xffee000, 5892, 
PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 
0) = 0xffee000
694   11:51:13.112191 close(3)          = 0
694   11:51:13.120605 open("/usr/lib/librt.so.1", O_RDONLY|O_CLOEXEC) = 
-1 ENOENT (No such file or directory)
694   11:51:13.126974 open("/lib/librt.so.1", O_RDONLY|O_CLOEXEC) = 3
694   11:51:13.133270 read(3, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\0\35\340\0\0\0004"..., 
512) = 512
694   11:51:13.140745 fstat64(3, {st_mode=S_IFREG|0755, st_size=49446, 
...}) = 0
694   11:51:13.148091 mmap(0xff91000, 148256, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xff91000
694   11:51:13.154869 mprotect(0xff9a000, 61440, PROT_NONE) = 0
694   11:51:13.162440 mmap(0xffa9000, 8192, 
PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 
0x8000) = 0xffa9000
694   11:51:13.169551 mmap(0xffab000, 41760, 
PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 
0) = 0xffab000
694   11:51:13.177602 close(3)          = 0
694   11:51:13.184542 open("/usr/lib/libm.so.6", O_RDONLY|O_CLOEXEC) = 
-1 ENOENT (No such file or directory)
694   11:51:13.191835 open("/lib/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
694   11:51:13.199377 read(3, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\0n \0\0\0004"..., 
512) = 512
694   11:51:13.206962 fstat64(3, {st_mode=S_IFREG|0755, st_size=1022197, 
...}) = 0
694   11:51:13.214564 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e60000
694   11:51:13.221671 mmap(0xfe83000, 1039816, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xfe83000
694   11:51:13.228422 mprotect(0xff70000, 61440, PROT_NONE) = 0
694   11:51:13.236147 mmap(0xff7f000, 8192, 
PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 
0xec000) = 0xff7f000
694   11:51:13.242999 close(3)          = 0
694   11:51:13.247293 open("/usr/lib/libdl.so.2", O_RDONLY|O_CLOEXEC) = 
-1 ENOENT (No such file or directory)
694   11:51:13.252854 open("/lib/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
694   11:51:13.258106 read(3, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\0\vt\0\0\0004"..., 
512) = 512
694   11:51:13.264032 fstat64(3, {st_mode=S_IFREG|0755, st_size=17446, 
...}) = 0
694   11:51:13.269786 mmap(0xfe5f000, 78316, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xfe5f000
694   11:51:13.275326 mprotect(0xfe61000, 65536, PROT_NONE) = 0
694   11:51:13.282223 mmap(0xfe71000, 8192, 
PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 
0x2000) = 0xfe71000
694   11:51:13.288668 close(3)          = 0
694   11:51:13.294792 open("/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 
-1 ENOENT (No such file or directory)
694   11:51:13.302046 open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
694   11:51:13.308142 read(3, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\2\5L\0\0\0004"..., 
512) = 512
694   11:51:13.315442 fstat64(3, {st_mode=S_IFREG|0755, st_size=1727850, 
...}) = 0
694   11:51:13.322478 mmap(0xfccd000, 1579676, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xfccd000
694   11:51:13.328473 mprotect(0xfe38000, 61440, PROT_NONE) = 0
694   11:51:13.334709 mmap(0xfe47000, 24576, 
PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 
0x16a000) = 0xfe47000
694   11:51:13.341232 mmap(0xfe4d000, 6812, 
PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 
0) = 0xfe4d000
694   11:51:13.348249 close(3)          = 0
694   11:51:13.355199 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5f000
694   11:51:13.361662 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5e000
694   11:51:13.371633 mprotect(0xfe47000, 8192, PROT_READ) = 0
694   11:51:13.378096 mprotect(0xfe71000, 4096, PROT_READ) = 0
694   11:51:13.385633 mprotect(0xff7f000, 4096, PROT_READ) = 0
694   11:51:13.392315 mprotect(0xffec000, 4096, PROT_READ) = 0
694   11:51:13.398646 mprotect(0xffa9000, 4096, PROT_READ) = 0
694   11:51:13.406051 mprotect(0x77e81000, 4096, PROT_READ) = 0
694   11:51:13.412450 set_tid_address(0x77e5e068) = 694
694   11:51:13.418505 set_robust_list(0x77e5e070, 0xc) = 0
694   11:51:13.424895 futex(0x7fa86368, FUTEX_WAKE_PRIVATE, 1) = 0
694   11:51:13.431748 futex(0x7fa86368, 
FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, 77e830fc) = -1 
EAGAIN (Resource temporarily unavailable)
694   11:51:13.440330 rt_sigaction(SIGRTMIN, {0xffcb1b0, [], 
SA_SIGINFO}, NULL, 8) = 0
694   11:51:13.451126 rt_sigaction(SIGRT_1, {0xffcacd4, [], 
SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
694   11:51:13.458623 rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
694   11:51:13.465968 getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, 
rlim_max=RLIM_INFINITY}) = 0
694   11:51:13.474789 statfs64("/sys/kernel/debug/", 88, 
{f_type=0x64626720, f_bsize=4096, f_blocks=0, f_bfree=0, f_bavail=0, 
f_files=0, f_ffree=0, f_fsid={0, 0}, f_namelen=255, f_frsize=4096}) = 0
694   11:51:13.486534 brk(0)            = 0x1018d000
694   11:51:13.494767 brk(0x101ae000)   = 0x101ae000
694   11:51:13.502933 
access("/root/gen/trunk/knl/debian//etc/perfconfig", R_OK) = -1 ENOENT 
(No such file or directory)
694   11:51:13.512469 stat64("/root/.perfconfig", 0x7fa860a0) = -1 
ENOENT (No such file or directory)
694   11:51:13.522487 rt_sigprocmask(SIG_BLOCK, [WINCH], NULL, 8) = 0
694   11:51:13.530594 
access("/root/gen/trunk/knl/debian//etc/perfconfig", R_OK) = -1 ENOENT 
(No such file or directory)
694   11:51:13.538779 stat64("/root/.perfconfig", 0x7fa85ff0) = -1 
ENOENT (No such file or directory)
694   11:51:13.548131 ioctl(1, TCGETS, {B115200 opost isig icanon echo 
...}) = 0
694   11:51:13.565370 open("/sys/devices/system/cpu/online", 
O_RDONLY|O_LARGEFILE) = 3
694   11:51:13.574006 fstat64(3, {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
694   11:51:13.582610 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:13.589035 read(3, "0\n", 4096) = 2
694   11:51:13.593974 close(3)          = 0
694   11:51:13.599654 munmap(0x77e5d000, 4096) = 0
694   11:51:13.605641 uname({sys="Linux", node="miae", ...}) = 0
694   11:51:13.614596 geteuid()         = 0
694   11:51:13.619641 ioctl(1, TIOCGWINSZ, {ws_row=0, ws_col=0, 
ws_xpixel=0, ws_ypixel=0}) = 0
694   11:51:13.625118 rt_sigaction(SIGWINCH, {0x1001b09c, [], 
SA_SIGINFO}, NULL, 8) = 0
694   11:51:13.631781 fstat64(0, {st_mode=S_IFCHR|0600, 
st_rdev=makedev(204, 46), ...}) = 0
694   11:51:13.638134 open("/sys/kernel/notes", O_RDONLY|O_LARGEFILE) = 3
694   11:51:13.644439 fstat64(3, {st_mode=S_IFREG|0444, st_size=36, 
...}) = 0
694   11:51:13.651239 read(3, 
"\0\0\0\4\0\0\0\24\0\0\0\3GNU\0J\252\257\251\305\310\20\"\357\33\252a2d\215n"..., 
36) = 36
694   11:51:13.657744 close(3)          = 0
694   11:51:13.663883 open("/proc/kallsyms", O_RDONLY|O_LARGEFILE) = 3
694   11:51:13.671571 fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:13.678153 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:13.684536 read(3, "c0000000 T _start\nc0000000 T _st"..., 
1024) = 1024
694   11:51:13.692260 close(3)          = 0
694   11:51:13.698291 munmap(0x77e5d000, 4096) = 0
694   11:51:13.704980 open("/proc/modules", O_RDONLY|O_LARGEFILE) = 3
694   11:51:13.711664 fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:13.719100 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:13.725352 read(3, "", 1024) = 0
694   11:51:13.731543 close(3)          = 0
694   11:51:13.738446 munmap(0x77e5d000, 4096) = 0
694   11:51:13.744907 open("/proc/version", O_RDONLY|O_LARGEFILE) = 3
694   11:51:13.751686 fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:13.758380 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:13.764761 read(3, "Linux version 3.12.1-s3k-drv-999"..., 
1024) = 155
694   11:51:13.772263 close(3)          = 0
694   11:51:13.778318 munmap(0x77e5d000, 4096) = 0
694   11:51:13.786011 openat(AT_FDCWD, 
"/lib/modules/3.12.1-s3k-drv-999-svn5426_knld-999-svn5415/kernel", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No 
such file or directory)
694   11:51:13.794047 openat(AT_FDCWD, "/proc", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
694   11:51:13.801339 fcntl64(3, F_GETFD) = 0x1 (flags FD_CLOEXEC)
694   11:51:13.809311 getdents64(3, /* 82 entries */, 32768) = 2224
694   11:51:13.830949 open("/proc/1/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:13.838100 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:13.845776 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:13.852781 read(4, "Name:\tinit\nState:\tS (sleeping)\nT"..., 
1024) = 691
694   11:51:13.862280 close(4)          = 0
694   11:51:13.869243 munmap(0x77e5d000, 4096) = 0
694   11:51:13.876784 openat(AT_FDCWD, "/proc/1/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:13.884290 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:13.892221 open("/proc/1/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:13.900285 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:13.907973 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:13.915534 read(5, "Name:\tinit\nState:\tS (sleeping)\nT"..., 
1024) = 691
694   11:51:13.923873 close(5)          = 0
694   11:51:13.931536 munmap(0x77e5d000, 4096) = 0
694   11:51:13.940338 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:13.947867 close(4)          = 0
694   11:51:13.955595 open("/proc/1/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:13.964688 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:13.973261 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:13.981131 read(4, "00100000-00103000 r-xp 00000000 "..., 
1024) = 1024
694   11:51:13.991989 open("/proc/self/maps", O_RDONLY|O_LARGEFILE) = 5
694   11:51:13.996643 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.002908 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5c000
694   11:51:14.008039 read(5, "00100000-00103000 r-xp 00000000 "..., 
1024) = 1024
694   11:51:14.014740 close(5)          = 0
694   11:51:14.019794 munmap(0x77e5c000, 4096) = 0
694   11:51:14.026233 open("/tmp/perf-vdso.so-IZih1b", 
O_RDWR|O_CREAT|O_EXCL|O_LARGEFILE, 0600) = 5
694   11:51:14.032064 write(5, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\20\3`\0\0\0004"..., 
12288) = 12288
694   11:51:14.039095 close(5)          = 0
694   11:51:14.047257 read(4, "   /lib/libpam.so.0.83.1\n0fcdf00"..., 
1024) = 1024
694   11:51:14.056915 read(4, ".16.so\n0ffdf000-0ffee000 ---p 00"..., 
1024) = 681
694   11:51:14.066327 read(4, "", 1024) = 0
694   11:51:14.072513 close(4)          = 0
694   11:51:14.079212 munmap(0x77e5d000, 4096) = 0
694   11:51:14.085758 open("/proc/2/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.093081 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.099695 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.106040 read(4, "Name:\tkthreadd\nState:\tS (sleepin"..., 
1024) = 460
694   11:51:14.113204 close(4)          = 0
694   11:51:14.119101 munmap(0x77e5d000, 4096) = 0
694   11:51:14.126260 openat(AT_FDCWD, "/proc/2/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:14.133023 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:14.139766 open("/proc/2/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:14.146429 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.153412 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.159593 read(5, "Name:\tkthreadd\nState:\tS (sleepin"..., 
1024) = 460
694   11:51:14.166698 close(5)          = 0
694   11:51:14.173045 munmap(0x77e5d000, 4096) = 0
694   11:51:14.180886 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:14.187568 close(4)          = 0
694   11:51:14.194587 open("/proc/2/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.202694 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.209933 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.217829 read(4, "", 1024) = 0
694   11:51:14.224878 close(4)          = 0
694   11:51:14.231896 munmap(0x77e5d000, 4096) = 0
694   11:51:14.238830 open("/proc/3/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.246046 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.254475 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.261468 read(4, "Name:\tksoftirqd/0\nState:\tS (slee"..., 
1024) = 463
694   11:51:14.269305 close(4)          = 0
694   11:51:14.276376 munmap(0x77e5d000, 4096) = 0
694   11:51:14.283490 openat(AT_FDCWD, "/proc/3/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:14.291602 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:14.298945 open("/proc/3/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:14.306237 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.314690 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.321603 read(5, "Name:\tksoftirqd/0\nState:\tS (slee"..., 
1024) = 463
694   11:51:14.330424 close(5)          = 0
694   11:51:14.337262 munmap(0x77e5d000, 4096) = 0
694   11:51:14.344632 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:14.351594 close(4)          = 0
694   11:51:14.358361 open("/proc/3/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.366696 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.374497 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.381812 read(4, "", 1024) = 0
694   11:51:14.388675 close(4)          = 0
694   11:51:14.395620 munmap(0x77e5d000, 4096) = 0
694   11:51:14.402927 open("/proc/4/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.407363 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.413294 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.418389 read(4, "Name:\tkworker/0:0\nState:\tS (slee"..., 
1024) = 462
694   11:51:14.425571 close(4)          = 0
694   11:51:14.430971 munmap(0x77e5d000, 4096) = 0
694   11:51:14.436241 openat(AT_FDCWD, "/proc/4/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:14.441963 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:14.448108 open("/proc/4/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:14.454529 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.461126 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.467779 read(5, "Name:\tkworker/0:0\nState:\tS (slee"..., 
1024) = 462
694   11:51:14.475023 close(5)          = 0
694   11:51:14.481191 munmap(0x77e5d000, 4096) = 0
694   11:51:14.487307 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:14.493446 close(4)          = 0
694   11:51:14.499443 open("/proc/4/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.505923 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.512697 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.520486 read(4, "", 1024) = 0
694   11:51:14.526420 close(4)          = 0
694   11:51:14.532661 munmap(0x77e5d000, 4096) = 0
694   11:51:14.538844 open("/proc/5/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.545378 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.552260 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.558219 read(4, "Name:\tkworker/0:0H\nState:\tS (sle"..., 
1024) = 463
694   11:51:14.566139 close(4)          = 0
694   11:51:14.572453 munmap(0x77e5d000, 4096) = 0
694   11:51:14.578562 openat(AT_FDCWD, "/proc/5/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:14.585159 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:14.592096 open("/proc/5/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:14.598401 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.605205 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.611361 read(5, "Name:\tkworker/0:0H\nState:\tS (sle"..., 
1024) = 463
694   11:51:14.619138 close(5)          = 0
694   11:51:14.626091 munmap(0x77e5d000, 4096) = 0
694   11:51:14.632728 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:14.638808 close(4)          = 0
694   11:51:14.645249 open("/proc/5/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.652079 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.658755 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.665932 read(4, "", 1024) = 0
694   11:51:14.672401 close(4)          = 0
694   11:51:14.678455 munmap(0x77e5d000, 4096) = 0
694   11:51:14.684734 open("/proc/6/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.691916 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.699135 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.706554 read(4, "Name:\tkworker/u2:0\nState:\tS (sle"..., 
1024) = 468
694   11:51:14.714437 close(4)          = 0
694   11:51:14.721338 munmap(0x77e5d000, 4096) = 0
694   11:51:14.728910 openat(AT_FDCWD, "/proc/6/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:14.736073 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:14.744328 open("/proc/6/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:14.751490 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.758893 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.765879 read(5, "Name:\tkworker/u2:0\nState:\tS (sle"..., 
1024) = 468
694   11:51:14.773765 close(5)          = 0
694   11:51:14.779611 munmap(0x77e5d000, 4096) = 0
694   11:51:14.785158 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:14.789718 close(4)          = 0
694   11:51:14.795016 open("/proc/6/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.800689 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.806400 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.812191 read(4, "", 1024) = 0
694   11:51:14.817241 close(4)          = 0
694   11:51:14.822588 munmap(0x77e5d000, 4096) = 0
694   11:51:14.828699 open("/proc/7/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.834448 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.840525 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.845722 read(4, "Name:\trcuc/0\nState:\tS (sleeping)"..., 
1024) = 460
694   11:51:14.852304 close(4)          = 0
694   11:51:14.858048 munmap(0x77e5d000, 4096) = 0
694   11:51:14.865077 openat(AT_FDCWD, "/proc/7/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:14.871701 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:14.878207 open("/proc/7/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:14.884724 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.891441 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.897411 read(5, "Name:\trcuc/0\nState:\tS (sleeping)"..., 
1024) = 460
694   11:51:14.904465 close(5)          = 0
694   11:51:14.911372 munmap(0x77e5d000, 4096) = 0
694   11:51:14.917512 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:14.924570 close(4)          = 0
694   11:51:14.930923 open("/proc/7/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.937190 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.944083 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.950420 read(4, "", 1024) = 0
694   11:51:14.956296 close(4)          = 0
694   11:51:14.963461 munmap(0x77e5d000, 4096) = 0
694   11:51:14.969673 open("/proc/8/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:14.976271 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:14.983300 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:14.989403 read(4, "Name:\trcub/0\nState:\tS (sleeping)"..., 
1024) = 457
694   11:51:14.996785 close(4)          = 0
694   11:51:15.003112 munmap(0x77e5d000, 4096) = 0
694   11:51:15.010337 openat(AT_FDCWD, "/proc/8/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:15.016727 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:15.023749 open("/proc/8/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:15.031147 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.037881 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.044168 read(5, "Name:\trcub/0\nState:\tS (sleeping)"..., 
1024) = 457
694   11:51:15.051425 close(5)          = 0
694   11:51:15.057245 munmap(0x77e5d000, 4096) = 0
694   11:51:15.065307 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:15.072434 close(4)          = 0
694   11:51:15.079226 open("/proc/8/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.086587 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.094059 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.101831 read(4, "", 1024) = 0
694   11:51:15.108518 close(4)          = 0
694   11:51:15.115342 munmap(0x77e5d000, 4096) = 0
694   11:51:15.122617 open("/proc/9/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.129405 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.138608 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.145739 read(4, "Name:\trcu_preempt\nState:\tS (slee"..., 
1024) = 465
694   11:51:15.153744 close(4)          = 0
694   11:51:15.160727 munmap(0x77e5d000, 4096) = 0
694   11:51:15.166879 openat(AT_FDCWD, "/proc/9/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:15.171911 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:15.178386 open("/proc/9/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:15.183961 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.189669 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.194948 read(5, "Name:\trcu_preempt\nState:\tS (slee"..., 
1024) = 465
694   11:51:15.201302 close(5)          = 0
694   11:51:15.206339 munmap(0x77e5d000, 4096) = 0
694   11:51:15.212831 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:15.218753 close(4)          = 0
694   11:51:15.225043 open("/proc/9/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.231423 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.238676 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.245725 read(4, "", 1024) = 0
694   11:51:15.251906 close(4)          = 0
694   11:51:15.257823 munmap(0x77e5d000, 4096) = 0
694   11:51:15.264234 open("/proc/10/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.270807 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.277425 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.283551 read(4, "Name:\trcu_bh\nState:\tS (sleeping)"..., 
1024) = 459
694   11:51:15.291290 close(4)          = 0
694   11:51:15.297217 munmap(0x77e5d000, 4096) = 0
694   11:51:15.303670 openat(AT_FDCWD, "/proc/10/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:15.309944 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:15.316859 open("/proc/10/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:15.323368 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.329920 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.336893 read(5, "Name:\trcu_bh\nState:\tS (sleeping)"..., 
1024) = 459
694   11:51:15.344803 close(5)          = 0
694   11:51:15.351095 munmap(0x77e5d000, 4096) = 0
694   11:51:15.357339 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:15.363588 close(4)          = 0
694   11:51:15.369784 open("/proc/10/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.376492 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.383416 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.390516 read(4, "", 1024) = 0
694   11:51:15.396569 close(4)          = 0
694   11:51:15.402952 munmap(0x77e5d000, 4096) = 0
694   11:51:15.409243 open("/proc/11/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.415890 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.422832 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.429017 read(4, "Name:\trcu_sched\nState:\tS (sleepi"..., 
1024) = 462
694   11:51:15.436233 close(4)          = 0
694   11:51:15.443985 munmap(0x77e5d000, 4096) = 0
694   11:51:15.451160 openat(AT_FDCWD, "/proc/11/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:15.458166 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:15.465722 open("/proc/11/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:15.472839 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.481143 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.487946 read(5, "Name:\trcu_sched\nState:\tS (sleepi"..., 
1024) = 462
694   11:51:15.495799 close(5)          = 0
694   11:51:15.502788 munmap(0x77e5d000, 4096) = 0
694   11:51:15.509631 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:15.517349 close(4)          = 0
694   11:51:15.524388 open("/proc/11/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.531635 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.539005 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.546498 read(4, "", 1024) = 0
694   11:51:15.552500 close(4)          = 0
694   11:51:15.556672 munmap(0x77e5d000, 4096) = 0
694   11:51:15.562427 open("/proc/12/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.567709 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.573660 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.578797 read(4, "Name:\tkhelper\nState:\tS (sleeping"..., 
1024) = 460
694   11:51:15.585267 close(4)          = 0
694   11:51:15.590749 munmap(0x77e5d000, 4096) = 0
694   11:51:15.596039 openat(AT_FDCWD, "/proc/12/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:15.601622 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:15.608172 open("/proc/12/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:15.614615 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.621205 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.627944 read(5, "Name:\tkhelper\nState:\tS (sleeping"..., 
1024) = 460
694   11:51:15.635057 close(5)          = 0
694   11:51:15.641305 munmap(0x77e5d000, 4096) = 0
694   11:51:15.648272 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:15.654484 close(4)          = 0
694   11:51:15.660817 open("/proc/12/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.667054 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.674752 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.681061 read(4, "", 1024) = 0
694   11:51:15.687075 close(4)          = 0
694   11:51:15.693339 munmap(0x77e5d000, 4096) = 0
694   11:51:15.699512 open("/proc/13/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.706070 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.712976 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.719006 read(4, "Name:\tkdevtmpfs\nState:\tS (sleepi"..., 
1024) = 463
694   11:51:15.726937 close(4)          = 0
694   11:51:15.733247 munmap(0x77e5d000, 4096) = 0
694   11:51:15.739439 openat(AT_FDCWD, "/proc/13/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:15.746797 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:15.753819 open("/proc/13/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:15.760286 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.766953 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.774002 read(5, "Name:\tkdevtmpfs\nState:\tS (sleepi"..., 
1024) = 463
694   11:51:15.781302 close(5)          = 0
694   11:51:15.787391 munmap(0x77e5d000, 4096) = 0
694   11:51:15.793890 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:15.800318 close(4)          = 0
694   11:51:15.806461 open("/proc/13/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.813129 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.819794 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.827061 read(4, "", 1024) = 0
694   11:51:15.833438 close(4)          = 0
694   11:51:15.839183 munmap(0x77e5d000, 4096) = 0
694   11:51:15.846267 open("/proc/14/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.854289 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.861799 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.869310 read(4, "Name:\tkworker/u2:1\nState:\tS (sle"..., 
1024) = 468
694   11:51:15.877445 close(4)          = 0
694   11:51:15.884289 munmap(0x77e5d000, 4096) = 0
694   11:51:15.891385 openat(AT_FDCWD, "/proc/14/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:15.898322 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:15.906728 open("/proc/14/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:15.914057 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.921527 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.927663 read(5, "Name:\tkworker/u2:1\nState:\tS (sle"..., 
1024) = 468
694   11:51:15.933054 close(5)          = 0
694   11:51:15.937941 munmap(0x77e5d000, 4096) = 0
694   11:51:15.943325 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:15.948232 close(4)          = 0
694   11:51:15.955395 open("/proc/14/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.961093 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:15.966801 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:15.972311 read(4, "", 1024) = 0
694   11:51:15.977426 close(4)          = 0
694   11:51:15.982887 munmap(0x77e5d000, 4096) = 0
694   11:51:15.988085 open("/proc/118/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:15.994561 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.001274 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.007209 read(4, "Name:\twriteback\nState:\tS (sleepi"..., 
1024) = 464
694   11:51:16.014268 close(4)          = 0
694   11:51:16.021164 munmap(0x77e5d000, 4096) = 0
694   11:51:16.027166 openat(AT_FDCWD, "/proc/118/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:16.033624 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:16.040454 open("/proc/118/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:16.046671 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.054189 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.060357 read(5, "Name:\twriteback\nState:\tS (sleepi"..., 
1024) = 464
694   11:51:16.067288 close(5)          = 0
694   11:51:16.074228 munmap(0x77e5d000, 4096) = 0
694   11:51:16.080757 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:16.086773 close(4)          = 0
694   11:51:16.093149 open("/proc/118/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.099442 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.106462 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.112786 read(4, "", 1024) = 0
694   11:51:16.119563 close(4)          = 0
694   11:51:16.125735 munmap(0x77e5d000, 4096) = 0
694   11:51:16.132331 open("/proc/153/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.138730 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.145692 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.152913 read(4, "Name:\tkworker/0:1\nState:\tS (slee"..., 
1024) = 469
694   11:51:16.159937 close(4)          = 0
694   11:51:16.166119 munmap(0x77e5d000, 4096) = 0
694   11:51:16.173435 openat(AT_FDCWD, "/proc/153/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:16.179872 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:16.186971 open("/proc/153/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:16.193335 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.200852 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.207501 read(5, "Name:\tkworker/0:1\nState:\tS (slee"..., 
1024) = 469
694   11:51:16.216107 close(5)          = 0
694   11:51:16.223036 munmap(0x77e5d000, 4096) = 0
694   11:51:16.229943 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:16.236870 close(4)          = 0
694   11:51:16.243744 open("/proc/153/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.251680 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.259029 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.266955 read(4, "", 1024) = 0
694   11:51:16.273972 close(4)          = 0
694   11:51:16.280942 munmap(0x77e5d000, 4096) = 0
694   11:51:16.288534 open("/proc/154/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.295999 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.303669 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.310600 read(4, "Name:\trpciod\nState:\tS (sleeping)"..., 
1024) = 461
694   11:51:16.317950 close(4)          = 0
694   11:51:16.322403 munmap(0x77e5d000, 4096) = 0
694   11:51:16.327469 openat(AT_FDCWD, "/proc/154/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:16.333034 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:16.339514 open("/proc/154/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:16.345160 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.351035 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.356953 read(5, "Name:\trpciod\nState:\tS (sleeping)"..., 
1024) = 461
694   11:51:16.364769 close(5)          = 0
694   11:51:16.370965 munmap(0x77e5d000, 4096) = 0
694   11:51:16.377071 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:16.383182 close(4)          = 0
694   11:51:16.389074 open("/proc/154/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.396437 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.403300 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.409327 read(4, "", 1024) = 0
694   11:51:16.415581 close(4)          = 0
694   11:51:16.421806 munmap(0x77e5d000, 4096) = 0
694   11:51:16.427928 open("/proc/231/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.434399 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.442015 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.448045 read(4, "Name:\tkhungtaskd\nState:\tS (sleep"..., 
1024) = 465
694   11:51:16.455120 close(4)          = 0
694   11:51:16.461354 munmap(0x77e5d000, 4096) = 0
694   11:51:16.468271 openat(AT_FDCWD, "/proc/231/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:16.474880 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:16.481786 open("/proc/231/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:16.488061 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.495723 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.502044 read(5, "Name:\tkhungtaskd\nState:\tS (sleep"..., 
1024) = 465
694   11:51:16.509155 close(5)          = 0
694   11:51:16.515307 munmap(0x77e5d000, 4096) = 0
694   11:51:16.521903 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:16.527941 close(4)          = 0
694   11:51:16.534286 open("/proc/231/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.541780 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.548462 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.554886 read(4, "", 1024) = 0
694   11:51:16.561278 close(4)          = 0
694   11:51:16.568109 munmap(0x77e5d000, 4096) = 0
694   11:51:16.574670 open("/proc/234/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.581359 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.588023 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.594942 read(4, "Name:\tkswapd0\nState:\tS (sleeping"..., 
1024) = 462
694   11:51:16.602799 close(4)          = 0
694   11:51:16.609490 munmap(0x77e5d000, 4096) = 0
694   11:51:16.616565 openat(AT_FDCWD, "/proc/234/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:16.623833 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:16.632130 open("/proc/234/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:16.639186 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.646634 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.653639 read(5, "Name:\tkswapd0\nState:\tS (sleeping"..., 
1024) = 462
694   11:51:16.661488 close(5)          = 0
694   11:51:16.668897 munmap(0x77e5d000, 4096) = 0
694   11:51:16.676293 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:16.683981 close(4)          = 0
694   11:51:16.691220 open("/proc/234/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.698252 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.705110 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.711301 read(4, "", 1024) = 0
694   11:51:16.716274 close(4)          = 0
694   11:51:16.721609 munmap(0x77e5d000, 4096) = 0
694   11:51:16.726821 open("/proc/288/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.732486 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.738147 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.743590 read(4, "Name:\tfsnotify_mark\nState:\tS (sl"..., 
1024) = 468
694   11:51:16.749655 close(4)          = 0
694   11:51:16.754815 munmap(0x77e5d000, 4096) = 0
694   11:51:16.760343 openat(AT_FDCWD, "/proc/288/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:16.766444 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:16.773866 open("/proc/288/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:16.781024 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.787588 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.793793 read(5, "Name:\tfsnotify_mark\nState:\tS (sl"..., 
1024) = 468
694   11:51:16.800887 close(5)          = 0
694   11:51:16.806757 munmap(0x77e5d000, 4096) = 0
694   11:51:16.813162 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:16.819059 close(4)          = 0
694   11:51:16.825286 open("/proc/288/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.832566 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.839153 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.845426 read(4, "", 1024) = 0
694   11:51:16.851680 close(4)          = 0
694   11:51:16.857604 munmap(0x77e5d000, 4096) = 0
694   11:51:16.863942 open("/proc/289/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.870538 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.878645 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.884981 read(4, "Name:\tnfsiod\nState:\tS (sleeping)"..., 
1024) = 461
694   11:51:16.892161 close(4)          = 0
694   11:51:16.898136 munmap(0x77e5d000, 4096) = 0
694   11:51:16.904722 openat(AT_FDCWD, "/proc/289/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:16.911390 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:16.918096 open("/proc/289/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:16.924629 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.932276 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.938435 read(5, "Name:\tnfsiod\nState:\tS (sleeping)"..., 
1024) = 461
694   11:51:16.945789 close(5)          = 0
694   11:51:16.952151 munmap(0x77e5d000, 4096) = 0
694   11:51:16.958396 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:16.964709 close(4)          = 0
694   11:51:16.971156 open("/proc/289/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:16.979290 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:16.986478 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:16.993570 read(4, "", 1024) = 0
694   11:51:17.000451 close(4)          = 0
694   11:51:17.007141 munmap(0x77e5d000, 4096) = 0
694   11:51:17.014058 open("/proc/294/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.022190 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.029604 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.036718 read(4, "Name:\tcrypto\nState:\tS (sleeping)"..., 
1024) = 461
694   11:51:17.044642 close(4)          = 0
694   11:51:17.051551 munmap(0x77e5d000, 4096) = 0
694   11:51:17.059220 openat(AT_FDCWD, "/proc/294/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:17.066952 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:17.074805 open("/proc/294/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:17.081401 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.086210 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.092389 read(5, "Name:\tcrypto\nState:\tS (sleeping)"..., 
1024) = 461
694   11:51:17.098413 close(5)          = 0
694   11:51:17.103582 munmap(0x77e5d000, 4096) = 0
694   11:51:17.109623 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:17.114991 close(4)          = 0
694   11:51:17.120510 open("/proc/294/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.125963 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.132091 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.137695 read(4, "", 1024) = 0
694   11:51:17.143415 close(4)          = 0
694   11:51:17.149321 munmap(0x77e5d000, 4096) = 0
694   11:51:17.155766 open("/proc/337/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.162339 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.168815 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.175830 read(4, "Name:\tbond0\nState:\tS (sleeping)\n"..., 
1024) = 460
694   11:51:17.183677 close(4)          = 0
694   11:51:17.189586 munmap(0x77e5d000, 4096) = 0
694   11:51:17.196048 openat(AT_FDCWD, "/proc/337/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:17.202682 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:17.209398 open("/proc/337/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:17.215936 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.223480 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.229572 read(5, "Name:\tbond0\nState:\tS (sleeping)\n"..., 
1024) = 460
694   11:51:17.236840 close(5)          = 0
694   11:51:17.243138 munmap(0x77e5d000, 4096) = 0
694   11:51:17.249488 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:17.255835 close(4)          = 0
694   11:51:17.262355 open("/proc/337/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.268616 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.276473 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.282903 read(4, "", 1024) = 0
694   11:51:17.289840 close(4)          = 0
694   11:51:17.296108 munmap(0x77e5d000, 4096) = 0
694   11:51:17.302668 open("/proc/466/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.309075 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.316129 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.323230 read(4, "Name:\tdeferwq\nState:\tS (sleeping"..., 
1024) = 462
694   11:51:17.330570 close(4)          = 0
694   11:51:17.336711 munmap(0x77e5d000, 4096) = 0
694   11:51:17.343304 openat(AT_FDCWD, "/proc/466/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:17.349620 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:17.356823 open("/proc/466/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:17.364050 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.372389 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.379183 read(5, "Name:\tdeferwq\nState:\tS (sleeping"..., 
1024) = 462
694   11:51:17.386940 close(5)          = 0
694   11:51:17.394561 munmap(0x77e5d000, 4096) = 0
694   11:51:17.401732 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:17.409207 close(4)          = 0
694   11:51:17.416242 open("/proc/466/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.423698 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.431352 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.438103 read(4, "", 1024) = 0
694   11:51:17.445892 close(4)          = 0
694   11:51:17.452862 munmap(0x77e5d000, 4096) = 0
694   11:51:17.459828 open("/proc/467/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.467258 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.474343 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.479407 read(4, "Name:\tkworker/u2:2\nState:\tS (sle"..., 
1024) = 467
694   11:51:17.486337 close(4)          = 0
694   11:51:17.491639 munmap(0x77e5d000, 4096) = 0
694   11:51:17.496848 openat(AT_FDCWD, "/proc/467/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:17.503317 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:17.509051 open("/proc/467/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:17.515557 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.522292 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.528286 read(5, "Name:\tkworker/u2:2\nState:\tS (sle"..., 
1024) = 467
694   11:51:17.535435 close(5)          = 0
694   11:51:17.541663 munmap(0x77e5d000, 4096) = 0
694   11:51:17.548509 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:17.554664 close(4)          = 0
694   11:51:17.560928 open("/proc/467/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.567136 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.573916 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.579845 read(4, "", 1024) = 0
694   11:51:17.586019 close(4)          = 0
694   11:51:17.592124 munmap(0x77e5d000, 4096) = 0
694   11:51:17.599800 open("/proc/469/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.606378 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.613332 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.619465 read(4, "Name:\tff000a80.spi\nState:\tS (sle"..., 
1024) = 467
694   11:51:17.626650 close(4)          = 0
694   11:51:17.632890 munmap(0x77e5d000, 4096) = 0
694   11:51:17.639017 openat(AT_FDCWD, "/proc/469/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:17.646310 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:17.653228 open("/proc/469/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:17.659568 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.666506 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.672910 read(5, "Name:\tff000a80.spi\nState:\tS (sle"..., 
1024) = 467
694   11:51:17.680197 close(5)          = 0
694   11:51:17.686182 munmap(0x77e5d000, 4096) = 0
694   11:51:17.692627 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:17.699391 close(4)          = 0
694   11:51:17.706644 open("/proc/469/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.713435 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.720423 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.726547 read(4, "", 1024) = 0
694   11:51:17.732905 close(4)          = 0
694   11:51:17.738925 munmap(0x77e5d000, 4096) = 0
694   11:51:17.746136 open("/proc/500/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.753349 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.760724 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.767387 read(4, "Name:\tkworker/u2:3\nState:\tS (sle"..., 
1024) = 467
694   11:51:17.775225 close(4)          = 0
694   11:51:17.782942 munmap(0x77e5d000, 4096) = 0
694   11:51:17.789760 openat(AT_FDCWD, "/proc/500/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:17.796976 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:17.804492 open("/proc/500/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:17.812683 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.820993 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.827752 read(5, "Name:\tkworker/u2:3\nState:\tS (sle"..., 
1024) = 467
694   11:51:17.835783 close(5)          = 0
694   11:51:17.842847 munmap(0x77e5d000, 4096) = 0
694   11:51:17.849736 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:17.855954 close(4)          = 0
694   11:51:17.861619 open("/proc/500/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.866879 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.872899 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.878042 read(4, "", 1024) = 0
694   11:51:17.883414 close(4)          = 0
694   11:51:17.888518 munmap(0x77e5d000, 4096) = 0
694   11:51:17.894097 open("/proc/539/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:17.899517 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.905523 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.911740 read(4, "Name:\tubi_bgt0d\nState:\tS (sleepi"..., 
1024) = 464
694   11:51:17.918235 close(4)          = 0
694   11:51:17.924279 munmap(0x77e5d000, 4096) = 0
694   11:51:17.930547 openat(AT_FDCWD, "/proc/539/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:17.937549 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:17.944474 open("/proc/539/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:17.951048 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:17.957632 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:17.963812 read(5, "Name:\tubi_bgt0d\nState:\tS (sleepi"..., 
1024) = 464
694   11:51:17.970965 close(5)          = 0
694   11:51:17.976852 munmap(0x77e5d000, 4096) = 0
694   11:51:17.984019 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:17.989928 close(4)          = 0
694   11:51:17.996338 open("/proc/539/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.003045 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.011074 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.017153 read(4, "", 1024) = 0
694   11:51:18.023439 close(4)          = 0
694   11:51:18.029339 munmap(0x77e5d000, 4096) = 0
694   11:51:18.036654 open("/proc/542/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.043385 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.050323 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.056523 read(4, "Name:\tubifs_bgt0_0\nState:\tS (sle"..., 
1024) = 467
694   11:51:18.063871 close(4)          = 0
694   11:51:18.069897 munmap(0x77e5d000, 4096) = 0
694   11:51:18.076497 openat(AT_FDCWD, "/proc/542/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:18.083890 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:18.090847 open("/proc/542/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:18.097249 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.104154 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.110405 read(5, "Name:\tubifs_bgt0_0\nState:\tS (sle"..., 
1024) = 467
694   11:51:18.118354 close(5)          = 0
694   11:51:18.124487 munmap(0x77e5d000, 4096) = 0
694   11:51:18.132434 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:18.139089 close(4)          = 0
694   11:51:18.146155 open("/proc/542/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.153549 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.161089 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.168572 read(4, "", 1024) = 0
694   11:51:18.175654 close(4)          = 0
694   11:51:18.182693 munmap(0x77e5d000, 4096) = 0
694   11:51:18.189598 open("/proc/638/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.196879 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.205107 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.212190 read(4, "Name:\tsyslogd\nState:\tS (sleeping"..., 
1024) = 695
694   11:51:18.220195 close(4)          = 0
694   11:51:18.227742 munmap(0x77e5d000, 4096) = 0
694   11:51:18.234929 openat(AT_FDCWD, "/proc/638/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:18.241506 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:18.247136 open("/proc/638/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:18.252698 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.258368 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.263709 read(5, "Name:\tsyslogd\nState:\tS (sleeping"..., 
1024) = 695
694   11:51:18.269927 close(5)          = 0
694   11:51:18.275390 munmap(0x77e5d000, 4096) = 0
694   11:51:18.280939 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:18.286772 close(4)          = 0
694   11:51:18.293012 open("/proc/638/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.299163 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.305840 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.312806 read(4, "00100000-00103000 r-xp 00000000 "..., 
1024) = 1024
694   11:51:18.322234 read(4, "   /lib/libpam.so.0.83.1\n0fcdf00"..., 
1024) = 1024
694   11:51:18.332554 read(4, ".16.so\n0ffdf000-0ffee000 ---p 00"..., 
1024) = 681
694   11:51:18.341531 read(4, "", 1024) = 0
694   11:51:18.347507 close(4)          = 0
694   11:51:18.353486 munmap(0x77e5d000, 4096) = 0
694   11:51:18.359640 open("/proc/658/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.367038 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.374048 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.380422 read(4, "Name:\tinetd\nState:\tS (sleeping)\n"..., 
1024) = 694
694   11:51:18.387622 close(4)          = 0
694   11:51:18.393831 munmap(0x77e5d000, 4096) = 0
694   11:51:18.400321 openat(AT_FDCWD, "/proc/658/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:18.406693 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:18.413617 open("/proc/658/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:18.420982 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.427752 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.434930 read(5, "Name:\tinetd\nState:\tS (sleeping)\n"..., 
1024) = 694
694   11:51:18.442328 close(5)          = 0
694   11:51:18.448398 munmap(0x77e5d000, 4096) = 0
694   11:51:18.455108 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:18.461456 close(4)          = 0
694   11:51:18.468373 open("/proc/658/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.474973 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.482627 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.489345 read(4, "00100000-00103000 r-xp 00000000 "..., 
1024) = 1024
694   11:51:18.499773 read(4, "r-xp 00000000 00:0b 294        /"..., 
1024) = 1024
694   11:51:18.509858 read(4, "00 00:00 0 \n0fed0000-0fed2000 r-"..., 
1024) = 1024
694   11:51:18.521586 read(4, "     [stack]\n", 1024) = 13
694   11:51:18.528633 read(4, "", 1024) = 0
694   11:51:18.535547 close(4)          = 0
694   11:51:18.542559 munmap(0x77e5d000, 4096) = 0
694   11:51:18.549362 open("/proc/670/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.558291 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.566442 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.573681 read(4, "Name:\tcrond\nState:\tS (sleeping)\n"..., 
1024) = 692
694   11:51:18.581882 close(4)          = 0
694   11:51:18.588518 munmap(0x77e5d000, 4096) = 0
694   11:51:18.596676 openat(AT_FDCWD, "/proc/670/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:18.604154 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:18.611880 open("/proc/670/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:18.618926 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.626491 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.634319 read(5, "Name:\tcrond\nState:\tS (sleeping)\n"..., 
1024) = 692
694   11:51:18.642956 close(5)          = 0
694   11:51:18.647172 munmap(0x77e5d000, 4096) = 0
694   11:51:18.652624 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:18.657594 close(4)          = 0
694   11:51:18.663708 open("/proc/670/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.669021 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.675131 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.680545 read(4, "00100000-00103000 r-xp 00000000 "..., 
1024) = 1024
694   11:51:18.689010 read(4, "   /lib/libpam.so.0.83.1\n0fcdf00"..., 
1024) = 1024
694   11:51:18.697973 read(4, ".16.so\n0ffdf000-0ffee000 ---p 00"..., 
1024) = 737
694   11:51:18.707791 read(4, "", 1024) = 0
694   11:51:18.713860 close(4)          = 0
694   11:51:18.719773 munmap(0x77e5d000, 4096) = 0
694   11:51:18.726270 open("/proc/684/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.732788 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.739364 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.745558 read(4, "Name:\tlogin\nState:\tS (sleeping)\n"..., 
1024) = 694
694   11:51:18.753438 close(4)          = 0
694   11:51:18.759320 munmap(0x77e5d000, 4096) = 0
694   11:51:18.765759 openat(AT_FDCWD, "/proc/684/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:18.773201 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:18.779883 open("/proc/684/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:18.786501 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.793372 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.799401 read(5, "Name:\tlogin\nState:\tS (sleeping)\n"..., 
1024) = 694
694   11:51:18.807462 close(5)          = 0
694   11:51:18.813568 munmap(0x77e5d000, 4096) = 0
694   11:51:18.819934 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:18.826347 close(4)          = 0
694   11:51:18.832862 open("/proc/684/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.839267 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.846324 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.853527 read(4, "00100000-00103000 r-xp 00000000 "..., 
1024) = 1024
694   11:51:18.863257 read(4, "/security/pam_nologin.so\n0fb5000"..., 
1024) = 1024
694   11:51:18.873066 read(4, "nix.so\n0fbfe000-0fc0a000 rwxp 00"..., 
1024) = 1024
694   11:51:18.884132 read(4, "---p 00002000 00:0b 294        /"..., 
1024) = 1024
694   11:51:18.894492 read(4, "bpam_misc.so.0.82.0\n0fed2000-0fe"..., 
1024) = 954
694   11:51:18.905092 read(4, "", 1024) = 0
694   11:51:18.912680 close(4)          = 0
694   11:51:18.919480 munmap(0x77e5d000, 4096) = 0
694   11:51:18.926797 open("/proc/685/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:18.934125 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:18.941906 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:18.949457 read(4, "Name:\tsh\nState:\tS (sleeping)\nTgi"..., 
1024) = 696
694   11:51:18.957552 close(4)          = 0
694   11:51:18.964460 munmap(0x77e5d000, 4096) = 0
694   11:51:18.971764 openat(AT_FDCWD, "/proc/685/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:18.978789 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:18.987101 open("/proc/685/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:18.994455 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:19.002136 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:19.009790 read(5, "Name:\tsh\nState:\tS (sleeping)\nTgi"..., 
1024) = 696
694   11:51:19.017918 close(5)          = 0
694   11:51:19.025797 munmap(0x77e5d000, 4096) = 0
694   11:51:19.033329 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:19.040486 close(4)          = 0
694   11:51:19.047454 open("/proc/685/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:19.054811 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:19.059776 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:19.065134 read(4, "00100000-00103000 r-xp 00000000 "..., 
1024) = 1024
694   11:51:19.074703 read(4, "   /lib/libpam.so.0.83.1\n0fcdf00"..., 
1024) = 1024
694   11:51:19.083351 read(4, ".16.so\n0ffdf000-0ffee000 ---p 00"..., 
1024) = 722
694   11:51:19.091711 read(4, "", 1024) = 0
694   11:51:19.096820 close(4)          = 0
694   11:51:19.102173 munmap(0x77e5d000, 4096) = 0
694   11:51:19.107466 open("/proc/691/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:19.113954 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:19.120709 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:19.126641 read(4, "Name:\tstrace\nState:\tR (running)\n"..., 
1024) = 700
694   11:51:19.133772 close(4)          = 0
694   11:51:19.139564 munmap(0x77e5d000, 4096) = 0
694   11:51:19.146743 openat(AT_FDCWD, "/proc/691/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:19.153355 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:19.159998 open("/proc/691/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:19.166592 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:19.173416 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:19.179529 read(5, "Name:\tstrace\nState:\tR (running)\n"..., 
1024) = 700
694   11:51:19.186763 close(5)          = 0
694   11:51:19.193723 munmap(0x77e5d000, 4096) = 0
694   11:51:19.199966 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:19.206291 close(4)          = 0
694   11:51:19.212662 open("/proc/691/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:19.219909 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:19.226895 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:19.233366 read(4, "00100000-00103000 r-xp 00000000 "..., 
1024) = 836
694   11:51:19.242714 read(4, "", 1024) = 0
694   11:51:19.249549 close(4)          = 0
694   11:51:19.255812 munmap(0x77e5d000, 4096) = 0
694   11:51:19.262467 open("/proc/694/status", O_RDONLY|O_LARGEFILE) = 4
694   11:51:19.269086 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:19.276204 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:19.282513 read(4, "Name:\tperf\nState:\tR (running)\nTg"..., 
1024) = 700
694   11:51:19.289765 close(4)          = 0
694   11:51:19.296760 munmap(0x77e5d000, 4096) = 0
694   11:51:19.303367 openat(AT_FDCWD, "/proc/694/task", 
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
694   11:51:19.310634 getdents64(4, /* 3 entries */, 32768) = 72
694   11:51:19.318364 open("/proc/694/status", O_RDONLY|O_LARGEFILE) = 5
694   11:51:19.326498 fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:19.334031 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:19.341879 read(5, "Name:\tperf\nState:\tR (running)\nTg"..., 
1024) = 700
694   11:51:19.349773 close(5)          = 0
694   11:51:19.356641 munmap(0x77e5d000, 4096) = 0
694   11:51:19.363878 getdents64(4, /* 0 entries */, 32768) = 0
694   11:51:19.370725 close(4)          = 0
694   11:51:19.378322 open("/proc/694/maps", O_RDONLY|O_LARGEFILE) = 4
694   11:51:19.385784 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:19.393457 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e5d000
694   11:51:19.400568 read(4, "00100000-00103000 r-xp 00000000 "..., 
1024) = 1024
694   11:51:19.410910 read(4, "ib/librt-2.16.so\n0ffa9000-0ffaa0"..., 
1024) = 1004
694   11:51:19.422308 read(4, "", 1024) = 0
694   11:51:19.429095 close(4)          = 0
694   11:51:19.436028 munmap(0x77e5d000, 4096) = 0
694   11:51:19.443206 getdents64(3, /* 0 entries */, 32768) = 0
694   11:51:19.450960 close(3)          = 0
694   11:51:19.458874 perf_event_open(0x1018d6a8, 0xffffffff, 0, 
0xffffffff, 0) = -1 ENOENT (No such file or directory)
694   11:51:19.465619 perf_event_open(0x1018d6a8, 0xffffffff, 0, 
0xffffffff, 0) = 3
694   11:51:19.471432 mmap2(NULL, 528384, PROT_READ|PROT_WRITE, 
MAP_SHARED, 3, 0) = 0x77ddd000
694   11:51:19.482744 fcntl64(3, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
694   11:51:19.487814 ioctl(3, PERF_EVENT_IOC_ENABLE, 0) = 0
694   11:51:19.498864 poll([{fd=3, events=POLLIN}], 1, 100) = 0 (Timeout)
694   11:51:19.612961 
open("/root/.debug/.build-id/4a/aaafa9c5c81022ef1baa6132648d6e76db07e5", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:19.623077 open("vmlinux", O_RDONLY|O_LARGEFILE) = -1 ENOENT 
(No such file or directory)
694   11:51:19.632862 open("/boot/vmlinux", O_RDONLY|O_LARGEFILE) = -1 
ENOENT (No such file or directory)
694   11:51:19.642628 
open("/boot/vmlinux-3.12.1-s3k-drv-999-svn5426_knld-999-svn5415", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:19.653954 
open("/lib/modules/3.12.1-s3k-drv-999-svn5426_knld-999-svn5415/build/vmlinux", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:19.664458 
open("/usr/lib/debug/lib/modules/3.12.1-s3k-drv-999-svn5426_knld-999-svn5415/vmlinux", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:19.675214 open("/sys/kernel/notes", O_RDONLY|O_LARGEFILE) = 4
694   11:51:19.685188 fstat64(4, {st_mode=S_IFREG|0444, st_size=36, 
...}) = 0
694   11:51:19.696847 read(4, 
"\0\0\0\4\0\0\0\24\0\0\0\3GNU\0J\252\257\251\305\310\20\"\357\33\252a2d\215n"..., 
36) = 36
694   11:51:19.706847 close(4)          = 0
694   11:51:19.716195 open("/proc/kallsyms", O_RDONLY|O_LARGEFILE) = 4
694   11:51:19.727402 fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
694   11:51:19.738116 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77ddc000
694   11:51:19.747950 read(4, "c0000000 T _start\nc0000000 T _st"..., 
1024) = 1024
694   11:51:19.761396 read(4, "c00019a4 t i0x1900\nc0001a00 t Tr"..., 
1024) = 1024
694   11:51:19.774869 read(4, "o_show_syscall_exit\nc0003a18 T d"..., 
1024) = 1024
694   11:51:19.788354 read(4, "0005d30 T get_fpexc_mode\nc0005d7"..., 
1024) = 1024
694   11:51:19.803091 read(4, "index_release\nc0007948 t shared_"..., 
1024) = 1024
694   11:51:19.816697 read(4, " T StackOverflow\nc0009148 T user"..., 
1024) = 1024
694   11:51:19.830354 read(4, "ne_restart\nc000abb0 T check_lega"..., 
1024) = 1024
694   11:51:19.844121 read(4, "a80 T flush_instruction_cache\nc0"..., 
1024) = 1024
694   11:51:19.857914 read(4, "ace_cont\nc000c9f8 T ret_from_sys"..., 
1024) = 1024
694   11:51:19.872918 read(4, "ioport_unmap\nc000d570 T iowrite3"..., 
1024) = 1024
694   11:51:19.886840 read(4, "_prot\nc000ef00 T ioremap_wc\nc000"..., 
1024) = 1024
694   11:51:19.902145 read(4, "t_error\nc0010154 T __div64_32\nc0"..., 
1024) = 1024
694   11:51:19.915871 read(4, "c00122d8 T get_immrbase\nc00123d0"..., 
1024) = 1024
694   11:51:19.929834 read(4, "nd_irq\nc0013300 T cpm_get_irq\nc0"..., 
1024) = 1024
694   11:51:19.945422 read(4, "t fpga_clk_disable\nc0014a30 t fp"..., 
1024) = 1024
694   11:51:19.960385 read(4, "mm_init\nc00160e0 T mm_alloc\nc001"..., 
1024) = 1024
694   11:51:19.975382 read(4, "e\nc0018678 T init_cpu_present\nc0"..., 
1024) = 1024
694   11:51:19.990455 read(4, "o_msecs\nc001b828 T jiffies_to_us"..., 
1024) = 1024
694   11:51:20.006647 read(4, "it\nc001c7a4 t ksoftirqd_should_r"..., 
1024) = 1024
694   11:51:20.021612 read(4, " T reallocate_resource\nc001dc54 "..., 
1024) = 1024
694   11:51:20.035914 read(4, "ulongvec_minmax\nc001f968 t proc_"..., 
1024) = 1024
694   11:51:20.052163 read(4, "4 T ptrace_readdata\nc0021bf4 t p"..., 
1024) = 1024
694   11:51:20.067928 read(4, " T mod_timer\nc0023d6c T add_time"..., 
1024) = 1024
694   11:51:20.084083 read(4, "e\nc00255a0 T unblock_all_signals"..., 
1024) = 1024
694   11:51:20.099179 read(4, "ng\nc0026c0c t task_participate_g"..., 
1024) = 1024
694   11:51:20.115908 read(4, "e_sig_info\nc00296b4 T force_sig\n"..., 
1024) = 1024
694   11:51:20.132640 read(4, "4 T SyS_uname\nc002b734 T sys_una"..., 
1024) = 1024
694   11:51:20.149337 read(4, "gv\nc002d2fc T call_usermodehelpe"..., 
1024) = 1024
694   11:51:20.159377 read(4, "_workqueue_attrs\nc002ef80 t init"..., 
1024) = 1024
694   11:51:20.169373 brk(0x101cf000)   = 0x101cf000
694   11:51:20.178457 read(4, "rescuer_thread\nc0032060 T workqu"..., 
1024) = 1024
694   11:51:20.191619 read(4, "4280 T free_pid\nc0034430 T chang"..., 
1024) = 1024
694   11:51:20.203204 read(4, "_kernel_param_unlock\nc00355b0 t "..., 
1024) = 1024
694   11:51:20.214828 read(4, "t_realtime_coarse\nc00365dc t pos"..., 
1024) = 1024
694   11:51:20.226190 read(4, "8494 T SyS_timer_settime\nc003849"..., 
1024) = 1024
694   11:51:20.237451 read(4, "prepare_to_wait\nc0039860 T remov"..., 
1024) = 1024
694   11:51:20.249114 read(4, "0039a40 W compat_sys_recvmmsg\nc0"..., 
1024) = 1024
694   11:51:20.261381 read(4, "o_get\nc0039a40 W sys_ioprio_set\n"..., 
1024) = 1024
694   11:51:20.274426 read(4, "c0039b90 T posix_cpu_timers_exit"..., 
1024) = 1024
694   11:51:20.287094 read(4, "n_posix_cpu_timers\nc003c3ac T po"..., 
1024) = 1024
694   11:51:20.299460 read(4, "imer_softirq\nc003e004 T hrtimer_"..., 
1024) = 1024
694   11:51:20.312180 read(4, "30 T raw_notifier_chain_register"..., 
1024) = 1024
694   11:51:20.326701 read(4, "nt_helper_store\nc00402ec t notes"..., 
1024) = 1024
694   11:51:20.339700 read(4, "e_domain\nc0041534 T async_synchr"..., 
1024) = 1024
694   11:51:20.352856 read(4, "_fn\nc0042ca4 T smpboot_register_"..., 
1024) = 1024
694   11:51:20.365855 read(4, "T can_nice\nc0043900 T hrtick_sta"..., 
1024) = 1024
694   11:51:20.378888 read(4, "40 T default_wake_function\nc0045"..., 
1024) = 1024
694   11:51:20.391673 read(4, "468c0 t put_prev_task_idle\nc0046"..., 
1024) = 1024
694   11:51:20.404653 read(4, " yield_task_fair\nc0047e48 t yiel"..., 
1024) = 1024
694   11:51:20.418850 read(4, "c0049178 T pm_qos_update_flags\nc"..., 
1024) = 1024
694   11:51:20.432421 read(4, "004b954 T wake_up_klogd\nc004b9e8"..., 
1024) = 1024
694   11:51:20.446350 read(4, "c_desc\nc004e344 T irq_to_desc\nc0"..., 
1024) = 1024
694   11:51:20.460453 read(4, "c0050478 T enable_irq\nc0050500 T"..., 
1024) = 1024
694   11:51:20.474844 read(4, "014 T irq_set_irq_type\nc0052098 "..., 
1024) = 1024
694   11:51:20.488128 read(4, "e5c T register_irq_proc\nc0053f34"..., 
1024) = 1024
694   11:51:20.502674 read(4, "dcc T __getnstimeofday\nc0054f70 "..., 
1024) = 1024
694   11:51:20.516617 read(4, "ec T ntp_validate_timex\nc00589a8"..., 
1024) = 1024
694   11:51:20.531720 read(4, "t_tickdevice\nc005a618 t print_cp"..., 
1024) = 1024
694   11:51:20.545907 read(4, "t alarm_timer_nsleep\nc005c538 t "..., 
1024) = 1024
694   11:51:20.559121 read(4, "ent\nc005deb0 T clockevents_updat"..., 
1024) = 1024
694   11:51:20.574873 read(4, "sh_futex\nc005f384 T SyS_set_robu"..., 
1024) = 1024
694   11:51:20.589090 read(4, "roxy_unlock\nc0062f38 T rt_mutex_"..., 
1024) = 1024
694   11:51:20.603195 read(4, "n\nc006460c t module_flags\nc00647"..., 
1024) = 1024
694   11:51:20.617667 read(4, "98 t setup_modinfo_version\nc0066"..., 
1024) = 1024
694   11:51:20.631957 read(4, "s_lookup_size_offset\nc00695e8 t "..., 
1024) = 1024
694   11:51:20.647180 read(4, "ds_cpu\nc006a3c4 t rcu_implicit_d"..., 
1024) = 1024
694   11:51:20.662210 read(4, "hread\nc006cb20 T rcu_read_unlock"..., 
1024) = 1024
694   11:51:20.677364 read(4, "er_print_page_header\nc006e904 T "..., 
1024) = 1024
694   11:51:20.691893 read(4, "1a8 t free_buffer_page\nc006f1e4 "..., 
1024) = 1024
694   11:51:20.707199 brk(0x101f0000)   = 0x101f0000
694   11:51:20.719337 read(4, "_get_reader_page\nc0071ad0 t rb_a"..., 
1024) = 1024
694   11:51:20.734128 read(4, "0 t perf_swevent_del\nc0073c08 t "..., 
1024) = 1024
694   11:51:20.750334 read(4, "cancel_hrtimer\nc0074aec t task_c"..., 
1024) = 1024
694   11:51:20.766423 read(4, "c00764c8 T __perf_event_disable\n"..., 
1024) = 1024
694   11:51:20.781666 read(4, "nt_free_task\nc0078ae8 t perf_rel"..., 
1024) = 1024
694   11:51:20.796673 read(4, "007d04c T perf_output_sample\nc00"..., 
1024) = 1024
694   11:51:20.812894 read(4, "29c T iov_iter_fault_in_readable"..., 
1024) = 1024
694   11:51:20.829694 read(4, "_range\nc0082028 T filemap_write_"..., 
1024) = 1024
694   11:51:20.840614 read(4, "9f4 T mempool_create\nc0084a00 T "..., 
1024) = 1024
694   11:51:20.851910 read(4, "ovable_nolock\nc0086580 T set_pag"..., 
1024) = 1024
694   11:51:20.863187 read(4, "act\nc0088b0c T free_hot_cold_pag"..., 
1024) = 1024
694   11:51:20.874441 read(4, " T bdi_dirty_limit\nc008b6ac T __"..., 
1024) = 1024
694   11:51:20.885728 read(4, "d8ac T pagevec_lookup\nc008d8ec t"..., 
1024) = 1024
694   11:51:20.897163 read(4, "74 T truncate_inode_pages\nc008fa"..., 
1024) = 1024
694   11:51:20.908676 read(4, "hmem_statfs\nc009377c t shmem_fol"..., 
1024) = 1024
694   11:51:20.921683 read(4, "em_parse_options\nc0095510 T shme"..., 
1024) = 1024
694   11:51:20.933670 read(4, " t pagetypeinfo_open\nc00988e8 t "..., 
1024) = 1024
694   11:51:20.945832 read(4, "g_stats_show\nc009a2b0 T bdi_wake"..., 
1024) = 1024
694   11:51:20.959133 read(4, "te\nc009c498 t __anon_vma_interva"..., 
1024) = 1024
694   11:51:20.971879 read(4, "ange\nc009f00c T follow_page_mask"..., 
1024) = 1024
694   11:51:20.984914 read(4, "00a3580 T munlock_vma_pages_rang"..., 
1024) = 1024
694   11:51:20.997670 read(4, "t __vma_link_file\nc00a506c t unm"..., 
1024) = 1024
694   11:51:21.011099 read(4, "ma\nc00a93a0 T SyS_mremap\nc00a93a"..., 
1024) = 1024
694   11:51:21.023850 read(4, " vmalloc_sync_all\nc00abd48 t f\nc"..., 
1024) = 1024
694   11:51:21.038122 read(4, "0adf54 T __vmalloc_node_range\nc0"..., 
1024) = 1024
694   11:51:21.051113 read(4, "fn_range\nc00aff6c T memblock_sta"..., 
1024) = 1024
694   11:51:21.063880 read(4, "ool_create\nc00b1b04 T dmam_pool_"..., 
1024) = 1024
694   11:51:21.077330 read(4, "em_cache_free\nc00b3618 t T.1258\n"..., 
1024) = 1024
694   11:51:21.090347 read(4, "heck_o_direct\nc00b65f4 T finish_"..., 
1024) = 1024
694   11:51:21.103697 read(4, "yS_faccessat\nc00b7a38 T sys_facc"..., 
1024) = 1024
694   11:51:21.117107 read(4, "b9958 T sys_writev\nc00b9a40 T vf"..., 
1024) = 1024
694   11:51:21.132090 read(4, "bb7d4 T set_anon_super\nc00bb818 "..., 
1024) = 1024
694   11:51:21.146159 read(4, "alloc\nc00bd988 T cdev_del\nc00bd9"..., 
1024) = 1024
694   11:51:21.160387 read(4, "newstat\nc00bef90 T SyS_stat\nc00b"..., 
1024) = 1024
694   11:51:21.175706 read(4, "ric_pipe_buf_confirm\nc00c15fc t "..., 
1024) = 1024
694   11:51:21.189439 read(4, "b0 T page_readlink\nc00c3c28 T ge"..., 
1024) = 1024
694   11:51:21.204952 read(4, "filename_lookup\nc00c6db0 T kern_"..., 
1024) = 1024
694   11:51:21.219358 read(4, " sys_mknodat\nc00ca834 T SyS_syml"..., 
1024) = 1024
694   11:51:21.233617 read(4, " poll_initwait\nc00cd340 t poll_s"..., 
1024) = 1024
694   11:51:21.245834 brk(0x10211000)   = 0x10211000
694   11:51:21.258375 read(4, "00cff8c T d_drop\nc00cffe4 t d_wa"..., 
1024) = 1024
694   11:51:21.274143 read(4, "eck_and_collect\nc00d2870 t __d_f"..., 
1024) = 1024
694   11:51:21.288629 read(4, "ode_hash\nc00d4a30 T __insert_ino"..., 
1024) = 1024
694   11:51:21.303119 read(4, "c9c T notify_change\nc00d701c T s"..., 
1024) = 1024
694   11:51:21.317364 read(4, "ode_readlink\nc00d7524 t bad_inod"..., 
1024) = 1024
694   11:51:21.332608 read(4, "d8a8c T dup_fd\nc00d8e14 T put_fi"..., 
1024) = 1024
694   11:51:21.348864 read(4, "_mountpoint\nc00da410 t attach_mn"..., 
1024) = 1024
694   11:51:21.364169 read(4, "ounts_for_expiry\nc00dc7ec T drop"..., 
1024) = 1024
694   11:51:21.379145 read(4, "se_private\nc00de6c8 T single_rel"..., 
1024) = 1024
694   11:51:21.396818 read(4, "T vfs_getxattr\nc00e0ae8 t getxat"..., 
1024) = 1024
694   11:51:21.412185 read(4, "d_from_buffer\nc00e2484 T simple_"..., 
1024) = 1024
694   11:51:21.427130 read(4, "e43a8 T write_inode_now\nc00e4434"..., 
1024) = 1024
694   11:51:21.442371 read(4, "00e69bc t page_cache_pipe_buf_st"..., 
1024) = 1024
694   11:51:21.458685 read(4, "nc_fs_one_sb\nc00e987c T vfs_fsyn"..., 
1024) = 1024
694   11:51:21.474336 read(4, "ree_fs_struct\nc00eac00 T unshare"..., 
1024) = 1024
694   11:51:21.489634 read(4, "_event\nc00ec918 T fsnotify_remov"..., 
1024) = 1024
694   11:51:21.506093 read(4, "k\nc00edd9c T fsnotify_duplicate_"..., 
1024) = 1024
694   11:51:21.522171 read(4, "cked\nc00ef784 T SyS_inotify_rm_w"..., 
1024) = 1024
694   11:51:21.532419 read(4, "oc\nc00f13a8 T SyS_epoll_wait\nc00"..., 
1024) = 1024
694   11:51:21.544137 read(4, "42c8 T timerfd_clock_was_set\nc00"..., 
1024) = 1024
694   11:51:21.555639 read(4, "aio_free_ring\nc00f627c T SyS_io_"..., 
1024) = 1024
694   11:51:21.568080 read(4, " T lease_get_mtime\nc00f9230 T lo"..., 
1024) = 1024
694   11:51:21.580436 read(4, "65c t zap_process\nc00fe714 t exp"..., 
1024) = 1024
694   11:51:21.592723 read(4, "8 T proc_fill_super\nc0101708 t u"..., 
1024) = 1024
694   11:51:21.604091 read(4, "\nc01030ec t oom_adj_read\nc010322"..., 
1024) = 1024
694   11:51:21.616920 read(4, " T proc_pid_lookup\nc0105df4 t pr"..., 
1024) = 1024
694   11:51:21.628871 read(4, "082a4 T proc_tid_stat\nc01082ac t"..., 
1024) = 1024
694   11:51:21.642618 read(4, "eq_next\nc010a160 t int_seq_stop\n"..., 
1024) = 1024
694   11:51:21.655458 read(4, "010bd74 t xlate_dir\nc010be30 t g"..., 
1024) = 1024
694   11:51:21.668421 read(4, "proc_task_net\nc010e5c4 t proc_tg"..., 
1024) = 1024
694   11:51:21.681659 read(4, "_get_inode\nc01104bc T sysfs_geta"..., 
1024) = 1024
694   11:51:21.694597 read(4, "98 T sysfs_add_one\nc0112364 T sy"..., 
1024) = 1024
694   11:51:21.707418 read(4, "s\nc0114098 t bin_fault\nc0114164 "..., 
1024) = 1024
694   11:51:21.720338 read(4, "e_io_error\nc0116750 T fscache_se"..., 
1024) = 1024
694   11:51:21.732629 read(4, "04 t fscache_abort_initialisatio"..., 
1024) = 1024
694   11:51:21.746120 read(4, "eval\nc011b330 t fscache_release_"..., 
1024) = 1024
694   11:51:21.758653 read(4, "k\nc011d81c T nfs_cleanup_cb_iden"..., 
1024) = 1024
694   11:51:21.771431 read(4, "eate_server\nc011fd54 T put_nfs_v"..., 
1024) = 1024
694   11:51:21.782614 brk(0x10232000)   = 0x10232000
694   11:51:21.793914 read(4, "s_rename\nc0122b1c T nfs_link\nc01"..., 
1024) = 1024
694   11:51:21.808398 read(4, "1250fc T nfs_attribute_cache_exp"..., 
1024) = 1024
694   11:51:21.822086 read(4, "s_release\nc0126ff8 T put_nfs_ope"..., 
1024) = 1024
694   11:51:21.836896 read(4, "9f4 T nfs_show_devname\nc012aaa0 "..., 
1024) = 1024
694   11:51:21.850887 read(4, "_wait_on_request\nc012d6a0 t nfs_"..., 
1024) = 1024
694   11:51:21.864422 read(4, "_read\nc012f284 T nfs_readhdr_fre"..., 
1024) = 1024
694   11:51:21.878204 read(4, "t nfs_page_find_request_locked\nc"..., 
1024) = 1024
694   11:51:21.892161 read(4, "2874 T nfs_commit_free\nc013289c "..., 
1024) = 1024
694   11:51:21.907103 read(4, "tup\nc0134704 t nfs_lock_check_bo"..., 
1024) = 1024
694   11:51:21.921381 read(4, "iteres\nc013601c t nfs2_xdr_dec_a"..., 
1024) = 1024
694   11:51:21.934923 read(4, "\nc0136e08 t nfs3_proc_lock\nc0136"..., 
1024) = 1024
694   11:51:21.949113 read(4, "f0 t nfs3_proc_pathconf\nc0138448"..., 
1024) = 1024
694   11:51:21.962864 read(4, "fs3_xdr_enc_create3args\nc0139b14"..., 
1024) = 1024
694   11:51:21.977920 read(4, "_locks_copy_lock\nc013b798 t nlmc"..., 
1024) = 1024
694   11:51:21.992202 read(4, "ckd_exit_net\nc013def4 t param_se"..., 
1024) = 1024
694   11:51:22.006208 read(4, "_traverse_shares\nc014006c T nlms"..., 
1024) = 1024
694   11:51:22.020363 read(4, "lock_all_by_sb\nc014143c T nlmsvc"..., 
1024) = 1024
694   11:51:22.035858 read(4, "68 T nlmsvc_encode_testres\nc0143"..., 
1024) = 1024
694   11:51:22.051913 read(4, "lm4svc_callback_exit\nc01446ec t "..., 
1024) = 1024
694   11:51:22.066448 read(4, "nl_delete_xattr\nc0148084 T ubifs"..., 
1024) = 1024
694   11:51:22.081678 read(4, "4d34c t free_wbufs\nc014d3ec t bu"..., 
1024) = 1024
694   11:51:22.097890 read(4, "wbuf_seek_nolock\nc01529f4 t wbuf"..., 
1024) = 1024
694   11:51:22.113098 read(4, "t matches_name\nc01567e4 t resolv"..., 
1024) = 1024
694   11:51:22.128198 read(4, "e4 T ubifs_validate_entry\nc015bc"..., 
1024) = 1024
694   11:51:22.143370 read(4, "ifs_orphan_start_commit\nc0161788"..., 
1024) = 1024
694   11:51:22.159679 read(4, "ifs_decompress\nc0166d50 T ubifs_"..., 
1024) = 1024
694   11:51:22.175358 read(4, "le\nc016b948 T ubifs_fast_find_em"..., 
1024) = 1024
694   11:51:22.191081 read(4, "8 t need_write_all\nc01702c8 t ge"..., 
1024) = 1024
694   11:51:22.204365 read(4, "_exit_fs\nc01759b4 T ubifs_dump_p"..., 
1024) = 1024
694   11:51:22.215379 read(4, "T dbg_check_nondata_nodes_order\n"..., 
1024) = 1024
694   11:51:22.227644 read(4, "c017d058 t debugfs_atomic_t_set\n"..., 
1024) = 1024
694   11:51:22.238592 read(4, "017ddf0 t fops_atomic_t_open\nc01"..., 
1024) = 1024
694   11:51:22.250886 read(4, "pc_find_ipc\nc017ec84 t sysvipc_p"..., 
1024) = 1024
694   11:51:22.262229 read(4, "c_semop\nc0181494 t wake_const_op"..., 
1024) = 1024
694   11:51:22.273910 read(4, "10 t shm_try_destroy_orphaned\nc0"..., 
1024) = 1024
694   11:51:22.285129 read(4, " cap_vm_enough_memory\nc0187528 T"..., 
1024) = 1024
694   11:51:22.295907 read(4, "T crypto_alloc_base\nc0188f74 T c"..., 
1024) = 1024
694   11:51:22.307566 read(4, " T crypto_init_spawn2\nc0189c58 T"..., 
1024) = 1024
694   11:51:22.320410 read(4, "ad_ops\nc018b600 t aead_null_give"..., 
1024) = 1024
694   11:51:22.331895 brk(0x10253000)   = 0x10253000
694   11:51:22.341404 read(4, "kcipher_walk_done\nc018cf84 t abl"..., 
1024) = 1024
694   11:51:22.354847 read(4, "rst\nc018ef6c t chainiv_module_ex"..., 
1024) = 1024
694   11:51:22.366655 read(4, "h_register_instance\nc018ffd0 T c"..., 
1024) = 1024
694   11:51:22.378729 read(4, "s\nc0190c98 T crypto_alloc_shash\n"..., 
1024) = 1024
694   11:51:22.391205 read(4, "194 T crypto_aes_set_key\nc01941e"..., 
1024) = 1024
694   11:51:22.402978 read(4, "niv_ahash_update_done\nc019613c t"..., 
1024) = 1024
694   11:51:22.415313 read(4, "T sort_extable\nc0197ac0 T fprop_"..., 
1024) = 1024
694   11:51:22.427403 read(4, "c01998bc T ida_destroy\nc01998f0 "..., 
1024) = 1024
694   11:51:22.441126 read(4, "nd_add\nc019b04c T kobject_get_pa"..., 
1024) = 1024
694   11:51:22.454364 read(4, "_lookup\nc019d350 T radix_tree_ta"..., 
1024) = 1024
694   11:51:22.467692 read(4, "strim\nc019f300 T strrchr\nc019f35"..., 
1024) = 1024
694   11:51:22.481728 read(4, " lockref_get_not_dead\nc01a31e8 T"..., 
1024) = 1024
694   11:51:22.495171 read(4, "__bitmap_and\nc01a52b0 T __bitmap"..., 
1024) = 1024
694   11:51:22.508422 read(4, "T sg_nents\nc01a6e14 T sg_miter_s"..., 
1024) = 1024
694   11:51:22.523061 read(4, "_bit\nc01a8874 T find_next_bit_le"..., 
1024) = 1024
694   11:51:22.536347 read(4, " percpu_ida_alloc\nc01aa258 T str"..., 
1024) = 1024
694   11:51:22.549591 read(4, "\nc01abc2c T devm_request_and_ior"..., 
1024) = 1024
694   11:51:22.563349 read(4, "nla_put_nohdr\nc01ae3cc T nla_put"..., 
1024) = 1024
694   11:51:22.576837 read(4, "stop\nc01afab8 t _gpio_set_open_d"..., 
1024) = 1024
694   11:51:22.591566 read(4, "t\nc01b16f4 t export_store\nc01b18"..., 
1024) = 1024
694   11:51:22.604980 read(4, "301_spi_read\nc01b3b10 T fb_notif"..., 
1024) = 1024
694   11:51:22.618614 read(4, "1b4a84 T tty_unregister_driver\nc"..., 
1024) = 1024
694   11:51:22.632571 read(4, "c T tty_write_lock\nc01b6c48 t tt"..., 
1024) = 1024
694   11:51:22.647354 read(4, "ty_receive_buf2\nc01bcc04 t n_tty"..., 
1024) = 1024
694   11:51:22.662072 read(4, "bed58 t tty_ldisc_close\nc01bedb4"..., 
1024) = 1024
694   11:51:22.676391 read(4, "_raise_dtr_rts\nc01c03d0 T tty_po"..., 
1024) = 1024
694   11:51:22.690891 read(4, "ix98_remove\nc01c1890 t pty_resiz"..., 
1024) = 1024
694   11:51:22.705220 read(4, "t uart_get_attr_custom_divisor\nc"..., 
1024) = 1024
694   11:51:22.720952 read(4, "4 t uart_hangup\nc01c51ac t uart_"..., 
1024) = 1024
694   11:51:22.735418 read(4, "t cpm_uart_init_port\nc01c8d84 t "..., 
1024) = 1024
694   11:51:22.750361 read(4, "e_range\nc01cadc4 t T.606\nc01cae3"..., 
1024) = 1024
694   11:51:22.765449 read(4, "hwrng_attr_available_show\nc01cd0"..., 
1024) = 1024
694   11:51:22.780196 read(4, "al_device_parent\nc01ce254 t get_"..., 
1024) = 1024
694   11:51:22.794654 read(4, "ice_create_with_groups\nc01d00cc "..., 
1024) = 1024
694   11:51:22.809094 read(4, "s_helper\nc01d0e20 T bus_probe_de"..., 
1024) = 1024
694   11:51:22.824976 read(4, "T driver_probe_done\nc01d290c t d"..., 
1024) = 1024
694   11:51:22.839444 read(4, " class_dev_iter_next\nc01d3b20 T "..., 
1024) = 1024
694   11:51:22.855314 read(4, "orm_device_register\nc01d4c0c T p"..., 
1024) = 1024
694   11:51:22.864877 read(4, "ve\nc01d614c T devres_release\nc01"..., 
1024) = 1024
694   11:51:22.875838 brk(0x10274000)   = 0x10274000
694   11:51:22.884564 read(4, "ummy_function\nc01d7288 t transpo"..., 
1024) = 1024
694   11:51:22.896586 read(4, "k_notify\nc01d82bc T dma_common_m"..., 
1024) = 1024
694   11:51:22.907617 read(4, "ad\nc01dabf4 t at25_mem_read\nc01d"..., 
1024) = 1024
694   11:51:22.918470 read(4, "t mtd_ecc_strength_show\nc01dc2cc"..., 
1024) = 1024
694   11:51:22.929724 read(4, "oncat_read_oob\nc01de8ec t concat"..., 
1024) = 1024
694   11:51:22.941146 read(4, "tion\nc01e0730 T del_mtd_partitio"..., 
1024) = 1024
694   11:51:22.952413 read(4, "lock\nc01e5c8c t fixup_sst39vf\nc0"..., 
1024) = 1024
694   11:51:22.964075 read(4, "ze\nc01eb1ac t fixup_convert_atme"..., 
1024) = 1024
694   11:51:22.976201 read(4, "t nand_read_oob_syndrome\nc01eee9"..., 
1024) = 1024
694   11:51:22.988402 read(4, "e_buf16\nc01f1b80 t nand_write_bu"..., 
1024) = 1024
694   11:51:23.000922 read(4, "f7828 t cmpc885_probe\nc01f7bc8 t"..., 
1024) = 1024
694   11:51:23.013160 read(4, "ree_internal_volumes\nc01fc3cc t "..., 
1024) = 1024
694   11:51:23.026643 read(4, "bi_eba_init\nc02003c8 T self_chec"..., 
1024) = 1024
694   11:51:23.039065 read(4, "e_del\nc0204d9c t tree_destroy\nc0"..., 
1024) = 1024
694   11:51:23.052815 read(4, "9c T ubi_debugfs_init_dev\nc020a6"..., 
1024) = 1024
694   11:51:23.065108 read(4, "0 T spi_master_suspend\nc020c16c "..., 
1024) = 1024
694   11:51:23.077662 read(4, "xxx_spi_work\nc020e3c8 T mpc8xxx_"..., 
1024) = 1024
694   11:51:23.089895 read(4, "vid\nc02102f0 t bond_vlan_rx_add_"..., 
1024) = 1024
694   11:51:23.102578 read(4, "p_send_all\nc02152ec T bond_activ"..., 
1024) = 1024
694   11:51:23.115878 read(4, "958 t alb_set_slave_mac_addr\nc02"..., 
1024) = 1024
694   11:51:23.128589 read(4, "c t bonding_show_mii_status\nc021"..., 
1024) = 1024
694   11:51:23.141824 read(4, "d764 t bonding_store_primary_res"..., 
1024) = 1024
694   11:51:23.154599 read(4, "21f5d0 T bond_create_proc_entry\n"..., 
1024) = 1024
694   11:51:23.167875 read(4, "machine\nc0221cb0 T phy_stop_mach"..., 
1024) = 1024
694   11:51:23.181202 read(4, "y_register_fixup_for_uid\nc0223a2"..., 
1024) = 1024
694   11:51:23.195871 read(4, "t fs_set_multicast_list\nc0224b94"..., 
1024) = 1024
694   11:51:23.209590 read(4, "_list\nc02280a0 t napi_clear_rx_e"..., 
1024) = 1024
694   11:51:23.223356 read(4, "\nc02295dc t cisco_rx\nc02298b0 t "..., 
1024) = 1024
694   11:51:23.236572 read(4, "stance\nc022c89c T thermal_unregi"..., 
1024) = 1024
694   11:51:23.249583 read(4, "ing_device_register\nc022e614 T t"..., 
1024) = 1024
694   11:51:23.265120 read(4, "8xxx_wdt_write\nc0230dd4 t mpc8xx"..., 
1024) = 1024
694   11:51:23.278883 read(4, " t gpio_blink_set\nc0232520 t del"..., 
1024) = 1024
694   11:51:23.292597 read(4, "233b3c t hw_supports\nc0233bc8 t "..., 
1024) = 1024
694   11:51:23.305840 read(4, "4 t aead_edesc_alloc\nc0237268 t "..., 
1024) = 1024
694   11:51:23.319315 read(4, "_u32_array\nc02391d0 T of_propert"..., 
1024) = 1024
694   11:51:23.334609 read(4, "23a950 T of_get_child_by_name\nc0"..., 
1024) = 1024
694   11:51:23.348845 read(4, "bus_default_translate\nc023c51c t"..., 
1024) = 1024
694   11:51:23.363177 read(4, "r_type_show\nc023e0d4 t fs_attr_b"..., 
1024) = 1024
694   11:51:23.378869 read(4, "0240280 t show_name\nc02402a0 t f"..., 
1024) = 1024
694   11:51:23.392979 read(4, "ebug\nc0241938 t fs_attr_cts_scc3"..., 
1024) = 1024
694   11:51:23.405857 brk(0x10295000)   = 0x10295000
694   11:51:23.418373 read(4, "c t fav_cs_get\nc0243cd4 t gain_v"..., 
1024) = 1024
694   11:51:23.434327 read(4, "ur_blink_show\nc0248284 t fs_attr"..., 
1024) = 1024
694   11:51:23.448871 read(4, "\nc024d784 T enreg_handler\nc024d7"..., 
1024) = 1024
694   11:51:23.463358 read(4, "RVE1PoseFct\nc0251918 T fDRVE1Emi"..., 
1024) = 1024
694   11:51:23.480607 read(4, "wRegRead\nc025765c T fDRVFpgaHdwR"..., 
1024) = 1024
694   11:51:23.495151 read(4, "25d94c t fDRVMtslRelease\nc025d9e"..., 
1024) = 1024
694   11:51:23.511163 read(4, "hannel_info\nc0261120 T devm_iio_"..., 
1024) = 1024
694   11:51:23.520902 read(4, "y_register\nc0263774 T iio_channe"..., 
1024) = 1024
694   11:51:23.531351 read(4, "vice_register_trigger_consumer\nc"..., 
1024) = 1024
694   11:51:23.541900 read(4, "c02668d4 t iio_set_length_kfifo\n"..., 
1024) = 1024
694   11:51:23.552679 read(4, "ffer_write_reserve\nc0267d94 T op"..., 
1024) = 1024
694   11:51:23.563864 read(4, "t depth_write\nc026996c t cpu_typ"..., 
1024) = 1024
694   11:51:23.575903 read(4, "c t sock_no_open\nc026a5d4 T sock"..., 
1024) = 1024
694   11:51:23.587403 read(4, " T kernel_recvmsg\nc026b804 T soc"..., 
1024) = 1024
694   11:51:23.598920 read(4, "sync\nc026cef0 T dlci_ioctl_set\nc"..., 
1024) = 1024
694   11:51:23.610461 read(4, " T sock_no_setsockopt\nc026e908 T"..., 
1024) = 1024
694   11:51:23.621653 read(4, "r\nc02700e4 T sk_send_sigurg\nc027"..., 
1024) = 1024
694   11:51:23.633349 read(4, "ock_rmem_free\nc0273588 T skb_add"..., 
1024) = 1024
694   11:51:23.645614 read(4, "\nc0276278 t skb_free_head\nc02762"..., 
1024) = 1024
694   11:51:23.657610 read(4, "ovecend\nc0279d20 T memcpy_toiove"..., 
1024) = 1024
694   11:51:23.671319 read(4, "27ce04 T gnet_stats_copy_basic\nc"..., 
1024) = 1024
694   11:51:23.683367 read(4, "_dev_get_by_index\nc027ef30 T dev"..., 
1024) = 1024
694   11:51:23.696661 read(4, "etif_schedule\nc027fe64 T dev_kfr"..., 
1024) = 1024
694   11:51:23.708977 read(4, "ecc T __dev_change_flags\nc028205"..., 
1024) = 1024
694   11:51:23.721597 read(4, "ac T dev_forward_skb\nc0284a94 T "..., 
1024) = 1024
694   11:51:23.733662 read(4, "286e10 T register_netdev\nc0286e4"..., 
1024) = 1024
694   11:51:23.745901 read(4, "tool_set_flags\nc028955c T __etht"..., 
1024) = 1024
694   11:51:23.758614 read(4, "e\nc028c8e8 T dev_addr_del\nc028c9"..., 
1024) = 1024
694   11:51:23.771566 read(4, "f164 t __neigh_notify\nc028f25c T"..., 
1024) = 1024
694   11:51:23.783866 read(4, "lear\nc0291ebc T neigh_changeaddr"..., 
1024) = 1024
694   11:51:23.798091 read(4, "02960e4 t rtnl_bridge_setlink\nc0"..., 
1024) = 1024
694   11:51:23.811321 read(4, "eue\nc0298d28 t linkwatch_event\nc"..., 
1024) = 1024
694   11:51:23.824230 read(4, "_ns\nc029b2b8 t net_netlink_ns\nc0"..., 
1024) = 1024
694   11:51:23.837952 read(4, "b0c t type_show\nc029bb18 t group"..., 
1024) = 1024
694   11:51:23.851452 read(4, "rors_show\nc029c2d0 t tx_bytes_sh"..., 
1024) = 1024
694   11:51:23.867094 read(4, " llc_set_station_handler\nc029d86"..., 
1024) = 1024
694   11:51:23.880900 read(4, "_event\nc029ed40 t garp_pdu_rcv\nc"..., 
1024) = 1024
694   11:51:23.894429 read(4, "ev_trans_start\nc02a0b4c T sch_di"..., 
1024) = 1024
694   11:51:23.907853 brk(0x102b6000)   = 0x102b6000
694   11:51:23.918117 read(4, " T __nlmsg_put\nc02a2bb4 T netlin"..., 
1024) = 1024
694   11:51:23.932404 read(4, "c T nlmsg_notify\nc02a5878 T netl"..., 
1024) = 1024
694   11:51:23.946107 read(4, "T nf_unregister_hooks\nc02a831c T"..., 
1024) = 1024
694   11:51:23.959630 read(4, "fnl_unlock\nc02a9a8c T nfnl_lock\n"..., 
1024) = 1024
694   11:51:23.973128 read(4, "ab15c T nf_conntrack_free\nc02ab1"..., 
1024) = 1024
694   11:51:23.986699 read(4, "\nc02ad574 T nf_conntrack_expect_"..., 
1024) = 1024
694   11:51:24.001817 read(4, "f330 T nf_ct_helper_destroy\nc02a"..., 
1024) = 1024
694   11:51:24.015663 read(4, "ct_l4proto_find_get\nc02b03dc T n"..., 
1024) = 1024
694   11:51:24.030593 read(4, "o_tuple\nc02b2160 t udp_error\nc02"..., 
1024) = 1024
694   11:51:24.046368 read(4, "t ctnetlink_dump_exp_ct\nc02b4278"..., 
1024) = 1024
694   11:51:24.060864 read(4, "pace\nc02b7fb8 t ct_sip_header_se"..., 
1024) = 1024
694   11:51:24.075153 read(4, "ove\nc02bb4c4 t nf_nat_move_stora"..., 
1024) = 1024
694   11:51:24.090903 read(4, "nf_nat_sdp_session\nc02be1ac t nf"..., 
1024) = 1024
694   11:51:24.106620 read(4, "targets\nc02c0228 T xt_find_revis"..., 
1024) = 1024
694   11:51:24.121638 read(4, "224c t led_tg\nc02c2334 t log_tg_"..., 
1024) = 1024
694   11:51:24.136419 read(4, "t\nc02c50bc t rt_cpu_seq_next\nc02"..., 
1024) = 1024
694   11:51:24.152399 read(4, "c\nc02c6708 T ip_rt_get_source\nc0"..., 
1024) = 1024
694   11:51:24.168653 read(4, "t ip4_frag_free\nc02ca720 t ip4_f"..., 
1024) = 1024
694   11:51:24.178814 read(4, "al_out\nc02d0034 T ip_local_out\nc"..., 
1024) = 1024
694   11:51:24.189681 read(4, "ance\nc02d48f4 t inet_twsk_free\nc"..., 
1024) = 1024
694   11:51:24.200812 read(4, "_bind_conflict\nc02d6ac8 T inet_c"..., 
1024) = 1024
694   11:51:24.212093 read(4, "sacktag_one\nc02dc524 T tcp_clear"..., 
1024) = 1024
694   11:51:24.223151 read(4, "2e0778 t tcp_try_rmem_schedule\nc"..., 
1024) = 1024
694   11:51:24.234074 read(4, "d_delayed_ack\nc02e654c T tcp_sen"..., 
1024) = 1024
694   11:51:24.244866 read(4, "ck_timer\nc02eb2e4 t tcp_stream_m"..., 
1024) = 1024
694   11:51:24.255899 read(4, "process\nc02ef618 T tcp_check_req"..., 
1024) = 1024
694   11:51:24.266703 read(4, " tcp_get_metrics\nc02f23c8 T tcp_"..., 
1024) = 1024
694   11:51:24.281111 read(4, "\nc02f4df0 T raw_hash_sk\nc02f4eb0"..., 
1024) = 1024
694   11:51:24.293624 read(4, "lookup\nc02f8150 t udp_send_skb\nc"..., 
1024) = 1024
694   11:51:24.306161 read(4, "cv\nc02fbfe0 t parp_redo\nc02fbfe4"..., 
1024) = 1024
694   11:51:24.318565 read(4, "init\nc02fead8 t ipv4_doint_and_f"..., 
1024) = 1024
694   11:51:24.331163 read(4, "ct\nc0302364 T inet_accept\nc03024"..., 
1024) = 1024
694   11:51:24.343420 read(4, "c t ip_mc_leave_src\nc03057f8 t i"..., 
1024) = 1024
694   11:51:24.355912 read(4, "st\nc0309ac4 t T.1100\nc0309cc4 t "..., 
1024) = 1024
694   11:51:24.368324 read(4, "0c9b8 t fib_find_node\nc030caa8 t"..., 
1024) = 1024
694   11:51:24.381911 read(4, "_get_idx\nc0310414 T ping_seq_nex"..., 
1024) = 1024
694   11:51:24.394585 read(4, "\nc03132ac t __ip_tunnel_create\nc"..., 
1024) = 1024
694   11:51:24.407071 read(4, "\nc0316968 t ipmr_vif_seq_show\nc0"..., 
1024) = 1024
694   11:51:24.419656 read(4, "cisco_rcv\nc031a84c t gre_rcv\nc03"..., 
1024) = 1024
694   11:51:24.432216 brk(0x102d7000)   = 0x102d7000
694   11:51:24.441658 read(4, "c031cd58 t tunnel64_err\nc031cdd4"..., 
1024) = 1024
694   11:51:24.454729 read(4, "mp_pkt_to_tuple\nc031e1dc t icmp_"..., 
1024) = 1024
694   11:51:24.469103 read(4, "7e4 t masquerade_tg_check\nc03218"..., 
1024) = 1024
694   11:51:24.484151 read(4, "q_len\nc0324954 t unix_poll\nc0324"..., 
1024) = 1024
694   11:51:24.497907 read(4, " t unix_dgram_sendmsg\nc03285a8 t"..., 
1024) = 1024
694   11:51:24.511900 read(4, "32b2f4 T ipv6_dev_ac_inc\nc032b59"..., 
1024) = 1024
694   11:51:24.525661 read(4, "_fill_ifaddr\nc0330c68 t addrconf"..., 
1024) = 1024
694   11:51:24.540640 read(4, "d_completed\nc0333450 t ipv6_get_"..., 
1024) = 1024
694   11:51:24.554180 read(4, "f8 t inet6_dump_ifmcaddr\nc033800"..., 
1024) = 1024
694   11:51:24.568093 read(4, "_show\nc0339d74 t rt6_info_route\n"..., 
1024) = 1024
694   11:51:24.582422 read(4, "33cd54 T ip6_redirect\nc033ce50 T"..., 
1024) = 1024
694   11:51:24.596153 read(4, "ontrol\nc0340248 t do_ipv6_setsoc"..., 
1024) = 1024
694   11:51:24.611650 read(4, "_seq_show\nc034525c T udpv6_getso"..., 
1024) = 1024
694   11:51:24.626063 read(4, "t\nc03492a4 T raw6_proc_exit\nc034"..., 
1024) = 1024
694   11:51:24.639815 read(4, "start_timer\nc034ca74 t igmp6_gro"..., 
1024) = 1024
694   11:51:24.654125 read(4, " mld_resend_report\nc035208c t ml"..., 
1024) = 1024
694   11:51:24.669815 read(4, "ipv6_recv_error\nc03566cc t dummy"..., 
1024) = 1024
694   11:51:24.685069 read(4, "_flowlabel_cleanup\nc0359d08 t fl"..., 
1024) = 1024
694   11:51:24.700878 read(4, "_open\nc035c344 t sockstat6_seq_o"..., 
1024) = 1024
694   11:51:24.715403 read(4, "35fc50 t ip6table_raw_hook\nc035f"..., 
1024) = 1024
694   11:51:24.731359 read(4, "d0 t nf_nat_ipv6_manip_pkt\nc0361"..., 
1024) = 1024
694   11:51:24.746104 read(4, "sit_tunnel_xmit\nc03641e8 t T.107"..., 
1024) = 1024
694   11:51:24.760629 read(4, "dev_setup\nc0367cdc T ip6_tnl_xmi"..., 
1024) = 1024
694   11:51:24.776444 read(4, "\nc036c004 t ip6gre_changelink\nc0"..., 
1024) = 1024
694   11:51:24.791654 read(4, " udp6_ufo_send_check\nc036e130 t "..., 
1024) = 1024
694   11:51:24.806657 read(4, "c03712ac t packet_sendmsg\nc0371f"..., 
1024) = 1024
694   11:51:24.822649 read(4, "04 T rpc_get_timeout\nc0375c44 T "..., 
1024) = 1024
694   11:51:24.833062 read(4, "8c t __xprt_lock_write_cong_func"..., 
1024) = 1024
694   11:51:24.844870 read(4, "t __xprt_lock_write_next_cong\nc0"..., 
1024) = 1024
694   11:51:24.855622 read(4, "dresses\nc037b598 t xs_setup_bc_t"..., 
1024) = 1024
694   11:51:24.867313 read(4, "release_calldata\nc037e1b8 T rpci"..., 
1024) = 1024
694   11:51:24.878813 read(4, "e\nc037f7fc T rpc_init_mempool\nc0"..., 
1024) = 1024
694   11:51:24.890317 read(4, "1120 t nul_destroy\nc0381124 t nu"..., 
1024) = 1024
694   11:51:24.901662 read(4, "c_prepare_thread\nc0382c40 T svc_"..., 
1024) = 1024
694   11:51:24.914391 read(4, "sock\nc03852c8 T svc_init_xprt_so"..., 
1024) = 1024
694   11:51:24.925893 read(4, "_map_lookup\nc0386b64 t ip_map_re"..., 
1024) = 1024
694   11:51:24.937607 read(4, "it_decode\nc038958c T xdr_set_scr"..., 
1024) = 1024
694   11:51:24.949660 read(4, "pipefs\nc038b53c t open_flush\nc03"..., 
1024) = 1024
694   11:51:24.962590 read(4, "procfs\nc038d80c t content_open_p"..., 
1024) = 1024
694   11:51:24.973928 brk(0x102f8000)   = 0x102f8000
694   11:51:24.984675 read(4, "ove_pipe_dir_object\nc038f330 T r"..., 
1024) = 1024
694   11:51:24.997158 read(4, " T rpc_pipefs_notifier_register\n"..., 
1024) = 1024
694   11:51:25.010228 read(4, "20 t svc_delete_xprt\nc0392be0 T "..., 
1024) = 1024
694   11:51:25.022857 read(4, "ev\nc0395358 T register_vlan_dev\n"..., 
1024) = 1024
694   11:51:25.035375 read(4, "397aac T vlan_gvrp_uninit_applic"..., 
1024) = 1024
694   11:51:25.047903 read(4, "xit_batch\nc03989a8 t ctnetlink_n"..., 
1024) = 1024
694   11:51:25.060815 read(4, "t_exit\nc039940c t unix_net_exit\n"..., 
1024) = 1024
694   11:51:25.073375 read(4, "99e78 t ip6gre_exit_net\nc0399f84"..., 
1024) = 1024
694   11:51:25.087325 read(4, "\nc039cee4 T ww_mutex_unlock\nc039"..., 
1024) = 1024
694   11:51:25.100903 read(4, "p_on_timeout\nc039ee04 T interrup"..., 
1024) = 1024
694   11:51:25.113634 read(4, "4f0 T __lock_text_start\nc03a0670"..., 
1024) = 1024
694   11:51:25.127621 read(4, "\nc0450afc t fs_names_setup\nc0450"..., 
1024) = 1024
694   11:51:25.141628 read(4, "_devtree\nc04533cc t early_init_d"..., 
1024) = 1024
694   11:51:25.154843 read(4, "cmpc885_setup_arch\nc04549d8 t cm"..., 
1024) = 1024
694   11:51:25.169197 read(4, "ule_kobject\nc04560d0 t param_sys"..., 
1024) = 1024
694   11:51:25.183157 read(4, "_clock\nc0457828 t init_jiffies_c"..., 
1024) = 1024
694   11:51:25.196447 read(4, "free_pages_bootmem\nc04590e8 T fr"..., 
1024) = 1024
694   11:51:25.210388 read(4, "2c T reserve_bootmem_node\nc045ba"..., 
1024) = 1024
694   11:51:25.223813 read(4, "loc\nc045cc60 T memblock_alloc_ni"..., 
1024) = 1024
694   11:51:25.238909 read(4, "roc_root_init\nc045df58 T proc_tt"..., 
1024) = 1024
694   11:51:25.252931 read(4, "init\nc045f0c4 t compr_init\nc045f"..., 
1024) = 1024
694   11:51:25.266878 read(4, "sole_init\nc045fdbc t pty_init\nc0"..., 
1024) = 1024
694   11:51:25.281564 read(4, "71c t ubi_mtd_param_parse\nc0461a"..., 
1024) = 1024
694   11:51:25.295087 read(4, "_memory_arch\nc04634a0 T early_in"..., 
1024) = 1024
694   11:51:25.309672 read(4, "_init\nc04644dc t iio_sysfs_trig_"..., 
1024) = 1024
694   11:51:25.325658 read(4, "t ctnetlink_net_init\nc0465b34 t "..., 
1024) = 1024
694   11:51:25.340689 read(4, "04671e0 T tcp_tasklet_init\nc0467"..., 
1024) = 1024
694   11:51:25.355160 read(4, "_init\nc046865c t ping_v4_proc_in"..., 
1024) = 1024
694   11:51:25.371119 read(4, "init\nc0469880 t unix_net_init\nc0"..., 
1024) = 1024
694   11:51:25.386161 read(4, "6b110 t tcpv6_net_init\nc046b144 "..., 
1024) = 1024
694   11:51:25.400462 read(4, "_init\nc046c740 T tcpv6_offload_i"..., 
1024) = 816
694   11:51:25.415346 read(4, "", 1024) = 0
694   11:51:25.426189 close(4)          = 0
694   11:51:25.437214 munmap(0x77ddc000, 4096) = 0
694   11:51:25.484326 open("/proc/kcore", O_RDONLY|O_LARGEFILE) = 4
694   11:51:25.496897 close(4)          = 0
694   11:51:25.912709 open("/lib/ld-2.16.so", O_RDONLY|O_LARGEFILE) = 4
694   11:51:25.924401 open("/usr/lib/debug/lib/ld-2.16.so.debug", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:25.934661 open("/usr/lib/debug/lib/ld-2.16.so", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:25.942849 open("/lib/ld-2.16.so", O_RDONLY|O_LARGEFILE) = 5
694   11:51:25.952933 open("/lib/ld-2.16.so", O_RDONLY|O_LARGEFILE) = 6
694   11:51:25.960942 open("/lib/ld-2.16.so", O_RDONLY|O_LARGEFILE) = 7
694   11:51:25.968838 open("/lib/ld-2.16.so", O_RDONLY|O_LARGEFILE) = 8
694   11:51:25.976949 fstat64(8, {st_mode=S_IFREG|0755, st_size=155445, 
...}) = 0
694   11:51:25.985460 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77ddc000
694   11:51:25.993211 read(8, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\1|@\0\0\0004"..., 
4096) = 4096
694   11:51:26.002570 _llseek(8, 0, [0], SEEK_SET) = 0
694   11:51:26.010723 read(8, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\1|@\0\0\0004"..., 
4096) = 4096
694   11:51:26.020594 _llseek(8, 4096, [4096], SEEK_SET) = 0
694   11:51:26.029103 _llseek(8, 244, [244], SEEK_SET) = 0
694   11:51:26.037689 close(8)          = 0
694   11:51:26.047184 munmap(0x77ddc000, 4096) = 0
694   11:51:26.055977 close(0)          = 0
694   11:51:26.065452 open("/lib/libc-2.16.so", O_RDONLY|O_LARGEFILE) = 0
694   11:51:26.074951 open("/usr/lib/debug/lib/libc-2.16.so.debug", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:26.084637 open("/usr/lib/debug/lib/libc-2.16.so", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:26.095158 open("/lib/libc-2.16.so", O_RDONLY|O_LARGEFILE) = 8
694   11:51:26.104707 open("/lib/libc-2.16.so", O_RDONLY|O_LARGEFILE) = 9
694   11:51:26.114157 open("/lib/libc-2.16.so", O_RDONLY|O_LARGEFILE) = 10
694   11:51:26.124908 open("/lib/libc-2.16.so", O_RDONLY|O_LARGEFILE) = 11
694   11:51:26.134109 fstat64(11, {st_mode=S_IFREG|0755, 
st_size=1727850, ...}) = 0
694   11:51:26.143966 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77ddc000
694   11:51:26.152869 read(11, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\2\5L\0\0\0004"..., 
4096) = 4096
694   11:51:26.162909 _llseek(11, 0, [0], SEEK_SET) = 0
694   11:51:26.171699 read(11, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\2\5L\0\0\0004"..., 
4096) = 4096
694   11:51:26.181820 _llseek(11, 4096, [4096], SEEK_SET) = 0
694   11:51:26.191832 _llseek(11, 4096, [4096], SEEK_SET) = 0
694   11:51:26.200818 _llseek(11, 404, [404], SEEK_SET) = 0
694   11:51:26.209436 close(11)         = 0
694   11:51:26.218433 munmap(0x77ddc000, 4096) = 0
694   11:51:26.227724 close(0)          = 0
694   11:51:26.286911 open("/bin/strace", O_RDONLY|O_LARGEFILE) = 0
694   11:51:26.296729 open("/usr/lib/debug/bin/strace.debug", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:26.306662 open("/usr/lib/debug/bin/strace", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:26.318116 open("/bin/strace", O_RDONLY|O_LARGEFILE) = 11
694   11:51:26.328379 open("/bin/strace", O_RDONLY|O_LARGEFILE) = 12
694   11:51:26.339133 open("/bin/strace", O_RDONLY|O_LARGEFILE) = 13
694   11:51:26.349666 open("/bin/strace", O_RDONLY|O_LARGEFILE) = 14
694   11:51:26.359704 fstat64(14, {st_mode=S_IFREG|0755, st_size=255776, 
...}) = 0
694   11:51:26.371582 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77ddc000
694   11:51:26.381463 read(14, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\2\0\24\0\0\0\1\20\0\24<\0\0\0004"..., 
4096) = 4096
694   11:51:26.392651 _llseek(14, 0, [0], SEEK_SET) = 0
694   11:51:26.402623 read(14, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\2\0\24\0\0\0\1\20\0\24<\0\0\0004"..., 
4096) = 4096
694   11:51:26.413354 _llseek(14, 4096, [4096], SEEK_SET) = 0
694   11:51:26.424137 _llseek(14, 4096, [4096], SEEK_SET) = 0
694   11:51:26.434321 _llseek(14, 356, [356], SEEK_SET) = 0
694   11:51:26.444161 close(14)         = 0
694   11:51:26.455179 munmap(0x77ddc000, 4096) = 0
694   11:51:26.465195 close(0)          = 0
694   11:51:26.522696 brk(0x10319000)   = 0x10319000
694   11:51:26.552124 open("/usr/sbin/perf", O_RDONLY|O_LARGEFILE) = 0
694   11:51:26.561968 open("/usr/lib/debug/usr/sbin/perf.debug", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:26.570708 open("/usr/lib/debug/usr/sbin/perf", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:26.579119 open("/usr/sbin/perf", O_RDONLY|O_LARGEFILE) = 14
694   11:51:26.587639 open("/usr/sbin/perf", O_RDONLY|O_LARGEFILE) = 15
694   11:51:26.596383 open("/usr/sbin/perf", O_RDONLY|O_LARGEFILE) = 16
694   11:51:26.604682 open("/usr/sbin/perf", O_RDONLY|O_LARGEFILE) = 17
694   11:51:26.612972 fstat64(17, {st_mode=S_IFREG|0755, 
st_size=1252008, ...}) = 0
694   11:51:26.621974 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77ddc000
694   11:51:26.629479 read(17, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\2\0\24\0\0\0\1\20\0*\f\0\0\0004"..., 
4096) = 4096
694   11:51:26.640203 _llseek(17, 0, [0], SEEK_SET) = 0
694   11:51:26.648585 read(17, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\2\0\24\0\0\0\1\20\0*\f\0\0\0004"..., 
4096) = 4096
694   11:51:26.659364 _llseek(17, 4096, [4096], SEEK_SET) = 0
694   11:51:26.668119 _llseek(17, 4096, [4096], SEEK_SET) = 0
694   11:51:26.677150 _llseek(17, 388, [388], SEEK_SET) = 0
694   11:51:26.685707 close(17)         = 0
694   11:51:26.694423 munmap(0x77ddc000, 4096) = 0
694   11:51:26.703206 close(0)          = 0
694   11:51:27.363173 open("/tmp/perf-vdso.so-IZih1b", 
O_RDONLY|O_LARGEFILE) = 0
694   11:51:27.373207 
open("/usr/lib/debug/tmp/perf-vdso.so-IZih1b.debug", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:27.383701 open("/usr/lib/debug/tmp/perf-vdso.so-IZih1b", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:27.393870 open("/tmp/perf-vdso.so-IZih1b", 
O_RDONLY|O_LARGEFILE) = 17
694   11:51:27.404197 open("/tmp/perf-vdso.so-IZih1b", 
O_RDONLY|O_LARGEFILE) = 18
694   11:51:27.414188 open("/tmp/perf-vdso.so-IZih1b", 
O_RDONLY|O_LARGEFILE) = 19
694   11:51:27.423925 open("/tmp/perf-vdso.so-IZih1b", 
O_RDONLY|O_LARGEFILE) = 20
694   11:51:27.434612 fstat64(20, {st_mode=S_IFREG|0600, st_size=12288, 
...}) = 0
694   11:51:27.445104 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77ddc000
694   11:51:27.454608 read(20, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\20\3`\0\0\0004"..., 
4096) = 4096
694   11:51:27.466659 _llseek(20, 0, [0], SEEK_SET) = 0
694   11:51:27.476400 read(20, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\20\3`\0\0\0004"..., 
4096) = 4096
694   11:51:27.486927 _llseek(20, 4096, [4096], SEEK_SET) = 0
694   11:51:27.496617 _llseek(20, 4096, [4096], SEEK_SET) = 0
694   11:51:27.506139 _llseek(20, 864, [864], SEEK_SET) = 0
694   11:51:27.516687 close(20)         = 0
694   11:51:27.525972 munmap(0x77ddc000, 4096) = 0
694   11:51:27.535343 close(0)          = 0
694   11:51:27.874439 open("/lib/libpthread-2.16.so", 
O_RDONLY|O_LARGEFILE) = 0
694   11:51:27.885570 
open("/usr/lib/debug/lib/libpthread-2.16.so.debug", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:27.896382 open("/usr/lib/debug/lib/libpthread-2.16.so", 
O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
694   11:51:27.908419 open("/lib/libpthread-2.16.so", 
O_RDONLY|O_LARGEFILE) = 20
694   11:51:27.919637 open("/lib/libpthread-2.16.so", 
O_RDONLY|O_LARGEFILE) = 21
694   11:51:27.930969 open("/lib/libpthread-2.16.so", 
O_RDONLY|O_LARGEFILE) = 22
694   11:51:27.941649 open("/lib/libpthread-2.16.so", 
O_RDONLY|O_LARGEFILE) = 23
694   11:51:27.953226 fstat64(23, {st_mode=S_IFREG|0755, st_size=123901, 
...}) = 0
694   11:51:27.965724 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77ddc000
694   11:51:27.976110 read(23, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\0Rt\0\0\0004"..., 
4096) = 4096
694   11:51:27.988087 _llseek(23, 0, [0], SEEK_SET) = 0
694   11:51:27.998479 read(23, 
"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\0Rt\0\0\0004"..., 
4096) = 4096
694   11:51:28.010326 _llseek(23, 4096, [4096], SEEK_SET) = 0
694   11:51:28.021877 _llseek(23, 4096, [4096], SEEK_SET) = 0
694   11:51:28.031443 _llseek(23, 372, [372], SEEK_SET) = 0
694   11:51:28.038186 close(23)         = 0
694   11:51:28.045965 munmap(0x77ddc000, 4096) = 0
694   11:51:28.054136 close(0)          = 0
694   11:51:28.668604 mmap(NULL, 8388608, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS|MAP_STACK, -1, 0) = 0x775dd000
694   11:51:28.677391 mprotect(0x775dd000, 4096, PROT_NONE) = 0
694   11:51:28.685717 clone(child_stack=0x77ddbfd0, 
flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, 
parent_tidptr=0x77ddc4d8, tls=0x77de3910, child_tidptr=0x77ddc4d8) = 695
695   11:51:28.711081 set_robust_list(0x77ddc4e0, 0xc) = 0
695   11:51:28.728093 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:28.739217 rt_sigprocmask(SIG_UNBLOCK, [WINCH], NULL, 8) = 0
695   11:51:28.748879 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:28.758953 fstat64(0, 0x77ddb988) = -1 EBADF (Bad file 
descriptor)
695   11:51:28.768223 mmap(NULL, 8192, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x775db000
695   11:51:28.777707 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:28.787324 fstat64(1, {st_mode=S_IFCHR|0600, 
st_rdev=makedev(204, 46), ...}) = 0
695   11:51:28.797702 ioctl(1, TCGETS, {B115200 opost isig icanon echo 
...}) = 0
695   11:51:28.807722 mmap(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x775da000
695   11:51:28.819886 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:28.831409 mmap(NULL, 2097152, PROT_NONE, 
MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = 0x773da000
695   11:51:28.841700 munmap(0x773da000, 155648) = 0
695   11:51:28.851969 munmap(0x77500000, 892928) = 0
695   11:51:28.862074 mprotect(0x77400000, 135168, PROT_READ|PROT_WRITE) = 0
695   11:51:28.872949 write(1, "   PerfTop:   10018 irqs/sec  ke"..., 
91) = 91
695   11:51:28.884972 write(1, "--------------------------------"..., 
80) = 80
694   11:51:28.900593 poll([{fd=3, events=POLLIN}], 1, 100) = 1 ([{fd=3, 
revents=POLLIN}])
695   11:51:28.942867 write(1, "\n", 1) = 1
695   11:51:28.960599 ioctl(1, TCGETS, {B115200 opost isig icanon echo 
...}) = 0
695   11:51:28.980610 write(1, "  \33[31m  30.86%\33[m  perf 
"..., 65) = 65
695   11:51:29.006208 write(1, "  \33[31m  11.48%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:29.028166 write(1, "  \33[31m   5.54%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.050602 write(1, "  \33[32m   3.95%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.076411 write(1, "  \33[32m   3.40%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.095943 write(1, "  \33[32m   2.73%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.119194 write(1, "  \33[32m   2.68%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.146161 write(1, "  \33[32m   2.54%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.168194 write(1, "  \33[32m   2.06%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.190597 write(1, "  \33[32m   1.54%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.220598 write(1, "  \33[32m   1.46%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.243194 write(1, "  \33[32m   1.28%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.266644 write(1, "  \33[32m   1.25%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.290592 write(1, "  \33[32m   1.15%\33[m 
libpthread-2"..., 65) = 65
695   11:51:29.316571 write(1, "  \33[32m   1.10%\33[m  strace 
"..., 65) = 65
695   11:51:29.339197 write(1, "  \33[32m   0.99%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.366444 write(1, "  \33[32m   0.76%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.399591 write(1, "  \33[32m   0.73%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.412443 write(1, "  \33[32m   0.72%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.424943 write(1, "  \33[32m   0.69%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.437085 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:29.450221 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:29.462606 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:29.470618 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:29.478656 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:29.487174 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:29.495676 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:29.504378 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:29.514444 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:29.523104 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:29.532868 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:29.542426 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:29.552206 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:29.561869 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:29.571425 write(1, "\n", 1) = 1
695   11:51:29.580958 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:29.590683 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:29.599714 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:29.610917 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:29.620684 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:29.629971 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:29.639861 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:29.649726 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:29.659330 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:29.671220 write(1, "   PerfTop:    1343 irqs/sec  ke"..., 
91) = 91
695   11:51:29.681407 write(1, "--------------------------------"..., 
80) = 80
694   11:51:29.700595 poll([{fd=3, events=POLLIN}], 1, 100) = 1 ([{fd=3, 
revents=POLLIN}])
695   11:51:29.727362 write(1, "\n", 1) = 1
695   11:51:29.746148 write(1, "  \33[31m  30.77%\33[m  perf 
"..., 65) = 65
695   11:51:29.767972 write(1, "  \33[31m  11.52%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:29.790592 write(1, "  \33[31m   5.60%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.817166 write(1, "  \33[32m   4.13%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.835967 write(1, "  \33[32m   3.52%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.870702 write(1, "  \33[32m   2.83%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.882419 write(1, "  \33[32m   2.74%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.905908 write(1, "  \33[32m   2.62%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.928911 write(1, "  \33[32m   2.07%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.950593 write(1, "  \33[32m   1.49%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.975944 write(1, "  \33[32m   1.47%\33[m  [kernel] 
"..., 65) = 65
695   11:51:29.997152 write(1, "  \33[32m   1.21%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.019145 write(1, "  \33[32m   1.18%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.050593 write(1, "  \33[32m   1.16%\33[m 
libpthread-2"..., 65) = 65
695   11:51:30.072602 write(1, "  \33[32m   1.09%\33[m  strace 
"..., 65) = 65
695   11:51:30.090597 write(1, "  \33[32m   0.86%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.110593 write(1, "  \33[32m   0.78%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.135927 write(1, "  \33[32m   0.77%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.157168 write(1, "  \33[32m   0.75%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.179163 write(1, "  \33[32m   0.75%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.200593 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:30.225722 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:30.245438 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:30.269097 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:30.286382 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:30.304176 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:30.320597 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:30.340593 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:30.348919 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:30.370599 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:30.390598 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:30.399106 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:30.420596 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:30.440595 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:30.448869 write(1, "\n", 1) = 1
695   11:51:30.464186 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:30.485857 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:30.504715 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:30.514341 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:30.523881 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:30.533110 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:30.542836 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:30.553860 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:30.563092 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:30.574694 write(1, "   PerfTop:    2201 irqs/sec  ke"..., 
91) = 91
695   11:51:30.584700 write(1, "--------------------------------"..., 
80) = 80
694   11:51:30.600601 poll([{fd=3, events=POLLIN}], 1, 100) = 1 ([{fd=3, 
revents=POLLIN}])
695   11:51:30.626479 write(1, "\n", 1) = 1
695   11:51:30.647186 write(1, "  \33[31m  30.58%\33[m  perf 
"..., 65) = 65
695   11:51:30.667871 write(1, "  \33[31m  11.38%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:30.689184 write(1, "  \33[31m   5.80%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.715932 write(1, "  \33[32m   4.11%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.737445 write(1, "  \33[32m   3.60%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.755945 write(1, "  \33[32m   2.97%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.777415 write(1, "  \33[32m   2.89%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.810605 write(1, "  \33[32m   2.59%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.823187 write(1, "  \33[32m   2.08%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.845941 write(1, "  \33[32m   1.57%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.870709 write(1, "  \33[32m   1.40%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.895628 write(1, "  \33[32m   1.19%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.907414 write(1, "  \33[32m   1.09%\33[m 
libpthread-2"..., 65) = 65
695   11:51:30.920632 write(1, "  \33[32m   1.07%\33[m  strace 
"..., 65) = 65
695   11:51:30.932419 write(1, "  \33[32m   1.03%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.944161 write(1, "  \33[32m   0.78%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.955900 write(1, "  \33[32m   0.76%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.967401 write(1, "  \33[32m   0.76%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.980410 write(1, "  \33[32m   0.74%\33[m  [kernel] 
"..., 65) = 65
695   11:51:30.992175 write(1, "  \33[32m   0.69%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.003405 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:31.014472 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:31.024728 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:31.036880 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:31.047923 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:31.060347 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:31.071327 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:31.079655 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:31.088372 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:31.096857 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:31.105369 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:31.116115 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:31.124665 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:31.133350 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:31.141853 write(1, "\n", 1) = 1
695   11:51:31.149911 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:31.158465 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:31.166961 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:31.176454 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:31.185974 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:31.195222 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:31.205963 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:31.216915 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:31.226330 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:31.236631 write(1, "   PerfTop:     790 irqs/sec  ke"..., 
91) = 91
695   11:51:31.246708 write(1, "--------------------------------"..., 
80) = 80
694   11:51:31.260593 poll([{fd=3, events=POLLIN}], 1, 100 <unfinished ...>
695   11:51:31.275605 write(1, "\n", 1) = 1
695   11:51:31.286092 write(1, "  \33[31m  30.63%\33[m  perf 
"..., 65) = 65
695   11:51:31.296855 write(1, "  \33[31m  11.48%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:31.308446 write(1, "  \33[31m   5.85%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.319932 write(1, "  \33[32m   4.13%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.331603 write(1, "  \33[32m   3.56%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.342693 write(1, "  \33[32m   2.99%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.354175 write(1, "  \33[32m   2.91%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.367385 write(1, "  \33[32m   2.60%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.378959 write(1, "  \33[32m   2.05%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.391592 write(1, "  \33[32m   1.58%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.403145 write(1, "  \33[32m   1.36%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.414665 write(1, "  \33[32m   1.18%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.427174 write(1, "  \33[32m   1.09%\33[m  strace 
"..., 65) = 65
695   11:51:31.438925 write(1, "  \33[32m   1.09%\33[m 
libpthread-2"..., 65) = 65
695   11:51:31.450889 write(1, "  \33[32m   0.97%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.462425 write(1, "  \33[32m   0.81%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.474175 write(1, "  \33[32m   0.78%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.486649 write(1, "  \33[32m   0.77%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.498407 write(1, "  \33[32m   0.74%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.510358 write(1, "  \33[32m   0.70%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.521372 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:31.532128 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:31.544215 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:31.555327 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:31.567384 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:31.578619 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:31.589872 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:31.602375 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:31.613174 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:31.621853 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:31.629951 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:31.638666 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:31.647167 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:31.655896 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:31.664353 write(1, "\n", 1) = 1
695   11:51:31.672654 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:31.681192 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:31.688962 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:31.697972 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:31.708612 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:31.719154 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:31.728952 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:31.738725 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:31.748135 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:31.758197 write(1, "   PerfTop:       0 irqs/sec  ke"..., 
91) = 91
695   11:51:31.768173 write(1, "--------------------------------"..., 
80) = 80
695   11:51:31.784408 write(1, "\n", 1) = 1
695   11:51:31.795649 write(1, "  \33[31m  30.63%\33[m  perf 
"..., 65) = 65
695   11:51:31.806608 write(1, "  \33[31m  11.48%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:31.817198 write(1, "  \33[31m   5.85%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.827958 write(1, "  \33[32m   4.13%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.838887 write(1, "  \33[32m   3.56%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.849438 write(1, "  \33[32m   2.99%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.860381 write(1, "  \33[32m   2.91%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.871666 write(1, "  \33[32m   2.60%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.884387 write(1, "  \33[32m   2.05%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.895923 write(1, "  \33[32m   1.58%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.907188 write(1, "  \33[32m   1.36%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.918680 write(1, "  \33[32m   1.18%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.931613 write(1, "  \33[32m   1.09%\33[m  strace 
"..., 65) = 65
695   11:51:31.943175 write(1, "  \33[32m   1.09%\33[m 
libpthread-2"..., 65) = 65
695   11:51:31.954685 write(1, "  \33[32m   0.97%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.966160 write(1, "  \33[32m   0.81%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.977643 write(1, "  \33[32m   0.78%\33[m  [kernel] 
"..., 65) = 65
695   11:51:31.990365 write(1, "  \33[32m   0.77%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.001942 write(1, "  \33[32m   0.74%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.013634 write(1, "  \33[32m   0.70%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.024855 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:32.035331 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:32.046465 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:32.057341 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:32.069373 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:32.081872 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:32.093374 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:32.106122 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:32.117118 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:32.128349 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:32.139421 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:32.150476 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:32.157872 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:32.166352 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:32.175604 write(1, "\n", 1) = 1
695   11:51:32.183864 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:32.192323 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:32.199964 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:32.208576 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:32.218227 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:32.226655 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:32.236205 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:32.245651 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:32.254728 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:32.264668 write(1, "   PerfTop:       0 irqs/sec  ke"..., 
91) = 91
695   11:51:32.275631 write(1, "--------------------------------"..., 
80) = 80
694   11:51:32.290474 <... poll resumed> ) = 0 (Timeout)
695   11:51:32.301857 write(1, "\n", 1) = 1
695   11:51:32.325668 write(1, "  \33[31m  30.63%\33[m  perf 
"..., 65) = 65
695   11:51:32.346612 write(1, "  \33[31m  11.48%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:32.365445 write(1, "  \33[31m   5.85%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.386170 write(1, "  \33[32m   4.13%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.405437 write(1, "  \33[32m   3.56%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.427455 write(1, "  \33[32m   2.99%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.448188 write(1, "  \33[32m   2.91%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.470705 write(1, "  \33[32m   2.60%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.490593 write(1, "  \33[32m   2.05%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.510593 write(1, "  \33[32m   1.58%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.530592 write(1, "  \33[32m   1.36%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.550593 write(1, "  \33[32m   1.18%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.575925 write(1, "  \33[32m   1.09%\33[m  strace 
"..., 65) = 65
695   11:51:32.597695 write(1, "  \33[32m   1.09%\33[m 
libpthread-2"..., 65) = 65
695   11:51:32.620590 write(1, "  \33[32m   0.97%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.640593 write(1, "  \33[32m   0.81%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.660591 write(1, "  \33[32m   0.78%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.685937 write(1, "  \33[32m   0.77%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.707440 write(1, "  \33[32m   0.74%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.728944 write(1, "  \33[32m   0.70%\33[m  [kernel] 
"..., 65) = 65
695   11:51:32.750591 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:32.770592 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:32.795473 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:32.817842 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:32.840689 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:32.860591 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:32.880593 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:32.905632 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:32.926919 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:32.948359 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:32.970591 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:32.990595 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:33.015674 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:33.038110 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:33.053606 write(1, "\n", 1) = 1
695   11:51:33.070703 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:33.090594 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:33.098222 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:33.116200 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:33.134714 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:33.154359 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:33.170594 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:33.190593 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:33.199839 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:33.220593 write(1, "   PerfTop:    2126 irqs/sec  ke"..., 
91) = 91
695   11:51:33.240593 write(1, "--------------------------------"..., 
80) = 80
695   11:51:33.278896 write(1, "\n", 1) = 1
695   11:51:33.300588 write(1, "  \33[31m  23.91%\33[m  perf 
"..., 65) = 65
695   11:51:33.320602 write(1, "  \33[31m  10.76%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:33.340593 write(1, "  \33[31m   6.88%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.360604 write(1, "  \33[32m   4.76%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.381968 write(1, "  \33[32m   4.11%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.402658 write(1, "  \33[32m   3.53%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.420598 write(1, "  \33[32m   3.36%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.440598 write(1, "  \33[32m   2.88%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.460604 write(1, "  \33[32m   2.18%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.480594 write(1, "  \33[32m   1.78%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.500597 write(1, "  \33[32m   1.43%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.520596 write(1, "  \33[32m   1.23%\33[m  strace 
"..., 65) = 65
695   11:51:33.540593 write(1, "  \33[32m   1.22%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.560710 write(1, "  \33[32m   0.96%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.580702 write(1, "  \33[32m   0.91%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.600696 write(1, "  \33[32m   0.88%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.625448 write(1, "  \33[32m   0.85%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.640589 write(1, "  \33[32m   0.83%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.660594 write(1, "  \33[32m   0.83%\33[m 
libpthread-2"..., 65) = 65
695   11:51:33.690592 write(1, "  \33[32m   0.82%\33[m  [kernel] 
"..., 65) = 65
695   11:51:33.699920 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:33.725477 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:33.746600 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:33.767144 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:33.787629 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:33.810592 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:33.830594 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:33.850593 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:33.875623 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:33.896595 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:33.920589 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:33.940589 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:33.960592 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:33.980592 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:34.005365 write(1, "\n", 1) = 1
695   11:51:34.027114 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:34.045463 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:34.070703 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:34.090591 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:34.110597 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:34.118228 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:34.134716 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:34.154835 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:34.170597 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:34.190594 write(1, "   PerfTop:    2551 irqs/sec  ke"..., 
91) = 91
695   11:51:34.199135 write(1, "--------------------------------"..., 
80) = 80
695   11:51:34.252328 write(1, "\n", 1) = 1
695   11:51:34.261445 write(1, "  \33[31m  25.71%\33[m  perf 
"..., 65) = 65
695   11:51:34.285609 write(1, "  \33[31m  10.89%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:34.305917 write(1, "  \33[31m   6.68%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.320604 write(1, "  \33[32m   4.60%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.340693 write(1, "  \33[32m   4.09%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.360595 write(1, "  \33[32m   3.41%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.390593 write(1, "  \33[32m   3.26%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.410616 write(1, "  \33[32m   2.86%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.430589 write(1, "  \33[32m   2.24%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.450593 write(1, "  \33[32m   1.71%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.470703 write(1, "  \33[32m   1.36%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.490594 write(1, "  \33[32m   1.20%\33[m  strace 
"..., 65) = 65
695   11:51:34.510592 write(1, "  \33[32m   1.15%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.521168 write(1, "  \33[32m   0.92%\33[m 
libpthread-2"..., 65) = 65
695   11:51:34.545447 write(1, "  \33[32m   0.90%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.566203 write(1, "  \33[32m   0.88%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.586948 write(1, "  \33[32m   0.86%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.605449 write(1, "  \33[32m   0.86%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.626202 write(1, "  \33[32m   0.83%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.646950 write(1, "  \33[32m   0.78%\33[m  [kernel] 
"..., 65) = 65
695   11:51:34.666939 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:34.687886 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:34.710590 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:34.730592 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:34.745129 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:34.766131 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:34.786926 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:34.820590 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:34.831419 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:34.855357 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:34.876376 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:34.897419 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:34.919630 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:34.940591 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:34.965602 write(1, "\n", 1) = 1
695   11:51:34.986366 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:35.005339 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:35.027957 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:35.050589 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:35.070706 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:35.093858 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:35.111459 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:35.130592 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:35.138105 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:35.154824 write(1, "   PerfTop:    2821 irqs/sec  ke"..., 
91) = 91
695   11:51:35.174168 write(1, "--------------------------------"..., 
80) = 80
695   11:51:35.183943 futex(0x1018d758, FUTEX_WAIT_PRIVATE, 2, NULL) = 
-1 EAGAIN (Resource temporarily unavailable)
695   11:51:35.192072 futex(0x1018d758, FUTEX_WAKE_PRIVATE, 1) = 0
694   11:51:35.210609 futex(0x1018d758, FUTEX_WAKE_PRIVATE, 1) = 0
695   11:51:35.236612 write(1, "\n", 1) = 1
695   11:51:35.250594 write(1, "  \33[31m  29.13%\33[m  perf 
"..., 65) = 65
695   11:51:35.270704 write(1, "  \33[31m  11.23%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:35.290594 write(1, "  \33[31m   6.32%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.380613 write(1, "  \33[32m   4.24%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.450608 write(1, "  \33[32m   3.85%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.610587 write(1, "  \33[32m   3.17%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.650584 write(1, "  \33[32m   3.04%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.774893 write(1, "  \33[32m   2.75%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.790595 write(1, "  \33[32m   2.11%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.810592 write(1, "  \33[32m   1.65%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.830703 write(1, "  \33[32m   1.22%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.850684 write(1, "  \33[32m   1.09%\33[m 
libpthread-2"..., 65) = 65
695   11:51:35.870702 write(1, "  \33[32m   1.09%\33[m  strace 
"..., 65) = 65
695   11:51:35.890599 write(1, "  \33[32m   1.07%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.910619 write(1, "  \33[32m   0.90%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.930594 write(1, "  \33[32m   0.87%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.950599 write(1, "  \33[32m   0.86%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.970597 write(1, "  \33[32m   0.80%\33[m  [kernel] 
"..., 65) = 65
695   11:51:35.990606 write(1, "  \33[32m   0.73%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.010602 write(1, "  \33[32m   0.73%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.040627 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:36.050686 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:36.075612 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:36.096091 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:36.116696 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:36.135401 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:36.157629 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:36.180595 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:36.200602 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:36.225605 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:36.245404 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:36.267876 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:36.289189 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:36.310593 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:36.335602 write(1, "\n", 1) = 1
695   11:51:36.357355 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:36.380599 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:36.400591 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:36.426455 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:36.448201 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:36.473823 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:36.491574 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:36.499844 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:36.514340 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:36.534893 write(1, "   PerfTop:    3190 irqs/sec  ke"..., 
91) = 91
695   11:51:36.554208 write(1, "--------------------------------"..., 
80) = 80
695   11:51:36.604676 write(1, "\n", 1) = 1
695   11:51:36.623649 write(1, "  \33[31m  30.52%\33[m  perf 
"..., 65) = 65
695   11:51:36.640590 write(1, "  \33[31m  10.95%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:36.660598 write(1, "  \33[31m   5.79%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.670844 write(1, "  \33[32m   3.85%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.695382 write(1, "  \33[32m   3.71%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.716918 write(1, "  \33[32m   3.59%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.735415 write(1, "  \33[32m   3.35%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.755916 write(1, "  \33[32m   3.11%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.776435 write(1, "  \33[32m   2.08%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.796912 write(1, "  \33[32m   1.57%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.815437 write(1, "  \33[32m   1.18%\33[m 
libpthread-2"..., 65) = 65
695   11:51:36.835948 write(1, "  \33[32m   1.07%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.857605 write(1, "  \33[32m   0.99%\33[m  strace 
"..., 65) = 65
695   11:51:36.875662 write(1, "  \33[32m   0.94%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.896416 write(1, "  \33[32m   0.93%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.917168 write(1, "  \33[32m   0.86%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.937725 write(1, "  \33[32m   0.82%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.955448 write(1, "  \33[32m   0.73%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.976169 write(1, "  \33[32m   0.71%\33[m  [kernel] 
"..., 65) = 65
695   11:51:36.997936 write(1, "  \33[32m   0.64%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.020593 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:37.040596 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:37.060598 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:37.080341 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:37.089937 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:37.100339 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:37.111079 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:37.122928 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:37.133915 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:37.144909 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:37.155923 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:37.166649 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:37.178691 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:37.189667 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:37.200720 write(1, "\n", 1) = 1
695   11:51:37.212611 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:37.223460 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:37.234960 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:37.245952 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:37.256971 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:37.267603 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:37.278952 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:37.292974 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:37.299598 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:37.308383 write(1, "   PerfTop:    1445 irqs/sec  ke"..., 
91) = 91
695   11:51:37.316932 write(1, "--------------------------------"..., 
80) = 80
694   11:51:37.331120 poll([{fd=3, events=POLLIN}], 1, 100) = 1 ([{fd=3, 
revents=POLLIN}])
695   11:51:37.356840 write(1, "\n", 1) = 1
695   11:51:37.375874 write(1, "  \33[31m  31.61%\33[m  perf 
"..., 65) = 65
695   11:51:37.390594 write(1, "  \33[31m  11.13%\33[m 
libc-2.16.so"..., 65) = 65
695   11:51:37.410621 write(1, "  \33[31m   5.75%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.424915 write(1, "  \33[32m   3.70%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.444917 write(1, "  \33[32m   3.63%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.465369 write(1, "  \33[32m   3.50%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.486704 write(1, "  \33[32m   3.25%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.506972 write(1, "  \33[32m   2.94%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.525212 write(1, "  \33[32m   2.08%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.545209 write(1, "  \33[32m   1.50%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.565347 write(1, "  \33[32m   1.24%\33[m 
libpthread-2"..., 65) = 65
695   11:51:37.585418 write(1, "  \33[32m   1.07%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.600595 write(1, "  \33[32m   0.99%\33[m  strace 
"..., 65) = 65
695   11:51:37.630590 write(1, "  \33[32m   0.92%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.640927 write(1, "  \33[32m   0.90%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.665415 write(1, "  \33[32m   0.82%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.680590 write(1, "  \33[32m   0.78%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.700592 write(1, "  \33[32m   0.73%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.725444 write(1, "  \33[32m   0.70%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.746195 write(1, "  \33[32m   0.61%\33[m  [kernel] 
"..., 65) = 65
695   11:51:37.760593 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:37.785102 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:37.805102 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:37.820591 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:37.840591 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:37.860588 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:37.880592 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:37.900849 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:37.925418 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:37.945410 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:37.966423 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:37.987377 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:38.005414 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:38.040622 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:38.061604 write(1, "\n", 1) = 1
695   11:51:38.081126 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:38.102378 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:38.121836 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:38.133954 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:38.145097 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:38.155598 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:38.166702 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:38.177575 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:38.189419 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:38.200873 write(1, "   PerfTop:    2078 irqs/sec  ke"..., 
91) = 91
695   11:51:38.208129 write(1, "--------------------------------"..., 
80) = 80
694   11:51:38.220595 poll([{fd=3, events=POLLIN}], 1, 100) = 1 ([{fd=3, 
revents=POLLIN}])
695   11:51:38.249371 write(1, "\n", 1) = 1
695   11:51:38.265187 write(1, "  \33[31m  31.49%\33[m  perf 
"..., 69) = 69
695   11:51:38.286112 write(1, "  \33[31m  11.15%\33[m 
libc-2.16.so"..., 69) = 69
695   11:51:38.305206 write(1, "  \33[31m   5.80%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.324919 write(1, "  \33[32m   3.75%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.340592 write(1, "  \33[32m   3.65%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.354914 write(1, "  \33[32m   3.46%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.376159 write(1, "  \33[32m   3.33%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.395889 write(1, "  \33[32m   2.88%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.415670 write(1, "  \33[32m   2.10%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.430592 write(1, "  \33[32m   1.52%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.444871 write(1, "  \33[32m   1.20%\33[m 
libpthread-2"..., 69) = 69
695   11:51:38.465416 write(1, "  \33[32m   1.03%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.486195 write(1, "  \33[32m   1.03%\33[m  strace 
"..., 69) = 69
695   11:51:38.506668 write(1, "  \33[32m   0.97%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.527200 write(1, "  \33[32m   0.91%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.545199 write(1, "  \33[32m   0.83%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.567448 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.583667 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.593963 write(1, "  \33[32m   0.68%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.604411 write(1, "  \33[32m   0.60%\33[m  [kernel] 
"..., 69) = 69
695   11:51:38.614414 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:38.623978 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:38.633229 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:38.643094 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:38.653876 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:38.664125 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:38.674627 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:38.685676 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:38.696663 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:38.707356 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:38.719175 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:38.730396 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:38.742626 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:38.753852 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:38.764612 write(1, "\n", 1) = 1
695   11:51:38.776361 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:38.787207 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:38.797835 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:38.808878 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:38.819696 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:38.832118 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:38.843453 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:38.854726 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:38.865574 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:38.877381 write(1, "   PerfTop:     913 irqs/sec  ke"..., 
91) = 91
695   11:51:38.889676 write(1, "--------------------------------"..., 
80) = 80
694   11:51:38.910615 poll([{fd=3, events=POLLIN}], 1, 100) = 1 ([{fd=3, 
revents=POLLIN}])
695   11:51:38.936421 write(1, "\n", 1) = 1
695   11:51:38.950595 write(1, "  \33[31m  31.48%\33[m  perf 
"..., 69) = 69
695   11:51:38.964860 write(1, "  \33[31m  11.26%\33[m 
libc-2.16.so"..., 69) = 69
695   11:51:38.984917 write(1, "  \33[31m   5.83%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.000616 write(1, "  \33[32m   3.69%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.014918 write(1, "  \33[32m   3.67%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.034689 write(1, "  \33[32m   3.39%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.054682 write(1, "  \33[32m   3.34%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.070701 write(1, "  \33[32m   2.83%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.090593 write(1, "  \33[32m   2.13%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.110591 write(1, "  \33[32m   1.48%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.119695 write(1, "  \33[32m   1.23%\33[m 
libpthread-2"..., 69) = 69
695   11:51:39.140595 write(1, "  \33[32m   1.06%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.154929 write(1, "  \33[32m   1.04%\33[m  strace 
"..., 69) = 69
695   11:51:39.174911 write(1, "  \33[32m   0.95%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.195207 write(1, "  \33[32m   0.95%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.216702 write(1, "  \33[32m   0.80%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.235419 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.255914 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.276445 write(1, "  \33[32m   0.68%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.295417 write(1, "  \33[32m   0.62%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.315364 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:39.335105 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:39.354976 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:39.370592 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:39.390597 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:39.410590 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:39.430598 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:39.450589 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:39.470703 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:39.490597 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:39.520594 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:39.540592 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:39.562630 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:39.580593 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:39.600688 write(1, "\n", 1) = 1
695   11:51:39.620590 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:39.645468 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:39.666969 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:39.686082 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:39.706976 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:39.727472 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:39.750594 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:39.780607 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:39.801097 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:39.822466 write(1, "   PerfTop:    2462 irqs/sec  ke"..., 
91) = 91
695   11:51:39.840593 write(1, "--------------------------------"..., 
80) = 80
694   11:51:39.870707 poll([{fd=3, events=POLLIN}], 1, 100 <unfinished ...>
695   11:51:39.886673 write(1, "\n", 1) = 1
695   11:51:39.899379 write(1, "  \33[31m  31.31%\33[m  perf 
"..., 69) = 69
695   11:51:39.910956 write(1, "  \33[31m  11.09%\33[m 
libc-2.16.so"..., 69) = 69
695   11:51:39.919927 write(1, "  \33[31m   5.95%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.929176 write(1, "  \33[32m   3.78%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.938444 write(1, "  \33[32m   3.77%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.947657 write(1, "  \33[32m   3.35%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.956906 write(1, "  \33[32m   3.28%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.966178 write(1, "  \33[32m   2.88%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.975200 write(1, "  \33[32m   2.14%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.984667 write(1, "  \33[32m   1.54%\33[m  [kernel] 
"..., 69) = 69
695   11:51:39.993950 write(1, "  \33[32m   1.21%\33[m 
libpthread-2"..., 69) = 69
695   11:51:40.003175 write(1, "  \33[32m   1.11%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.013578 write(1, "  \33[32m   1.04%\33[m  strace 
"..., 69) = 69
695   11:51:40.022689 write(1, "  \33[32m   0.94%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.033168 write(1, "  \33[32m   0.91%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.042684 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.052174 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.061611 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.071120 write(1, "  \33[32m   0.69%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.080417 write(1, "  \33[32m   0.66%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.088946 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:40.098474 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:40.107606 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:40.117340 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:40.128125 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:40.138125 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:40.148189 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:40.158201 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:40.168199 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:40.179180 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:40.189200 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:40.199727 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:40.210885 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:40.221862 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:40.232659 write(1, "\n", 1) = 1
695   11:51:40.243401 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:40.255458 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:40.265962 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:40.277203 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:40.288070 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:40.298362 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:40.310422 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:40.321381 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:40.332398 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:40.344129 write(1, "   PerfTop:      99 irqs/sec  ke"..., 
91) = 91
695   11:51:40.356629 write(1, "--------------------------------"..., 
80) = 80
695   11:51:40.376911 write(1, "\n", 1 <unfinished ...>
694   11:51:40.382360 <... poll resumed> ) = 0 (Timeout)
695   11:51:40.400576 <... write resumed> ) = 1
695   11:51:40.410622 write(1, "  \33[31m  31.31%\33[m  perf 
"..., 69) = 69
695   11:51:40.430592 write(1, "  \33[31m  11.09%\33[m 
libc-2.16.so"..., 69) = 69
695   11:51:40.457427 write(1, "  \33[31m   5.95%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.475903 write(1, "  \33[32m   3.78%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.490594 write(1, "  \33[32m   3.77%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.504667 write(1, "  \33[32m   3.35%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.524679 write(1, "  \33[32m   3.28%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.544680 write(1, "  \33[32m   2.88%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.560593 write(1, "  \33[32m   2.14%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.580593 write(1, "  \33[32m   1.54%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.589468 write(1, "  \33[32m   1.21%\33[m 
libpthread-2"..., 69) = 69
695   11:51:40.610594 write(1, "  \33[32m   1.11%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.630593 write(1, "  \33[32m   1.04%\33[m  strace 
"..., 69) = 69
695   11:51:40.650593 write(1, "  \33[32m   0.94%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.670706 write(1, "  \33[32m   0.91%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.679709 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.694920 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.714918 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.734916 write(1, "  \33[32m   0.69%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.750591 write(1, "  \33[32m   0.66%\33[m  [kernel] 
"..., 69) = 69
695   11:51:40.770594 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:40.790590 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:40.799603 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:40.820594 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:40.840591 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:40.854882 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:40.875188 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:40.894938 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:40.915920 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:40.936919 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:40.956952 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:40.977129 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:40.997381 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:41.015357 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:41.035945 write(1, "\n", 1) = 1
695   11:51:41.056386 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:41.078606 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:41.100688 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:41.130597 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:41.151408 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:41.170592 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:41.192597 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:41.210599 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:41.230595 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:41.256138 write(1, "   PerfTop:    2306 irqs/sec  ke"..., 
91) = 91
695   11:51:41.275626 write(1, "--------------------------------"..., 
80) = 80
695   11:51:41.327433 write(1, "\n", 1) = 1
695   11:51:41.349146 write(1, "  \33[31m  29.97%\33[m  perf 
"..., 69) = 69
695   11:51:41.370588 write(1, "  \33[31m  11.25%\33[m 
libc-2.16.so"..., 69) = 69
695   11:51:41.396151 write(1, "  \33[31m   6.26%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.417908 write(1, "  \33[32m   3.83%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.440594 write(1, "  \33[32m   3.76%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.467662 write(1, "  \33[32m   3.34%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.484179 write(1, "  \33[32m   3.33%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.500594 write(1, "  \33[32m   2.84%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.514698 write(1, "  \33[32m   2.14%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.534670 write(1, "  \33[32m   1.56%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.550593 write(1, "  \33[32m   1.16%\33[m 
libpthread-2"..., 69) = 69
695   11:51:41.564667 write(1, "  \33[32m   1.12%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.585700 write(1, "  \33[32m   1.11%\33[m  strace 
"..., 69) = 69
695   11:51:41.604668 write(1, "  \33[32m   0.97%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.620592 write(1, "  \33[32m   0.90%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.640590 write(1, "  \33[32m   0.89%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.660593 write(1, "  \33[32m   0.82%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.669666 write(1, "  \33[32m   0.80%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.688959 write(1, "  \33[32m   0.72%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.704722 write(1, "  \33[32m   0.66%\33[m  [kernel] 
"..., 69) = 69
695   11:51:41.724188 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:41.744478 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:41.760594 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:41.780603 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:41.800591 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:41.810366 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:41.830589 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:41.855187 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:41.876450 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:41.893169 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:41.903177 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:41.913373 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:41.923626 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:41.933616 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:41.944602 write(1, "\n", 1) = 1
695   11:51:41.954949 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:41.965834 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:41.976207 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:41.986954 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:41.998724 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:42.009218 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:42.020204 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:42.030925 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:42.042578 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:42.055133 write(1, "   PerfTop:    1705 irqs/sec  ke"..., 
91) = 91
695   11:51:42.066194 write(1, "--------------------------------"..., 
80) = 80
694   11:51:42.080594 poll([{fd=3, events=POLLIN}], 1, 100) = 1 ([{fd=3, 
revents=POLLIN}])
695   11:51:42.121086 write(1, "\n", 1) = 1
695   11:51:42.132371 write(1, "  \33[31m  31.33%\33[m  perf 
"..., 69) = 69
695   11:51:42.160604 write(1, "  \33[31m  11.32%\33[m 
libc-2.16.so"..., 69) = 69
695   11:51:42.180593 write(1, "  \33[31m   6.11%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.210598 write(1, "  \33[32m   3.77%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.230598 write(1, "  \33[32m   3.63%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.252405 write(1, "  \33[32m   3.28%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.276395 write(1, "  \33[32m   3.17%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.294147 write(1, "  \33[32m   2.77%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.314157 write(1, "  \33[32m   2.09%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.330593 write(1, "  \33[32m   1.52%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.350591 write(1, "  \33[32m   1.23%\33[m 
libpthread-2"..., 69) = 69
695   11:51:42.360928 write(1, "  \33[32m   1.11%\33[m  strace 
"..., 69) = 69
695   11:51:42.380593 write(1, "  \33[32m   1.09%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.394729 write(1, "  \33[32m   0.96%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.414697 write(1, "  \33[32m   0.90%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.430597 write(1, "  \33[32m   0.87%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.444896 write(1, "  \33[32m   0.80%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.464916 write(1, "  \33[32m   0.78%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.485452 write(1, "  \33[32m   0.72%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.504911 write(1, "  \33[32m   0.62%\33[m  [kernel] 
"..., 69) = 69
695   11:51:42.520603 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:42.540592 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:42.548351 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:42.565593 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:42.585428 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:42.605628 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:42.626685 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:42.646635 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:42.667683 write(1, "\t[s]     annotate symbol.       "..., 
52) = 52
695   11:51:42.687667 write(1, "\t[S]     stop annotation.\n", 26) = 26
695   11:51:42.704928 write(1, "\t[K]     hide kernel_symbols sym"..., 
48) = 48
695   11:51:42.724930 write(1, "\t[U]     hide user symbols.     "..., 
48) = 48
695   11:51:42.744127 write(1, "\t[z]     toggle sample zeroing. "..., 
49) = 49
695   11:51:42.754350 write(1, "\t[qQ]    quit.\n", 15) = 15
695   11:51:42.764111 write(1, "\n", 1) = 1
695   11:51:42.773628 write(1, "Enter selection, or unmapped key"..., 
46) = 46
695   11:51:42.784709 ioctl(0, TCGETS, 0x77ddba28) = -1 EBADF (Bad file 
descriptor)
695   11:51:42.794958 ioctl(0, TCSETS, {B0 -opost isig -icanon -echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:42.805825 poll([{fd=0, events=POLLIN}], 1, -1) = 1 ([{fd=0, 
revents=POLLNVAL}])
695   11:51:42.816474 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:42.826722 ioctl(0, TCSETSF, {B0 -opost isig icanon echo 
...}) = -1 EBADF (Bad file descriptor)
695   11:51:42.838575 ioctl(0, TCSETS, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:42.850677 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:42.861169 write(1, "\33[H\33[2J\n", 8) = 8
695   11:51:42.872645 write(1, "   PerfTop:    1704 irqs/sec  ke"..., 
91) = 91
695   11:51:42.883631 write(1, "--------------------------------"..., 
80) = 80
694   11:51:42.900593 poll([{fd=3, events=POLLIN}], 1, 100) = 1 ([{fd=3, 
revents=POLLIN}])
695   11:51:42.940594 write(1, "\n", 1) = 1
695   11:51:42.962112 write(1, "  \33[31m  31.35%\33[m  perf 
"..., 69) = 69
695   11:51:42.980592 write(1, "  \33[31m  11.28%\33[m 
libc-2.16.so"..., 69) = 69
695   11:51:43.000620 write(1, "  \33[31m   6.13%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.026147 write(1, "  \33[32m   3.82%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.047944 write(1, "  \33[32m   3.64%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.070701 write(1, "  \33[32m   3.35%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.090603 write(1, "  \33[32m   3.09%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.116137 write(1, "  \33[32m   2.75%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.138941 write(1, "  \33[32m   2.11%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.165396 write(1, "  \33[32m   1.58%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.180590 write(1, "  \33[32m   1.20%\33[m 
libpthread-2"..., 69) = 69
695   11:51:43.200592 write(1, "  \33[32m   1.13%\33[m  strace 
"..., 69) = 69
695   11:51:43.209417 write(1, "  \33[32m   1.12%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.230597 write(1, "  \33[32m   0.92%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.250593 write(1, "  \33[32m   0.89%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.259666 write(1, "  \33[32m   0.83%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.280614 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.294674 write(1, "  \33[32m   0.79%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.314697 write(1, "  \33[32m   0.75%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.330589 write(1, "  \33[32m   0.60%\33[m  [kernel] 
"..., 69) = 69
695   11:51:43.350695 poll([{fd=0, events=POLLIN}], 1, 2000) = 1 
([{fd=0, revents=POLLNVAL}])
695   11:51:43.364636 read(0, 0x775db000, 8192) = -1 EBADF (Bad file 
descriptor)
695   11:51:43.384473 ioctl(0, TCSETSF, {0x54 /* B??? */ -opost -isig 
-icanon -echo ...}) = -1 EBADF (Bad file descriptor)
695   11:51:43.400585 write(1, "\nMapped keys:\n", 14) = 14
695   11:51:43.420589 write(1, "\t[d]     display refresh delay. "..., 
49) = 49
695   11:51:43.440593 write(1, "\t[e]     display entries (lines)"..., 
50) = 50
695   11:51:43.458420 write(1, "\t[f]     profile display filter "..., 
49) = 49
695   11:51:43.468437 write(1, "\t[F]     annotate display filter"..., 
50) = 50
695   11:51:43.478621 write(1, "\t[s]     annotate symbol.       "..., 
52) = ? ERESTARTSYS (To be restarted)
695   11:51:43.489663 --- {si_signo=SIGINT, si_code=SI_KERNEL} 
(Interrupt) ---
694   11:51:43.503860 +++ killed by SIGINT +++



