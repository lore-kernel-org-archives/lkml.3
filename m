Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab3D2VZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:25:58 -0400
Received: from relay3.sgi.com ([192.48.152.1]:43104 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758581Ab3D2VZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:25:57 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/proc: smaps should avoid VM_PFNMAP areas
Cc: akpm@linux-foundation.org, mgorman@suse.de, paul.mundt@nokia.com,
        dhowells@redhat.com, aarcange@redhat.com, hughd@google.com,
        gorcunov@openvz.org, kamezawa.hiroyuki@gmail.com,
        n-horiguchi@ah.jp.nec.com, eag0628@gmail.com, khlebnikov@openvz.org,
        sasha.levin@oracle.com, siddhesh.poyarekar@gmail.com,
        rientjes@google.com, kirill.shutemov@linux.intel.com,
        viro@ZenIV.linux.org.uk, amwang@redhat.com
Message-Id: <E1UWva5-0005fY-Km@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 29 Apr 2013 16:25:53 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


/proc/<pid>/smaps should not be looking at VM_PFNMAP areas.

Certain tests in show_smap() (especially for huge pages) assume that the
mapped PFN's are backed with page structures.  And this is not usually true
for VM_PFNMAP areas.  This can result in panics on kernel page faults when
attempting to address those page structures.

VM_PFNMAP areas are used by
- graphics memory manager   gpu/drm/drm_gem.c
- global reference unit     sgi-gru/grufile.c
- sgi special memory        char/mspec.c
- probably several out-of-tree modules

I'm copying everyone who has changed fs/proc/task_mmu.c recently, in case
of some reason to provide /proc/<pid>/smaps for these areas that I am not
aware of.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 fs/proc/task_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/fs/proc/task_mmu.c
===================================================================
--- linux.orig/fs/proc/task_mmu.c
+++ linux/fs/proc/task_mmu.c
@@ -589,6 +589,9 @@ static int show_smap(struct seq_file *m,
 		.private = &mss,
 	};
 
+	if (vma->vm_flags & VM_PFNMAP)
+		return 0;
+
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
 	/* mmap_sem is held in m_start */
