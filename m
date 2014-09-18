Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbaIRBva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 21:51:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38997 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbaIRBv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 21:51:28 -0400
Message-ID: <541A3A8D.9010908@oracle.com>
Date: Wed, 17 Sep 2014 21:51:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Ming Lei <ming.lei@canonical.com>, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 2/7] test: add firmware_class loader test
References: <1405373897-31671-1-git-send-email-keescook@chromium.org> <1405373897-31671-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1405373897-31671-3-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 05:38 PM, Kees Cook wrote:
> This provides a simple interface to trigger the firmware_class loader
> to test built-in, filesystem, and user helper modes. Additionally adds
> tests via the new interface to the selftests tree.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Hi folks,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[  413.999779] misc test_firmware: Falling back to user helper
[  414.003728] WARNING: CPU: 25 PID: 9860 at lib/kobject.c:209 kobject_add_internal+0x3a3/0x450()
[  414.006815] kobject: (ffff8807b4ef5dc8): attempted to be registered with empty name!
[  414.009482] Modules linked in:
[  414.010818] CPU: 25 PID: 9860 Comm: trinity-c662 Tainted: G        W      3.17.0-rc5-next-20140917-sasha-00041-gd01267b #1198
[  414.014626]  0000000000000009 ffff880236547a68 ffffffff9d56d655 0000000000000000
[  414.017585]  ffff880236547ab8 ffff880236547aa8 ffffffff9a15f3d1 00000000001e3540
[  414.020733]  ffff8807b4ef5dc8 00000000ffffffea ffff88043d114108 ffff8807b4ef5db8
[  414.023345] Call Trace:
[  414.024254] dump_stack (lib/dump_stack.c:52)
[  414.026232] warn_slowpath_common (kernel/panic.c:432)
[  414.028355] warn_slowpath_fmt (kernel/panic.c:446)
[  414.030366] ? __raw_spin_lock_init (kernel/locking/spinlock_debug.c:24)
[  414.032369] kobject_add_internal (lib/kobject.c:211 (discriminator 1))
[  414.034313] ? __dynamic_pr_debug (lib/dynamic_debug.c:561)
[  414.036254] kobject_add (lib/kobject.c:403)
[  414.038017] ? device_private_init (drivers/base/core.c:929)
[  414.040340] ? klist_init (lib/klist.c:90)
[  414.044729] device_add (drivers/base/core.c:1010)
[  414.049854] ? dev_set_name (drivers/base/core.c:876)
[  414.060790] _request_firmware (drivers/base/firmware_class.c:892 drivers/base/firmware_class.c:957 drivers/base/firmware_class.c:1139)
[  414.062814] request_firmware (drivers/base/firmware_class.c:1189)
[  414.064796] trigger_request_store (lib/test_firmware.c:68)
[  414.066774] dev_attr_store (drivers/base/core.c:138)
[  414.068531] sysfs_kf_write (fs/sysfs/file.c:115)
[  414.070826] kernfs_fop_write (fs/kernfs/file.c:308)
[  414.074648] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:267)
[  414.076864] do_loop_readv_writev (fs/read_write.c:710)
[  414.078947] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:267)
[  414.081269] do_readv_writev (fs/read_write.c:842)
[  414.083281] ? preempt_count_sub (kernel/sched/core.c:2634)
[  414.085380] ? mutex_lock_nested (./arch/x86/include/asm/preempt.h:98 kernel/locking/mutex.c:599 kernel/locking/mutex.c:616)
[  414.087401] ? __fdget_pos (fs/file.c:714)
[  414.089286] vfs_writev (fs/read_write.c:881)
[  414.091243] SyS_writev (fs/read_write.c:914 fs/read_write.c:905)
[  414.093053] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)


Thanks,
Sasha
