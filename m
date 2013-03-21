Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3CUELK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 00:11:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab3CUELJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 00:11:09 -0400
Message-ID: <514A8855.7090402@redhat.com>
Date: Thu, 21 Mar 2013 12:11:01 +0800
From: WANG Chao <chaowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: srostedt@redhat.com, mingo@kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: PROBLEM: 3.9-rc1 - WARNING: at include/linux/ftrace.h:209 ftrace_ops_control_func+0xde/0xf0()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 3.9-rc1, if I run `perf stat -e ftrace:function sleep 1`, a kernel warning 
would happen like below:

root# perf stat -e ftrace:function sleep 1
[   74.339105] WARNING: at include/linux/ftrace.h:209 ftrace_ops_control_func+0xde/0xf0()
[   74.349522] Hardware name: PRIMERGY RX200 S6
[   74.357149] Modules linked in: sg igb iTCO_wdt ptp pps_core iTCO_vendor_support i7core_edac dca lpc_ich i2c_i801 coretemp edac_core crc32c_intel mfd_core ghash_clmulni_intel dm_multipath acpi_power_meter pcspk
r microcode vhost_net tun macvtap macvlan nfsd kvm_intel kvm auth_rpcgss nfs_acl lockd sunrpc uinput xfs libcrc32c sd_mod crc_t10dif sr_mod cdrom mgag200 i2c_algo_bit drm_kms_helper ttm qla2xxx mptsas ahci drm li
bahci scsi_transport_sas mptscsih libata scsi_transport_fc i2c_core mptbase scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[   74.446233] Pid: 1377, comm: perf Tainted: G        W    3.9.0-rc1 #1
[   74.453458] Call Trace:
[   74.456233]  [<ffffffff81062e3f>] warn_slowpath_common+0x7f/0xc0
[   74.462997]  [<ffffffff810fbc60>] ? rcu_note_context_switch+0xa0/0xa0
[   74.470272]  [<ffffffff811041a2>] ? __unregister_ftrace_function+0xa2/0x1a0
[   74.478117]  [<ffffffff81062e9a>] warn_slowpath_null+0x1a/0x20
[   74.484681]  [<ffffffff81102ede>] ftrace_ops_control_func+0xde/0xf0
[   74.491760]  [<ffffffff8162f400>] ftrace_call+0x5/0x2f
[   74.497511]  [<ffffffff8162f400>] ? ftrace_call+0x5/0x2f
[   74.503486]  [<ffffffff8162f400>] ? ftrace_call+0x5/0x2f
[   74.509500]  [<ffffffff810fbc65>] ? synchronize_sched+0x5/0x50
[   74.516088]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
[   74.522268]  [<ffffffff810fbc65>] ? synchronize_sched+0x5/0x50
[   74.528837]  [<ffffffff811041a2>] ? __unregister_ftrace_function+0xa2/0x1a0
[   74.536696]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
[   74.542878]  [<ffffffff8162402d>] ? mutex_lock+0x1d/0x50
[   74.548869]  [<ffffffff81105c67>] unregister_ftrace_function+0x27/0x50
[   74.556243]  [<ffffffff8111eadf>] perf_ftrace_event_register+0x9f/0x140
[   74.563709]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
[   74.569887]  [<ffffffff8162402d>] ? mutex_lock+0x1d/0x50
[   74.575898]  [<ffffffff8111e94e>] perf_trace_destroy+0x2e/0x50
[   74.582505]  [<ffffffff81127ba9>] tp_perf_event_destroy+0x9/0x10
[   74.589298]  [<ffffffff811295d0>] free_event+0x70/0x1a0
[   74.595208]  [<ffffffff8112a579>] perf_event_release_kernel+0x69/0xa0
[   74.602460]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
[   74.608667]  [<ffffffff8112a640>] put_event+0x90/0xc0
[   74.614373]  [<ffffffff8112a740>] perf_release+0x10/0x20
[   74.620367]  [<ffffffff811a3044>] __fput+0xf4/0x280
[   74.625894]  [<ffffffff811a31de>] ____fput+0xe/0x10
[   74.631387]  [<ffffffff81083697>] task_work_run+0xa7/0xe0
[   74.637452]  [<ffffffff81014981>] do_notify_resume+0x71/0xb0
[   74.643843]  [<ffffffff8162fa92>] int_signal+0x12/0x17

 Performance counter stats for 'sleep 1':

             9,325 ftrace:function

       1.004088470 seconds time elapsed
root#

The warning only appears the first time above perf command being triggered. You won't see this until a fresh boot.

3.8 doesn't have this issue. Still exists on 3.9-rc3.

-- 
Thanks,
WANG Chao
