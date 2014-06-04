Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbaFEAwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:52:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaFDXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:20:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Tobias Powalowski <tobias.powalowski@googlemail.com>
Subject: [PATCH 3.14 012/228] kernfs: add back missing error check in kernfs_fop_mmap()
Date: Wed,  4 Jun 2014 16:20:41 -0700
Message-Id: <20140604232348.488712437@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit b44b2140265ddfde03acbe809336111d31adb0d1 upstream.

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
Tested-by: Tobias Powalowski <tobias.powalowski@googlemail.com>
References: http://lkml.kernel.org/g/533D01BD.1010200@googlemail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/kernfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -476,6 +476,8 @@ static int kernfs_fop_mmap(struct file *
 
 	ops = kernfs_ops(of->kn);
 	rc = ops->mmap(of, vma);
+	if (rc)
+		goto out_put;
 
 	/*
 	 * PowerPC's pci_mmap of legacy_mem uses shmem_zero_setup()


