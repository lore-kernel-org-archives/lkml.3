Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3EUWlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:41:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3EUWlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:41:39 -0400
Date: Tue, 21 May 2013 15:41:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec-list (kexec@lists.infradead.org)" <kexec@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: Re: [PATCH]Add kmsg_dump() to kexec path
Message-Id: <20130521154137.0db53981578ee206b21850f9@linux-foundation.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFEF289@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFEF289@USINDEM103.corp.hds.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, can we please get some review attention to this?


From: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Add kmsg_dump() to kexec path

Problem
=======

>From our support service experience, we always need to detect root cause
of OS panic.  And customers in enterprise area never forgive us if we
can't detect the root cause of panic due to lack of materials for
investigation.

Kdump is a powerful troubleshooting feature, but it may accesses to
multiple hardware, like HBA, FC-cable, to get to dump disk.

This means kdump is not robust against hardware failure.

Solution
========

Logging kernel message to persistent device is an effective way to get
materials for investigation in case of kdump failure.

So this patch adds kmsg_dump() to a kexec path.  Also, it adds
KMSG_DUMP_KEXEC to pstore_cannot_block_path() so that it can avoid
deadlocking in kexec path.

Please see the detail of pstore_cannot_block_path(). 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/pstore/platform.c?id=9f244e9cfd70c7c0f82d3c92ce772ab2a92d9f64

Actually, there are some objections about kmsg_dump(KMSG_DUMP_KEXEC) and
EFI below.  But I still think adding kmsg_dump() to a kexec path is
useful.

- http://marc.info/?l=linux-kernel&m=130698519720887&w=2

(1) kdump already saves kernel messages inside /proc/vmcore

  - https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/kernel/kexec.c?id=a3dd3323058d281abd584b15ad4c5b65064d7a61

  It is correct, but the content of /proc/vmcore is stored a dump disk
  as well.  So, if kdump fails due to hardware failures, the kernel
  messages will be lost.

(2) EFI firmware is buggy

  - http://marc.info/?l=linux-kernel&m=130698519720887&w=2

  I haven't seen actual firmware bugs which may cause kdump failure.  So
  I don't think we need to care about it too much.  However, just to be
  safe, I introduced pstore_cannot_block_path() avoid deadlocking to
  pstore.

Also, this patch doesn't affect almost all users because kmsg_dump() is
kicked only when specifying both pstore.backend and
printk.always_kmsg_dump parameters.  Even if a buggy firmware causes a
kdump failure and someone blames kdump, we can ask them to reproduce the
kdump failure by removing the parameters.

In addition, I checked current coding of platform drivers.  There is no
obvious problem as follows.

- mtdoops/ramoops
  They are designed to be kicked in panic and oops cases only.
  So, they never run in a kexec path.

- erst/efi/early_printk_mrst/nvram driver for powerpc
  I don't see any bugs which may causes kdump failure because
  deadlocking/dynamic memory allocation don't happen in their write callbacks.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/platform.c      |    4 ++++
 include/linux/kmsg_dump.h |    1 +
 kernel/kexec.c            |    2 ++
 3 files changed, 7 insertions(+)

diff -puN fs/pstore/platform.c~add-kmsg_dump-to-kexec-path fs/pstore/platform.c
--- a/fs/pstore/platform.c~add-kmsg_dump-to-kexec-path
+++ a/fs/pstore/platform.c
@@ -91,6 +91,8 @@ static const char *get_reason_str(enum k
 		return "Halt";
 	case KMSG_DUMP_POWEROFF:
 		return "Poweroff";
+	case KMSG_DUMP_KEXEC:
+		return "Kexec";
 	default:
 		return "Unknown";
 	}
@@ -110,6 +112,8 @@ bool pstore_cannot_block_path(enum kmsg_
 	case KMSG_DUMP_PANIC:
 	/* Emergency restart shouldn't be blocked by spin lock. */
 	case KMSG_DUMP_EMERG:
+	/* In kexec path, pstore shouldn't be blocked to avoid kexec failure. */
+	case KMSG_DUMP_KEXEC:
 		return true;
 	default:
 		return false;
diff -puN include/linux/kmsg_dump.h~add-kmsg_dump-to-kexec-path include/linux/kmsg_dump.h
--- a/include/linux/kmsg_dump.h~add-kmsg_dump-to-kexec-path
+++ a/include/linux/kmsg_dump.h
@@ -28,6 +28,7 @@ enum kmsg_dump_reason {
 	KMSG_DUMP_RESTART,
 	KMSG_DUMP_HALT,
 	KMSG_DUMP_POWEROFF,
+	KMSG_DUMP_KEXEC,
 };
 
 /**
diff -puN kernel/kexec.c~add-kmsg_dump-to-kexec-path kernel/kexec.c
--- a/kernel/kexec.c~add-kmsg_dump-to-kexec-path
+++ a/kernel/kexec.c
@@ -32,6 +32,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <linux/kmsg_dump.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1089,6 +1090,7 @@ void crash_kexec(struct pt_regs *regs)
 
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
+			kmsg_dump(KMSG_DUMP_KEXEC);
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
_

