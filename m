Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbaAJP3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:29:41 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:13204 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaAJP3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:29:38 -0500
Message-ID: <52D011C9.7000209@hp.com>
Date: Fri, 10 Jan 2014 10:29:13 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: SIGSEGV when using "perf record -g" with 3.13-rc* kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I recently encountered a strange problem using 3.13-rc* kernel that
did not happen in a 3.12 kernel. When I ran the high_systime benchmark
of the AIM7 test suite, I saw the following errors:

   Child terminated by signal #11

   core dumped

   Child terminated by signal #11

   Child process called exit(), status = 139

   core dumped

   Child terminated by signal #11

This only happened when I monitored the running of the benchmark using
"perf record -g". There was no problem if callchain was not enabled.
Adding debug code to the kernel showed the following stack trace:

Call Trace:
<NMI>  [<ffffffff815710af>] dump_stack+0x49/0x62
  [<ffffffff8104e3bc>] warn_slowpath_common+0x8c/0xc0
  [<ffffffff8104e40a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8105f1f1>] force_sig_info+0x131/0x140
  [<ffffffff81042a4f>] force_sig_info_fault+0x5f/0x70
  [<ffffffff8106d8da>] ? search_exception_tables+0x2a/0x50
  [<ffffffff81043b3d>] ? fixup_exception+0x1d/0x70
  [<ffffffff81042cc9>] no_context+0x159/0x1f0
  [<ffffffff81042e8d>] __bad_area_nosemaphore+0x12d/0x230
  [<ffffffff81042e8d>] ? __bad_area_nosemaphore+0x12d/0x230
  [<ffffffff81042fa3>] bad_area_nosemaphore+0x13/0x20
  [<ffffffff81578fc2>] __do_page_fault+0x362/0x480
  [<ffffffff81578fc2>] ? __do_page_fault+0x362/0x480
  [<ffffffff815791be>] do_page_fault+0xe/0x10
  [<ffffffff81575962>] page_fault+0x22/0x30
  [<ffffffff815817e4>] ? bad_to_user+0x5e/0x66b
  [<ffffffff81285316>] copy_from_user_nmi+0x76/0x90
  [<ffffffff81017a20>] perf_callchain_user+0xd0/0x360
  [<ffffffff8111f64f>] perf_callchain+0x1af/0x1f0
  [<ffffffff81117693>] perf_prepare_sample+0x2f3/0x3a0
  [<ffffffff8111a2af>] __perf_event_overflow+0x10f/0x220
  [<ffffffff8111ab14>] perf_event_overflow+0x14/0x20
  [<ffffffff8101f69e>] intel_pmu_handle_irq+0x1de/0x3c0
  [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
  [<ffffffff81576e64>] perf_event_nmi_handler+0x34/0x60
  [<ffffffff8157664a>] nmi_handle+0x8a/0x170
  [<ffffffff81576848>] default_do_nmi+0x68/0x210
  [<ffffffff81576a80>] do_nmi+0x90/0xe0
  [<ffffffff81575c67>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
  [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
  [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
<<EOE>>  [<ffffffff81042f7d>] __bad_area_nosemaphore+0x21d/0x230
  [<ffffffff81042fa3>] bad_area_nosemaphore+0x13/0x20
  [<ffffffff81578fc2>] __do_page_fault+0x362/0x480
  [<ffffffff8113cfbc>] ? vm_mmap_pgoff+0xbc/0xe0
  [<ffffffff815791be>] do_page_fault+0xe/0x10
  [<ffffffff81575962>] page_fault+0x22/0x30
---[ end trace 037bf09d279751ec ]---

So this is a double page faults. Looking at relevant changes in
3.13 kernel, I spotted the following one patch that modified the
perf_callchain_user() function shown up in the stack trace above:

     perf: Fix arch_perf_out_copy_user default

@@ -2041,7 +2041,7 @@ perf_callchain_user(struct perf_callchain_entry 
*entry, struct pt_regs *regs)
          frame.return_address = 0;

          bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
-        if (bytes != sizeof(frame))
+        if (bytes != 0)
              break;

          if (!valid_user_frame(fp, sizeof(frame)))

I wondered if it was the cause of the SIGSEGV. Please let me know your
thought on that.

-Longman

