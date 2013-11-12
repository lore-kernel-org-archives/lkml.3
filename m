Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3KLSel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:34:41 -0500
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:46980 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753616Ab3KLSei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:34:38 -0500
X-Greylist: delayed 1710 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2013 13:34:38 EST
Message-ID: <52826DF3.5080207@elastichosts.com>
Date: Tue, 12 Nov 2013 18:05:39 +0000
From: Alin Dobre <alin.dobre@elastichosts.com>
Organization: Elastichosts Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Re: unused swap offset / bad page map.
References: <lJQeu-5tO-9@gated-at.bofh.it> <lJQHv-5W5-3@gated-at.bofh.it> <lJQHv-5W5-1@gated-at.bofh.it> <lKVYt-5fo-1@gated-at.bofh.it> <lLakO-6hD-15@gated-at.bofh.it> <lLbqy-7B9-31@gated-at.bofh.it> <lLbTA-824-19@gated-at.bofh.it> <lLd90-1jl-19@gated-at.bofh.it> <lLdsl-1BG-15@gated-at.bofh.it> <lLmYF-4Sc-1@gated-at.bofh.it> <lLujx-5DP-31@gated-at.bofh.it>
In-Reply-To: <lLujx-5DP-31@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/13 17:30, Dave Jones wrote:
> Seems to do the trick.

We are running many virtualization hosts with Linux 3.11.3, qemu 1.6.1 + 
kvm and ksm. The hosts have 128GB RAM, 10GB swap and 24x AMD Opteron 
6238 cores.

Several times few weeks ago, we have seen the OOM killer come to life 
and quickly kill a large number of VMs on a host, even when there 
appears to be free memory on that host at the start of this.

However the OOM killings are preceded by some other traces, similar to 
the ones that were reported by Dave couple of months ago in this very 
thread (https://lkml.org/lkml/2013/8/7/27).

The relevant kernel log lines read:

20:30:44 kernel: swap_free: Unused swap file entry 200000000000200
20:30:44 kernel: BUG: Bad page map in process qemu-system-x86 
pte:00040002 pmd:1ecc0d4067
20:30:44 kernel: addr:00007f5b8b404000 vm_flags:80100073 
anon_vma:ffff880ff0e9df00 mapping:          (null) index:7f5b8b404
20:30:44 kernel: CPU: 9 PID: 22652 Comm: qemu-system-x86 Not tainted 
3.11.2-elastic #2
20:30:44 kernel: Hardware name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS 
2.0b       03/01/2012
20:30:44 kernel: 00007f5b8b404000 ffff8807b76b1ab8 ffffffff817ee7a6 
00000000000400f6
20:30:44 kernel: ffff880ea36a0e60 ffff8807b76b1b08 ffffffff81135ed5 
000000000000000e
20:30:44 kernel: 00000007f5b8b404 ffff8807b76b1b08 00007f5b8b404000 
ffff880ea36a0e60
20:30:44 kernel: Call Trace:
20:30:44 kernel: [<ffffffff817ee7a6>] dump_stack+0x55/0x86
20:30:44 kernel: [<ffffffff81135ed5>] print_bad_pte+0x1f5/0x213
20:30:44 kernel: [<ffffffff811379fd>] unmap_single_vma+0x509/0x6d6
20:30:44 kernel: [<ffffffff81138291>] unmap_vmas+0x4d/0x80
20:30:44 kernel: [<ffffffff8113e615>] exit_mmap+0x93/0x11e
20:30:44 kernel: [<ffffffff810bc2fb>] mmput+0x51/0xdb
20:30:44 kernel: [<ffffffff810c00b1>] do_exit+0x33c/0x8a2
20:30:44 kernel: [<ffffffff810f58ab>] ? get_futex_key+0x87/0x20c
20:30:44 kernel: [<ffffffff810c7215>] ? __dequeue_signal+0x16/0x114
20:30:44 kernel: [<ffffffff810c06af>] do_group_exit+0x6a/0x9d
20:30:44 kernel: [<ffffffff810c956a>] get_signal_to_deliver+0x488/0x4a7
20:30:44 kernel: [<ffffffff81032db9>] do_signal+0x47/0x48f
20:30:44 kernel: [<ffffffff8110dc29>] ? rcu_eqs_enter+0x7d/0x82
20:30:44 kernel: [<ffffffff810e0ff4>] ? account_user_time+0x6a/0x95
20:30:44 kernel: [<ffffffff810e13b6>] ? vtime_account_user+0x5d/0x65
20:30:44 kernel: [<ffffffff81033229>] do_notify_resume+0x28/0x6a
20:30:44 kernel: [<ffffffff817f6358>] int_signal+0x12/0x17
20:30:44 kernel: Disabling lock debugging due to kernel taint
20:30:44 kernel: 33550335 pages RAM
20:30:44 kernel: 561601 pages reserved
20:30:44 kernel: 24628376 pages shared
20:30:44 kernel: 7190750 pages non-shared

Since we are using a 3.11.3 kernel, it already contains Cyrill's fix. 
However, our kernel log is very similar to Dave's report, so we are 
wondering if our mass OOM kill is another problem in the same area?

Any thoughts on this? I can provide more information from the logs, if 
necessary, and my colleague Richard originally reported the mass OOM 
kill in detail at http://article.gmane.org/gmane.linux.kernel.mm/108703.

Cheers,
Alin.
