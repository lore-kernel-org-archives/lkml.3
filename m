Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3I3SsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:48:09 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58665 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3I3SsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:48:07 -0400
MIME-Version: 1.0
Date: Mon, 30 Sep 2013 11:48:06 -0700
Message-ID: <CAHKr1a5tHy1o1Tve87jkgC6AT_Nic6G+BTb8zVEX8KZXwC0Vbg@mail.gmail.com>
Subject: getitimer() returns a value different from the one set by setitimer()
 for ITIMER_PROF
From: Sashi Madduri <mail.to.sashi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing a getitimer() immediately after a setitimer() on ITIMER_PROF
returns the value incremented by 4ms. I can reproduce the issue with
itimer values less than 1s.

I verified that this issue does not occur on CentOS (kernel 2.6 from Dec 2009).

I checked the source code for kernel/itimer.c, and the following
commit in 2011 seems relevant:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/kernel/itimer.c?id=648616343cdbe904c585a6c12e323d3b3c72e46f

I do not understand the source fully to confirm that the issue is due
to the above commit.

Test program:

#include <sys/time.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <iostream>

int main(int argc, char** argv) {
  struct itimerval ts;
  ts.it_value.tv_sec = 0;
  ts.it_value.tv_usec = 8000;
  ts.it_interval.tv_sec = 0;
  ts.it_interval.tv_usec = 8000;

  for (int i = 0; i < 10; ++i) {
    syscall(SYS_setitimer, ITIMER_PROF, &ts, NULL);
    syscall(SYS_getitimer, ITIMER_PROF, &ts);
    std::cout << "Got back itimer value of " << ts.it_interval.tv_sec
<< ", " << ts.it_interval.tv_usec << "\n";
  }
}

My current setup:

/proc/version:
Linux version 3.8.0-19-generic (buildd@allspice) (gcc version 4.7.3
(Ubuntu/Linaro 4.7.3-1ubuntu1) ) #29-Ubuntu SMP Wed Apr 17 18:16:28
UTC 2013

/proc/cpuinfo:
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz
stepping : 9
cpu MHz : 2379.182
cache size : 6144 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm
constant_tsc rep_good nopl pni ssse3 lahf_lm
bogomips : 4758.36
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

Sashi.
