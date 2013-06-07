Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab3FGESO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 00:18:14 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:65165 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3FGESM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 00:18:12 -0400
MIME-Version: 1.0
Date: Fri, 7 Jun 2013 12:18:09 +0800
Message-ID: <CABwSAgF2afnzfEZvhJhJRSwAFQhsn5_BsWZpfN_Cpccj257GXQ@mail.gmail.com>
Subject: iperf high cpu usage bug on 3.10.0-rc3?
From: Junxiao Bi <junxiao.bi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Through iperf test between two 1000M NIC, I got a very different cpu
usage on server mode when bind iperf to cpu 0 or bind to other cpu,
the cpu usage of binding to cpu 0 is about two times higher than
another one, but the network bandwidth is nearly the same. My NIC
doesn't support multi-queue, so all rx interrupt are delivered through
cpu 0. So does the cpu accounting take many run time of interrupt into
process's sys and user time? But on older kernel like 2.6.32, I didn't
find this issue. I just used the default kernel config on 3.10.0-rc3,
is this a bug?

test command:
============
server mode: taskset -c $cpu_id ./iperf -s -u -l 8192 -i 1
client mode: iperf -c x.x.x.x -t 60000 -i 1 -u -b 1000m -l 8192

test log when bind iperf to cpu 0:
=========================

[root@localhost ~]# taskset -c 0 ./iperf -s -u -l 8192 -i 1
------------------------------------------------------------
Server listening on UDP port 5001
Receiving 8192 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 10.182.38.217 port 5001 connected with 10.182.39.153 port 51712
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  3]  0.0- 1.0 sec   114 MBytes   953 Mbits/sec   0.092 ms    0/14539 (0%)
[  3]  1.0- 2.0 sec   114 MBytes   953 Mbits/sec   0.108 ms    0/14540 (0%)
[  3]  2.0- 3.0 sec   114 MBytes   953 Mbits/sec   0.090 ms    0/14535 (0%)
[  3]  3.0- 4.0 sec   114 MBytes   953 Mbits/sec   0.072 ms    0/14542 (0%)
[  3]  4.0- 5.0 sec   114 MBytes   953 Mbits/sec   0.099 ms    0/14541 (0%)
[  3]  5.0- 6.0 sec   114 MBytes   953 Mbits/sec   0.093 ms    0/14542 (0%)
[  3]  6.0- 7.0 sec   113 MBytes   952 Mbits/sec   0.076 ms    0/14523 (0%)
[  3]  7.0- 8.0 sec   114 MBytes   953 Mbits/sec   0.089 ms    0/14539 (0%)

[root@localhost ~]# top

top - 11:15:09 up 31 min,  2 users,  load average: 0.01, 0.04, 0.12
Tasks: 150 total,   1 running, 149 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.4%us,  1.3%sy,  0.0%ni, 98.1%id,  0.1%wa,  0.0%hi,  0.1%si,  0.0%st
Mem:   8069456k total,   475484k used,  7593972k free,    21628k buffers
Swap: 18351188k total,        0k used, 18351188k free,   283256k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7036 root      20   0 38400  896  768 S 24.3  0.0   0:05.02 iperf
    9 root      20   0     0    0    0 S  0.3  0.0   0:00.30 rcu_sched
 7069 root      20   0 12808 1052  740 R  0.3  0.0   0:00.01 top
    1 root      20   0 10416  676  564 S  0.0  0.0   0:00.37 init
     [...]
[root@localhost ~]# cat /proc/7036/stat
7036 (iperf) S 6786 7036 6786 34817 7036 4218880 483 0 0 0 107 695 0 0
20 0 4 0 188437 39321600 224 18446744073709551615 4194304 4255669
140734309787120 140734309786768 231733243625 0 0 4096 24578
18446744073709551615 0 0 17 0 0 0 0 0 0 6352896 6354304 29339648
140734309788663 140734309788690 140734309788690 140734309789680 0
[root@localhost ~]# cat /proc/7036/task/703*/stat
7036 (iperf) S 6786 7036 6786 34817 7036 4218880 434 0 0 0 0 0 0 0 20
0 4 0 188437 39321600 224 18446744073709551615 4194304 4255669
140734309787120 140734309786768 231733243625 0 0 4096 24578
18446744071579488839 0 0 17 0 0 0 0 0 0 6352896 6354304 29339648
140734309788663 140734309788690 140734309788690 140734309789680 0
7037 (iperf) S 6786 7036 6786 34817 7036 4218944 8 0 0 0 0 0 0 0 20 0
4 0 188437 39321600 224 18446744073709551615 4194304 4255669
140734309787120 1082806336 231733255580 0 0 4096 24578
18446744071583423935 0 0 -1 0 0 0 0 0 0 6352896 6354304 29339648
140734309788663 140734309788690 140734309788690 140734309789680 0
7038 (iperf) S 6786 7036 6786 34817 7036 4218944 28 0 0 0 8 1 0 0 20 0
4 0 188437 39321600 224 18446744073709551615 4194304 4255669
140734309787120 1113174224 231721248065 0 0 4096 24578
18446744071579289067 0 0 -1 0 0 0 0 0 0 6352896 6354304 29339648
140734309788663 140734309788690 140734309788690 140734309789680 0
7039 (iperf) S 6786 7036 6786 34817 7036 4218944 13 0 0 0 113 848 0 0
20 0 4 0 189328 39321600 224 18446744073709551615 4194304 4255669
140734309787120 1091199120 231733255393 0 0 4096 24578
18446744071583423935 0 0 -1 0 0 0 0 0 0 6352896 6354304 29339648
140734309788663 140734309788690 140734309788690 140734309789680 0
[root@localhost ~]#


test log when bind iperf to cpu 1:
===============================

[root@localhost ~]# taskset -c 1 ./iperf -s -u -l 8192 -i 1
------------------------------------------------------------
Server listening on UDP port 5001
Receiving 8192 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 10.182.38.217 port 5001 connected with 10.182.39.153 port 47470
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  3]  0.0- 1.0 sec   114 MBytes   953 Mbits/sec   0.075 ms    0/14539 (0%)
[  3]  1.0- 2.0 sec   114 MBytes   953 Mbits/sec   0.078 ms    0/14542 (0%)
[  3]  2.0- 3.0 sec   113 MBytes   950 Mbits/sec   0.078 ms    0/14498 (0%)
[  3]  3.0- 4.0 sec   113 MBytes   951 Mbits/sec   0.085 ms    0/14504 (0%)
[  3]  4.0- 5.0 sec   114 MBytes   953 Mbits/sec   0.097 ms    0/14543 (0%)
[  3]  5.0- 6.0 sec   114 MBytes   953 Mbits/sec   0.077 ms    0/14541 (0%)
[  3]  6.0- 7.0 sec   114 MBytes   953 Mbits/sec   0.081 ms    0/14541 (0%)


[root@localhost ~]# top

top - 11:20:08 up 36 min,  2 users,  load average: 0.08, 0.04, 0.10
Tasks: 151 total,   1 running, 150 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.3%us,  1.9%sy,  0.0%ni, 97.7%id,  0.1%wa,  0.0%hi,  0.1%si,  0.0%st
Mem:   8069456k total,   476068k used,  7593388k free,    21712k buffers
Swap: 18351188k total,        0k used, 18351188k free,   283260k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7140 root      20   0 38400  900  768 S 11.6  0.0   0:02.25 iperf
 6770 root      20   0 90200 3368 2656 S  0.3  0.0   0:00.28 sshd
    1 root      20   0 10416  676  564 S  0.0  0.0   0:00.37 init
    2 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthreadd
    3 root      20   0     0    0    0 S  0.0  0.0   0:00.07
ksoftirqd/0
     [...]
[root@localhost ~]# cat /proc/7140/stat
7140 (iperf) S 6786 7140 6786 34817 7140 4218880 483 0 0 0 31 262 0 0
20 0 4 0 218867 39321600 225 18446744073709551615 4194304 4255669
140735174143280 140735174142928 231733243625 0 0 4096 24578
18446744073709551615 0 0 17 1 0 0 0 0 0 6352896 6354304 25030656
140735174147063 140735174147090 140735174147090 140735174148080 0
[root@localhost ~]# cat /proc/7140/task/714*/stat
7140 (iperf) S 6786 7140 6786 34817 7140 4218880 434 0 0 0 0 0 0 0 20
0 4 0 218867 39321600 225 18446744073709551615 4194304 4255669
140735174143280 140735174142928 231733243625 0 0 4096 24578
18446744071579488839 0 0 17 1 0 0 0 0 0 6352896 6354304 25030656
140735174147063 140735174147090 140735174147090 140735174148080 0
7141 (iperf) S 6786 7140 6786 34817 7140 4218944 8 0 0 0 0 0 0 0 20 0
4 0 218867 39321600 225 18446744073709551615 4194304 4255669
140735174143280 1099792448 231733255580 0 0 4096 24578
18446744071583423935 0 0 -1 1 0 0 0 0 0 6352896 6354304 25030656
140735174147063 140735174147090 140735174147090 140735174148080 0
7142 (iperf) S 6786 7140 6786 34817 7140 4218944 28 0 0 0 4 0 0 0 20 0
4 0 218867 39321600 225 18446744073709551615 4194304 4255669
140735174143280 1108185296 231721248065 0 0 4096 24578
18446744071579289067 0 0 -1 1 0 0 0 0 0 6352896 6354304 25030656
140735174147063 140735174147090 140735174147090 140735174148080 0
7143 (iperf) S 6786 7140 6786 34817 7140 4218944 13 0 0 0 36 360 0 0
20 0 4 0 219293 39321600 225 18446744073709551615 4194304 4255669
140735174143280 1087606928 231733255393 0 0 4096 24578
18446744071583423935 0 0 -1 1 0 0 0 0 0 6352896 6354304 25030656
140735174147063 140735174147090 140735174147090 140735174148080 0

test environment:
============
[root@localhost ~]# uname -a
Linux localhost.localdomain 3.10.0-rc3 #1 SMP Tue May 28 07:38:30 CST
2013 x86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# cat /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 42
model name    : Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz
stepping    : 7
microcode    : 0x23
cpu MHz        : 3101.000
cache size    : 6144 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 4
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt
pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips    : 6186.16
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 42
model name    : Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz
stepping    : 7
microcode    : 0x23
cpu MHz        : 1600.000
cache size    : 6144 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 4
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt
pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips    : 6186.16
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 42
model name    : Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz
stepping    : 7
microcode    : 0x23
cpu MHz        : 1600.000
cache size    : 6144 KB
physical id    : 0
siblings    : 4
core id        : 2
cpu cores    : 4
apicid        : 4
initial apicid    : 4
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt
pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips    : 6186.16
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 42
model name    : Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz
stepping    : 7
microcode    : 0x23
cpu MHz        : 1600.000
cache size    : 6144 KB
physical id    : 0
siblings    : 4
core id        : 3
cpu cores    : 4
apicid        : 6
initial apicid    : 6
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt
pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips    : 6186.16
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

[root@localhost ~]#


Thanks,
Junxiao.
