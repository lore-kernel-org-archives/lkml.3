Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaGBWQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:16:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaGBWQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:16:02 -0400
Message-ID: <1404339330.1862.69.camel@ul30vt.home>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
From: Alex Williamson <alex.williamson@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 02 Jul 2014 16:15:30 -0600
In-Reply-To: <20140628174609.930049472@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
	 <20140628174609.930049472@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-28 at 10:47 -0700, Greg Kroah-Hartman wrote:
> 3.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sagi Grimberg <sagig@mellanox.com>
> 
> commit d77e65350f2d82dfa0557707d505711f5a43c8fd upstream.
> 
> In case protection information exists over the wire
> iscsi header data length is required to include it.
> Use protection information aware scsi helpers to set
> the correct transfer length.
> 
> In order to avoid breakage, remove iser transfer length
> checks for each task as they are not always true and
> somewhat redundant anyway.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> Acked-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/infiniband/ulp/iser/iser_initiator.c |   34 +++++++--------------------
>  drivers/scsi/libiscsi.c                      |   18 +++++++-------
>  2 files changed, 19 insertions(+), 33 deletions(-)

I'm a bit late to object, but this is causing a regression for me on
3.15.3 and 3.16-rc.  Using an iscsi_tcp rootfs, I'm seeing the NULL
pointer dereference below.  Reverting this patch resolves it.  Thanks,

Alex

[   19.672549] BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
[   19.680405] IP: [<ffffffffa0019d38>] iscsi_tcp_segment_done+0x2a8/0x370 [libiscsi_tcp]
[   19.688338] PGD 0 
[   19.690365] Oops: 0000 [#1] SMP 
[   19.693624] Modules linked in: cfg80211 snd_hda_codec_analog snd_hda_codec_generic nfsd auth_rpcgss nfs_acl lockd sunrpc snd_hda_intel snd_hda_controller coretemp snd_hda_codec kvm_intel kvm snd_hwdep snd_seq i7core_edac ioatdma snd_seq_device lpc_ich edac_core snd_pcm serio_raw snd_timer shpchp tpm_tis pcspkr i2c_i801 snd mfd_core microcode tpm soundcore acpi_cpufreq nouveau video mxm_wmi drm_kms_helper igb tg3 ttm dca drm i2c_algo_bit ptp crc32c_intel pps_core i2c_core wmi iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
[   19.741125] CPU: 3 PID: 98 Comm: kworker/u16:5 Tainted: G          I   3.15.3 #23
[   19.748602] Hardware name: LENOVO 4157CTO/LENOVO, BIOS 60KT41AUS 01/04/2011
[   19.755558] Workqueue: iscsi_q_6 iscsi_xmitworker [libiscsi]
[   19.761231] task: ffff8801e5cb0890 ti: ffff8801e5cc8000 task.ti: ffff8801e5cc8000
[   19.768702] RIP: 0010:[<ffffffffa0019d38>]  [<ffffffffa0019d38>] iscsi_tcp_segment_done+0x2a8/0x370 [libiscsi_tcp]
[   19.779060] RSP: 0018:ffff8801e5ccbc48  EFLAGS: 00010206
[   19.784365] RAX: 0000000000000000 RBX: ffff8801e5d9dec0 RCX: 0000000000000200
[   19.791490] RDX: 0000000000000e00 RSI: 0000000000000000 RDI: ffff8801e5d9dec0
[   19.798615] RBP: ffff8801e5ccbca8 R08: 0000000000000200 R09: 0000000000016640
[   19.805747] R10: ffff8801e3d48120 R11: 00000000000005a8 R12: 0000000000000200
[   19.812872] R13: ffff8801e5d9dd30 R14: 0000000000000000 R15: ffff8801e5d9dec0
[   19.819997] FS:  0000000000000000(0000) GS:ffff88037fcc0000(0000) knlGS:0000000000000000
[   19.828075] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   19.833812] CR2: 000000000000000c CR3: 0000000001c11000 CR4: 00000000000007e0
[   19.840938] Stack:
[   19.842947]  ffff8801e3d48000 ffff88036dde5400 ffff8801e5d9deb0 ffff8801e5ccbce8
[   19.850402]  ffff8801e5d9dec0 ffff8801e5ccbca8 00000000ef5a5f2a 0000000000000200
[   19.857856]  ffff8801e5d9dd30 ffff8801e5d9deb0 ffff8801e5ccbce8 ffff8801e5d9dec0
[   19.865310] Call Trace:
[   19.867760]  [<ffffffffa003456e>] iscsi_sw_tcp_pdu_xmit+0xde/0x2d0 [iscsi_tcp]
[   19.874979]  [<ffffffffa001952a>] iscsi_tcp_task_xmit+0xaa/0x2a0 [libiscsi_tcp]
[   19.882285]  [<ffffffff810ac2be>] ? dequeue_task_fair+0x42e/0x640
[   19.888379]  [<ffffffffa0025763>] iscsi_xmit_task+0x53/0xc0 [libiscsi]
[   19.894906]  [<ffffffffa00281e0>] iscsi_xmitworker+0x260/0x2f0 [libiscsi]
[   19.901691]  [<ffffffff8108d465>] process_one_work+0x175/0x430
[   19.907522]  [<ffffffff8108e0db>] worker_thread+0x11b/0x3a0
[   19.913096]  [<ffffffff8108dfc0>] ? rescuer_thread+0x390/0x390
[   19.918931]  [<ffffffff81094af1>] kthread+0xe1/0x100
[   19.923896]  [<ffffffff81094a10>] ? insert_kthread_work+0x40/0x40
[   19.929991]  [<ffffffff816a6cbc>] ret_from_fork+0x7c/0xb0
[   19.935389]  [<ffffffff81094a10>] ? insert_kthread_work+0x40/0x40
[   19.941481] Code: b8 00 00 e9 25 fe ff ff 0f 1f 00 48 8b 7b 30 e8 7f 9e 31 e1 8b 53 10 2b 53 14 44 89 f6 48 89 43 30 c7 43 40 00 00 00 00 48 89 df <8b> 40 0c 48 c7 03 00 00 00 00 39 c2 0f 47 d0 89 53 08 e8 41 fc 
[   19.961432] RIP  [<ffffffffa0019d38>] iscsi_tcp_segment_done+0x2a8/0x370 [libiscsi_tcp]
[   19.969451]  RSP <ffff8801e5ccbc48>
[   19.972935] CR2: 000000000000000c
[   19.976247] ---[ end trace f418fccfb3747914 ]---

