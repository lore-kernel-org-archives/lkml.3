Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3COSjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:39:25 -0400
Received: from ns.iliad.fr ([212.27.33.1]:38484 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab3COSjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:39:24 -0400
Message-ID: <51436AD7.1050205@freebox.fr>
Date: Fri, 15 Mar 2013 19:39:19 +0100
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 1/3] seccomp: add generic code for jitted seccomp
 filters.
References: <1363372123-8861-1-git-send-email-nschichan@freebox.fr> <1363372123-8861-2-git-send-email-nschichan@freebox.fr>
In-Reply-To: <1363372123-8861-2-git-send-email-nschichan@freebox.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 07:28 PM, Nicolas Schichan wrote:
[Sorry, I forgot to put the mailing lists as the receivers of the introductory 
message]

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

Regards,

-- 
Nicolas Schichan
Freebox SAS
