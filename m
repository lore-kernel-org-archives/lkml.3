Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3JaGgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:36:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab3JaGgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:36:03 -0400
References: <52715D9E.10701@hds.com>
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, tony.luck@intel.com, tomoki.sekiyama@hds.com,
        dle-develop@lists.sourceforge.net, Madper Xie <cxie@redhat.com>
Subject: Re: [PATCH v4] efivars,efi-pstore: Hold off deletion of sysfs entry until the scan is completed
In-reply-to: <52715D9E.10701@hds.com>
Date: Thu, 31 Oct 2013 14:35:39 +0800
Message-ID: <87a9hq6j7o.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


seiji.aguchi@hds.com writes:

> Change from v3:
> - Introduce EFI_VARS_DATA_SIZE_MAX macro.
> - Add some description why a scanning/deleting logic is needed.
>
> Currently, when mounting pstore file system, a read callback of efi_pstore
> driver runs mutiple times as below.
>
> - In the first read callback, scan efivar_sysfs_list from head and pass
>   a kmsg buffer of a entry to an upper pstore layer.
> - In the second read callback, rescan efivar_sysfs_list from the entry and pass
>   another kmsg buffer to it.
> - Repeat the scan and pass until the end of efivar_sysfs_list.
>
> In this process, an entry is read across the multiple read function calls.
> To avoid race between the read and erasion, the whole process above is
> protected by a spinlock, holding in open() and releasing in close().
>
> At the same time, kmemdup() is called to pass the buffer to pstore filesystem
> during it.
> And then, it causes a following lockdep warning.
>
> To make the dynamic memory allocation runnable without taking spinlock,
> holding off a deletion of sysfs entry if it happens while scanning it
> via efi_pstore, and deleting it after the scan is completed.
>
> To implement it, this patch introduces two flags, scanning and deleting,
> to efivar_entry.
>
> On the code basis, it seems that all the scanning and deleting logic is not
> needed because __efivars->lock are not dropped when reading from the EFI
> variable store.
>
> But, the scanning and deleting logic is still needed because an efi-pstore and
> a pstore filesystem works as follows.
>
> In case an entry(A) is found, the pointer is saved to psi->data.
> And efi_pstore_read() passes the entry(A) to a pstore filesystem by
> releasing  __efivars->lock.
>
> And then, the pstore filesystem calls efi_pstore_read() again and the same
> entry(A), which is saved to psi->data, is used for resuming to scan
> a sysfs-list.
>
> So, to protect the entry(A), the logic is needed.
>
> [    1.143710] ------------[ cut here ]------------
> [    1.144058] WARNING: CPU: 1 PID: 1 at kernel/lockdep.c:2740
> lockdep_trace_alloc+0x104/0x110()
> [    1.144058] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
> [    1.144058] Modules linked in:
>
> [    1.144058] CPU: 1 PID: 1 Comm: systemd Not tainted 3.11.0-rc5 #2
> [    1.144058]  0000000000000009 ffff8800797e9ae0 ffffffff816614a5
> ffff8800797e9b28
> [    1.144058]  ffff8800797e9b18 ffffffff8105510d 0000000000000080
> 0000000000000046
> [    1.144058]  00000000000000d0 00000000000003af ffffffff81ccd0c0
> ffff8800797e9b78
> [    1.144058] Call Trace:
> [    1.144058]  [<ffffffff816614a5>] dump_stack+0x54/0x74
> [    1.144058]  [<ffffffff8105510d>] warn_slowpath_common+0x7d/0xa0
> [    1.144058]  [<ffffffff8105517c>] warn_slowpath_fmt+0x4c/0x50
> [    1.144058]  [<ffffffff8131290f>] ? vsscanf+0x57f/0x7b0
> [    1.144058]  [<ffffffff810bbd74>] lockdep_trace_alloc+0x104/0x110
> [    1.144058]  [<ffffffff81192da0>] __kmalloc_track_caller+0x50/0x280
> [    1.144058]  [<ffffffff815147bb>] ?
> efi_pstore_read_func.part.1+0x12b/0x170
> [    1.144058]  [<ffffffff8115b260>] kmemdup+0x20/0x50
> [    1.144058]  [<ffffffff815147bb>] efi_pstore_read_func.part.1+0x12b/0x170
> [    1.144058]  [<ffffffff81514800>] ?
> efi_pstore_read_func.part.1+0x170/0x170
> [    1.144058]  [<ffffffff815148b4>] efi_pstore_read_func+0xb4/0xe0
> [    1.144058]  [<ffffffff81512b7b>] __efivar_entry_iter+0xfb/0x120
> [    1.144058]  [<ffffffff8151428f>] efi_pstore_read+0x3f/0x50
> [    1.144058]  [<ffffffff8128d7ba>] pstore_get_records+0x9a/0x150
> [    1.158207]  [<ffffffff812af25c>] ? selinux_d_instantiate+0x1c/0x20
> [    1.158207]  [<ffffffff8128ce30>] ? parse_options+0x80/0x80
> [    1.158207]  [<ffffffff8128ced5>] pstore_fill_super+0xa5/0xc0
> [    1.158207]  [<ffffffff811ae7d2>] mount_single+0xa2/0xd0
> [    1.158207]  [<ffffffff8128ccf8>] pstore_mount+0x18/0x20
> [    1.158207]  [<ffffffff811ae8b9>] mount_fs+0x39/0x1b0
> [    1.158207]  [<ffffffff81160550>] ? __alloc_percpu+0x10/0x20
> [    1.158207]  [<ffffffff811c9493>] vfs_kern_mount+0x63/0xf0
> [    1.158207]  [<ffffffff811cbb0e>] do_mount+0x23e/0xa20
> [    1.158207]  [<ffffffff8115b51b>] ? strndup_user+0x4b/0xf0
> [    1.158207]  [<ffffffff811cc373>] SyS_mount+0x83/0xc0
> [    1.158207]  [<ffffffff81673cc2>] system_call_fastpath+0x16/0x1b
> [    1.158207] ---[ end trace 61981bc62de9f6f4 ]---
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

After applied this patch, I can't see the warning again when I mounting
pstore fs and deleting pstore entries. 

Tested-by: Madper Xie <cxie@redhat.com>
> ---
>  drivers/firmware/efi/efi-pstore.c | 143 +++++++++++++++++++++++++++++++++++---
>  drivers/firmware/efi/efivars.c    |  12 ++--
>  drivers/firmware/efi/vars.c       |  12 +++-
>  include/linux/efi.h               |   4 ++
>  4 files changed, 155 insertions(+), 16 deletions(-)
>

-- 
Best,
Madper Xie.
