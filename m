Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3KZGva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:51:30 -0500
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:34943 "EHLO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3KZGv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:51:28 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Nov 2013 01:51:27 EST
From: Patrick Farrell <paf@cray.com>
To: Peng Tao <bergwolf@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cheng Shao <cheng_shao@xyratex.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: RE: [PATCH 03/16] staging/lustre/nfs: writing to new files will
 return ENOENT
Thread-Topic: [PATCH 03/16] staging/lustre/nfs: writing to new files will
 return ENOENT
Thread-Index: AQHO6kwJQpYosj08KUyMoLCP4bFXF5o3ESgv
Date: Tue, 26 Nov 2013 06:45:57 +0000
Message-ID: <DB0C8A206669AC40B1C4E52A8584A6F614549D77@CFWEX01.americas.cray.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>,<1385431510-18988-4-git-send-email-bergwolf@gmail.com>
In-Reply-To: <1385431510-18988-4-git-send-email-bergwolf@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.234.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peng,

I'm sorry to say, this patch was reverted due to interoperability problems with 2.1 servers (This either a slightly later [but still broken] version of the patch we discussed recently, or the same one.).  If Greg's accepted this upstream (and it looks like he has), it'll have to be reverted.

Sorry for the trouble here!

- Patrick
________________________________________
From: Peng Tao [bergwolf@gmail.com]
Sent: Monday, November 25, 2013 8:04 PM
To: Greg Kroah-Hartman
Cc: linux-kernel@vger.kernel.org; Patrick Farrell; Cheng Shao; Peng Tao; Andreas Dilger
Subject: [PATCH 03/16] staging/lustre/nfs: writing to new files will return ENOENT

From: Patrick Farrell <paf@cray.com>

This happend with SLES11SP2 Lustre client, which in turn acts as an
NFS server, exporting a subtree of an Lustre fs through NFS.

We detected that whenever we are writing to a new file using, fx,
'echo blah > newfile', it will return ENOENT error. We found
out that this was caused by the anonymous dentry. In SLESS11SP2,
anonymous dentries are assigned '/' as the name, instead of an
empty string. When MDT handles the intent_open call, it will look
up the obj by the name if it is not an empty string, and thus
couldn't find it.

As MDS_OPEN_BY_FID is always set on this request, we never need
to send the name in this request.  The fid is already available
and should be used in case the file has been renamed.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3544
Lustre-change: http://review.whamcloud.com/6920
Signed-off-by: Cheng Shao <cheng_shao@xyratex.com>
Signed-off-by: Patrick Farrell <paf@cray.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Alexey Shvetsov <alexxy@gentoo.org>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 82248e9..f36c5d8 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -368,8 +368,6 @@ static int ll_intent_file_open(struct file *file, void *lmm,
 {
        struct ll_sb_info *sbi = ll_i2sbi(file->f_dentry->d_inode);
        struct dentry *parent = file->f_dentry->d_parent;
-       const char *name = file->f_dentry->d_name.name;
-       const int len = file->f_dentry->d_name.len;
        struct md_op_data *op_data;
        struct ptlrpc_request *req;
        __u32 opc = LUSTRE_OPC_ANY;
@@ -394,8 +392,9 @@ static int ll_intent_file_open(struct file *file, void *lmm,
        }

        op_data  = ll_prep_md_op_data(NULL, parent->d_inode,
-                                     file->f_dentry->d_inode, name, len,
+                                     file->f_dentry->d_inode, NULL, 0,
                                      O_RDWR, opc, NULL);
+
        if (IS_ERR(op_data))
                return PTR_ERR(op_data);

--
1.7.9.5

