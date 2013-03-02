Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3CEHFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:05:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44555 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3CEHFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:05:51 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v2 10/20] vmcore: read buffers for vmcore objects copied from
 old memory
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 17:36:44 +0900
Message-ID: <20130302083644.31252.31560.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
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
index 09b7f34..c8899dc 100644
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

