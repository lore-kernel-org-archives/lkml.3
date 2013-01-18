Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3ARCxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 21:53:20 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:53010 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3ARCxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 21:53:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130117143839.GJ15956@shiny>
References: <20130117143839.GJ15956@shiny>
Date: Thu, 17 Jan 2013 18:53:18 -0800
X-Google-Sender-Auth: Ho-ZAjC2fO4cLxfJLMDgRm3QWL8
Message-ID: <CAA9_cmerHyZnrXD6vgXNXPsvoaCj9+70kg_6nYH9iJEPckOWTA@mail.gmail.com>
Subject: Re: dma engine bugs
From: Dan Williams <djbw@fb.com>
To: Chris Mason <chris.mason@fusionio.com>, Dan Williams <djbw@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 6:38 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> [ Sorry resend with the right address for Dan ]
>
> Hi Dan,
>
> I'm doing some benchmarking on MD raid5/6 on 4 fusionio cards in an HP
> DL380p.  I'm doing 128K randomw writes on a 4 drive raid6 with a 64K
> stripe size per drive.  I have 4 fio processes sending down the aio/dio,
> and a high queue depth (8192).
>
> When I bump up the MD raid stripe cache size, I'm running into
> soft lockups in the async memcopy code:
>
> [34336.959645] BUG: soft lockup - CPU#6 stuck for 22s! [fio:38296]
> [34336.959648] BUG: soft lockup - CPU#9 stuck for 22s! [md0_raid6:5172]
> [34336.959704] Modules linked in: raid456 async_raid6_recov async_pq
> async_xor async_memcpy async_tx iomemory_vsl(O) binfmt_misc
> cpufreq_conservative cpufreq_userspace cpufreq_powersave pcc_cpufreq
> mperf loop dm_mod coretemp kvm_intel kvm ghash_clmulni_intel sr_mod
> cdrom aesni_intel ablk_helper cryptd lrw aes_x86_64 ata_generic xts
> gf128mul ioatdma sb_edac gpio_ich ata_piix hid_generic dca edac_core
> lpc_ich microcode serio_raw mfd_core hpilo hpwdt button container tg3 sg
> acpi_power_meter usbhid mgag200 ttm drm_kms_helper drm i2c_algo_bit
> sysimgblt sysfillrect syscopyarea uhci_hcd crc32c_intel ehci_hcd hpsa
> processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc
> scsi_dh_alua scsi_dh btrfs raid6_pq zlib_deflate xor libcrc32c asix
> usbnet usbcore usb_common
>
> [34336.959709] CPU 9
> [34336.959709] Pid: 5172, comm: md0_raid6 Tainted: G        W  O 3.7.1-1-default #2 HP ProLiant DL380p Gen8
> [34336.959720] RIP: 0010:[<ffffffff815381ad>]  [<ffffffff815381ad>] _raw_spin_unlock_irqrestore+0xd/0x20
> [34336.959721] RSP: 0018:ffff8807af6db858  EFLAGS: 00000292
> [34336.959722] RAX: 0000000000001000 RBX: ffff8810176fd000 RCX: 0000000000000292
> [34336.959723] RDX: 0000000000001000 RSI: 0000000000000292 RDI: 0000000000000292
> [34336.959724] RBP: ffff8807af6db858 R08: ffff881017e40440 R09: ffff880f554fabc0
> [34336.959725] R10: 0000000000002000 R11: 0000000000000000 R12: ffff881017e40460
> [34336.959726] R13: 0000000000000040 R14: 0000000000000001 R15: ffff881017e40480
> [34336.959728] FS:  0000000000000000(0000) GS:ffff88103f660000(0000) knlGS:0000000000000000
> [34336.959729] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [34336.959730] CR2: 00000000035cf458 CR3: 0000000001a0b000 CR4: 00000000000407e0
> [34336.959731] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [34336.959733] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [34336.959734] Process md0_raid6 (pid: 5172, threadinfo ffff8807af6da000, task ffff88077d7725c0)
> [34336.959735] Stack:
> [34336.959738]  ffff8807af6db898 ffffffff8114f287 ffff8807af6db8b8 0000000000000000
> [34336.959740]  0000000000000000 00000000005bd84a ffff881015f2fa18 ffff881017632a38
> [34336.959742]  ffff8807af6db8e8 ffffffffa057adf4 0000000000000000 ffff881015f2fa18
> [34336.959743] Call Trace:
> [34336.959750]  [<ffffffff8114f287>] dma_pool_alloc+0x67/0x270
> [34336.959758]  [<ffffffffa057adf4>] ioat2_alloc_ring_ent+0x34/0xc0 [ioatdma]
> [34336.959761]  [<ffffffffa057afc5>] reshape_ring+0x145/0x370 [ioatdma]
> [34336.959764]  [<ffffffff8153841d>] ? _raw_spin_lock_bh+0x2d/0x40
> [34336.959767]  [<ffffffffa057b2d9>] ioat2_check_space_lock+0xe9/0x240 [ioatdma]
> [34336.959768]  [<ffffffff81538381>] ? _raw_spin_unlock_bh+0x11/0x20
> [34336.959771]  [<ffffffffa057b48c>] ioat2_dma_prep_memcpy_lock+0x5c/0x280 [ioatdma]
> [34336.959773]  [<ffffffffa03102df>] ? do_async_gen_syndrome+0x29f/0x3d0 [async_pq]
> [34336.959775]  [<ffffffff81538381>] ? _raw_spin_unlock_bh+0x11/0x20
> [34336.959790]  [<ffffffffa057ac22>] ? ioat2_tx_submit_unlock+0x92/0x100 [ioatdma]
> [34336.959792]  [<ffffffffa02f8207>] async_memcpy+0x207/0x1000 [async_memcpy]
> [34336.959795]  [<ffffffffa031f67d>] async_copy_data+0x9d/0x150 [raid456]
> [34336.959797]  [<ffffffffa03206ba>] __raid_run_ops+0x4ca/0x990 [raid456]
> [34336.959802]  [<ffffffff811b7c42>] ? __aio_put_req+0x102/0x150
> [34336.959805]  [<ffffffffa031c7ae>] ?  handle_stripe_dirtying+0x30e/0x440 [raid456]
> [34336.959807]  [<ffffffffa03217a8>] handle_stripe+0x528/0x10b0 [raid456]
> [34336.959810]  [<ffffffffa03226f0>] handle_active_stripes+0x1e0/0x270 [raid456]
> [34336.959814]  [<ffffffff81293bb3>] ? blk_flush_plug_list+0xb3/0x220
> [34336.959817]  [<ffffffffa03229a0>] raid5d+0x220/0x3c0 [raid456]
> [34336.959822]  [<ffffffff81413b0e>] md_thread+0x12e/0x160
> [34336.959828]  [<ffffffff8106bfa0>] ? wake_up_bit+0x40/0x40
> [34336.959829]  [<ffffffff814139e0>] ? md_rdev_init+0x110/0x110
> [34336.959831]  [<ffffffff8106b806>] kthread+0xc6/0xd0
> [34336.959834]  [<ffffffff8106b740>] ?  kthread_freezable_should_stop+0x70/0x70
> [34336.959849]  [<ffffffff8154047c>] ret_from_fork+0x7c/0xb0
> [34336.959851]  [<ffffffff8106b740>] ?  kthread_freezable_should_stop+0x70/0x70
>
> Since I'm running on fast cards, I assumed MD was just hammering on this
> path so much that MD needed a cond_resched().  But now that I've
> sprinkled conditional pixie dust everywhere I'm still seeing exactly the
> same trace, and the lockups keep flowing forever, even after I've
> stopped all new IO.
>
> Looking at ioat2_check_space_lock(), it is looping when the ring
> allocation fails.  We're trying to grow our ring with atomic allocations
> and not giving up the CPU?
>
> I'm not sure what the right answer is for a patch.  If it is safe for
> the callers we could add the cond_resched() but still we might fail to
> grow the ring.

We're already doing a cond_resched() once per-stripe batch so that
should be sufficient.

>
> Would it be better to fallback to synchronous operations if we can't get
> into the ring?

Falling back is supposed to be the default in the memcpy path.  We try
to expand the ring and retry the slot allocation if the ring gets
bigger, otherwise fail the allocation and do it synchronously.  Is it
always the async_memcpy path, does async_gen_syndrome get in on the
action?  I will take a closer look at the code tonight.

--
Dan
