Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820Ab3CSCeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:34:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46247 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933578Ab3CSCbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:31:01 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 11/21] vmcore: read buffers for vmcore objects copied from
 old memory
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:01:49 +0900
Message-ID: <20130316040149.15064.6738.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If flag MEM_TYPE_CURRENT_KERNEL is set, the object is copied in the
buffer on the 2nd kernel, then read_vmcore() reads the buffer. If the
flag is not set, read_vmcore() reads old memory as usual.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 7e21d64..b252d17 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -158,10 +158,17 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 			tsz = m->offset + m->size - *fpos;
 			if (buflen < tsz)
 				tsz = buflen;
-			start = m->paddr + *fpos - m->offset;
-			tmp = read_from_oldmem(buffer, tsz, &start, 1);
-			if (tmp < 0)
-				return tmp;
+			if (m->flag & MEM_TYPE_CURRENT_KERNEL) {
+				if (copy_to_user(buffer,
+						 m->buf + *fpos - m->offset,
+						 tsz))
+					return -EFAULT;
+			} else {
+				start = m->paddr + *fpos - m->offset;
+				tmp = read_from_oldmem(buffer, tsz, &start, 1);
+				if (tmp < 0)
+					return tmp;
+			}
 			buflen -= tsz;
 			*fpos += tsz;
 			buffer += tsz;

