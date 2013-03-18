Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3CRIkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:40:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35300 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab3CRIkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:40:19 -0400
Message-ID: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
Subject: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 18 Mar 2013 08:40:14 +0000
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <JBottomley@Parallels.com>

The object here is to make the NV+BS variables accessible (at least read only)
at runtime so we can get a full picture of the state of the EFI variables for
debugging and secure boot purposes.

The way this is done is to get the efi stub to pull all the NV+BS
(i.e. variables without the RT flag) out into setup_data records which can
then be read back in at runtime.  the EFI calls get_next_variable() and
get_variable() are modified to run through these setup records when the real
calls fail.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---

This same mechanism should work for all architectures, but the method of
transferring information from boot to runtime differs, so it can't be
done generically

James

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index c205035..6bbbb2e 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -251,6 +251,85 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 	*size = len;
 }
 
+static efi_status_t setup_efi_bootvars(struct boot_params *params)
+{
+	const int len = 1024;
+	efi_char16_t *str;
+	efi_status_t status;
+	struct setup_data **data = (struct setup_data **)&params->hdr.setup_data;
+
+	status = efi_call_phys3(sys_table->boottime->allocate_pool,
+				EFI_LOADER_DATA, len, &str);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	/*
+	 * Note: this trick only works on Little Endian if hdr.setup_data
+	 * is u64 on both 64 and 32 bit
+	 */
+	while (*data)
+		data = (struct setup_data **)&(*data)->next;
+
+	memset(str, 0, len);
+
+	for (;;) {
+		unsigned long size = len, str_len;
+		efi_guid_t guid;
+		struct efi_setup_bootvars *bvs;
+		unsigned int attributes;
+
+		status = efi_call_phys3(sys_table->runtime->get_next_variable,
+					&size, str, &guid);
+		if (status != EFI_SUCCESS)
+			break;
+
+		str_len = size;
+		size = 0;
+		status = efi_call_phys5(sys_table->runtime->get_variable,
+					str, &guid, &attributes, &size, NULL);
+		if (status != EFI_SUCCESS && status != EFI_BUFFER_TOO_SMALL)
+			break;
+
+
+		/*
+		 * Please don't be tempted to optimise here: some
+		 * UEFI implementations fail to set attributes if
+		 * they return any error (including EFI_BUFFER_TOO_SMALL)
+		 */
+		status = efi_call_phys3(sys_table->boottime->allocate_pool,
+					EFI_LOADER_DATA,
+					size + sizeof(*bvs) + str_len,
+					&bvs);
+		if (status != EFI_SUCCESS)
+			continue;
+		memset(bvs, 0 , sizeof(bvs));
+		status = efi_call_phys5(sys_table->runtime->get_variable,
+					str, &guid, &attributes,
+					&size, bvs->data);
+
+		if (status != EFI_SUCCESS
+		    || (attributes & 0x07) != (EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					       EFI_VARIABLE_NON_VOLATILE)) {
+			efi_call_phys1(sys_table->boottime->free_pool, bvs);
+			continue;
+		}
+		memcpy(bvs->data + size, str, str_len);
+		bvs->name_size = str_len;
+		bvs->s_d.type = SETUP_EFIVAR;
+		bvs->s_d.len = size + sizeof(*bvs) + str_len;
+		bvs->guid = guid;
+		bvs->size = size;
+		bvs->attributes = attributes;
+		*data = (struct setup_data *)bvs;
+		data = (struct setup_data **)&(*data)->next;
+	}
+	*data = NULL;
+	status = EFI_SUCCESS;
+ out:
+	efi_call_phys1(sys_table->boottime->free_pool, str);
+	return status;
+}
+
 static efi_status_t setup_efi_pci(struct boot_params *params)
 {
 	efi_pci_io_protocol *pci;
@@ -1159,6 +1238,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 
 	setup_efi_pci(boot_params);
 
+	setup_efi_bootvars(boot_params);
+
 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
 				EFI_LOADER_DATA, sizeof(*gdt),
 				(void **)&gdt);
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 60c89f3..2dadecd 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -122,4 +122,13 @@ static inline bool efi_is_native(void)
 #define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
 #endif /* CONFIG_EFI */
 
+struct efi_setup_bootvars {
+	struct setup_data s_d;
+	unsigned int attributes;
+	efi_guid_t guid;
+	unsigned long name_size;
+	unsigned long size;	/* size of the variable data (name follows) */
+	unsigned char data[0];
+};
+
 #endif /* _ASM_X86_EFI_H */
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index c15ddaf..e864d23 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -6,6 +6,7 @@
 #define SETUP_E820_EXT			1
 #define SETUP_DTB			2
 #define SETUP_PCI			3
+#define SETUP_EFIVAR			4
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index fff986d..931060a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -153,17 +153,103 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 					  unsigned long *data_size,
 					  void *data)
 {
-	return efi_call_virt5(get_variable,
-			      name, vendor, attr,
-			      data_size, data);
+	efi_status_t status = efi_call_virt5(get_variable,
+					     name, vendor, attr,
+					     data_size, data);
+	u64 pa_data;
+	struct setup_data *s_d;
+
+	if (status != EFI_NOT_FOUND)
+		return status;
+
+
+	for (pa_data = boot_params.hdr.setup_data; pa_data;
+	     pa_data = s_d->next) {
+		struct efi_setup_bootvars *bvs;
+		efi_char16_t *bvs_name;
+		int i = 0;
+
+		s_d = phys_to_virt(pa_data);
+
+		if (s_d->type != SETUP_EFIVAR)
+			continue;
+
+		bvs = (struct efi_setup_bootvars *)s_d;
+		bvs_name = (efi_char16_t *)(bvs->data + bvs->size);
+
+		for (i = 0; bvs_name[i] != 0 && name[i] != 0; i++)
+			if (bvs_name[i] != name[i])
+				break;
+
+		if (bvs_name[i] != 0 || name[i] != 0)
+			continue;
+
+		if (memcmp(&bvs->guid, vendor, sizeof(*vendor)) != 0)
+			continue;
+
+		if (attr)
+			*attr = bvs->attributes;
+
+		if (*data_size < bvs->size) {
+			*data_size = bvs->size;
+			return EFI_BUFFER_TOO_SMALL;
+		}
+		*data_size = bvs->size;
+		memcpy(data, bvs->data, bvs->size);
+
+		return EFI_SUCCESS;
+	}
+	return EFI_NOT_FOUND;
 }
 
 static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	return efi_call_virt3(get_next_variable,
-			      name_size, name, vendor);
+	static int use_bootvars = 0;
+	efi_status_t status;
+	u64 pa_data = boot_params.hdr.setup_data;
+	int found = 0;
+	struct setup_data *data;
+
+	if (!use_bootvars) {
+		status = efi_call_virt3(get_next_variable,
+					name_size, name, vendor);
+		if (status == EFI_NOT_FOUND)
+			use_bootvars = 1;
+		else
+			return status;
+	}
+
+	for (pa_data = boot_params.hdr.setup_data; pa_data;
+	     pa_data = data->next) {
+		struct efi_setup_bootvars *bvs;
+		efi_char16_t *bvs_name;
+
+		data = phys_to_virt(pa_data);
+
+		if (data->type != SETUP_EFIVAR)
+			continue;
+
+		bvs = (struct efi_setup_bootvars *)data;
+		bvs_name = (efi_char16_t *)(bvs->data + bvs->size);
+
+		if (use_bootvars != 1 && !found) {
+			unsigned long size = min(bvs->name_size, *name_size);
+
+			if (memcmp(bvs_name, name, size) == 0)
+				found = 1;
+		} else {
+			memcpy(name, bvs_name, bvs->name_size);
+			*name_size = bvs->name_size;
+			*vendor = bvs->guid;
+			use_bootvars = 2;
+			return EFI_SUCCESS;
+		}
+	}
+	use_bootvars = 0;
+
+	return EFI_NOT_FOUND;
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,


