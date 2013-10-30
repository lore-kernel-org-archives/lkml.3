Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3J3OAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:00:18 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59912 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3J3OAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:00:08 -0400
Message-ID: <52711121.9030606@linux.vnet.ibm.com>
Date: Wed, 30 Oct 2013 19:31:05 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com> <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com> <52700C24.9050001@linux.vnet.ibm.com> <CA+55aFzqumDX8hRyC4avbpA2g_RRb28ZPYk=_-4atGJ=67Zu1A@mail.gmail.com>
In-Reply-To: <CA+55aFzqumDX8hRyC4avbpA2g_RRb28ZPYk=_-4atGJ=67Zu1A@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010006010408080105000901"
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103014-8878-0000-0000-0000097D66EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010006010408080105000901
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/2013 01:03 AM, Linus Torvalds wrote:
> On Tue, Oct 29, 2013 at 12:27 PM, Raghavendra K T
> <raghavendra.kt@linux.vnet.ibm.com> wrote:
>>
>> Could one solution be cascading actual error
>> that is lost in fs/debugfs/inode.c:__create_file(), so that we could
>> take correct action in case of failure of debugfs_create_dir()?
>>
>> (ugly side is we increase total number of params for __create_file to
>> 6). or I hope there could be some better solution.
>
> The solution to this would be to simply return an error-pointer. See
> <linux/err.h>. That's what we do for most complex subsystems that
> return a pointer to a struct: rather than returning "NULL" as an
> error, return the actual error number encoded in the pointer itself.

Thank you Linus. Yes, this would have been ideal.

>
> But that would require every user of debugfs_create_dir() to be
> updated to check errors using IS_ERR() instead of checking against
> NULL, and there's quite a few of them.
>
> So I think just making the error be EEXIST is a simpler solution right now.
>

Agree.
I had below patch, and just before sending as formal mail I saw
Paolo's pull request which already took care of it.
---8<---



--------------010006010408080105000901
Content-Type: text/x-patch;
 name="0001-Return-EEXIST-on-debugfs_create_dir-failure-in-kvm.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Return-EEXIST-on-debugfs_create_dir-failure-in-kvm.patc";
 filename*1="h"

>From ac5d9f038c273f27bea7a54aab6af79b57f56317 Mon Sep 17 00:00:00 2001
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Date: Wed, 30 Oct 2013 18:59:46 +0530
Subject: [PATCH] Return EEXIST on debugfs_create_dir failure in kvm

As quoted by Linus,  EFAULT means "user passed in an invalid
virtual address pointer", which is why the error string is Bad address.
But when a debugfs directory creation fails, the above error is not valid.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 I understand that Tim's patch that renames directory to something like
 kvm-pv would solve kvm-amd/kvm-intel modules insertion problem. 
 This patch is to address error code  change complained by Linus.

 arch/x86/kernel/kvm.c | 2 +-
 virt/kvm/kvm_main.c   | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a0e2a8a..e475fdb 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -622,7 +622,7 @@ static int __init kvm_spinlock_debugfs(void)
 
 	d_kvm = kvm_init_debugfs();
 	if (d_kvm == NULL)
-		return -ENOMEM;
+		return -EEXIST;
 
 	d_spin_debug = debugfs_create_dir("spinlocks", d_kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a9dd682..0430853 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3091,13 +3091,14 @@ static const struct file_operations *stat_fops[] = {
 
 static int kvm_init_debug(void)
 {
-	int r = -EFAULT;
+	int r = -EEXIST;
 	struct kvm_stats_debugfs_item *p;
 
 	kvm_debugfs_dir = debugfs_create_dir("kvm", NULL);
 	if (kvm_debugfs_dir == NULL)
 		goto out;
 
+	r = -EFAULT;
 	for (p = debugfs_entries; p->name; ++p) {
 		p->dentry = debugfs_create_file(p->name, 0444, kvm_debugfs_dir,
 						(void *)(long)p->offset,
-- 
1.7.11.7


--------------010006010408080105000901--

