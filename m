Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaBXTXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:23:53 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:8440 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753144AbaBXTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:23:51 -0500
Message-ID: <1393269828.27792.5.camel@ultrabook>
Subject: [PATCH 0/1] hfsplus: fix longname handling
From: Sougata Santra <sougata@tuxera.com>
Reply-To: <sougata@tuxera.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Perches <joe@perches.com>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        Christoph Hellwig <hch@lst.de>, Sougata Santra <sougata@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 21:23:48 +0200
Organization: Tuxera
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [89.166.4.239]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Longname is not correctly handled by hfsplus driver. If an attempt to
create a longname(>255) file/directory is made, it succeeds by creating
a file/directory with HFSPLUS_MAX_STRLEN and incorrect catalog key.
Thus leaving the volume in an inconsistent state. This patch fixes
this issue.

Although lookup is always called first to create a negative entry, so just
doing a check in lookup would probably fix this issue. I choose to propagate
error to other iops as well.

Please NOTE: I have factored out hfsplus_cat_build_key_with_cnid from 
hfsplus_cat_build_key, to avoid unncessary branching.

Thanks a lot.

TEST:
------
dir="TEST_DIR"
cdir=`pwd`
name255="_123456789_123456789_123456789_123456789_123456789_123456789\
_123456789_123456789_123456789_123456789_123456789_123456789_123456789\
_123456789_123456789_123456789_123456789_123456789_123456789_123456789\
_123456789_123456789_123456789_123456789_123456789_1234"
name256="${name255}5"

mkdir $dir
cd $dir
touch $name255
rm -f $name255
touch $name256
ls -la
cd $cdir
rm -rf $dir


RESULT:
-------
[sougata@ultrabook tmp]$ cdir=`pwd`
[sougata@ultrabook tmp]$ 
name255="_123456789_123456789_123456789_123456789_123456789_123456789\
 > _123456789_123456789_123456789_123456789_123456789_123456789_123456789\
 > _123456789_123456789_123456789_123456789_123456789_123456789_123456789\
 > _123456789_123456789_123456789_123456789_123456789_1234"
[sougata@ultrabook tmp]$ name256="${name255}5"
[sougata@ultrabook tmp]$
[sougata@ultrabook tmp]$ mkdir $dir
[sougata@ultrabook tmp]$ cd $dir
[sougata@ultrabook TEST_DIR]$ touch $name255
[sougata@ultrabook TEST_DIR]$ rm -f $name255
[sougata@ultrabook TEST_DIR]$ touch $name256
[sougata@ultrabook TEST_DIR]$ ls -la
ls: cannot access 
_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_1234:
No such file or directory
total 0
drwxrwxr-x 1 sougata sougata 3 Feb 20 19:56 .
drwxrwxrwx 1 root    root    6 Feb 20 19:56 ..
-????????? ? ?       ?       ?            ? 
_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_1234
[sougata@ultrabook TEST_DIR]$ cd $cdir
[sougata@ultrabook tmp]$ rm -rf $dir
rm: cannot remove ‘TEST_DIR’: Directory not empty


Sougata Santra (1):
  hfsplus: fix longname handling

 fs/hfsplus/catalog.c    | 89 ++++++++++++++++++++++++++++++++++++-------------
 fs/hfsplus/dir.c        | 11 ++++--
 fs/hfsplus/hfsplus_fs.h |  4 ++-
 fs/hfsplus/super.c      |  4 ++-
 4 files changed, 79 insertions(+), 29 deletions(-)

-- 
1.8.5.3



