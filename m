Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab3KIGvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:51:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab3KIGvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiaxing Wang <hello.wjx@gmail.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jonghwan Choi <jhbird.choi@gmail.com>
Subject: [PATCH 3.10 70/74] seq_file: always update file->f_pos in seq_lseek()
Date: Fri,  8 Nov 2013 22:52:15 -0800
Message-Id: <20131109065118.388161189@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gu Zheng <guz.fnst@cn.fujitsu.com>

commit 05e16745c0c471bba313961b605b6da3b21a853d upstream.

This issue was first pointed out by Jiaxing Wang several months ago, but no
further comments:
https://lkml.org/lkml/2013/6/29/41

As we know pread() does not change f_pos, so after pread(), file->f_pos
and m->read_pos become different. And seq_lseek() does not update file->f_pos
if offset equals to m->read_pos, so after pread() and seq_lseek()(lseek to
m->read_pos), then a subsequent read may read from a wrong position, the
following program produces the problem:

    char str1[32] = { 0 };
    char str2[32] = { 0 };
    int poffset = 10;
    int count = 20;

    /*open any seq file*/
    int fd = open("/proc/modules", O_RDONLY);

    pread(fd, str1, count, poffset);
    printf("pread:%s\n", str1);

    /*seek to where m->read_pos is*/
    lseek(fd, poffset+count, SEEK_SET);

    /*supposed to read from poffset+count, but this read from position 0*/
    read(fd, str2, count);
    printf("read:%s\n", str2);

out put:
pread:
 ck_netbios_ns 12665
read:
 nf_conntrack_netbios

/proc/modules:
nf_conntrack_netbios_ns 12665 0 - Live 0xffffffffa038b000
nf_conntrack_broadcast 12589 1 nf_conntrack_netbios_ns, Live 0xffffffffa0386000

So we always update file->f_pos to offset in seq_lseek() to fix this issue.

Signed-off-by: Jiaxing Wang <hello.wjx@gmail.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonghwan Choi <jhbird.choi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/seq_file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -328,6 +328,8 @@ loff_t seq_lseek(struct file *file, loff
 				m->read_pos = offset;
 				retval = file->f_pos = offset;
 			}
+		} else {
+			file->f_pos = offset;
 		}
 	}
 	file->f_version = m->version;


