Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbaIRQ4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:56:44 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46597 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbaIRQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <541A3A8D.9010908@oracle.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
	<1405373897-31671-3-git-send-email-keescook@chromium.org>
	<541A3A8D.9010908@oracle.com>
Date: Thu, 18 Sep 2014 09:56:40 -0700
X-Google-Sender-Auth: QDGO8HkdEAhag3qJObp-KHj6w7c
Message-ID: <CAGXu5j+-PF+VY5+JT6Cf5a9RD3JmxPjUcYeH=FGpMTaSBGF3Sg@mail.gmail.com>
Subject: Re: [PATCH 2/7] test: add firmware_class loader test
From: Kees Cook <keescook@chromium.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 6:51 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 07/14/2014 05:38 PM, Kees Cook wrote:
>> This provides a simple interface to trigger the firmware_class loader
>> to test built-in, filesystem, and user helper modes. Additionally adds
>> tests via the new interface to the selftests tree.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Hi folks,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:
>
> [  413.999779] misc test_firmware: Falling back to user helper

Do you have the log above this? It looks like trinity wrote to
/dev/test_firmware that the test_firmware.ko module creates. I'm
assuming it wrote 0 bytes based on the trace below...

> [  414.003728] WARNING: CPU: 25 PID: 9860 at lib/kobject.c:209 kobject_add_internal+0x3a3/0x450()
> [  414.006815] kobject: (ffff8807b4ef5dc8): attempted to be registered with empty name!
> [  414.009482] Modules linked in:
> [  414.010818] CPU: 25 PID: 9860 Comm: trinity-c662 Tainted: G        W      3.17.0-rc5-next-20140917-sasha-00041-gd01267b #1198
> [  414.014626]  0000000000000009 ffff880236547a68 ffffffff9d56d655 0000000000000000
> [  414.017585]  ffff880236547ab8 ffff880236547aa8 ffffffff9a15f3d1 00000000001e3540
> [  414.020733]  ffff8807b4ef5dc8 00000000ffffffea ffff88043d114108 ffff8807b4ef5db8
> [  414.023345] Call Trace:
> [  414.024254] dump_stack (lib/dump_stack.c:52)
> [  414.026232] warn_slowpath_common (kernel/panic.c:432)
> [  414.028355] warn_slowpath_fmt (kernel/panic.c:446)
> [  414.030366] ? __raw_spin_lock_init (kernel/locking/spinlock_debug.c:24)
> [  414.032369] kobject_add_internal (lib/kobject.c:211 (discriminator 1))
> [  414.034313] ? __dynamic_pr_debug (lib/dynamic_debug.c:561)
> [  414.036254] kobject_add (lib/kobject.c:403)
> [  414.038017] ? device_private_init (drivers/base/core.c:929)
> [  414.040340] ? klist_init (lib/klist.c:90)
> [  414.044729] device_add (drivers/base/core.c:1010)
> [  414.049854] ? dev_set_name (drivers/base/core.c:876)
> [  414.060790] _request_firmware (drivers/base/firmware_class.c:892 drivers/base/firmware_class.c:957 drivers/base/firmware_class.c:1139)

dev_set_name with an empty string should only be possible via an empty
firmware name via the test module interface. I think _request_firmware
should grow a check for !name or name[0] == '\0' in addition to the
!firmware_p check it already does.

Thoughts?

-Kees

> [  414.062814] request_firmware (drivers/base/firmware_class.c:1189)
> [  414.064796] trigger_request_store (lib/test_firmware.c:68)
> [  414.066774] dev_attr_store (drivers/base/core.c:138)
> [  414.068531] sysfs_kf_write (fs/sysfs/file.c:115)
> [  414.070826] kernfs_fop_write (fs/kernfs/file.c:308)
> [  414.074648] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:267)
> [  414.076864] do_loop_readv_writev (fs/read_write.c:710)
> [  414.078947] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:267)
> [  414.081269] do_readv_writev (fs/read_write.c:842)
> [  414.083281] ? preempt_count_sub (kernel/sched/core.c:2634)
> [  414.085380] ? mutex_lock_nested (./arch/x86/include/asm/preempt.h:98 kernel/locking/mutex.c:599 kernel/locking/mutex.c:616)
> [  414.087401] ? __fdget_pos (fs/file.c:714)
> [  414.089286] vfs_writev (fs/read_write.c:881)
> [  414.091243] SyS_writev (fs/read_write.c:914 fs/read_write.c:905)
> [  414.093053] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
>
>
> Thanks,
> Sasha



-- 
Kees Cook
Chrome OS Security
