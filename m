Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaATVW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:22:26 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34295 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaATVWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:22:22 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: libunwind-devel <libunwind-devel@nongnu.org>
Cc: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 2/3] Dwarf: load and parse the debug info of different target address sizes
Date: Mon, 20 Jan 2014 22:22:01 +0100
Message-Id: <1390252922-25889-3-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
References: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When in compat mode, load and parse the dwarf debug info accordingly.

Tested dwarf local unwinding on ARMv8 (aka AARCH64) with ARMv7 and
ARMv8 binaries.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 src/dwarf/Gfde.c                |  25 ++++--
 src/dwarf/Gfind_proc_info-lsb.c | 194 +++++++++++++++++++++++++++++++---------
 2 files changed, 170 insertions(+), 49 deletions(-)

diff --git a/src/dwarf/Gfde.c b/src/dwarf/Gfde.c
index 8659624..81959d1 100644
--- a/src/dwarf/Gfde.c
+++ b/src/dwarf/Gfde.c
@@ -59,14 +59,23 @@ parse_cie (unw_addr_space_t as, unw_accessors_t *a, unw_word_t addr,
   /* Pick appropriate default for FDE-encoding.  DWARF spec says
      start-IP (initial_location) and the code-size (address_range) are
      "address-unit sized constants".  The `R' augmentation can be used
-     to override this, but by default, we pick an address-sized unit
-     for fde_encoding.  */
-  switch (dwarf_addr_size (as))
-    {
-    case 4:	fde_encoding = DW_EH_PE_udata4; break;
-    case 8:	fde_encoding = DW_EH_PE_udata8; break;
-    default:	fde_encoding = DW_EH_PE_omit; break;
-    }
+     to override this, but by default, we pick the target binary address
+     size unit for fde_encoding.  */
+  switch (as->target_addr_size)
+  {
+  /* If defined at binary load time (e.g. from the ELF format) */
+  case TARGET_ADDR_SIZE_32:	fde_encoding = DW_EH_PE_udata4; break;
+  case TARGET_ADDR_SIZE_64:	fde_encoding = DW_EH_PE_udata8; break;
+  /* If not defined, use the current address size unit */
+  case TARGET_ADDR_SIZE_DEFAULT:
+  default:
+	switch (dwarf_addr_size (as))
+	{
+	case 4:    fde_encoding = DW_EH_PE_udata4; break;
+	case 8:    fde_encoding = DW_EH_PE_udata8; break;
+	default:   fde_encoding = DW_EH_PE_omit; break;
+	}
+  }
 
   dci->lsda_encoding = DW_EH_PE_omit;
   dci->handler = 0;
diff --git a/src/dwarf/Gfind_proc_info-lsb.c b/src/dwarf/Gfind_proc_info-lsb.c
index f75bda2..8c35e58 100644
--- a/src/dwarf/Gfind_proc_info-lsb.c
+++ b/src/dwarf/Gfind_proc_info-lsb.c
@@ -81,36 +81,89 @@ linear_search (unw_addr_space_t as, unw_word_t ip,
 #endif /* !UNW_REMOTE_ONLY */
 
 #ifdef CONFIG_DEBUG_FRAME
-/* Load .debug_frame section from FILE.  Allocates and returns space
-   in *BUF, and sets *BUFSIZE to its size.  IS_LOCAL is 1 if using the
-   local process, in which case we can search the system debug file
-   directory; 0 for other address spaces, in which case we do not; or
-   -1 for recursive calls following .gnu_debuglink.  Returns 0 on
-   success, 1 on error.  Succeeds even if the file contains no
-   .debug_frame.  */
-/* XXX: Could use mmap; but elf_map_image keeps tons mapped in.  */
-
-static int
-load_debug_frame (const char *file, char **buf, size_t *bufsize, int is_local)
+static int load_debug_frame_Elf32(const char *file, FILE *f, char *linkbuf,
+				  size_t *linksize, char **buf, size_t *bufsize)
 {
-  FILE *f;
-  Elf_W (Ehdr) ehdr;
-  Elf_W (Half) shstrndx;
-  Elf_W (Shdr) *sec_hdrs = NULL;
+  Elf32_Ehdr ehdr;
+  Elf32_Shdr *sec_hdrs = NULL;
+  Elf32_Half shstrndx;
   char *stringtab = NULL;
   unsigned int i;
-  size_t linksize = 0;
-  char *linkbuf = NULL;
+
+  if (fseek(f, 0L, SEEK_SET))
+    goto file_error;
+  if (fread (&ehdr, sizeof(Elf32_Ehdr), 1, f) != 1)
+    goto file_error;
   
-  *buf = NULL;
-  *bufsize = 0;
+  shstrndx = ehdr.e_shstrndx;
   
-  f = fopen (file, "r");
+  Debug (4, "opened file '%s'. Section header at offset %d\n",
+         file, (int) ehdr.e_shoff);
+
+  fseek (f, ehdr.e_shoff, SEEK_SET);
+  sec_hdrs = calloc (ehdr.e_shnum, sizeof(Elf32_Shdr));
+  if (fread (sec_hdrs, sizeof(Elf32_Shdr), ehdr.e_shnum, f) != ehdr.e_shnum)
+    goto file_error;
   
-  if (!f)
-    return 1;
+  Debug (4, "loading string table of size %zd\n",
+	   sec_hdrs[shstrndx].sh_size);
+  stringtab = malloc (sec_hdrs[shstrndx].sh_size);
+  fseek (f, sec_hdrs[shstrndx].sh_offset, SEEK_SET);
+  if (fread (stringtab, 1, sec_hdrs[shstrndx].sh_size, f) != sec_hdrs[shstrndx].sh_size)
+    goto file_error;
   
-  if (fread (&ehdr, sizeof (Elf_W (Ehdr)), 1, f) != 1)
+  for (i = 1; i < ehdr.e_shnum && *buf == NULL; i++)
+  {
+      char *secname = &stringtab[sec_hdrs[i].sh_name];
+
+      if (strcmp (secname, ".debug_frame") == 0)
+        {
+	  *bufsize = sec_hdrs[i].sh_size;
+	  *buf = malloc (*bufsize);
+
+	  fseek (f, sec_hdrs[i].sh_offset, SEEK_SET);
+	  if (fread (*buf, 1, *bufsize, f) != *bufsize)
+	    goto file_error;
+
+	  Debug (4, "read %zd bytes of .debug_frame from offset %d\n",
+		 *bufsize, sec_hdrs[i].sh_offset);
+	}
+      else if (strcmp (secname, ".gnu_debuglink") == 0)
+	{
+	  *linksize = sec_hdrs[i].sh_size;
+	  linkbuf = malloc(*linksize);
+
+	  fseek (f, sec_hdrs[i].sh_offset, SEEK_SET);
+	  if (fread (linkbuf, 1, *linksize, f) != *linksize)
+	    goto file_error;
+
+	  Debug (4, "read %d bytes of .gnu_debuglink from offset %d\n",
+		 (int) *linksize, sec_hdrs[i].sh_offset);
+	}
+  }
+
+  free(sec_hdrs);
+  free(stringtab);
+  return 0;
+
+file_error:
+  free(sec_hdrs);
+  free(stringtab);
+  return -1;
+}
+
+static int load_debug_frame_Elf64(const char *file, FILE *f, char *linkbuf,
+				  size_t *linksize, char **buf, size_t *bufsize)
+{
+  Elf64_Ehdr ehdr;
+  Elf64_Shdr *sec_hdrs = NULL;
+  Elf64_Half shstrndx;
+  char *stringtab = NULL;
+  unsigned int i;
+
+  if (fseek(f, 0L, SEEK_SET))
+    goto file_error;
+  if (fread (&ehdr, sizeof(Elf64_Ehdr), 1, f) != 1)
     goto file_error;
   
   shstrndx = ehdr.e_shstrndx;
@@ -119,8 +172,8 @@ load_debug_frame (const char *file, char **buf, size_t *bufsize, int is_local)
          file, (int) ehdr.e_shoff);
 
   fseek (f, ehdr.e_shoff, SEEK_SET);
-  sec_hdrs = calloc (ehdr.e_shnum, sizeof (Elf_W (Shdr)));
-  if (fread (sec_hdrs, sizeof (Elf_W (Shdr)), ehdr.e_shnum, f) != ehdr.e_shnum)
+  sec_hdrs = calloc (ehdr.e_shnum, sizeof(Elf64_Shdr));
+  if (fread (sec_hdrs, sizeof(Elf64_Shdr), ehdr.e_shnum, f) != ehdr.e_shnum)
     goto file_error;
   
   Debug (4, "loading string table of size %zd\n",
@@ -131,7 +184,7 @@ load_debug_frame (const char *file, char **buf, size_t *bufsize, int is_local)
     goto file_error;
   
   for (i = 1; i < ehdr.e_shnum && *buf == NULL; i++)
-    {
+  {
       char *secname = &stringtab[sec_hdrs[i].sh_name];
 
       if (strcmp (secname, ".debug_frame") == 0)
@@ -148,20 +201,71 @@ load_debug_frame (const char *file, char **buf, size_t *bufsize, int is_local)
 	}
       else if (strcmp (secname, ".gnu_debuglink") == 0)
 	{
-	  linksize = sec_hdrs[i].sh_size;
-	  linkbuf = malloc (linksize);
+	  *linksize = sec_hdrs[i].sh_size;
+	  linkbuf = malloc(*linksize);
 
 	  fseek (f, sec_hdrs[i].sh_offset, SEEK_SET);
-	  if (fread (linkbuf, 1, linksize, f) != linksize)
+	  if (fread (linkbuf, 1, *linksize, f) != *linksize)
 	    goto file_error;
 
-	  Debug (4, "read %zd bytes of .gnu_debuglink from offset %zd\n",
-		 linksize, sec_hdrs[i].sh_offset);
+	  Debug (4, "read %d bytes of .gnu_debuglink from offset %zd\n",
+		 (int) *linksize, sec_hdrs[i].sh_offset);
 	}
-    }
+  }
+
+  free(sec_hdrs);
+  free(stringtab);
+  return 0;
+
+file_error:
+  free(sec_hdrs);
+  free(stringtab);
+  return -1;
+}
+
+/* Load .debug_frame section from FILE.  Allocates and returns space
+   in *BUF, and sets *BUFSIZE to its size.  IS_LOCAL is 1 if using the
+   local process, in which case we can search the system debug file
+   directory; 0 for other address spaces, in which case we do not; or
+   -1 for recursive calls following .gnu_debuglink.  Returns 0 on
+   success, 1 on error.  Succeeds even if the file contains no
+   .debug_frame.  */
+/* XXX: Could use mmap; but elf_map_image keeps tons mapped in.  */
 
-  free (stringtab);
-  free (sec_hdrs);
+static int
+load_debug_frame (const char *file, char **buf, size_t *bufsize,
+		  unw_addr_space_t as, int is_local)
+{
+  FILE *f;
+  unsigned char e_ident[sizeof(((Elf32_Ehdr *)0)->e_ident)];
+  size_t linksize = 0;
+  char *linkbuf = NULL;
+  
+  *buf = NULL;
+  *bufsize = 0;
+  
+  f = fopen (file, "r");
+  
+  if (!f)
+    return 1;
+  
+  if (fread (&e_ident, sizeof(e_ident), 1, f) != 1)
+    goto file_error;
+ 
+  switch (e_ident[EI_CLASS]) {
+  case ELFCLASS32:
+	as->target_addr_size = TARGET_ADDR_SIZE_32;
+	load_debug_frame_Elf32(file, f, linkbuf, &linksize, buf, bufsize);
+	break;
+  case ELFCLASS64:
+	as->target_addr_size = TARGET_ADDR_SIZE_64;
+	load_debug_frame_Elf64(file, f, linkbuf, &linksize, buf, bufsize);
+  	break;
+  case ELFCLASSNONE:
+  default:
+	Debug (15, "Wrong ELF class 0x%02x\n", e_ident[EI_CLASS]);
+	goto file_error;
+  }
 
   fclose (f);
 
@@ -195,14 +299,14 @@ load_debug_frame (const char *file, char **buf, size_t *bufsize, int is_local)
       strcpy (newname, basedir);
       strcat (newname, "/");
       strcat (newname, linkbuf);
-      ret = load_debug_frame (newname, buf, bufsize, -1);
+      ret = load_debug_frame (newname, buf, bufsize, as, -1);
 
       if (ret == 1)
 	{
 	  strcpy (newname, basedir);
 	  strcat (newname, "/.debug/");
 	  strcat (newname, linkbuf);
-	  ret = load_debug_frame (newname, buf, bufsize, -1);
+	  ret = load_debug_frame (newname, buf, bufsize, as, -1);
 	}
 
       if (ret == 1 && is_local == 1)
@@ -211,20 +315,19 @@ load_debug_frame (const char *file, char **buf, size_t *bufsize, int is_local)
 	  strcat (newname, basedir);
 	  strcat (newname, "/");
 	  strcat (newname, linkbuf);
-	  ret = load_debug_frame (newname, buf, bufsize, -1);
+	  ret = load_debug_frame (newname, buf, bufsize, as, -1);
 	}
 
       free (basedir);
       free (newname);
     }
-  free (linkbuf);
+
+  free(linkbuf);
 
   return 0;
 
 /* An error reading image file. Release resources and return error code */
 file_error:
-  free(stringtab);
-  free(sec_hdrs);
   free(linkbuf);
   fclose(f);
 
@@ -303,7 +406,8 @@ locate_debug_info (unw_addr_space_t as, unw_word_t addr, const char *dlname,
   else
     name = (char*) dlname;
 
-  err = load_debug_frame (name, &buf, &bufsize, as == unw_local_addr_space);
+  err = load_debug_frame (name, &buf, &bufsize, as,
+		  	  as == unw_local_addr_space);
   
   if (!err)
     {
@@ -851,6 +955,14 @@ dwarf_search_unwind_table (unw_addr_space_t as, unw_word_t ip,
 #ifndef UNW_REMOTE_ONLY
       struct unw_debug_frame_list *fdesc = (void *) di->u.ti.table_data;
 
+      /*
+       * Set the target address size as found in the loaded debug binary.
+       * Note: in case of local unwinding the caller 'as' is set to
+       * unw_local_addr_space, cf. below. Let's assign the value to
+       * the caller 'as' before changing the value of 'as'.
+       */
+      as->target_addr_size = unw_local_addr_space->target_addr_size;
+
       /* UNW_INFO_FORMAT_TABLE (i.e. .debug_frame) is read from local address
          space.  Both the index and the unwind tables live in local memory, but
          the address space to check for properties like the address size and
-- 
1.7.11.7

