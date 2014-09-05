Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaIEWQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:16:21 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:57769 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaIEWQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:16:19 -0400
Date: Fri, 5 Sep 2014 23:16:16 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Message-ID: <20140905221616.GP3001@console-pimps.org>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5408D299.5000300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:
> 
> I am fine with this patch, but at the same time I do want to note that
> there is an alternative to double-buffer the patch and/or (if that
> applies to the buggy BIOS) round up the size of the target buffer.

I took a whack at the double-buffer strategy, and I think the patch is
conceptually pretty straight forward.

Could someone try out the following patch? It works around the problem
on my ASUS machine.

---

>From 89e7fdaeb04f79d9834678e486215974986d4ac8 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Fri, 5 Sep 2014 23:15:11 +0100
Subject: [PATCH] x86/efi: Workaround firmware bug with double-buffer read
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
loaded above 4G"), the kernel freezes at the earliest possible moment
when trying to boot via UEFI on Asus laptop.

The cause of the freeze appears to be a firmware bug when reading file
data into buffers above 4GB, though the exact reason is unknown.  Mantas
reports that the hang can be avoided if the file size is a multiple of
512 bytes, but I've seen some ASUS firmware simply corrupting the file
data rather than freezing.

Since the bug has only been reported when reading into a buffer above
4GB, we can workaround the problem by doing a double-buffer read, where
we read a partial file chunk into a buffer < 4GB then copy it to the
buffer (potentially) above 4GB.

Laszlo fixed an issue in the upstream EDK2 DiskIO code in Aug 2013 which
may possibly be related, commit 4e39b75e ("MdeModulePkg/DiskIoDxe: fix
source/destination pointer of overrun transfer"). Whatever the cause,
it's unlikely that a fix will be forthcoming from the vendor, hence the
workaround.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Laszlo Ersek <lersek@redhat.com>
Reported-by: Mantas Mikulėnas <grawity@gmail.com>
Reported-by: Harald Hoyer <harald@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 28 ++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 32d5cca30f49..470793ce2617 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -297,6 +297,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 {
 	struct file_info *files;
 	unsigned long file_addr;
+	unsigned long chunkbuf;
 	u64 file_size_total;
 	efi_file_handle_t *fh = NULL;
 	efi_status_t status;
@@ -416,6 +417,24 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 			goto free_file_total;
 		}
 
+		/*
+		 * Allocate a bounce buffer below 4GB.
+		 *
+		 * Some firmware implementations cannot perform file
+		 * reads into buffers above 4G and at best corrupt the
+		 * buffer, at worst they hang completely.
+		 *
+		 * Pass chunkbuf to the firmware to perform reads in
+		 * chunksize bytes and copy them to the target buffer
+		 * 'file_addr'.
+		 */
+		status = efi_high_alloc(sys_table_arg, EFI_READ_CHUNK_SIZE,
+					0x1000, &chunkbuf, 0xffffffff);
+		if (status != EFI_SUCCESS) {
+			pr_efi_err(sys_table_arg, "Failed to alloc file chunk buffer\n");
+			goto free_chunk;
+		}
+
 		addr = file_addr;
 		for (j = 0; j < nr_files; j++) {
 			unsigned long size;
@@ -430,11 +449,13 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 				status = efi_file_read(files[j].handle,
 						       &chunksize,
-						       (void *)addr);
+						       (void *)chunkbuf);
 				if (status != EFI_SUCCESS) {
 					pr_efi_err(sys_table_arg, "Failed to read file\n");
-					goto free_file_total;
+					goto free_chunk;
 				}
+
+				memcpy((void *)addr, (void *)chunkbuf, chunksize);
 				addr += chunksize;
 				size -= chunksize;
 			}
@@ -442,6 +463,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 			efi_file_close(files[j].handle);
 		}
 
+		efi_free(sys_table_arg, EFI_READ_CHUNK_SIZE, chunkbuf);
 	}
 
 	efi_call_early(free_pool, files);
@@ -451,6 +473,8 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 	return status;
 
+free_chunk:
+	efi_free(sys_table_arg, EFI_READ_CHUNK_SIZE, chunkbuf);
 free_file_total:
 	efi_free(sys_table_arg, file_size_total, file_addr);
 
-- 
1.9.3

-- 
Matt Fleming, Intel Open Source Technology Center
