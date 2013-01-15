Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab3AOWjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:39:22 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41477 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab3AOWjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:39:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        konrad@kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH 2/2] ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled
Date: Tue, 15 Jan 2013 23:45:08 +0100
Message-ID: <6440043.2WKgQ0tYWV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358288604-24620-3-git-send-email-konrad.wilk@oracle.com>
References: <1358288604-24620-1-git-send-email-konrad.wilk@oracle.com> <1358288604-24620-3-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 15, 2013 05:23:24 PM Konrad Rzeszutek Wilk wrote:
> If cpuidle is disabled, that means the:
> 
> 	per_cpu(acpi_cpuidle_device, pr->id)
> 
> is set to NULL as the acpi_processor_power_init ends up failing at
> 
> 	 retval = cpuidle_register_driver(&acpi_idle_driver)
> 
> (in acpi_processor_power_init) and never sets the per_cpu idle
> device. So when acpi_processor_hotplug on CPU online notification tries
> to reference said device it crashes:
> 
> cpu 3 spinlock event irq 62
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> IP: [<ffffffff81381013>] acpi_processor_setup_cpuidle_cx+0x3f/0x105
> PGD a259b067 PUD ab38b067 PMD 0
> Oops: 0002 [#1] SMP
> odules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c nouveau mxm_wmi wmi radeon ttm sg sr_mod sd_mod cdrom ata_generic ata_piix libata crc32c_intel scsi_mod atl1c i915 fbcon tileblit font bitblit softcursor drm_kms_helper video xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xenfs xen_privcmd mperf
> CPU 1
> Pid: 3047, comm: bash Not tainted 3.8.0-rc3upstream-00250-g165c029 #1 MSI MS-7680/H61M-P23 (MS-7680)
> RIP: e030:[<ffffffff81381013>]  [<ffffffff81381013>] acpi_processor_setup_cpuidle_cx+0x3f/0x105
> RSP: e02b:ffff88001742dca8  EFLAGS: 00010202
> RAX: 0000000000010be9 RBX: ffff8800a0a61800 RCX: ffff880105380000
> RDX: 0000000000000003 RSI: 0000000000000200 RDI: ffff8800a0a61800
> RBP: ffff88001742dce8 R08: ffffffff81812360 R09: 0000000000000200
> R10: aaaaaaaaaaaaaaaa R11: 0000000000000001 R12: ffff8800a0a61800
> R13: 00000000ffffff01 R14: 0000000000000000 R15: ffffffff81a907a0
> FS:  00007fd6942f7700(0000) GS:ffff880105280000(0000) knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000004 CR3: 00000000a6773000 CR4: 0000000000042660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bash (pid: 3047, threadinfo ffff88001742c000, task ffff880017944000)
> Stack:
>  0000000000000150 ffff880100f59e00 ffff88001742dcd8 ffff8800a0a61800
>  0000000000000000 00000000ffffff01 0000000000000000 ffffffff81a907a0
>  ffff88001742dd18 ffffffff813815b1 ffff88001742dd08 ffffffff810ae336
> Call Trace:
>  [<ffffffff813815b1>] acpi_processor_hotplug+0x7c/0x9f
>  [<ffffffff810ae336>] ? schedule_delayed_work_on+0x16/0x20
>  [<ffffffff8137ee8f>] acpi_cpu_soft_notify+0x90/0xca
>  [<ffffffff8166023d>] notifier_call_chain+0x4d/0x70
>  [<ffffffff810bc369>] __raw_notifier_call_chain+0x9/0x10
>  [<ffffffff81094a4b>] __cpu_notify+0x1b/0x30
>  [<ffffffff81652cf7>] _cpu_up+0x103/0x14b
>  [<ffffffff81652e18>] cpu_up+0xd9/0xec
>  [<ffffffff8164a254>] store_online+0x94/0xd0
>  [<ffffffff814122fb>] dev_attr_store+0x1b/0x20
>  [<ffffffff81216404>] sysfs_write_file+0xf4/0x170
> 
> This patch fixes it.

This appears to be -stable material too.  Which -stable kernels should it
be applied to?

Rafael


> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/acpi/processor_idle.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index f1a5da4..fea6f8d 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -958,6 +958,9 @@ static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr)
>  		return -EINVAL;
>  	}
>  
> +	if (!dev)
> +		return -EINVAL;
> +
>  	dev->cpu = pr->id;
>  
>  	if (max_cstate == 0)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
