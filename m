Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966Ab3GSFlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:41:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965433Ab3GSF0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zach Bobroff <zacharyb@ami.com>, Matt Fleming <matt.fleming@intel.com>
Subject: [ 27/72] x86, efi: retry ExitBootServices() on failure
Date: Thu, 18 Jul 2013 22:25:44 -0700
Message-Id: <20130719052601.721799876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zach Bobroff <zacharyb@ami.com>

commit d3768d885c6ccbf8a137276843177d76c49033a7 upstream.

ExitBootServices is absolutely supposed to return a failure if any
ExitBootServices event handler changes the memory map.  Basically the
get_map loop should run again if ExitBootServices returns an error the
first time.  I would say it would be fair that if ExitBootServices gives
an error the second time then Linux would be fine in returning control
back to BIOS.

The second change is the following line:

again:
        size += sizeof(*mem_map) * 2;

Originally you were incrementing it by the size of one memory map entry.
The issue here is all related to the low_alloc routine you are using.
In this routine you are making allocations to get the memory map itself.
Doing this allocation or allocations can affect the memory map by more
than one record.

[ mfleming - changelog, code style ]
Signed-off-by: Zach Bobroff <zacharyb@ami.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/eboot.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -992,18 +992,20 @@ static efi_status_t exit_boot(struct boo
 	efi_memory_desc_t *mem_map;
 	efi_status_t status;
 	__u32 desc_version;
+	bool called_exit = false;
 	u8 nr_entries;
 	int i;
 
 	size = sizeof(*mem_map) * 32;
 
 again:
-	size += sizeof(*mem_map);
+	size += sizeof(*mem_map) * 2;
 	_size = size;
 	status = low_alloc(size, 1, (unsigned long *)&mem_map);
 	if (status != EFI_SUCCESS)
 		return status;
 
+get_map:
 	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
 				mem_map, &key, &desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
@@ -1029,8 +1031,20 @@ again:
 	/* Might as well exit boot services now */
 	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
 				handle, key);
-	if (status != EFI_SUCCESS)
-		goto free_mem_map;
+	if (status != EFI_SUCCESS) {
+		/*
+		 * ExitBootServices() will fail if any of the event
+		 * handlers change the memory map. In which case, we
+		 * must be prepared to retry, but only once so that
+		 * we're guaranteed to exit on repeated failures instead
+		 * of spinning forever.
+		 */
+		if (called_exit)
+			goto free_mem_map;
+
+		called_exit = true;
+		goto get_map;
+	}
 
 	/* Historic? */
 	boot_params->alt_mem_k = 32 * 1024;


