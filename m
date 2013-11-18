Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3KRU0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:26:14 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11455 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KRU0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:26:10 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-60-528a77e0e644
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, jmorris@namei.org
Cc: dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/2] ima: directory integrity appraisal
Date: Mon, 18 Nov 2013 22:24:57 +0200
Message-id: <cover.1384806012.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xy7oPyruCDJqWqlnc+ruX2eLL0jqL
	desXM1ns2XuSxeLyrjlsFh96HrFZnP97nNXi04pJzA4cHjtn3WX3eHBoM4tHz/dkj74tqxg9
	Pm+S89j05C1TAFsUl01Kak5mWWqRvl0CV8aNjpiCVrGKHVvesTUw7hHsYuTkkBAwkbi7fikj
	hC0mceHeerYuRi4OIYGljBLT102DcrqZJJoWfmUDqWIT0JPY0PyDHSQhIrCBUeLb3hdg7cwC
	7hIbft5hBrGFBcwl9k28yAJiswioStx79x8szitgKXG3v4sVYp2CxLIva5knMHIvYGRYxSia
	WppcUJyUnmukV5yYW1yal66XnJ+7iRESNl93MC49ZnWIUYCDUYmHd6J7V5AQa2JZcWXuIUYJ
	DmYlEd7fpUAh3pTEyqrUovz4otKc1OJDjEwcnFINjGufq8mdMDK6OmFFLc9sfjPFVb6ub9Su
	31CK1DD/4K9zUl61t9djW07IhB590zlpS7+JmjIc9dyUekCSbeFN0UX/JfgOqDH9z0zg0GXc
	9MXFNza+7ZjTzxfCZXuM92XxOiaffat3bkpYaLSioJHTukkXbVosep8cSVs0kXHZ+4lin1g/
	7aiep8RSnJFoqMVcVJwIAOJvWib5AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset provides extension to IMA to protect appraisal of directories.

Both IMA-appraisal and EVM protect the integrity of regular files.
IMA protects file data integrity, while EVM protects the file meta-data
integrity, such as file attributes and extended attributes. This patch
set adds offline directory integrity protection.

An inode itself does not have any file name associated with it. The
association of the file name to inode is done via directory entries.
On a running system, mandatory and/or discretionary access control prevent
unprivileged file deletion, file name change, or hardlink creation.
In an offline attack, without these protections, the association between
a file name and an inode is unprotected. Files can be deleted, renamed
or moved from one directory to another. In all of these cases,
the integrity of the file data and metadata are good.

To prevent such attacks, it is necessary to protect the integrity of the
directory content.  This patchset calculates a hash of the directory content
and verify this hash against good reference value stored in 'security.ima'
extended attribute. The directory hash is a hash over the list of directory
entries, that includes name, ino, d_type. Initial idea how to calculate the
directory hash was suggested by Jayant Mangalampalli (Intel).

This patchset adds 2 new hooks for directory integrity protection:
ima_dir_check() and ima_dir_update().

ima_dir_check() verifies the directory integrity during the initial path
lookup, when the dentry is just being created and may block. It allocates
the needed data structures and performs the integrity verification.
The results of which are cached. Subsequent calls mostly happen under
RCU locking, when the code may not block, and returns immediately with
the cached verification status. So ima_dir_check() does not interrupt
RCU path walk.

ima_dir_update(), which is called from several places in namei.c when
the directory content is changing, for updating the directory hash.

- Dmitry

Dmitry Kasatkin (2):
  ima: hooks for directory integrity protection
  ima: directory integrity protection implementation

 fs/namei.c                          |  42 ++++-
 fs/open.c                           |   6 +
 include/linux/ima.h                 |  23 +++
 net/unix/af_unix.c                  |   2 +
 security/integrity/ima/Kconfig      |  10 +
 security/integrity/ima/Makefile     |   1 +
 security/integrity/ima/ima.h        |   3 +-
 security/integrity/ima/ima_dir.c    | 358 ++++++++++++++++++++++++++++++++++++
 security/integrity/ima/ima_main.c   |   3 +
 security/integrity/ima/ima_policy.c |   2 +
 10 files changed, 446 insertions(+), 4 deletions(-)
 create mode 100644 security/integrity/ima/ima_dir.c

-- 
1.8.3.2

