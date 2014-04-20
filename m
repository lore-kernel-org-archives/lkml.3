Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaDTM3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 08:29:35 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63701 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaDTM3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 08:29:25 -0400
Date: Sun, 20 Apr 2014 08:29:21 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>,
        linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, davej@redhat.com,
        Tobias Powalowski <tobias.powalowski@googlemail.com>
Subject: [PATCH driver-core-linus] kernfs: add back missing error check in
 kernfs_fop_mmap()
Message-ID: <20140420122921.GA32624@htj.dyndns.org>
References: <533D01BD.1010200@googlemail.com>
 <20140418203825.GK23576@htj.dyndns.org>
 <5352C7BB.8040009@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5352C7BB.8040009@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While updating how mmap enabled kernfs files are handled by lockdep,
9b2db6e18945 ("sysfs: bail early from kernfs_file_mmap() to avoid
spurious lockdep warning") inadvertently dropped error return check
from kernfs_file_mmap().  The intention was just dropping "if
(ops->mmap)" check as the control won't reach the point if the mmap
callback isn't implemented, but I mistakenly removed the error return
check together with it.

This led to Xorg crash on i810 which was reported and bisected to the
commit and then to the specific change by Tobias.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-bisected-by: Tobias Powalowski <tobias.powalowski@googlemail.com>
References: http://lkml.kernel.org/g/533D01BD.1010200@googlemail.com
---
Hello,

Oops, sorry that I didn't see the mistake which seems so obvious now.
Can you please verify that this patch works?

Thanks a lot for the report and bisection!

 fs/kernfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8034706..e01ea4a 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -484,6 +484,8 @@ static int kernfs_fop_mmap(struct file *file, struct vm_area_struct *vma)
 
 	ops = kernfs_ops(of->kn);
 	rc = ops->mmap(of, vma);
+	if (rc)
+		goto out_put;
 
 	/*
 	 * PowerPC's pci_mmap of legacy_mem uses shmem_zero_setup()
