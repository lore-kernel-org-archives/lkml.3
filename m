Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3AOVfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:35:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351Ab3AOVe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:34:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, zohar@linux.vnet.ibm.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com,
        vgoyal@redhat.com
Subject: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Date: Tue, 15 Jan 2013 16:34:54 -0500
Message-Id: <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a binary is signed, verify its signature. If signature is not valid, do
not allow execution. If binary is not signed, execution is allowed
unconditionally.

CONFIG_BINFMT_ELF_SIGNATURE controls whether elf binary signature support
is compiled in or not.

Signature are expected to be present in elf section ".section". This code
is written along the lines of module signature verification code. Just
that I have removed the magic string. It is not needed as signature is
expected to be present in a specific section.

I put the signature into a section, instead of appending it so that
strip operation works fine.

One signs and verifies  all the areas mapped by PT_LOAD segments of elf
binary. Typically Elf header is mapped in first PT_LOAD segment. As adding
.signature section can change three elf header fields (e_shoff, e_shnum
and e_shstrndx), these fields are excluded from digest calculation

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/Kconfig.binfmt |    7 +
 fs/binfmt_elf.c   |  455 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 462 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 0efd152..93eb90d 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -23,6 +23,13 @@ config BINFMT_ELF
 	  ld.so (check the file <file:Documentation/Changes> for location and
 	  latest version).
 
+config BINFMT_ELF_SIGNATURE
+	bool "Kernel support for ELF binaries signature verification"
+	depends on BINFMT_ELF && MODULE_SIG
+	default n
+	---help---
+	  ELF binary signature verification support.
+
 config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 0c42cdb..80da13c 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -33,6 +33,10 @@
 #include <linux/elf.h>
 #include <linux/utsname.h>
 #include <linux/coredump.h>
+#include <linux/module.h>
+#include <crypto/public_key.h>
+#include <crypto/hash.h>
+#include <keys/asymmetric-type.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -44,6 +48,27 @@
 #define user_siginfo_t siginfo_t
 #endif
 
+struct elf_sig_info {
+	u8      algo;		/* Public-key crypto algorithm [enum pkey_algo] */
+	u8	hash;		/* Digest algorithm [enum pkey_hash_algo] */
+	u8	id_type;	/* Key identifier type [enum pkey_id_type] */
+	u8	signer_len;	/* Length of signer's name */
+	u8	key_id_len;	/* Length of key identifier */
+	u8	__pad[3];
+	__be32	sig_len;	/* Length of signature data */
+};
+
+struct elf_sig_data {
+	enum pkey_hash_algo hash;
+	char *sig;
+	unsigned int sig_len;
+	struct key *key;
+	struct shash_desc *desc;
+	char *digest;
+	unsigned int digest_sz;
+};
+
+
 static int load_elf_binary(struct linux_binprm *bprm);
 static int load_elf_library(struct file *);
 static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
@@ -558,6 +583,400 @@ static unsigned long randomize_stack_top(unsigned long stack_top)
 #endif
 }
 
+#ifdef CONFIG_BINFMT_ELF_SIGNATURE
+/* Elf Signature Verification related stuff */
+static int esd_shash_init(struct elf_sig_data *esd)
+{
+	struct shash_desc *desc;
+	struct crypto_shash *tfm;
+	size_t digest_size, desc_size;
+	char *digest;
+	int ret;
+
+	tfm = crypto_alloc_shash(pkey_hash_algo[esd->hash], 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		return (ret == -ENOENT ? -ENOPKG : ret);
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto out_free_tfm;
+	}
+
+	digest = kzalloc(digest_size, GFP_KERNEL);
+	if (!digest) {
+		ret = -ENOMEM;
+		goto out_free_desc;
+	}
+
+	desc->tfm   = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto out_free_digest;
+
+	esd->desc = desc;
+	esd->digest = digest;
+	esd->digest_sz = digest_size;
+	return 0;
+
+out_free_digest:
+	kfree(digest);
+out_free_desc:
+	kfree(desc);
+out_free_tfm:
+	crypto_free_shash(tfm);
+	return ret;
+}
+
+static struct elf_sig_data *
+elf_parse_binary_signature(struct elfhdr *ehdr, struct file *file)
+{
+	loff_t rem_file_sz, file_sz;
+	loff_t offset;
+	struct elf_sig_data *esd;
+	struct elf_sig_info *esi;
+	int retval, i;
+	size_t sig_len;
+	struct key *key;
+	struct elf_shdr *elf_shtable, *elf_spnt, *elf_shstrpnt;
+	unsigned int sig_info_sz, shtable_sz;
+	uint16_t shstrndx;
+	bool found_sig_section = false;
+	void *signer_name, *key_id;
+
+	if (!ehdr->e_shnum)
+		return NULL;
+
+	if (ehdr->e_shstrndx == SHN_UNDEF)
+		return NULL;
+
+	/* Read in elf section table */
+	file_sz = i_size_read(file->f_path.dentry->d_inode);
+	shtable_sz = ehdr->e_shnum * sizeof(struct elf_shdr);
+	elf_shtable = kmalloc(shtable_sz, GFP_KERNEL);
+	if (!elf_shtable)
+		return ERR_PTR(-ENOMEM);
+
+	retval = kernel_read(file, ehdr->e_shoff, (char *)elf_shtable,
+					shtable_sz);
+	if (retval != shtable_sz) {
+		if (retval >= 0)
+			retval = -EIO;
+		goto out_free_shtable;
+	}
+
+	if (ehdr->e_shstrndx == 0xffff)
+		shstrndx = elf_shtable[0].sh_link;
+	else
+		shstrndx = ehdr->e_shstrndx;
+
+	if (shstrndx >= ehdr->e_shnum) {
+		retval = -EINVAL;
+		goto out_free_shtable;
+	}
+
+	elf_shstrpnt = elf_shtable + shstrndx;
+	elf_spnt = elf_shtable;
+
+	/* Scan for section with name ".signature" */
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		char sec_name[11];
+		offset = elf_shstrpnt->sh_offset + elf_spnt->sh_name;
+		retval = kernel_read(file, offset, sec_name, 11);
+		if (retval != 11) {
+			if (retval >= 0)
+				retval = -EIO;
+			goto out_free_shtable;
+		}
+
+		if(!strcmp(sec_name, ".signature")) {
+			found_sig_section = true;
+			break;
+		}
+		elf_spnt++;
+	}
+
+	if (!found_sig_section) {
+		/* File is not signed */
+		retval = 0;
+		goto out_free_shtable;
+	}
+
+	esi = kzalloc(sizeof(struct elf_sig_info), GFP_KERNEL);
+	if (!esi) {
+		retval = -ENOMEM;
+		goto out_free_shtable;
+	}
+
+	esd = kzalloc(sizeof(struct elf_sig_data), GFP_KERNEL);
+	if (!esd) {
+		retval = -ENOMEM;
+		goto out_free_esi;
+	}
+
+	/* Read in sig info */
+	sig_info_sz = sizeof(struct elf_sig_info);
+
+	offset = elf_spnt->sh_offset + elf_spnt->sh_size - sig_info_sz;
+	rem_file_sz = file_sz - sig_info_sz;
+	retval = kernel_read(file, offset, (char *)esi, sig_info_sz);
+	if (retval != sig_info_sz) {
+		if (retval >= 0)
+			retval = -EIO;
+		goto out_free_esd;
+	}
+
+	sig_len = be32_to_cpu(esi->sig_len);
+	if (sig_len >= rem_file_sz) {
+		retval = -EBADMSG;
+		goto out_free_esd;
+	}
+	rem_file_sz -= sig_len;
+
+	if ((size_t)esi->signer_len + esi->key_id_len >= rem_file_sz) {
+		retval = -EBADMSG;
+		goto out_free_esd;
+	}
+
+	rem_file_sz -= ((size_t)esi->signer_len + esi->key_id_len);
+
+	/* For the moment, only support RSA and X.509 identifiers */
+	if (esi->algo != PKEY_ALGO_RSA || esi->id_type != PKEY_ID_X509) {
+		retval = -ENOPKG;
+		goto out_free_esd;
+	}
+
+	if (esi->hash >= PKEY_HASH__LAST || !pkey_hash_algo[esi->hash]) {
+		retval = -ENOPKG;
+		goto out_free_esd;
+	}
+
+	esd->hash = esi->hash;
+
+	/* Read in signature */
+	esd->sig = kzalloc(sig_len, GFP_KERNEL);
+	if (!esd->sig) {
+		retval = -ENOMEM;
+		goto out_free_esd;
+	}
+	esd->sig_len = sig_len;
+
+	offset = offset - sig_len;
+	retval = kernel_read(file, offset, esd->sig, sig_len);
+	if (retval != sig_len) {
+		if (retval >= 0)
+			retval = -EIO;
+		goto out_free_esd_sig;
+	}
+
+	/* Read in skid */
+	key_id = kzalloc(esi->key_id_len, GFP_KERNEL);
+	if (!key_id) {
+		retval = -ENOMEM;
+		goto out_free_esd_sig;
+	}
+
+	offset = offset - esi->key_id_len;
+	retval = kernel_read(file, offset, key_id, esi->key_id_len);
+	if (retval != esi->key_id_len) {
+		if (retval >= 0)
+			retval = -EIO;
+		goto out_free_key_id;
+	}
+
+	/* Read in signer_name */
+	signer_name = kzalloc(esi->signer_len, GFP_KERNEL);
+	if (!signer_name) {
+		retval = -ENOMEM;
+		goto out_free_key_id;
+	}
+
+	offset = offset - esi->signer_len;
+	retval = kernel_read(file, offset, signer_name, esi->signer_len);
+	if (retval != esi->signer_len) {
+		if (retval >= 0)
+			retval = -EIO;
+		goto out_free_signer_name;
+	}
+
+	/* search for key */
+	key = request_asymmetric_key(signer_name, esi->signer_len,
+				     key_id, esi->key_id_len);
+	if (IS_ERR(key)) {
+		retval = PTR_ERR(key);
+		goto out_free_signer_name;
+	}
+	esd->key = key;
+
+	retval = esd_shash_init(esd);
+	if (retval < 0)
+		goto out_put_key;
+
+	kfree(elf_shtable);
+	kfree(signer_name);
+	kfree(key_id);
+	kfree(esi);
+	return esd;
+
+out_put_key:
+	key_put(key);
+out_free_signer_name:
+	kfree(signer_name);
+out_free_key_id:
+	kfree(key_id);
+out_free_esd_sig:
+	kfree(esd->sig);
+out_free_esd:
+	kfree(esd);
+out_free_esi:
+	kfree(esi);
+out_free_shtable:
+	kfree(elf_shtable);
+	return ERR_PTR(retval);
+}
+
+static void free_elf_sig_data(struct elf_sig_data *esd)
+{
+	if (!esd)
+		return;
+
+	if (esd->sig)
+		kfree(esd->sig);
+
+	if (esd->key)
+		key_put(esd->key);
+
+	if (esd->desc && esd->desc->tfm)
+		crypto_free_shash(esd->desc->tfm);
+
+	if (esd->desc)
+		kfree(esd->desc);
+
+	if (esd->digest)
+		kfree(esd->digest);
+}
+
+static void elf_digest_first_phdr(struct elfhdr *elfhdr,
+		struct elf_phdr *elf_ppnt, struct elf_sig_data *esd,
+		unsigned long map_addr)
+{
+	unsigned int off_e_shoff = offsetof(struct elfhdr, e_shoff);
+	unsigned int off_e_flags = offsetof(struct elfhdr, e_flags);
+	unsigned int off_e_shnum = offsetof(struct elfhdr, e_shnum);
+
+	/*
+	 * If elf header is mapped in first segment, execlude e_shoff, e_shnum
+	 * and e_shstrndx from digest calculation as this can change when
+	 * signature section is added or executable is stripped after
+	 * signing.
+	 */
+
+	if (!elf_ppnt->p_offset) {
+		/* ELF header is mapped into first PT_LOAD segment */
+		unsigned long sz = off_e_shoff;
+
+		crypto_shash_update(esd->desc, (u8*)map_addr, sz);
+
+		/* Digest e_flags to e_shentsize */
+		sz = off_e_shnum - off_e_flags;
+		crypto_shash_update(esd->desc, (u8*)map_addr + off_e_flags, sz);
+
+		/* Digest rest of the segment */
+		crypto_shash_update(esd->desc, (u8*)map_addr + elfhdr->e_ehsize,
+				elf_ppnt->p_filesz - elfhdr->e_ehsize);
+	} else
+		/* Digest full segment */
+		crypto_shash_update(esd->desc, (u8*)map_addr,
+					elf_ppnt->p_filesz);
+}
+
+static void elf_digest_phdr(struct elfhdr *ehdr, struct elf_phdr *phdr,
+			struct elf_sig_data *esd, unsigned long map_addr,
+			bool first_phdr)
+{
+	/*
+	 * If phdr->p_vaddr is not aligned, then elf_map() will map
+	 * at aligned address. Take that into account
+	 */
+	map_addr = map_addr + ELF_PAGEOFFSET(phdr->p_vaddr);
+
+	if (first_phdr)
+		elf_digest_first_phdr(ehdr, phdr, esd, map_addr);
+	else
+		crypto_shash_update(esd->desc, (u8*)map_addr, phdr->p_filesz);
+}
+
+static int elf_verify_signature(struct elf_sig_data *esd)
+{
+	struct public_key_signature *pks;
+	int retval;
+
+	pks = kzalloc(sizeof(*pks), GFP_KERNEL);
+	if (!pks)
+		return -ENOMEM;
+
+	pks->pkey_hash_algo = esd->hash;
+	pks->digest = (u8*)esd->digest;
+	pks->digest_size = esd->digest_sz;
+
+	retval = mod_extract_mpi_array(pks, esd->sig, esd->sig_len);
+	if (retval < 0)
+		goto error_free_pks;
+
+	retval = verify_signature(esd->key, pks);
+	mpi_free(pks->rsa.s);
+error_free_pks:
+	kfree(pks);
+	return retval;
+}
+
+static int elf_finalize_digest_verify_signature(struct elf_sig_data *esd)
+{
+	int retval;
+
+	retval = crypto_shash_final(esd->desc, (u8*)esd->digest);
+	if (retval < 0)
+		return retval;
+
+	retval = elf_verify_signature(esd);
+	if (retval < 0)
+		return retval;
+
+	return 0;
+}
+
+#else /* CONFIG_BINFMT_ELF_SIGNATURE */
+static inline struct elf_sig_data *
+elf_parse_binary_signature(struct elfhdr *ehdr, struct file *file)
+{
+	return NULL;
+}
+
+static inline void free_elf_sig_data(struct elf_sig_data *esd) {}
+
+static inline void elf_digest_phdr(struct elfhdr *ehdr, struct elf_phdr *phdr,
+			struct elf_sig_data *esd, unsigned long map_addr,
+			bool first_phdr) {}
+
+static inline int elf_verify_signature(struct elf_sig_data *esd)
+{
+	return 0;
+}
+
+static inline int elf_finalize_digest_verify_signature(struct elf_sig_data *esd)
+{
+	return 0;
+}
+
+#endif /* CONFIG_BINFMT_ELF_SIGNATURE */
+
 static int load_elf_binary(struct linux_binprm *bprm)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
@@ -575,6 +994,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	unsigned long reloc_func_desc __maybe_unused = 0;
 	int executable_stack = EXSTACK_DEFAULT;
 	unsigned long def_flags = 0;
+	struct elf_sig_data *esd = NULL;
+	bool first_signed_phdr = true;
 	struct pt_regs *regs = current_pt_regs();
 	struct {
 		struct elfhdr elf_ex;
@@ -741,6 +1162,14 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	
 	current->mm->start_stack = bprm->p;
 
+	esd = elf_parse_binary_signature(&loc->elf_ex, bprm->file);
+	if (IS_ERR(esd)) {
+		retval = PTR_ERR(esd);
+		send_sig(SIGKILL, current, 0);
+		esd = NULL;
+		goto out_free_dentry;
+	}
+
 	/* Now we do a little grungy work by mmapping the ELF image into
 	   the correct location in memory. */
 	for(i = 0, elf_ppnt = elf_phdata;
@@ -788,6 +1217,14 @@ static int load_elf_binary(struct linux_binprm *bprm)
 
 		elf_flags = MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE;
 
+		/*
+		 * mlock the pages of signed binary. We don't want these
+		 * to be swapped out and be potentially modifed, effectively
+		 * bypassing signature verification.
+		 */
+		if (esd)
+			elf_flags = elf_flags | MAP_LOCKED;
+
 		vaddr = elf_ppnt->p_vaddr;
 		if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
 			elf_flags |= MAP_FIXED;
@@ -831,6 +1268,14 @@ static int load_elf_binary(struct linux_binprm *bprm)
 				reloc_func_desc = load_bias;
 			}
 		}
+
+		/* Calculate digest of PT_LOAD segments */
+		if (esd) {
+			elf_digest_phdr(&loc->elf_ex, elf_ppnt, esd, error,
+					first_signed_phdr);
+			first_signed_phdr = false;
+		}
+
 		k = elf_ppnt->p_vaddr;
 		if (k < start_code)
 			start_code = k;
@@ -864,6 +1309,15 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			elf_brk = k;
 	}
 
+	/* Finalize digest and do signature verification */
+	if (esd) {
+		retval = elf_finalize_digest_verify_signature(esd);
+		if (retval < 0) {
+			send_sig(SIGKILL, current, 0);
+			goto out_free_dentry;
+		}
+	}
+
 	loc->elf_ex.e_entry += load_bias;
 	elf_bss += load_bias;
 	elf_brk += load_bias;
@@ -985,6 +1439,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	start_thread(regs, elf_entry, bprm->p);
 	retval = 0;
 out:
+	free_elf_sig_data(esd);
 	kfree(loc);
 out_ret:
 	return retval;
-- 
1.7.7.6

