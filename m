Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3DXR2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:28:08 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:35661 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3DXR2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:28:05 -0400
From: Nicolas Schichan <nschichan@freebox.fr>
To: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH V3] Support for JIT in Seccomp BPF filters.
Date: Wed, 24 Apr 2013 19:27:06 +0200
Message-Id: <1366824429-26652-1-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch serie adds support for jitted seccomp BPF filters, with the
required modifications to make it work on the ARM architecture.

- The first patch in the serie adds the required boiler plate in the
  core kernel seccomp code to invoke the JIT compilation/free code.

- The second patch reworks the ARM BPF JIT code to make the generation
  process less dependent on struct sk_filter.

- The last patch actually implements the ARM part in the BPF jit code.

Some benchmarks, on a 1.6Ghz 88f6282 CPU:

Each system call is tested in two way (fast/slow):

 - on the fast version, the tested system call is accepted immediately
   after checking the architecture (5 BPF instructions).

 - on the slow version, the tested system call is accepted after
   previously checking for 85 syscall (90 instructions, including the
   architecture check).

The tested syscall is invoked in a loop 1000000 time, the reported
time is the time spent in the loop in seconds.

Without Seccomp JIT:

Syscall		Time-Fast  Time-Slow
--------------- ---------- ----------
gettimeofday	0.389	   1.633
getpid		0.406	   1.688
getresuid	1.003	   2.266
getcwd		1.342	   2.128

With Seccomp JIT:

Syscall		Time-Fast  Time-Slow
--------------- ----------- ---------
gettimeofday	0.348	    0.428
getpid		0.365	    0.480
getresuid	0.981	    1.060
getcwd		1.237	    1.294

For reference, the same code without any seccomp filter:

Syscall		Time
--------------- -----
gettimeofday	0.119
getpid		0.137
getresuid	0.747
getcwd		1.021

The activation of the BPF JIT for seccomp is still controled with the
/proc/sys/net/core/bpf_jit_enable sysctl knob.

Those changes are based on the latest rmk-for-next branch.

V2 Changes:
- Document the @bpf_func field in struct seccomp_filter as recommended
  by Kees Cook.
- Invoke seccomp_bpf_load directly from generated code without going
  via a wrapper.

V3 Changes:
- add accessors giving access to the fields in struct seccomp_filter
  as recommended by Andrew Morton. This avoids having to include
  <linux/filter.h> in <linux/seccomp.h>, and fixes broken include
  dependencies on x86_64 allmodconfig build.
- checkpatch fixes (void*) -> (void *)

Regards,
