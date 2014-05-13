Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaEMP73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:59:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20724 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaEMP7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:59:18 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-ba-537241534355
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org,
        eparis@redhat.com, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, hooanon05g@gmail.com, jmorris@namei.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/2] ima: prevent dead lock when a file is opened for direct io
 (take 3)
Date: Tue, 13 May 2014 18:59:38 +0300
Message-id: <cover.1399996667.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xy7rBjkXBBld/K1jc+ruX2eLL0jqL
	idvbWCzO97WyWaxbv5jJ4uWMeewWl3fNYbP40POIzeL83+OsFp9WTGJ24PLYOesuu8eDQ5tZ
	PHYv+Mzk0fM92eP9vqtsHn1bVjF6fN4k57HpyVumAI4oLpuU1JzMstQifbsEroxbLw8xFXRa
	V6zfepa1gfG9YRcjB4eEgInExskeXYycQKaYxIV769m6GLk4hASWMkq8PrmWDSQhJNDJJLHm
	jQaIzSagJ7Gh+Qc7SJGIwCxGic5t/UwgDrPABEaJB9sbmUCqhAWiJL7uvg/WzSKgKvH98R5G
	EJtXwFLi9NKbzBDr5CROHpvMOoGRewEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkPD6
	soNx8TGrQ4wCHIxKPLwBXAXBQqyJZcWVuYcYJTiYlUR4P+sVBQvxpiRWVqUW5ccXleakFh9i
	ZOLglGpgXJuX7CSeU/d/eprAQ46mPXKsxTf+nGH9ZfNciX+n0Z+EWu55diusthoc2GQy+f5a
	xc+JXzzYentn1tiFfa6emHlSfWqbnl+hstMjveZFYadSzW7Ke+2fZfr6upbVjAaBe2l/MrUy
	5XL/ZPOt6rWvfC7y+5Ek94Iuz3VJKy/kfpxevl/BKua4EktxRqKhFnNRcSIAbY+1+w0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Files are measured or appraised based on the IMA policy.  When a file,
in policy, is opened with the O_DIRECT flag, a deadlock occurs.
Kernel oops can be seen bellow.

ima_process_measurement() takes the i_mutex, before calculating the
hash, appraising the hash against a 'good' known value stored as an
extended attribute, and caching the result, before releasing the
i_mutex.  Holding the i_mutex results in a lockdep with
do_blockdev_direct_IO(), which takes the i_mutex and releases it
for each read.

The first attempt at resolving this lockdep temporarily removed the
O_DIRECT flag and restored it, after calculating the hash.
This resolved the lockdep, but the benefits of using O_DIRECT,
in terms of page cache, were lost.  Al Viro objected to this patch,
because it made the "existing locking rule more convoluted".
(The existing (undocumented) IMA locking rule prohibits ->read() of
regular files from taking the i_mutex. The change would have prohibited
->read() of regular files from taking the i_mutex, unless they were
opened with O_DIRECT.)

The second attempt was to introduce the O_DIRECT_HAVELOCK flag for
file->f_flags, which would tell to do_blockdev_direct_IO() to skip
taking of the i_mutex. This patch did not get any feedback.

This patchset solves O_DIRECT problem with fixing IMA by providing
2 patches.

First patch re-introduce IMA iint->mutex and removes prohibition
of ->read of regular files from taking the i_mutex.

As a problem of i_mutex locking is solved, there is now possibility
for IMA to use direct-io functionality without temporarily removing
O_DIRECT. But that has uncovered that it is impossible to pass
kmalloc or vmalloc allocated buffer to the direct-io code, because
it writes directly to the user-space pages. In order to overcome
this problem, second patch introduces usage of vm_mmap() to allocate
user-space like memory like many drivers do.

Thanks,

Dmitry


-----------------------------------------------------------------------
[   38.221614] =============================================
[   38.222422] [ INFO: possible recursive locking detected ]
[   38.223338] 3.13.0-rc7-kds+ #2124 Not tainted
[   38.223993] ---------------------------------------------
[   38.224027] openclose-direc/2637 is trying to acquire lock:
[   38.224027]  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8116a414>] __blockdev_direct_IO+0x21e/0x2fbd
[   38.224027] 
[   38.224027] but task is already holding lock:
[   38.224027]  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff81290748>] process_measurement+0xb0/0x206
[   38.224027] 
[   38.224027] other info that might help us debug this:
[   38.224027]  Possible unsafe locking scenario:
[   38.224027] 
[   38.224027]        CPU0
[   38.224027]        ----
[   38.224027]   lock(&sb->s_type->i_mutex_key#11);
[   38.224027]   lock(&sb->s_type->i_mutex_key#11);
[   38.224027] 
[   38.224027]  *** DEADLOCK ***
[   38.224027] 
[   38.224027]  May be due to missing lock nesting notation
[   38.224027] 
[   38.224027] 1 lock held by openclose-direc/2637:
[   38.224027]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff81290748>] process_measurement+0xb0/0x206
[   38.224027] 
[   38.224027] stack backtrace:
[   38.224027] CPU: 1 PID: 2637 Comm: openclose-direc Not tainted 3.13.0-rc7-kds+ #2124
[   38.224027] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   38.224027]  0000000000000000 ffff8800363cd4c0 ffffffff814edf5e ffffffff821d7930
[   38.224027]  ffff8800363cd580 ffffffff8107f31e ffffffff8102eb8d ffff8800363cd4e8
[   38.224027]  0000000081008925 ffff880000000000 ffffffff00000000 0000000000000000
[   38.224027] Call Trace:
[   38.224027]  [<ffffffff814edf5e>] dump_stack+0x45/0x56
[   38.224027]  [<ffffffff8107f31e>] __lock_acquire+0x802/0x1984
[   38.224027]  [<ffffffff8102eb8d>] ? kvm_clock_read+0x1f/0x21
[   38.224027]  [<ffffffff8106bf44>] ? sched_clock_cpu+0xc1/0xcc
[   38.224027]  [<ffffffff8102eb8d>] ? kvm_clock_read+0x1f/0x21
[   38.224027]  [<ffffffff81080a14>] lock_acquire+0xac/0x118
[   38.224027]  [<ffffffff8116a414>] ? __blockdev_direct_IO+0x21e/0x2fbd
[   38.224027]  [<ffffffff814f1a3b>] mutex_lock_nested+0x5e/0x354
[   38.224027]  [<ffffffff8116a414>] ? __blockdev_direct_IO+0x21e/0x2fbd
[   38.224027]  [<ffffffff8116a414>] ? __blockdev_direct_IO+0x21e/0x2fbd
[   38.224027]  [<ffffffff81131c0a>] ? kmem_cache_alloc+0x36/0xf8
[   38.224027]  [<ffffffff8116a3bc>] ? __blockdev_direct_IO+0x1c6/0x2fbd
[   38.224027]  [<ffffffff8116a414>] __blockdev_direct_IO+0x21e/0x2fbd
[   38.224027]  [<ffffffff8102eb8d>] ? kvm_clock_read+0x1f/0x21
[   38.224027]  [<ffffffff81008925>] ? sched_clock+0x9/0xd
[   38.224027]  [<ffffffff8106bdbc>] ? sched_clock_local+0x12/0x72
[   38.224027]  [<ffffffff8102eb8d>] ? kvm_clock_read+0x1f/0x21
[   38.224027]  [<ffffffff8102eb8d>] ? kvm_clock_read+0x1f/0x21
[   38.224027]  [<ffffffff8106bdbc>] ? sched_clock_local+0x12/0x72
[   38.224027]  [<ffffffff8106bf44>] ? sched_clock_cpu+0xc1/0xcc
[   38.224027]  [<ffffffff8102eb8d>] ? kvm_clock_read+0x1f/0x21
[   38.224027]  [<ffffffff81008925>] ? sched_clock+0x9/0xd
[   38.224027]  [<ffffffff8106bf44>] ? sched_clock_cpu+0xc1/0xcc
[   38.224027]  [<ffffffff811d53b2>] ext4_ind_direct_IO+0x1fb/0x36a
[   38.224027]  [<ffffffff811a525b>] ? _ext4_get_block+0x160/0x160
[   38.224027]  [<ffffffff811a1f1e>] ext4_direct_IO+0x318/0x3c1
[   38.224027]  [<ffffffff811637cd>] ? __find_get_block+0x1a7/0x1e1
[   38.224027]  [<ffffffff810fe46d>] generic_file_aio_read+0xde/0x61a
[   38.224027]  [<ffffffff8102eb8d>] ? kvm_clock_read+0x1f/0x21
[   38.224027]  [<ffffffff8106bf44>] ? sched_clock_cpu+0xc1/0xcc
[   38.224027]  [<ffffffff81134c56>] do_sync_read+0x59/0x78
[   38.224027]  [<ffffffff81290c75>] ima_kernel_read+0x5f/0x88
[   38.224027]  [<ffffffff81291483>] ima_calc_file_hash+0x1bd/0x229
[   38.224027]  [<ffffffff811573ac>] ? generic_getxattr+0x4f/0x61
[   38.224027]  [<ffffffff81291383>] ? ima_calc_file_hash+0xbd/0x229
[   38.224027]  [<ffffffff812918b2>] ima_collect_measurement+0x8b/0x11e
[   38.224027]  [<ffffffff814f5163>] ? _raw_write_unlock+0x27/0x2a
[   38.224027]  [<ffffffff812907d3>] process_measurement+0x13b/0x206
[   38.224027]  [<ffffffff812909b1>] ima_file_check+0x113/0x11f
[   38.280032]  [<ffffffff8114231b>] do_last+0x937/0xb83
[   38.280032]  [<ffffffff811427ac>] path_openat+0x245/0x633
[   38.280032]  [<ffffffff8102eb8d>] ? kvm_clock_read+0x1f/0x21
[   38.280032]  [<ffffffff81008925>] ? sched_clock+0x9/0xd
[   38.280032]  [<ffffffff81143972>] do_filp_open+0x3a/0x7f
[   38.280032]  [<ffffffff814f4bf4>] ? _raw_spin_unlock+0x27/0x2a
[   38.280032]  [<ffffffff81150a41>] ? __alloc_fd+0x1b7/0x1c9
[   38.280032]  [<ffffffff811348de>] do_sys_open+0x14d/0x1dc
[   38.280032]  [<ffffffff8113498b>] SyS_open+0x1e/0x20
[   38.280032]  [<ffffffff814fcf69>] system_call_fastpath+0x16/0x1b
-----------------------------------------------------------------------

Dmitry Kasatkin (2):
  ima: re-introduce own integrity cache lock
  ima: allocate user-space like memory for direct-io

 security/integrity/iint.c             | 10 ++++++--
 security/integrity/ima/ima_appraise.c | 22 +++++++-----------
 security/integrity/ima/ima_crypto.c   | 44 ++++++++++++++++++++++++++++-------
 security/integrity/ima/ima_main.c     | 27 ++++++++++++---------
 security/integrity/integrity.h        |  5 ++++
 5 files changed, 73 insertions(+), 35 deletions(-)

-- 
1.9.1

