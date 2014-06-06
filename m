Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaFFC7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 22:59:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:43015 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751694AbaFFC7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 22:59:16 -0400
Date: Thu, 5 Jun 2014 22:59:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch 1/2] rtmutex: Handle deadlock detection smarter
Message-ID: <20140605225914.13b8b714@gandalf.local.home>
In-Reply-To: <20140605152801.836501969@linutronix.de>
References: <20140605152544.641846795@linutronix.de>
	<20140605152801.836501969@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014 15:28:32 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Index: tip/kernel/locking/rtmutex.h
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.h
> +++ tip/kernel/locking/rtmutex.h
> @@ -21,6 +21,10 @@
>  #define debug_rt_mutex_unlock(l)			do { } while (0)
>  #define debug_rt_mutex_init(m, n)			do { } while (0)
>  #define debug_rt_mutex_deadlock(d, a ,l)		do { } while (0)
> -#define debug_rt_mutex_print_deadlock(w)		do { } while (0)
>  #define debug_rt_mutex_detect_deadlock(w,d)		(d)
>  #define debug_rt_mutex_reset_waiter(w)			do { } while (0)
> +
> +static inline void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
> +{
> +	WARN(1, "rtmutex deadlock detected\n");
> +}
> 

The above is called directly in rt_mutex_start_proxy_lock(), and as it
doesn't have a conditional where the DEBUG_RT_MUTEXES version does, I
get a ton of these:

[   27.192428] WARNING: CPU: 1 PID: 1013 at /home/rostedt/work/git/linux-rt.git/kernel/locking/rtmutex.h:29 rt_mutex_start_proxy_lock+0x89/0xc0()
[   27.205212] rtmutex deadlock detected
[   27.208901] Modules linked in: lockd bnep bluetooth nf_conntrack_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv4 nf_defrag_ipv6 xt_state ip6table_filter nf_conntrack ip6_table
s snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm x86_pkg_temp_thermal hp_wmi
 tpm_infineon snd_timer rfkill i2c_i801 lpc_ich coretemp sparse_keymap wmi mfd_core tpm_tis tpm snd soundcore serio_raw microcode pcspkr uinput i915 i2c_algo_bit e1000e drm_kms_hel
per ptp crc32c_intel drm pps_core i2c_core video sunrpc
[   27.262062] CPU: 1 PID: 1013 Comm: threaded-ml Tainted: G        W     3.15.0-rc8-test+ #292
[   27.270531] Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v02.05 05/07/2012
[   27.279504]  000000000000001d ffff8800c7bc3c48 ffffffff816884fd ffff88011ea4ef68
[   27.287008]  ffff8800c7bc3c98 ffff8800c7bc3c88 ffffffff8106f28c ffff8800c7bc3c78
[   27.294519]  ffff8800c795a8b0 0000000000000000 ffff8800c890bd40 ffffc9000476e7f0
[   27.302018] Call Trace:
[   27.304491]  [<ffffffff816884fd>] dump_stack+0x4f/0x7c
[   27.309643]  [<ffffffff8106f28c>] warn_slowpath_common+0x8c/0xc0
[   27.315678]  [<ffffffff8106f376>] warn_slowpath_fmt+0x46/0x50
[   27.321461]  [<ffffffff810b9259>] rt_mutex_start_proxy_lock+0x89/0xc0
[   27.327921]  [<ffffffff810e0ad7>] futex_requeue+0x507/0x840
[   27.333504]  [<ffffffff810e1576>] do_futex+0x2e6/0xb80
[   27.338660]  [<ffffffff8118317a>] ? unmap_region+0xea/0x110
[   27.344257]  [<ffffffff8109f0f1>] ? get_parent_ip+0x11/0x50
[   27.349876]  [<ffffffff8169374d>] ? preempt_count_add+0x5d/0xb0
[   27.355816]  [<ffffffff8109f0f1>] ? get_parent_ip+0x11/0x50
[   27.361404]  [<ffffffff81338633>] ? __this_cpu_preempt_check+0x13/0x20
[   27.367947]  [<ffffffff81344093>] ? __percpu_counter_add+0x93/0xd0
[   27.374161]  [<ffffffff810e1f52>] SyS_futex+0x142/0x1a0
[   27.379403]  [<ffffffff81101fa0>] ? __audit_syscall_exit+0x200/0x280
[   27.385776]  [<ffffffff81697cd2>] system_call_fastpath+0x16/0x1b
[   27.391797] ---[ end trace 438aec68793ded61 ]---
[   27.396483] ------------[ cut here ]------------


-- Steve
