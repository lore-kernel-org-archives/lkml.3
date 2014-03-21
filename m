Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966137AbaCUBAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:00:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965350AbaCUAEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Artem Fetishev <artem_fetishev@epam.com>,
        Aleksandr Terekhov <aleksandr_terekhov@epam.com>,
        wiebittewas@gmail.com, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 098/149] fs/proc/base.c: fix GPF in /proc/$PID/map_files
Date: Thu, 20 Mar 2014 17:04:21 -0700
Message-Id: <20140321000440.355050526@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Fetishev <artem_fetishev@epam.com>

commit 70335abb2689c8cd5df91bf2d95a65649addf50b upstream.

The expected logic of proc_map_files_get_link() is either to return 0
and initialize 'path' or return an error and leave 'path' uninitialized.

By the time dname_to_vma_addr() returns 0 the corresponding vma may have
already be gone.  In this case the path is not initialized but the
return value is still 0.  This results in 'general protection fault'
inside d_path().

Steps to reproduce:

  CONFIG_CHECKPOINT_RESTORE=y

    fd = open(...);
    while (1) {
        mmap(fd, ...);
        munmap(fd, ...);
    }

  ls -la /proc/$PID/map_files

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=68991

Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
Signed-off-by: Aleksandr Terekhov <aleksandr_terekhov@epam.com>
Reported-by: <wiebittewas@gmail.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1819,6 +1819,7 @@ static int proc_map_files_get_link(struc
 	if (rc)
 		goto out_mmput;
 
+	rc = -ENOENT;
 	down_read(&mm->mmap_sem);
 	vma = find_exact_vma(mm, vm_start, vm_end);
 	if (vma && vma->vm_file) {


