Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaHTOtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:49:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20331 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbaHTOtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:49:32 -0400
Message-ID: <53F4B555.7060403@fb.com>
Date: Wed, 20 Aug 2014 10:48:53 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <miaox@cn.fujitsu.com>, <dsterba@suse.cz>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, <lkp@01.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Abhay Sachan <lkp.abhay@gmail.com>
Subject: [PATCH] Btrfs: fix filemap_flush call in btrfs_file_release
References: <20140816075233.GA26842@localhost> <20140819115820.GA21418@localhost> <20140819142348.GU1553@twin.jikos.cz> <53F36601.5020609@fb.com> <53F47E07.3080807@cn.fujitsu.com>
In-Reply-To: <53F47E07.3080807@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-20_05:2014-08-20,2014-08-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=6.49436060484732e-12 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.533125042697551
 urlsuspect_oldscore=0.533125042697551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.533125042697551 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408200152
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We should only be flushing on close if the file was flagged as needing
it during truncate.  I broke this with my ordered data vs transaction
commit deadlock fix.

Thanks to Miao Xie for catching this.

Signed-off-by: Chris Mason <clm@fb.com>
Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f15c13f..36861b7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1840,7 +1840,15 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 {
 	if (filp->private_data)
 		btrfs_ioctl_trans_end(filp);
-	filemap_flush(inode->i_mapping);
+	/*
+	 * ordered_data_close is set by settattr when we are about to truncate
+	 * a file from a non-zero size to a zero size.  This tries to
+	 * flush down new bytes that may have been written if the
+	 * application were using truncate to replace a file in place.
+	 */
+	if (test_and_clear_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
+			       &BTRFS_I(inode)->runtime_flags))
+			filemap_flush(inode->i_mapping);
 	return 0;
 }
 
