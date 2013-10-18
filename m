Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab3JRWbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:31:22 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:43881 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab3JRWbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:31:20 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: RE: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs entry
 until, the scan is completed
Thread-Topic: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs
 entry until, the scan is completed
Thread-Index: AQHOxq/e4sZK5DM4RE6BnyVI+JE7Npn5LGGAgAHpKMA=
Date: Fri, 18 Oct 2013 22:30:58 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443F0F2D6@USINDEM103.corp.hds.com>
References: <52584373.3010202@hds.com>
 <20131017131821.GH10834@console-pimps.org>
In-Reply-To: <20131017131821.GH10834@console-pimps.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-18_03:2013-10-18,2013-10-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310180124
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

> It seems to me that because you're no longer dropping __efivars->lock
> when reading from the EFI variable store, you actually don't need all
> the ->scanning and ->deleting logic because anything that sets those
> flags runs to completion while holding the lock.

The scanning and deleting logic is still needed.
In case an entry(A) is found, the pointer is saved to psi->data.
And efi_pstore_read() passes the entry(A) to a pstore filesystem by releasing  __efivars->lock.

And then, the pstore filesystem calls efi_pstore_read() again and the same entry(A), which is saved to
psi->data, is used for re-scanning a sysfs-list.
(That is why list_for_each_entry_safe_from () is used in efi_pstore_sysfs_entry_iter().)

So, to protect the entry(A), the logic is needed because, in pstore filesystem,  __efivars->lock
Is released. 

> Can't the patch be simplified to just allocating data.buf at the
> beginning of efi_pstore_read()? 

I think data.buf is simply allocated at the beginning of efi_pstore_read() with this patch v3.
If you are not satisfied with it, could you please show me your pseudo code?

>Also, it would be a good idea to
> introduce a #define for the 1024 magic number, e.g.
> 
> #define EFIVARS_DATA_SIZE_MAX	1024

It is good idea. I can fix it.

Seiji

<snip>
+/**
+ * efi_pstore_read
+ *
+ * This function returns a size of NVRAM entry logged via efi_pstore_write().
+ * The meaning and behavior of efi_pstore/pstore are as below.
+ *
+ * size > 0: Got data of an entry logged via efi_pstore_write() successfully,
+ *           and pstore filesystem will continue reading subsequent entries.
+ * size == 0: Entry was not logged via efi_pstore_write(),
+ *            and efi_pstore driver will continue reading subsequent entries.
+ * size < 0: Failed to get data of entry logging via efi_pstore_write(),
+ *           and pstore will stop reading entry.
+ */
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			       int *count, struct timespec *timespec,
 			       char **buf, bool *compressed,
 			       struct pstore_info *psi)
 {
 	struct pstore_read_data data;
+	ssize_t size;
 
 	data.id = id;
 	data.type = type;
@@ -112,8 +216,17 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	data.compressed = compressed;
 	data.buf = buf;
 
-	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
-				   (struct efivar_entry **)&psi->data);
+	*data.buf = kzalloc(1024, GFP_KERNEL);
+	if (!*data.buf)
+		return -ENOMEM;
+
+	efivar_entry_iter_begin();
+	size = efi_pstore_sysfs_entry_iter(&data,
+					   (struct efivar_entry **)&psi->data);
+	efivar_entry_iter_end();
+	if (size <= 0)
+		kfree(*data.buf);
+	return size;
 }
<snip>
