Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422681AbaD3Obl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:31:41 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52333 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758929AbaD3Oaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:52 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [RFC 12/16] kgr: add tools
Date: Wed, 30 Apr 2014 16:30:45 +0200
Message-Id: <1398868249-26169-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are a base which can be used for kgraft patch generation.

The code was provided by Michael

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Michael Matz <matz@suse.de>
---
 tools/Makefile                   |   13 +-
 tools/kgraft/Makefile            |   30 +
 tools/kgraft/README              |   50 +
 tools/kgraft/TODO                |   20 +
 tools/kgraft/app.c               |   35 +
 tools/kgraft/app.h               |    7 +
 tools/kgraft/create-kgrmodule.sh |   25 +
 tools/kgraft/create-stub.sh      |   53 +
 tools/kgraft/dwarf-inline-tree.c |  544 +++++
 tools/kgraft/dwarf_names.awk     |  126 ++
 tools/kgraft/dwarf_names.c       | 4366 ++++++++++++++++++++++++++++++++++++++
 tools/kgraft/dwarf_names.h       |   53 +
 tools/kgraft/extract-syms.sh     |   18 +
 tools/kgraft/it2rev.pl           |   40 +
 tools/kgraft/objcopy.diff        |  131 ++
 tools/kgraft/symlist             |    1 +
 16 files changed, 5507 insertions(+), 5 deletions(-)
 create mode 100644 tools/kgraft/Makefile
 create mode 100644 tools/kgraft/README
 create mode 100644 tools/kgraft/TODO
 create mode 100644 tools/kgraft/app.c
 create mode 100644 tools/kgraft/app.h
 create mode 100755 tools/kgraft/create-kgrmodule.sh
 create mode 100755 tools/kgraft/create-stub.sh
 create mode 100644 tools/kgraft/dwarf-inline-tree.c
 create mode 100644 tools/kgraft/dwarf_names.awk
 create mode 100644 tools/kgraft/dwarf_names.c
 create mode 100644 tools/kgraft/dwarf_names.h
 create mode 100755 tools/kgraft/extract-syms.sh
 create mode 100644 tools/kgraft/it2rev.pl
 create mode 100644 tools/kgraft/objcopy.diff
 create mode 100644 tools/kgraft/symlist

diff --git a/tools/Makefile b/tools/Makefile
index bcae806b0c39..d624e61606c4 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -8,6 +8,7 @@ help:
 	@echo '  cpupower   - a tool for all things x86 CPU power'
 	@echo '  firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer'
 	@echo '  hv         - tools used when in Hyper-V clients'
+	@echo '  kgraft     - the userspace part needed for online patching'
 	@echo '  lguest     - a minimal 32-bit x86 hypervisor'
 	@echo '  perf       - Linux performance measurement and analysis tool'
 	@echo '  selftests  - various kernel selftests'
@@ -41,7 +42,7 @@ acpi: FORCE
 cpupower: FORCE
 	$(call descend,power/$@)
 
-cgroup firewire hv guest usb virtio vm net: FORCE
+cgroup firewire hv kgraft guest usb virtio vm net: FORCE
 	$(call descend,$@)
 
 libapikfs: FORCE
@@ -65,7 +66,7 @@ acpi_install:
 cpupower_install:
 	$(call descend,power/$(@:_install=),install)
 
-cgroup_install firewire_install hv_install lguest_install perf_install usb_install virtio_install vm_install net_install:
+cgroup_install firewire_install hv_install kgraft_install lguest_install perf_install usb_install virtio_install vm_install net_install:
 	$(call descend,$(@:_install=),install)
 
 selftests_install:
@@ -77,7 +78,8 @@ turbostat_install x86_energy_perf_policy_install:
 tmon_install:
 	$(call descend,thermal/$(@:_install=),install)
 
-install: acpi_install cgroup_install cpupower_install hv_install firewire_install lguest_install \
+install: acpi_install cgroup_install cpupower_install hv_install \
+		kgraft_install firewire_install lguest_install \
 		perf_install selftests_install turbostat_install usb_install \
 		virtio_install vm_install net_install x86_energy_perf_policy_install \
 	tmon
@@ -88,7 +90,7 @@ acpi_clean:
 cpupower_clean:
 	$(call descend,power/cpupower,clean)
 
-cgroup_clean hv_clean firewire_clean lguest_clean usb_clean virtio_clean vm_clean net_clean:
+cgroup_clean hv_clean kgraft_clean firewire_clean lguest_clean usb_clean virtio_clean vm_clean net_clean:
 	$(call descend,$(@:_clean=),clean)
 
 libapikfs_clean:
@@ -106,7 +108,8 @@ turbostat_clean x86_energy_perf_policy_clean:
 tmon_clean:
 	$(call descend,thermal/tmon,clean)
 
-clean: acpi_clean cgroup_clean cpupower_clean hv_clean firewire_clean lguest_clean \
+clean: acpi_clean cgroup_clean cpupower_clean hv_clean kgraft_clean \
+		firewire_clean lguest_clean \
 		perf_clean selftests_clean turbostat_clean usb_clean virtio_clean \
 		vm_clean net_clean x86_energy_perf_policy_clean tmon_clean
 
diff --git a/tools/kgraft/Makefile b/tools/kgraft/Makefile
new file mode 100644
index 000000000000..75e0030b550d
--- /dev/null
+++ b/tools/kgraft/Makefile
@@ -0,0 +1,30 @@
+CC=gcc
+CFLAGS=-g
+
+all: objcopy-hacked dwarf-inline-tree it2rev.pl
+
+objcopy-hacked: objcopy.diff
+	echo "Build by hand!"
+	exit 1
+
+dwarf-inline-tree: dwarf-inline-tree.o dwarf_names.o
+	gcc -o $@ $^ -ldwarf -lelf
+
+dwarf-inline-tree.o: dwarf_names.h
+dwarf_names.o: dwarf_names.h
+
+check: app.o symlist all
+	@echo "inline tree"
+	./dwarf-inline-tree app.o
+	@echo "inline pairs"
+	./dwarf-inline-tree app.o | perl it2rev.pl
+	@echo "extract stuff"
+	./objcopy-hacked --strip-unneeded -j .doesntexist. --keep-symbols symlist app.o app-extract.o
+	@echo "symbols"
+	readelf -sW app.o app-extract.o
+
+app.c: app.h
+app.o: CFLAGS=-g -ffunction-sections -fdata-sections
+
+clean:
+	rm -f dwarf-inline-tree.o dwarf_names.o dwarf-inline-tree app.o app-extract.o
diff --git a/tools/kgraft/README b/tools/kgraft/README
new file mode 100644
index 000000000000..179db470a5b8
--- /dev/null
+++ b/tools/kgraft/README
@@ -0,0 +1,50 @@
+Some tools for kgraft.
+
+# make && make check
+
+will build most of them, and the check target contains example invocations.
+The only thing not built automatically is the hacked objcopy (objcopy-hacked),
+as usually the necessary binutils headers aren't installed.  You'll
+have to have (recent) binutils sources, apply the patch objcopy.diff
+and build it yourself.
+
+objcopy-hacked:
+  Given a list of symbols (e.g. in a file symlist) this will extract
+  all sections defining those symbols.  It will also recursively extract
+  sections needed by those (e.g. by section based relocations).
+
+dwarf-inline-tree:
+  Given an ELF file with debug info this will generate a parsable
+  output of the inline tree, like so:
+    U somesymbol
+    D filename.c:anothersym
+    I bla.h:helper
+  Meaning there's a reference to 'somesymbol', there's a definition
+  of function anothersym() from file filename.c, and that one contains
+  an inline expansion of function helper() from bla.h.
+
+  Filenames are directly from the debuginfo, and so can contain
+  directory prefixes dependending on how the objects were compiled.
+
+it2rev.pl [<path-prefix>]
+  This transforms the output of dwarf-inline-tree into a list of
+  whats-inlined-where lists, like
+    bla.h:helper filename.c:anothersym file2.c:bar
+  (helper is inlined into anothersym and bar).  If path-prefix
+  is given it is removed from all filenames from the input list.
+
+extract-syms.sh <list of symbol names>
+  This will use objcopy-hacked to extract the sections for the given
+  symbols from vmlinux.o into extracted.o.  All given symbols will
+  be prefixed with "new_" in the generated output.
+
+create-stub.sh <list of symbol names>
+  This will generate on stdout a C source that is the module source
+  code for a kgraft module patching the given symbols.
+
+create-kgrmodule.sh <list of symbol names>
+  This will generated a full kgraft module from a list of symbol
+  names (by using the above scripts).  Take care for compiling
+  the kernel providing the new code with
+    -ffunction-sections -fdata-sections .
+  The module will be in kgrafttmp/kgrmodule.ko .
diff --git a/tools/kgraft/TODO b/tools/kgraft/TODO
new file mode 100644
index 000000000000..498104c555d8
--- /dev/null
+++ b/tools/kgraft/TODO
@@ -0,0 +1,20 @@
+TODO list for kgraft tools
+
+extract-syms.sh shouldn't use vmlinux.o for extraction, but the
+underlying individual .o files.  The sections in vmlinux.o will be
+catted together already (for things like data.mostly_read), referencing
+too much unrelated stuff.
+
+extract-syms.sh should use an optional inliner tree to expand the set
+of symbols to those that have them inlined.  Further it should use
+(optionally) filename:symbol pairs for those cases where static functions
+need to be extracted whose names happen to occur multiple times in different
+units.
+
+Perhaps a top-level script taking a kernel patch, and pulling everything
+together should be created (applying patch, building kernel the right way,
+extracting stuff and so on).
+
+The seeding symbol list currently needs to come from a human.  It's probably
+feasible to generate that list for most cases by interpreting a kernel
+diff.  Binary comparison should _not_ be used to generate it.
diff --git a/tools/kgraft/app.c b/tools/kgraft/app.c
new file mode 100644
index 000000000000..16d8b313b438
--- /dev/null
+++ b/tools/kgraft/app.c
@@ -0,0 +1,35 @@
+#include <stdio.h>
+#include "app.h"
+
+static int local_data;
+int global_data;
+
+static void __attribute__((noinline)) in_app (void)
+{
+  printf ("in_app\n");
+  in_app_inline ();
+  local_data = 42;
+}
+
+static inline void __attribute__((always_inline)) in_app_inline_twice (void)
+{
+  global_data++;
+  in_app_inline ();
+}
+
+void in_app_global (void)
+{
+  printf ("in_app_global\n");
+  in_app();
+  in_app_inline_twice ();
+  global_data = 43;
+}
+
+int main ()
+{
+  in_app_global();
+  second_file ();
+  printf ("local_data = %d\n", local_data);
+  printf ("global_data = %d\n", global_data);
+  return 0;
+}
diff --git a/tools/kgraft/app.h b/tools/kgraft/app.h
new file mode 100644
index 000000000000..c07e10b23367
--- /dev/null
+++ b/tools/kgraft/app.h
@@ -0,0 +1,7 @@
+static inline void __attribute__((always_inline)) in_app_inline (void)
+{
+  static int local_static_data;
+  printf ("in_app_inline: %d\n", local_static_data++);
+}
+
+void second_file (void);
diff --git a/tools/kgraft/create-kgrmodule.sh b/tools/kgraft/create-kgrmodule.sh
new file mode 100755
index 000000000000..d73cccf01b22
--- /dev/null
+++ b/tools/kgraft/create-kgrmodule.sh
@@ -0,0 +1,25 @@
+#!/bin/bash
+TOOLPATH=`dirname $0`
+if ! test -f vmlinux.o; then
+    echo "vmlinux.o needs to exist in cwd"
+    exit 1
+fi
+if test -z "$1"; then
+    echo "usage: $0 [list of symbols to extract]"
+    exit 2
+fi
+mkdir -p kgrafttmp
+$TOOLPATH/extract-syms.sh $@
+mv extracted.o kgrafttmp
+cd kgrafttmp
+$TOOLPATH/create-stub.sh $@ > kgrstub.c
+cat <<EOF > Makefile
+obj-m = kgrmodule.o
+kgrmodule-y += kgrstub.o extracted.o
+
+all:
+	make -C .. M=\$(PWD) modules
+EOF
+make
+cd ..
+ls -l kgrafttmp/kgrmodule.ko
diff --git a/tools/kgraft/create-stub.sh b/tools/kgraft/create-stub.sh
new file mode 100755
index 000000000000..9551ebae5b31
--- /dev/null
+++ b/tools/kgraft/create-stub.sh
@@ -0,0 +1,53 @@
+#!/bin/bash
+
+if test -z "$1"; then
+    echo "usage: $0 [list of symbols]"
+fi
+
+cat <<EOF
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/kgr.h>
+#include <linux/kallsyms.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/capability.h>
+#include <linux/ptrace.h>
+
+EOF
+
+for i in $@; do
+    echo "extern void new_$i (void);"
+    echo "KGR_PATCHED_FUNCTION(patch, $i, new_$i);"
+done
+
+echo "static const struct kgr_patch patch = {"
+echo "	.patches = {"
+for i in $@; do
+    echo "		KGR_PATCH($i),"
+done
+echo "		KGR_PATCH_END"
+echo "	}"
+echo "};"
+
+cat <<EOF
+static int __init kgr_patcher_init(void)
+{
+        /* removing not supported (yet?) */
+        __module_get(THIS_MODULE);
+        /* +4 to skip push rbb / mov rsp,rbp prologue */
+        kgr_start_patching(&patch);
+        return 0;
+}
+
+static void __exit kgr_patcher_cleanup(void)
+{
+        printk(KERN_ERR "removing now buggy!\n");
+}
+
+module_init(kgr_patcher_init);
+module_exit(kgr_patcher_cleanup);
+
+MODULE_LICENSE("GPL");
+EOF
diff --git a/tools/kgraft/dwarf-inline-tree.c b/tools/kgraft/dwarf-inline-tree.c
new file mode 100644
index 000000000000..e8aea10f687d
--- /dev/null
+++ b/tools/kgraft/dwarf-inline-tree.c
@@ -0,0 +1,544 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+
+#include <libelf.h>
+
+#include <libdwarf/dwarf.h>
+#include <libdwarf/libdwarf.h>
+
+#define HAVE_ELF64_GETEHDR
+
+#define string char*
+#include "dwarf_names.h"
+#undef string
+
+int ellipsis = 0;
+int verbose = 0;
+static char *file_name;
+static char *program_name;
+Dwarf_Error err;
+
+void
+print_error(Dwarf_Debug dbg, char *msg, int dwarf_code,
+	    Dwarf_Error err)
+{
+    if (dwarf_code == DW_DLV_ERROR) {
+	char *errmsg = dwarf_errmsg(err);
+	long long myerr = dwarf_errno(err);
+
+	fprintf(stderr, "%s ERROR:  %s:  %s (%lld)\n",
+		program_name, msg, errmsg, myerr);
+    } else if (dwarf_code == DW_DLV_NO_ENTRY) {
+	fprintf(stderr, "%s NO ENTRY:  %s: \n", program_name, msg);
+    } else if (dwarf_code == DW_DLV_OK) {
+	fprintf(stderr, "%s:  %s \n", program_name, msg);
+    } else {
+	fprintf(stderr, "%s InternalError:  %s:  code %d\n",
+		program_name, msg, dwarf_code);
+    }
+    exit(1);
+}
+
+static int indent_level;
+
+static void
+print_attribute(Dwarf_Debug dbg, Dwarf_Die die,
+		Dwarf_Half attr,
+		Dwarf_Attribute attr_in,
+		char **srcfiles, Dwarf_Signed cnt, Dwarf_Half tag)
+{
+    Dwarf_Attribute attrib = 0;
+    char *atname = 0;
+    int tres = 0;
+    Dwarf_Half form = 0;
+
+    attrib = attr_in;
+    atname = get_AT_name(dbg, attr);
+
+    tres = dwarf_whatform (attrib, &form, &err);
+    if (tres != DW_DLV_OK)
+	print_error (dbg, "dwarf_whatform", tres, err);
+    printf("\t\t%-28s%s\t", atname, get_FORM_name (dbg, form));
+    /* Don't move over the attributes for the top-level compile_unit
+     * DIEs.  */
+    if (tag == DW_TAG_compile_unit)
+      {
+	printf ("\n");
+	return;
+      }
+    switch (form) {
+	case DW_FORM_addr:
+	    {
+		Dwarf_Addr a;
+		tres = dwarf_formaddr (attrib, &a, &err);
+		if (tres != DW_DLV_OK)
+		    print_error (dbg, "dwarf_formaddr", tres, err);
+		printf ("0x%llx", (unsigned long long)a);
+	    }
+	    break;
+	case DW_FORM_data4:
+	case DW_FORM_data8:
+	case DW_FORM_data1:
+	case DW_FORM_data2:
+	case DW_FORM_udata:
+	    {
+		/* Bah.  From just looking at FORM_data[1248] we don't
+		 * really know if it's signed or unsigned.  We have to
+		 * look at the context.  Luckily only two ATs can be signed. */
+		switch (attr) {
+		    case DW_AT_upper_bound:
+		    case DW_AT_lower_bound:
+			  {
+			    Dwarf_Signed s;
+			    tres = dwarf_formsdata (attrib, &s, &err);
+			    if (tres != DW_DLV_OK)
+			      print_error (dbg, "dwarf_formudata", tres, err);
+			    printf ("%lld", s);
+			  }
+			break;
+		    default:
+			  {
+			    Dwarf_Unsigned u;
+			    tres = dwarf_formudata (attrib, &u, &err);
+			    if (tres != DW_DLV_OK)
+			      print_error (dbg, "dwarf_formudata", tres, err);
+			    printf ("%llu", u);
+			  }
+			break;
+		}
+	    }
+	    break;
+	case DW_FORM_sdata:
+	    {
+		Dwarf_Signed s;
+		tres = dwarf_formsdata (attrib, &s, &err);
+		if (tres != DW_DLV_OK)
+		    print_error (dbg, "dwarf_formsdata", tres, err);
+		printf ("%lld", s);
+	    }
+	    break;
+	case DW_FORM_string:
+	case DW_FORM_strp:
+	    {
+		char *s;
+		tres = dwarf_formstring (attrib, &s, &err);
+		if (tres != DW_DLV_OK)
+		    print_error (dbg, "dwarf_formstring", tres, err);
+		printf ("%s\n", s);
+	    }
+	    break;
+	case DW_FORM_block:
+	case DW_FORM_block1:
+	case DW_FORM_block2:
+	case DW_FORM_block4:
+	    {
+		Dwarf_Block *b;
+		tres = dwarf_formblock (attrib, &b, &err);
+		if (tres != DW_DLV_OK)
+		    print_error (dbg, "dwarf_formblock", tres, err);
+		printf ("[block data]");
+	    }
+	    break;
+	case DW_FORM_flag:
+	    {
+		Dwarf_Bool b;
+		tres = dwarf_formflag (attrib, &b, &err);
+		if (tres != DW_DLV_OK)
+		    print_error (dbg, "dwarf_formflag", tres, err);
+		printf ("%s", b ? "true" : "false");
+	    }
+	    break;
+	case DW_FORM_ref_addr:
+	case DW_FORM_ref1:
+	case DW_FORM_ref2:
+	case DW_FORM_ref4:
+	case DW_FORM_ref8:
+	case DW_FORM_ref_udata:
+	    {
+		Dwarf_Off o;
+		tres = dwarf_global_formref (attrib, &o, &err);
+		if (tres != DW_DLV_OK)
+		    print_error (dbg, "dwarf_global_formref", tres, err);
+		printf ("ref <0x%x>\n", o);
+	    }
+	    break;
+	case DW_FORM_indirect:
+	default:
+	    print_error (dbg, "broken DW_FORM", 0, 0);
+	    break;
+    }
+    printf ("\n");
+}
+
+int
+get_file_and_name (Dwarf_Debug dbg, Dwarf_Die die, int *file, char **name)
+{
+  Dwarf_Attribute attr;
+  Dwarf_Half form = 0;
+  int tres = 0;
+  int ret = DW_DLV_OK;
+
+  if (dwarf_attr (die, DW_AT_abstract_origin, &attr, &err) == DW_DLV_OK
+      && dwarf_whatform (attr, &form, &err) == DW_DLV_OK)
+    {
+      Dwarf_Off o;
+      Dwarf_Die ref;
+      tres = dwarf_global_formref (attr, &o, &err);
+      if (tres != DW_DLV_OK)
+	print_error (dbg, "dwarf_global_formref", tres, err);
+      else
+	{
+	  if (dwarf_offdie (dbg, o, &ref, &err) == DW_DLV_OK)
+	    get_file_and_name (dbg, ref, file, name);
+	}
+    }
+
+  if (dwarf_attr (die, DW_AT_decl_file, &attr, &err) == DW_DLV_OK
+      && dwarf_whatform (attr, &form, &err) == DW_DLV_OK)
+    {
+      if (form == DW_FORM_sdata)
+	{
+	  Dwarf_Signed s;
+	  if ((tres = dwarf_formsdata (attr, &s, &err)) == DW_DLV_OK)
+	    *file = s;
+	  else
+	    ret = DW_DLV_ERROR, print_error (dbg, "dwarf_formsdata", tres, err);
+	}
+      else
+	{
+	  Dwarf_Unsigned u;
+	  if ((tres = dwarf_formudata (attr, &u, &err)) == DW_DLV_OK)
+	    *file = u;
+	  else
+	    ret = DW_DLV_ERROR, print_error (dbg, "dwarf_formudata", tres, err);
+	}
+    }
+
+  if ((dwarf_attr (die, DW_AT_MIPS_linkage_name, &attr, &err) == DW_DLV_OK
+       && dwarf_whatform (attr, &form, &err) == DW_DLV_OK)
+      || (dwarf_attr (die, DW_AT_name, &attr, &err) == DW_DLV_OK
+	  && dwarf_whatform (attr, &form, &err) == DW_DLV_OK))
+    {
+      char *s;
+      tres = dwarf_formstring (attr, &s, &err);
+      if (tres != DW_DLV_OK)
+	ret = DW_DLV_ERROR, print_error (dbg, "dwarf_formstring", tres, err);
+      *name = s;
+    }
+  return ret;
+}
+
+/* handle one die */
+void
+print_one_die(Dwarf_Debug dbg, Dwarf_Die die,
+	      char **srcfiles, Dwarf_Signed cnt)
+{
+    Dwarf_Signed i;
+    Dwarf_Off offset, overall_offset;
+    char *tagname;
+    Dwarf_Half tag;
+    Dwarf_Signed atcnt;
+    Dwarf_Attribute *atlist;
+    int tres;
+    int ores;
+    int atres;
+
+    tres = dwarf_tag(die, &tag, &err);
+    if (tres != DW_DLV_OK) {
+	print_error(dbg, "accessing tag of die!", tres, err);
+    }
+    tagname = get_TAG_name(dbg, tag);
+    ores = dwarf_dieoffset(die, &overall_offset, &err);
+    if (ores != DW_DLV_OK) {
+	print_error(dbg, "dwarf_dieoffset", ores, err);
+    }
+    ores = dwarf_die_CU_offset(die, &offset, &err);
+    if (ores != DW_DLV_OK) {
+	print_error(dbg, "dwarf_die_CU_offset", ores, err);
+    }
+
+    if (verbose)
+      {
+	if (indent_level == 0) {
+		printf
+		    ("\nCOMPILE_UNIT<header overall offset = %llu>:\n",
+		     overall_offset - offset);
+	}
+	printf("<%d><%5llu>\t%s\n", indent_level, offset, tagname);
+      }
+
+    if (tag == DW_TAG_subprogram || tag == DW_TAG_inlined_subroutine)
+      {
+	char *name = 0;
+	int filenum = -1;
+	char *prefix;
+	Dwarf_Attribute attr;
+	if (tag == DW_TAG_inlined_subroutine)
+	  prefix = "I";
+	else if (dwarf_attr (die, DW_AT_low_pc, &attr, &err) == DW_DLV_OK)
+	  prefix = "D";
+	else
+	  prefix = "U";
+	if (get_file_and_name (dbg, die, &filenum, &name) == DW_DLV_OK)
+	  {
+	    char *filename;
+	    if (filenum > 0 && filenum <= cnt)
+	      filename = srcfiles[filenum - 1];
+	    else
+	      filename = "";
+	    printf ("%s %s:%s\n", prefix, filename, name);
+	  }
+	else
+	  printf ("%s couldn't decode name or file\n", prefix);
+      }
+
+    if (!verbose)
+      return;
+
+    atres = dwarf_attrlist(die, &atlist, &atcnt, &err);
+    if (atres == DW_DLV_ERROR) {
+	print_error(dbg, "dwarf_attrlist", atres, err);
+    } else if (atres == DW_DLV_NO_ENTRY) {
+	/* indicates there are no attrs.  It is not an error. */
+	atcnt = 0;
+    }
+
+    for (i = 0; i < atcnt; i++) {
+	Dwarf_Half attr;
+	int ares;
+
+	ares = dwarf_whatattr(atlist[i], &attr, &err);
+	if (ares == DW_DLV_OK) {
+	    print_attribute(dbg, die, attr,
+			    atlist[i], srcfiles, cnt, tag);
+	} else {
+	    print_error(dbg, "dwarf_whatattr entry missing", ares, err);
+	}
+    }
+
+    for (i = 0; i < atcnt; i++) {
+	dwarf_dealloc(dbg, atlist[i], DW_DLA_ATTR);
+    }
+    if (atres == DW_DLV_OK) {
+	dwarf_dealloc(dbg, atlist, DW_DLA_LIST);
+    }
+}
+
+/* recursively follow the die tree */
+void
+print_die_and_children(Dwarf_Debug dbg, Dwarf_Die in_die_in,
+		       char **srcfiles, Dwarf_Signed cnt)
+{
+    Dwarf_Die child;
+    Dwarf_Die sibling;
+    Dwarf_Error err;
+    int tres;
+    int cdres;
+    Dwarf_Die in_die = in_die_in;
+
+    for (;;) {
+	/* here to pre-descent processing of the die */
+	print_one_die(dbg, in_die, srcfiles, cnt);
+
+	cdres = dwarf_child(in_die, &child, &err);
+	/* child first: we are doing depth-first walk */
+	if (cdres == DW_DLV_OK) {
+	    indent_level++;
+	    print_die_and_children(dbg, child, srcfiles, cnt);
+	    indent_level--;
+	    dwarf_dealloc(dbg, child, DW_DLA_DIE);
+	} else if (cdres == DW_DLV_ERROR) {
+	    print_error(dbg, "dwarf_child", cdres, err);
+	}
+
+	cdres = dwarf_siblingof(dbg, in_die, &sibling, &err);
+	if (cdres == DW_DLV_OK) {
+	    /* print_die_and_children(dbg, sibling, srcfiles, cnt); We 
+	       loop around to actually print this, rather than
+	       recursing. Recursing is horribly wasteful of stack
+	       space. */
+	} else if (cdres == DW_DLV_ERROR) {
+	    print_error(dbg, "dwarf_siblingof", cdres, err);
+	}
+
+	/* Here do any post-descent (ie post-dwarf_child) processing
+	   of the in_die. */
+
+	if (in_die != in_die_in) {
+	    /* Dealloc our in_die, but not the argument die, it belongs 
+	       to our caller. Whether the siblingof call worked or not. 
+	     */
+	    dwarf_dealloc(dbg, in_die, DW_DLA_DIE);
+	}
+	if (cdres == DW_DLV_OK) {
+	    /* Set to process the sibling, loop again. */
+	    in_die = sibling;
+	} else {
+	    /* We are done, no more siblings at this level. */
+
+	    break;
+	}
+    }				/* end for loop on siblings */
+}
+
+static void
+print_infos(Dwarf_Debug dbg)
+{
+    Dwarf_Unsigned cu_header_length = 0;
+    Dwarf_Unsigned abbrev_offset = 0;
+    Dwarf_Half version_stamp = 0;
+    Dwarf_Half address_size = 0;
+    Dwarf_Die cu_die = 0;
+    Dwarf_Unsigned next_cu_offset = 0;
+    int nres = DW_DLV_OK;
+
+    /* Loop until it fails.  */
+    while ((nres =
+	    dwarf_next_cu_header(dbg, &cu_header_length, &version_stamp,
+				 &abbrev_offset, &address_size,
+				 &next_cu_offset, &err))
+	   == DW_DLV_OK) {
+	int sres;
+
+	if (verbose)
+	{
+		printf("\nCU_HEADER:\n");
+		printf("\t\t%-28s%llu\n", "cu_header_length",
+		       cu_header_length);
+		printf("\t\t%-28s%d\n", "version_stamp", version_stamp);
+		printf("\t\t%-28s%llu\n", "abbrev_offset",
+		       abbrev_offset);
+		printf("\t\t%-28s%d", "address_size", address_size);
+	}
+
+	/* process a single compilation unit in .debug_info. */
+	sres = dwarf_siblingof(dbg, NULL, &cu_die, &err);
+	if (sres == DW_DLV_OK) {
+	    {
+		Dwarf_Signed cnt = 0;
+		char **srcfiles = 0;
+		int srcf = dwarf_srcfiles(cu_die,
+					  &srcfiles, &cnt, &err);
+
+		if (srcf != DW_DLV_OK) {
+		    srcfiles = 0;
+		    cnt = 0;
+		}
+
+		print_die_and_children(dbg, cu_die, srcfiles, cnt);
+		if (srcf == DW_DLV_OK) {
+		    int si;
+
+		    for (si = 0; si < cnt; ++si) {
+			dwarf_dealloc(dbg, srcfiles[si], DW_DLA_STRING);
+		    }
+		    dwarf_dealloc(dbg, srcfiles, DW_DLA_LIST);
+		}
+	    }
+	    dwarf_dealloc(dbg, cu_die, DW_DLA_DIE);
+	} else if (sres == DW_DLV_NO_ENTRY) {
+	    /* do nothing I guess. */
+	} else {
+	    print_error(dbg, "Regetting cu_die", sres, err);
+	}
+    }
+    if (nres == DW_DLV_ERROR) {
+	char *errmsg = dwarf_errmsg(err);
+	long long myerr = dwarf_errno(err);
+
+	fprintf(stderr, "%s ERROR:  %s:  %s (%lld)\n",
+		program_name, "attempting to print .debug_info",
+		errmsg, myerr);
+	fprintf(stderr, "attempting to continue.\n");
+    }
+}
+
+static void
+process_one_file (Elf *elf, char *file_name)
+{
+    Dwarf_Debug dbg;
+    int dres;
+
+    if (verbose)
+      printf ("processing %s\n", file_name);
+    dres = dwarf_elf_init(elf, DW_DLC_READ, NULL, NULL, &dbg, &err);
+    if (dres == DW_DLV_NO_ENTRY) {
+	printf("No DWARF information present in %s\n", file_name);
+	return;
+    }
+    if (dres != DW_DLV_OK) {
+	print_error(dbg, "dwarf_elf_init", dres, err);
+    }
+
+    print_infos(dbg);
+
+    dres = dwarf_finish(dbg, &err);
+    if (dres != DW_DLV_OK) {
+	print_error(dbg, "dwarf_finish", dres, err);
+    }
+    return;
+}
+	
+int
+main(int argc, char *argv[])
+{
+    int f;
+    Elf_Cmd cmd;
+    Elf *arf, *elf;
+
+    program_name = argv[0];
+    
+    (void) elf_version(EV_NONE);
+    if (elf_version(EV_CURRENT) == EV_NONE) {
+	(void) fprintf(stderr, "dwarf-inline-tree: libelf.a out of date.\n");
+	exit(1);
+    }
+
+    if (argc < 2)
+    {
+	fprintf (stderr, "dwarf-inline-tree <input-elf>\n");
+	exit (2);
+    }
+    file_name = argv[1];
+    f = open(file_name, O_RDONLY);
+    if (f == -1) {
+	fprintf(stderr, "%s ERROR:  can't open %s\n", program_name,
+		file_name);
+	return 1;
+    }
+
+    cmd = ELF_C_READ;
+    arf = elf_begin(f, cmd, (Elf *) 0);
+    while ((elf = elf_begin(f, cmd, arf)) != 0) {
+	Elf32_Ehdr *eh32;
+
+#ifdef HAVE_ELF64_GETEHDR
+	Elf64_Ehdr *eh64;
+#endif /* HAVE_ELF64_GETEHDR */
+	eh32 = elf32_getehdr(elf);
+	if (!eh32) {
+#ifdef HAVE_ELF64_GETEHDR
+	    /* not a 32-bit obj */
+	    eh64 = elf64_getehdr(elf);
+	    if (!eh64) {
+		/* not a 64-bit obj either! */
+		/* dwarfdump is quiet when not an object */
+	    } else {
+		process_one_file(elf, file_name);
+	    }
+#endif /* HAVE_ELF64_GETEHDR */
+	} else {
+	    process_one_file(elf, file_name);
+	}
+	cmd = elf_next(elf);
+	elf_end(elf);
+    }
+    elf_end(arf);
+    return 0;
+}
diff --git a/tools/kgraft/dwarf_names.awk b/tools/kgraft/dwarf_names.awk
new file mode 100644
index 000000000000..e5b39726fe1a
--- /dev/null
+++ b/tools/kgraft/dwarf_names.awk
@@ -0,0 +1,126 @@
+# Print routines to return constant name for associated value.
+# The input is dwarf.h
+# For each set of names with a common prefix, we create a routine
+# to return the name given the value.
+# Also print header file that gives prototypes of routines.
+# To handle cases where there are multiple names for a single
+# value (DW_AT_* has some due to ambiguities in the DWARF2 spec)
+# we take the first of a given value as the definitive name.
+# TAGs, Attributes, etc are given distinct checks.
+BEGIN {
+	prefix = "foo"
+	prefix_id = "foo"
+	prefix_len = length(prefix)
+	dw_prefix = "DW_"
+	dw_len = length(dw_prefix)
+	start_routine = 0
+	printf "#include <stdio.h>\n"
+	printf "#include <string.h>\n"
+	printf "#include <libdwarf/dwarf.h>\n"
+	printf "#include <libdwarf/libdwarf.h>\n"
+
+	printf "typedef char * string;\n"
+	printf "#define makename strdup\n"
+	printf "extern int ellipsis;\n"
+
+	header = "dwarf_names.h"
+	printf "/* automatically generated routines */\n" > header
+	dup_arr["0"] = ""
+}
+{
+	if (skipit && $1 == "#endif") {
+		skipit = 0
+		next
+	}
+	if ($2 == 0 || skipit) {
+		# if 0, skip to endif
+		skipit = 1
+		next
+	}
+	if ($1 == "#define") {
+		if (substr($2,1,prefix_len) != prefix) {
+			# new prefix
+			if (substr($2,1,dw_len) != dw_prefix) {
+				# skip
+				next
+			} else if (substr($2,1,dw_len+3) == "DW_CFA") {
+				# skip, cause numbers conflict
+				# (have both high-order and low-order bits)
+				next
+			} else {
+				# New prefix, empty the dup_arr
+				for (k in dup_arr)
+					dup_arr[k] = ""
+				if (start_routine) {
+					# end routine
+					printf "\tdefault:\n"
+printf "\t\t{ \n"
+printf "\t\t    char buf[100]; \n"
+printf "\t\t    char *n; \n"
+printf "\t\t    sprintf(buf,\"<Unknown %s value 0x%%x>\",(int)val);\n",prefix_id
+printf "\t\t fprintf(stderr,\"%s of %%d (0x%%x) is unknown to dwarfdump. \" \n ", prefix_id
+printf "\t\t \"Continuing. \\n\",(int)val,(int)val );  \n"
+printf "\t\t    n = makename(buf);\n"
+printf "\t\t    return n; \n"
+printf "\t\t} \n"
+					printf "\t}\n"
+					printf "/*NOTREACHED*/\n"
+					printf "}\n\n"
+				}
+				start_routine = 1
+				post_dw = substr($2,dw_len+1, length($2))
+				second_underscore = index(post_dw,"_")
+				prefix = substr($2,1,second_underscore+dw_len)
+				prefix_len = length(prefix)
+				# prefix id is unique part after DW_, e.g. LANG
+				prefix_id = substr(prefix,dw_len+1,prefix_len-dw_len-1)
+				printf "/* ARGSUSED */\n"
+				printf "extern string\n"
+				printf "get_%s_name (Dwarf_Debug dbg, Dwarf_Half val)\n", prefix_id
+				printf "{\n"
+				printf "\tswitch (val) {\n"
+				printf "extern string get_%s_name (Dwarf_Debug dbg, Dwarf_Half val);\n\n", prefix_id >> header
+			}
+		}
+		if (substr($2,1,prefix_len) == prefix) {
+			if (substr($2,1,dw_len+8) == "DW_CHILDREN" \
+			    || substr($2,1,dw_len+8) == "DW_children" \
+			    || substr($2,1,dw_len+4) == "DW_ADDR") {
+				main_part = substr($2,dw_len+1, length($2))
+			}
+			else {
+				post_dw = substr($2,dw_len+1, length($2))
+				second_underscore = index(post_dw,"_")
+				main_part = substr($2,dw_len+second_underscore+1, length($2))
+			}
+			if( dup_arr[$3] != $3 ) {
+			  # Take first of those with identical value,
+			  # ignore others.
+			  dup_arr[$3] = $3
+			  printf "\tcase %s:\n", $2
+			  printf "\t\tif (ellipsis)\n"
+			  printf "\t\t\treturn \"%s\";\n", main_part
+			  printf "\t\telse\n"
+			  printf "\t\t\treturn \"%s\";\n", $2
+		        }
+		}
+	}
+}
+END {
+	if (start_routine) {
+					printf "\tdefault:\n"
+printf "\t\t{ \n"
+printf "\t\t    char buf[100]; \n"
+printf "\t\t    char *n; \n"
+printf "\t\t    sprintf(buf,\"<Unknown %s value 0x%%x>\",(int)val);\n",prefix_id
+printf "\t\t fprintf(stderr,\"%s of %%d (0x%%x) is unknown to dwarfdump. \" \n ", prefix_id
+printf "\t\t \"Continuing. \\n\",(int)val,(int)val );  \n"
+printf "\t\t    n = makename(buf);\n"
+printf "\t\t    return n; \n"
+printf "\t\t} \n"
+					printf "\t}\n"
+					printf "/*NOTREACHED*/\n"
+					printf "}\n\n"
+	}
+}
+
diff --git a/tools/kgraft/dwarf_names.c b/tools/kgraft/dwarf_names.c
new file mode 100644
index 000000000000..e0afd80c9cd4
--- /dev/null
+++ b/tools/kgraft/dwarf_names.c
@@ -0,0 +1,4366 @@
+#include <stdio.h>
+#include <string.h>
+#include <libdwarf/dwarf.h>
+#include <libdwarf/libdwarf.h>
+typedef char * string;
+#define makename strdup
+extern int ellipsis;
+/* ARGSUSED */
+extern string
+get_TAG_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_TAG_array_type:
+		if (ellipsis)
+			return "array_type";
+		else
+			return "DW_TAG_array_type";
+	case DW_TAG_class_type:
+		if (ellipsis)
+			return "class_type";
+		else
+			return "DW_TAG_class_type";
+	case DW_TAG_entry_point:
+		if (ellipsis)
+			return "entry_point";
+		else
+			return "DW_TAG_entry_point";
+	case DW_TAG_enumeration_type:
+		if (ellipsis)
+			return "enumeration_type";
+		else
+			return "DW_TAG_enumeration_type";
+	case DW_TAG_formal_parameter:
+		if (ellipsis)
+			return "formal_parameter";
+		else
+			return "DW_TAG_formal_parameter";
+	case DW_TAG_imported_declaration:
+		if (ellipsis)
+			return "imported_declaration";
+		else
+			return "DW_TAG_imported_declaration";
+	case DW_TAG_label:
+		if (ellipsis)
+			return "label";
+		else
+			return "DW_TAG_label";
+	case DW_TAG_lexical_block:
+		if (ellipsis)
+			return "lexical_block";
+		else
+			return "DW_TAG_lexical_block";
+	case DW_TAG_member:
+		if (ellipsis)
+			return "member";
+		else
+			return "DW_TAG_member";
+	case DW_TAG_pointer_type:
+		if (ellipsis)
+			return "pointer_type";
+		else
+			return "DW_TAG_pointer_type";
+	case DW_TAG_reference_type:
+		if (ellipsis)
+			return "reference_type";
+		else
+			return "DW_TAG_reference_type";
+	case DW_TAG_compile_unit:
+		if (ellipsis)
+			return "compile_unit";
+		else
+			return "DW_TAG_compile_unit";
+	case DW_TAG_string_type:
+		if (ellipsis)
+			return "string_type";
+		else
+			return "DW_TAG_string_type";
+	case DW_TAG_structure_type:
+		if (ellipsis)
+			return "structure_type";
+		else
+			return "DW_TAG_structure_type";
+	case DW_TAG_subroutine_type:
+		if (ellipsis)
+			return "subroutine_type";
+		else
+			return "DW_TAG_subroutine_type";
+	case DW_TAG_typedef:
+		if (ellipsis)
+			return "typedef";
+		else
+			return "DW_TAG_typedef";
+	case DW_TAG_union_type:
+		if (ellipsis)
+			return "union_type";
+		else
+			return "DW_TAG_union_type";
+	case DW_TAG_unspecified_parameters:
+		if (ellipsis)
+			return "unspecified_parameters";
+		else
+			return "DW_TAG_unspecified_parameters";
+	case DW_TAG_variant:
+		if (ellipsis)
+			return "variant";
+		else
+			return "DW_TAG_variant";
+	case DW_TAG_common_block:
+		if (ellipsis)
+			return "common_block";
+		else
+			return "DW_TAG_common_block";
+	case DW_TAG_common_inclusion:
+		if (ellipsis)
+			return "common_inclusion";
+		else
+			return "DW_TAG_common_inclusion";
+	case DW_TAG_inheritance:
+		if (ellipsis)
+			return "inheritance";
+		else
+			return "DW_TAG_inheritance";
+	case DW_TAG_inlined_subroutine:
+		if (ellipsis)
+			return "inlined_subroutine";
+		else
+			return "DW_TAG_inlined_subroutine";
+	case DW_TAG_module:
+		if (ellipsis)
+			return "module";
+		else
+			return "DW_TAG_module";
+	case DW_TAG_ptr_to_member_type:
+		if (ellipsis)
+			return "ptr_to_member_type";
+		else
+			return "DW_TAG_ptr_to_member_type";
+	case DW_TAG_set_type:
+		if (ellipsis)
+			return "set_type";
+		else
+			return "DW_TAG_set_type";
+	case DW_TAG_subrange_type:
+		if (ellipsis)
+			return "subrange_type";
+		else
+			return "DW_TAG_subrange_type";
+	case DW_TAG_with_stmt:
+		if (ellipsis)
+			return "with_stmt";
+		else
+			return "DW_TAG_with_stmt";
+	case DW_TAG_access_declaration:
+		if (ellipsis)
+			return "access_declaration";
+		else
+			return "DW_TAG_access_declaration";
+	case DW_TAG_base_type:
+		if (ellipsis)
+			return "base_type";
+		else
+			return "DW_TAG_base_type";
+	case DW_TAG_catch_block:
+		if (ellipsis)
+			return "catch_block";
+		else
+			return "DW_TAG_catch_block";
+	case DW_TAG_const_type:
+		if (ellipsis)
+			return "const_type";
+		else
+			return "DW_TAG_const_type";
+	case DW_TAG_constant:
+		if (ellipsis)
+			return "constant";
+		else
+			return "DW_TAG_constant";
+	case DW_TAG_enumerator:
+		if (ellipsis)
+			return "enumerator";
+		else
+			return "DW_TAG_enumerator";
+	case DW_TAG_file_type:
+		if (ellipsis)
+			return "file_type";
+		else
+			return "DW_TAG_file_type";
+	case DW_TAG_friend:
+		if (ellipsis)
+			return "friend";
+		else
+			return "DW_TAG_friend";
+	case DW_TAG_namelist:
+		if (ellipsis)
+			return "namelist";
+		else
+			return "DW_TAG_namelist";
+	case DW_TAG_namelist_item:
+		if (ellipsis)
+			return "namelist_item";
+		else
+			return "DW_TAG_namelist_item";
+	case DW_TAG_packed_type:
+		if (ellipsis)
+			return "packed_type";
+		else
+			return "DW_TAG_packed_type";
+	case DW_TAG_subprogram:
+		if (ellipsis)
+			return "subprogram";
+		else
+			return "DW_TAG_subprogram";
+	case DW_TAG_template_type_parameter:
+		if (ellipsis)
+			return "template_type_parameter";
+		else
+			return "DW_TAG_template_type_parameter";
+	case DW_TAG_template_value_parameter:
+		if (ellipsis)
+			return "template_value_parameter";
+		else
+			return "DW_TAG_template_value_parameter";
+	case DW_TAG_thrown_type:
+		if (ellipsis)
+			return "thrown_type";
+		else
+			return "DW_TAG_thrown_type";
+	case DW_TAG_try_block:
+		if (ellipsis)
+			return "try_block";
+		else
+			return "DW_TAG_try_block";
+	case DW_TAG_variant_part:
+		if (ellipsis)
+			return "variant_part";
+		else
+			return "DW_TAG_variant_part";
+	case DW_TAG_variable:
+		if (ellipsis)
+			return "variable";
+		else
+			return "DW_TAG_variable";
+	case DW_TAG_volatile_type:
+		if (ellipsis)
+			return "volatile_type";
+		else
+			return "DW_TAG_volatile_type";
+	case DW_TAG_dwarf_procedure:
+		if (ellipsis)
+			return "dwarf_procedure";
+		else
+			return "DW_TAG_dwarf_procedure";
+	case DW_TAG_restrict_type:
+		if (ellipsis)
+			return "restrict_type";
+		else
+			return "DW_TAG_restrict_type";
+	case DW_TAG_interface_type:
+		if (ellipsis)
+			return "interface_type";
+		else
+			return "DW_TAG_interface_type";
+	case DW_TAG_namespace:
+		if (ellipsis)
+			return "namespace";
+		else
+			return "DW_TAG_namespace";
+	case DW_TAG_imported_module:
+		if (ellipsis)
+			return "imported_module";
+		else
+			return "DW_TAG_imported_module";
+	case DW_TAG_unspecified_type:
+		if (ellipsis)
+			return "unspecified_type";
+		else
+			return "DW_TAG_unspecified_type";
+	case DW_TAG_partial_unit:
+		if (ellipsis)
+			return "partial_unit";
+		else
+			return "DW_TAG_partial_unit";
+	case DW_TAG_imported_unit:
+		if (ellipsis)
+			return "imported_unit";
+		else
+			return "DW_TAG_imported_unit";
+	case DW_TAG_mutable_type:
+		if (ellipsis)
+			return "mutable_type";
+		else
+			return "DW_TAG_mutable_type";
+	case DW_TAG_condition:
+		if (ellipsis)
+			return "condition";
+		else
+			return "DW_TAG_condition";
+	case DW_TAG_shared_type:
+		if (ellipsis)
+			return "shared_type";
+		else
+			return "DW_TAG_shared_type";
+	case DW_TAG_type_unit:
+		if (ellipsis)
+			return "type_unit";
+		else
+			return "DW_TAG_type_unit";
+	case DW_TAG_rvalue_reference_type:
+		if (ellipsis)
+			return "rvalue_reference_type";
+		else
+			return "DW_TAG_rvalue_reference_type";
+	case DW_TAG_template_alias:
+		if (ellipsis)
+			return "template_alias";
+		else
+			return "DW_TAG_template_alias";
+	case DW_TAG_lo_user:
+		if (ellipsis)
+			return "lo_user";
+		else
+			return "DW_TAG_lo_user";
+	case DW_TAG_MIPS_loop:
+		if (ellipsis)
+			return "MIPS_loop";
+		else
+			return "DW_TAG_MIPS_loop";
+	case DW_TAG_HP_array_descriptor:
+		if (ellipsis)
+			return "HP_array_descriptor";
+		else
+			return "DW_TAG_HP_array_descriptor";
+	case DW_TAG_format_label:
+		if (ellipsis)
+			return "format_label";
+		else
+			return "DW_TAG_format_label";
+	case DW_TAG_function_template:
+		if (ellipsis)
+			return "function_template";
+		else
+			return "DW_TAG_function_template";
+	case DW_TAG_class_template:
+		if (ellipsis)
+			return "class_template";
+		else
+			return "DW_TAG_class_template";
+	case DW_TAG_GNU_BINCL:
+		if (ellipsis)
+			return "GNU_BINCL";
+		else
+			return "DW_TAG_GNU_BINCL";
+	case DW_TAG_GNU_EINCL:
+		if (ellipsis)
+			return "GNU_EINCL";
+		else
+			return "DW_TAG_GNU_EINCL";
+	case DW_TAG_GNU_template_template_parameter:
+		if (ellipsis)
+			return "GNU_template_template_parameter";
+		else
+			return "DW_TAG_GNU_template_template_parameter";
+	case DW_TAG_GNU_template_parameter_pack:
+		if (ellipsis)
+			return "GNU_template_parameter_pack";
+		else
+			return "DW_TAG_GNU_template_parameter_pack";
+	case DW_TAG_GNU_formal_parameter_pack:
+		if (ellipsis)
+			return "GNU_formal_parameter_pack";
+		else
+			return "DW_TAG_GNU_formal_parameter_pack";
+	case DW_TAG_GNU_call_site:
+		if (ellipsis)
+			return "GNU_call_site";
+		else
+			return "DW_TAG_GNU_call_site";
+	case DW_TAG_GNU_call_site_parameter:
+		if (ellipsis)
+			return "GNU_call_site_parameter";
+		else
+			return "DW_TAG_GNU_call_site_parameter";
+	case DW_TAG_ALTIUM_circ_type:
+		if (ellipsis)
+			return "ALTIUM_circ_type";
+		else
+			return "DW_TAG_ALTIUM_circ_type";
+	case DW_TAG_ALTIUM_mwa_circ_type:
+		if (ellipsis)
+			return "ALTIUM_mwa_circ_type";
+		else
+			return "DW_TAG_ALTIUM_mwa_circ_type";
+	case DW_TAG_ALTIUM_rev_carry_type:
+		if (ellipsis)
+			return "ALTIUM_rev_carry_type";
+		else
+			return "DW_TAG_ALTIUM_rev_carry_type";
+	case DW_TAG_ALTIUM_rom:
+		if (ellipsis)
+			return "ALTIUM_rom";
+		else
+			return "DW_TAG_ALTIUM_rom";
+	case DW_TAG_upc_shared_type:
+		if (ellipsis)
+			return "upc_shared_type";
+		else
+			return "DW_TAG_upc_shared_type";
+	case DW_TAG_upc_strict_type:
+		if (ellipsis)
+			return "upc_strict_type";
+		else
+			return "DW_TAG_upc_strict_type";
+	case DW_TAG_upc_relaxed_type:
+		if (ellipsis)
+			return "upc_relaxed_type";
+		else
+			return "DW_TAG_upc_relaxed_type";
+	case DW_TAG_PGI_kanji_type:
+		if (ellipsis)
+			return "PGI_kanji_type";
+		else
+			return "DW_TAG_PGI_kanji_type";
+	case DW_TAG_PGI_interface_block:
+		if (ellipsis)
+			return "PGI_interface_block";
+		else
+			return "DW_TAG_PGI_interface_block";
+	case DW_TAG_SUN_function_template:
+		if (ellipsis)
+			return "SUN_function_template";
+		else
+			return "DW_TAG_SUN_function_template";
+	case DW_TAG_SUN_class_template:
+		if (ellipsis)
+			return "SUN_class_template";
+		else
+			return "DW_TAG_SUN_class_template";
+	case DW_TAG_SUN_struct_template:
+		if (ellipsis)
+			return "SUN_struct_template";
+		else
+			return "DW_TAG_SUN_struct_template";
+	case DW_TAG_SUN_union_template:
+		if (ellipsis)
+			return "SUN_union_template";
+		else
+			return "DW_TAG_SUN_union_template";
+	case DW_TAG_SUN_indirect_inheritance:
+		if (ellipsis)
+			return "SUN_indirect_inheritance";
+		else
+			return "DW_TAG_SUN_indirect_inheritance";
+	case DW_TAG_SUN_codeflags:
+		if (ellipsis)
+			return "SUN_codeflags";
+		else
+			return "DW_TAG_SUN_codeflags";
+	case DW_TAG_SUN_memop_info:
+		if (ellipsis)
+			return "SUN_memop_info";
+		else
+			return "DW_TAG_SUN_memop_info";
+	case DW_TAG_SUN_omp_child_func:
+		if (ellipsis)
+			return "SUN_omp_child_func";
+		else
+			return "DW_TAG_SUN_omp_child_func";
+	case DW_TAG_SUN_rtti_descriptor:
+		if (ellipsis)
+			return "SUN_rtti_descriptor";
+		else
+			return "DW_TAG_SUN_rtti_descriptor";
+	case DW_TAG_SUN_dtor_info:
+		if (ellipsis)
+			return "SUN_dtor_info";
+		else
+			return "DW_TAG_SUN_dtor_info";
+	case DW_TAG_SUN_dtor:
+		if (ellipsis)
+			return "SUN_dtor";
+		else
+			return "DW_TAG_SUN_dtor";
+	case DW_TAG_SUN_f90_interface:
+		if (ellipsis)
+			return "SUN_f90_interface";
+		else
+			return "DW_TAG_SUN_f90_interface";
+	case DW_TAG_SUN_fortran_vax_structure:
+		if (ellipsis)
+			return "SUN_fortran_vax_structure";
+		else
+			return "DW_TAG_SUN_fortran_vax_structure";
+	case DW_TAG_SUN_hi:
+		if (ellipsis)
+			return "SUN_hi";
+		else
+			return "DW_TAG_SUN_hi";
+	case DW_TAG_hi_user:
+		if (ellipsis)
+			return "hi_user";
+		else
+			return "DW_TAG_hi_user";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown TAG value 0x%x>",(int)val);
+		 fprintf(stderr,"TAG of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_children_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_children_no:
+		if (ellipsis)
+			return "children_no";
+		else
+			return "DW_children_no";
+	case DW_children_yes:
+		if (ellipsis)
+			return "children_yes";
+		else
+			return "DW_children_yes";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown children value 0x%x>",(int)val);
+		 fprintf(stderr,"children of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_FORM_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_FORM_addr:
+		if (ellipsis)
+			return "addr";
+		else
+			return "DW_FORM_addr";
+	case DW_FORM_block2:
+		if (ellipsis)
+			return "block2";
+		else
+			return "DW_FORM_block2";
+	case DW_FORM_block4:
+		if (ellipsis)
+			return "block4";
+		else
+			return "DW_FORM_block4";
+	case DW_FORM_data2:
+		if (ellipsis)
+			return "data2";
+		else
+			return "DW_FORM_data2";
+	case DW_FORM_data4:
+		if (ellipsis)
+			return "data4";
+		else
+			return "DW_FORM_data4";
+	case DW_FORM_data8:
+		if (ellipsis)
+			return "data8";
+		else
+			return "DW_FORM_data8";
+	case DW_FORM_string:
+		if (ellipsis)
+			return "string";
+		else
+			return "DW_FORM_string";
+	case DW_FORM_block:
+		if (ellipsis)
+			return "block";
+		else
+			return "DW_FORM_block";
+	case DW_FORM_block1:
+		if (ellipsis)
+			return "block1";
+		else
+			return "DW_FORM_block1";
+	case DW_FORM_data1:
+		if (ellipsis)
+			return "data1";
+		else
+			return "DW_FORM_data1";
+	case DW_FORM_flag:
+		if (ellipsis)
+			return "flag";
+		else
+			return "DW_FORM_flag";
+	case DW_FORM_sdata:
+		if (ellipsis)
+			return "sdata";
+		else
+			return "DW_FORM_sdata";
+	case DW_FORM_strp:
+		if (ellipsis)
+			return "strp";
+		else
+			return "DW_FORM_strp";
+	case DW_FORM_udata:
+		if (ellipsis)
+			return "udata";
+		else
+			return "DW_FORM_udata";
+	case DW_FORM_ref_addr:
+		if (ellipsis)
+			return "ref_addr";
+		else
+			return "DW_FORM_ref_addr";
+	case DW_FORM_ref1:
+		if (ellipsis)
+			return "ref1";
+		else
+			return "DW_FORM_ref1";
+	case DW_FORM_ref2:
+		if (ellipsis)
+			return "ref2";
+		else
+			return "DW_FORM_ref2";
+	case DW_FORM_ref4:
+		if (ellipsis)
+			return "ref4";
+		else
+			return "DW_FORM_ref4";
+	case DW_FORM_ref8:
+		if (ellipsis)
+			return "ref8";
+		else
+			return "DW_FORM_ref8";
+	case DW_FORM_ref_udata:
+		if (ellipsis)
+			return "ref_udata";
+		else
+			return "DW_FORM_ref_udata";
+	case DW_FORM_indirect:
+		if (ellipsis)
+			return "indirect";
+		else
+			return "DW_FORM_indirect";
+	case DW_FORM_sec_offset:
+		if (ellipsis)
+			return "sec_offset";
+		else
+			return "DW_FORM_sec_offset";
+	case DW_FORM_exprloc:
+		if (ellipsis)
+			return "exprloc";
+		else
+			return "DW_FORM_exprloc";
+	case DW_FORM_flag_present:
+		if (ellipsis)
+			return "flag_present";
+		else
+			return "DW_FORM_flag_present";
+	case DW_FORM_ref_sig8:
+		if (ellipsis)
+			return "ref_sig8";
+		else
+			return "DW_FORM_ref_sig8";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown FORM value 0x%x>",(int)val);
+		 fprintf(stderr,"FORM of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_AT_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_AT_sibling:
+		if (ellipsis)
+			return "sibling";
+		else
+			return "DW_AT_sibling";
+	case DW_AT_location:
+		if (ellipsis)
+			return "location";
+		else
+			return "DW_AT_location";
+	case DW_AT_name:
+		if (ellipsis)
+			return "name";
+		else
+			return "DW_AT_name";
+	case DW_AT_ordering:
+		if (ellipsis)
+			return "ordering";
+		else
+			return "DW_AT_ordering";
+	case DW_AT_subscr_data:
+		if (ellipsis)
+			return "subscr_data";
+		else
+			return "DW_AT_subscr_data";
+	case DW_AT_byte_size:
+		if (ellipsis)
+			return "byte_size";
+		else
+			return "DW_AT_byte_size";
+	case DW_AT_bit_offset:
+		if (ellipsis)
+			return "bit_offset";
+		else
+			return "DW_AT_bit_offset";
+	case DW_AT_bit_size:
+		if (ellipsis)
+			return "bit_size";
+		else
+			return "DW_AT_bit_size";
+	case DW_AT_element_list:
+		if (ellipsis)
+			return "element_list";
+		else
+			return "DW_AT_element_list";
+	case DW_AT_stmt_list:
+		if (ellipsis)
+			return "stmt_list";
+		else
+			return "DW_AT_stmt_list";
+	case DW_AT_low_pc:
+		if (ellipsis)
+			return "low_pc";
+		else
+			return "DW_AT_low_pc";
+	case DW_AT_high_pc:
+		if (ellipsis)
+			return "high_pc";
+		else
+			return "DW_AT_high_pc";
+	case DW_AT_language:
+		if (ellipsis)
+			return "language";
+		else
+			return "DW_AT_language";
+	case DW_AT_member:
+		if (ellipsis)
+			return "member";
+		else
+			return "DW_AT_member";
+	case DW_AT_discr:
+		if (ellipsis)
+			return "discr";
+		else
+			return "DW_AT_discr";
+	case DW_AT_discr_value:
+		if (ellipsis)
+			return "discr_value";
+		else
+			return "DW_AT_discr_value";
+	case DW_AT_visibility:
+		if (ellipsis)
+			return "visibility";
+		else
+			return "DW_AT_visibility";
+	case DW_AT_import:
+		if (ellipsis)
+			return "import";
+		else
+			return "DW_AT_import";
+	case DW_AT_string_length:
+		if (ellipsis)
+			return "string_length";
+		else
+			return "DW_AT_string_length";
+	case DW_AT_common_reference:
+		if (ellipsis)
+			return "common_reference";
+		else
+			return "DW_AT_common_reference";
+	case DW_AT_comp_dir:
+		if (ellipsis)
+			return "comp_dir";
+		else
+			return "DW_AT_comp_dir";
+	case DW_AT_const_value:
+		if (ellipsis)
+			return "const_value";
+		else
+			return "DW_AT_const_value";
+	case DW_AT_containing_type:
+		if (ellipsis)
+			return "containing_type";
+		else
+			return "DW_AT_containing_type";
+	case DW_AT_default_value:
+		if (ellipsis)
+			return "default_value";
+		else
+			return "DW_AT_default_value";
+	case DW_AT_inline:
+		if (ellipsis)
+			return "inline";
+		else
+			return "DW_AT_inline";
+	case DW_AT_is_optional:
+		if (ellipsis)
+			return "is_optional";
+		else
+			return "DW_AT_is_optional";
+	case DW_AT_lower_bound:
+		if (ellipsis)
+			return "lower_bound";
+		else
+			return "DW_AT_lower_bound";
+	case DW_AT_producer:
+		if (ellipsis)
+			return "producer";
+		else
+			return "DW_AT_producer";
+	case DW_AT_prototyped:
+		if (ellipsis)
+			return "prototyped";
+		else
+			return "DW_AT_prototyped";
+	case DW_AT_return_addr:
+		if (ellipsis)
+			return "return_addr";
+		else
+			return "DW_AT_return_addr";
+	case DW_AT_start_scope:
+		if (ellipsis)
+			return "start_scope";
+		else
+			return "DW_AT_start_scope";
+	case DW_AT_bit_stride:
+		if (ellipsis)
+			return "bit_stride";
+		else
+			return "DW_AT_bit_stride";
+	case DW_AT_upper_bound:
+		if (ellipsis)
+			return "upper_bound";
+		else
+			return "DW_AT_upper_bound";
+	case DW_AT_abstract_origin:
+		if (ellipsis)
+			return "abstract_origin";
+		else
+			return "DW_AT_abstract_origin";
+	case DW_AT_accessibility:
+		if (ellipsis)
+			return "accessibility";
+		else
+			return "DW_AT_accessibility";
+	case DW_AT_address_class:
+		if (ellipsis)
+			return "address_class";
+		else
+			return "DW_AT_address_class";
+	case DW_AT_artificial:
+		if (ellipsis)
+			return "artificial";
+		else
+			return "DW_AT_artificial";
+	case DW_AT_base_types:
+		if (ellipsis)
+			return "base_types";
+		else
+			return "DW_AT_base_types";
+	case DW_AT_calling_convention:
+		if (ellipsis)
+			return "calling_convention";
+		else
+			return "DW_AT_calling_convention";
+	case DW_AT_count:
+		if (ellipsis)
+			return "count";
+		else
+			return "DW_AT_count";
+	case DW_AT_data_member_location:
+		if (ellipsis)
+			return "data_member_location";
+		else
+			return "DW_AT_data_member_location";
+	case DW_AT_decl_column:
+		if (ellipsis)
+			return "decl_column";
+		else
+			return "DW_AT_decl_column";
+	case DW_AT_decl_file:
+		if (ellipsis)
+			return "decl_file";
+		else
+			return "DW_AT_decl_file";
+	case DW_AT_decl_line:
+		if (ellipsis)
+			return "decl_line";
+		else
+			return "DW_AT_decl_line";
+	case DW_AT_declaration:
+		if (ellipsis)
+			return "declaration";
+		else
+			return "DW_AT_declaration";
+	case DW_AT_discr_list:
+		if (ellipsis)
+			return "discr_list";
+		else
+			return "DW_AT_discr_list";
+	case DW_AT_encoding:
+		if (ellipsis)
+			return "encoding";
+		else
+			return "DW_AT_encoding";
+	case DW_AT_external:
+		if (ellipsis)
+			return "external";
+		else
+			return "DW_AT_external";
+	case DW_AT_frame_base:
+		if (ellipsis)
+			return "frame_base";
+		else
+			return "DW_AT_frame_base";
+	case DW_AT_friend:
+		if (ellipsis)
+			return "friend";
+		else
+			return "DW_AT_friend";
+	case DW_AT_identifier_case:
+		if (ellipsis)
+			return "identifier_case";
+		else
+			return "DW_AT_identifier_case";
+	case DW_AT_macro_info:
+		if (ellipsis)
+			return "macro_info";
+		else
+			return "DW_AT_macro_info";
+	case DW_AT_namelist_item:
+		if (ellipsis)
+			return "namelist_item";
+		else
+			return "DW_AT_namelist_item";
+	case DW_AT_priority:
+		if (ellipsis)
+			return "priority";
+		else
+			return "DW_AT_priority";
+	case DW_AT_segment:
+		if (ellipsis)
+			return "segment";
+		else
+			return "DW_AT_segment";
+	case DW_AT_specification:
+		if (ellipsis)
+			return "specification";
+		else
+			return "DW_AT_specification";
+	case DW_AT_static_link:
+		if (ellipsis)
+			return "static_link";
+		else
+			return "DW_AT_static_link";
+	case DW_AT_type:
+		if (ellipsis)
+			return "type";
+		else
+			return "DW_AT_type";
+	case DW_AT_use_location:
+		if (ellipsis)
+			return "use_location";
+		else
+			return "DW_AT_use_location";
+	case DW_AT_variable_parameter:
+		if (ellipsis)
+			return "variable_parameter";
+		else
+			return "DW_AT_variable_parameter";
+	case DW_AT_virtuality:
+		if (ellipsis)
+			return "virtuality";
+		else
+			return "DW_AT_virtuality";
+	case DW_AT_vtable_elem_location:
+		if (ellipsis)
+			return "vtable_elem_location";
+		else
+			return "DW_AT_vtable_elem_location";
+	case DW_AT_allocated:
+		if (ellipsis)
+			return "allocated";
+		else
+			return "DW_AT_allocated";
+	case DW_AT_associated:
+		if (ellipsis)
+			return "associated";
+		else
+			return "DW_AT_associated";
+	case DW_AT_data_location:
+		if (ellipsis)
+			return "data_location";
+		else
+			return "DW_AT_data_location";
+	case DW_AT_byte_stride:
+		if (ellipsis)
+			return "byte_stride";
+		else
+			return "DW_AT_byte_stride";
+	case DW_AT_entry_pc:
+		if (ellipsis)
+			return "entry_pc";
+		else
+			return "DW_AT_entry_pc";
+	case DW_AT_use_UTF8:
+		if (ellipsis)
+			return "use_UTF8";
+		else
+			return "DW_AT_use_UTF8";
+	case DW_AT_extension:
+		if (ellipsis)
+			return "extension";
+		else
+			return "DW_AT_extension";
+	case DW_AT_ranges:
+		if (ellipsis)
+			return "ranges";
+		else
+			return "DW_AT_ranges";
+	case DW_AT_trampoline:
+		if (ellipsis)
+			return "trampoline";
+		else
+			return "DW_AT_trampoline";
+	case DW_AT_call_column:
+		if (ellipsis)
+			return "call_column";
+		else
+			return "DW_AT_call_column";
+	case DW_AT_call_file:
+		if (ellipsis)
+			return "call_file";
+		else
+			return "DW_AT_call_file";
+	case DW_AT_call_line:
+		if (ellipsis)
+			return "call_line";
+		else
+			return "DW_AT_call_line";
+	case DW_AT_description:
+		if (ellipsis)
+			return "description";
+		else
+			return "DW_AT_description";
+	case DW_AT_binary_scale:
+		if (ellipsis)
+			return "binary_scale";
+		else
+			return "DW_AT_binary_scale";
+	case DW_AT_decimal_scale:
+		if (ellipsis)
+			return "decimal_scale";
+		else
+			return "DW_AT_decimal_scale";
+	case DW_AT_small:
+		if (ellipsis)
+			return "small";
+		else
+			return "DW_AT_small";
+	case DW_AT_decimal_sign:
+		if (ellipsis)
+			return "decimal_sign";
+		else
+			return "DW_AT_decimal_sign";
+	case DW_AT_digit_count:
+		if (ellipsis)
+			return "digit_count";
+		else
+			return "DW_AT_digit_count";
+	case DW_AT_picture_string:
+		if (ellipsis)
+			return "picture_string";
+		else
+			return "DW_AT_picture_string";
+	case DW_AT_mutable:
+		if (ellipsis)
+			return "mutable";
+		else
+			return "DW_AT_mutable";
+	case DW_AT_threads_scaled:
+		if (ellipsis)
+			return "threads_scaled";
+		else
+			return "DW_AT_threads_scaled";
+	case DW_AT_explicit:
+		if (ellipsis)
+			return "explicit";
+		else
+			return "DW_AT_explicit";
+	case DW_AT_object_pointer:
+		if (ellipsis)
+			return "object_pointer";
+		else
+			return "DW_AT_object_pointer";
+	case DW_AT_endianity:
+		if (ellipsis)
+			return "endianity";
+		else
+			return "DW_AT_endianity";
+	case DW_AT_elemental:
+		if (ellipsis)
+			return "elemental";
+		else
+			return "DW_AT_elemental";
+	case DW_AT_pure:
+		if (ellipsis)
+			return "pure";
+		else
+			return "DW_AT_pure";
+	case DW_AT_recursive:
+		if (ellipsis)
+			return "recursive";
+		else
+			return "DW_AT_recursive";
+	case DW_AT_signature:
+		if (ellipsis)
+			return "signature";
+		else
+			return "DW_AT_signature";
+	case DW_AT_main_subprogram:
+		if (ellipsis)
+			return "main_subprogram";
+		else
+			return "DW_AT_main_subprogram";
+	case DW_AT_data_bit_offset:
+		if (ellipsis)
+			return "data_bit_offset";
+		else
+			return "DW_AT_data_bit_offset";
+	case DW_AT_const_expr:
+		if (ellipsis)
+			return "const_expr";
+		else
+			return "DW_AT_const_expr";
+	case DW_AT_enum_class:
+		if (ellipsis)
+			return "enum_class";
+		else
+			return "DW_AT_enum_class";
+	case DW_AT_linkage_name:
+		if (ellipsis)
+			return "linkage_name";
+		else
+			return "DW_AT_linkage_name";
+	case DW_AT_HP_block_index:
+		if (ellipsis)
+			return "HP_block_index";
+		else
+			return "DW_AT_HP_block_index";
+	case DW_AT_MIPS_fde:
+		if (ellipsis)
+			return "MIPS_fde";
+		else
+			return "DW_AT_MIPS_fde";
+	case DW_AT_MIPS_loop_begin:
+		if (ellipsis)
+			return "MIPS_loop_begin";
+		else
+			return "DW_AT_MIPS_loop_begin";
+	case DW_AT_MIPS_tail_loop_begin:
+		if (ellipsis)
+			return "MIPS_tail_loop_begin";
+		else
+			return "DW_AT_MIPS_tail_loop_begin";
+	case DW_AT_MIPS_epilog_begin:
+		if (ellipsis)
+			return "MIPS_epilog_begin";
+		else
+			return "DW_AT_MIPS_epilog_begin";
+	case DW_AT_MIPS_loop_unroll_factor:
+		if (ellipsis)
+			return "MIPS_loop_unroll_factor";
+		else
+			return "DW_AT_MIPS_loop_unroll_factor";
+	case DW_AT_MIPS_software_pipeline_depth:
+		if (ellipsis)
+			return "MIPS_software_pipeline_depth";
+		else
+			return "DW_AT_MIPS_software_pipeline_depth";
+	case DW_AT_MIPS_linkage_name:
+		if (ellipsis)
+			return "MIPS_linkage_name";
+		else
+			return "DW_AT_MIPS_linkage_name";
+	case DW_AT_MIPS_stride:
+		if (ellipsis)
+			return "MIPS_stride";
+		else
+			return "DW_AT_MIPS_stride";
+	case DW_AT_MIPS_abstract_name:
+		if (ellipsis)
+			return "MIPS_abstract_name";
+		else
+			return "DW_AT_MIPS_abstract_name";
+	case DW_AT_MIPS_clone_origin:
+		if (ellipsis)
+			return "MIPS_clone_origin";
+		else
+			return "DW_AT_MIPS_clone_origin";
+	case DW_AT_MIPS_has_inlines:
+		if (ellipsis)
+			return "MIPS_has_inlines";
+		else
+			return "DW_AT_MIPS_has_inlines";
+	case DW_AT_MIPS_stride_byte:
+		if (ellipsis)
+			return "MIPS_stride_byte";
+		else
+			return "DW_AT_MIPS_stride_byte";
+	case DW_AT_MIPS_stride_elem:
+		if (ellipsis)
+			return "MIPS_stride_elem";
+		else
+			return "DW_AT_MIPS_stride_elem";
+	case DW_AT_MIPS_ptr_dopetype:
+		if (ellipsis)
+			return "MIPS_ptr_dopetype";
+		else
+			return "DW_AT_MIPS_ptr_dopetype";
+	case DW_AT_MIPS_allocatable_dopetype:
+		if (ellipsis)
+			return "MIPS_allocatable_dopetype";
+		else
+			return "DW_AT_MIPS_allocatable_dopetype";
+	case DW_AT_MIPS_assumed_shape_dopetype:
+		if (ellipsis)
+			return "MIPS_assumed_shape_dopetype";
+		else
+			return "DW_AT_MIPS_assumed_shape_dopetype";
+	case DW_AT_MIPS_assumed_size:
+		if (ellipsis)
+			return "MIPS_assumed_size";
+		else
+			return "DW_AT_MIPS_assumed_size";
+	case DW_AT_HP_raw_data_ptr:
+		if (ellipsis)
+			return "HP_raw_data_ptr";
+		else
+			return "DW_AT_HP_raw_data_ptr";
+	case DW_AT_HP_pass_by_reference:
+		if (ellipsis)
+			return "HP_pass_by_reference";
+		else
+			return "DW_AT_HP_pass_by_reference";
+	case DW_AT_HP_opt_level:
+		if (ellipsis)
+			return "HP_opt_level";
+		else
+			return "DW_AT_HP_opt_level";
+	case DW_AT_HP_prof_version_id:
+		if (ellipsis)
+			return "HP_prof_version_id";
+		else
+			return "DW_AT_HP_prof_version_id";
+	case DW_AT_HP_opt_flags:
+		if (ellipsis)
+			return "HP_opt_flags";
+		else
+			return "DW_AT_HP_opt_flags";
+	case DW_AT_HP_cold_region_low_pc:
+		if (ellipsis)
+			return "HP_cold_region_low_pc";
+		else
+			return "DW_AT_HP_cold_region_low_pc";
+	case DW_AT_HP_cold_region_high_pc:
+		if (ellipsis)
+			return "HP_cold_region_high_pc";
+		else
+			return "DW_AT_HP_cold_region_high_pc";
+	case DW_AT_HP_all_variables_modifiable:
+		if (ellipsis)
+			return "HP_all_variables_modifiable";
+		else
+			return "DW_AT_HP_all_variables_modifiable";
+	case DW_AT_HP_linkage_name:
+		if (ellipsis)
+			return "HP_linkage_name";
+		else
+			return "DW_AT_HP_linkage_name";
+	case DW_AT_HP_prof_flags:
+		if (ellipsis)
+			return "HP_prof_flags";
+		else
+			return "DW_AT_HP_prof_flags";
+	case DW_AT_INTEL_other_endian:
+		if (ellipsis)
+			return "INTEL_other_endian";
+		else
+			return "DW_AT_INTEL_other_endian";
+	case DW_AT_sf_names:
+		if (ellipsis)
+			return "sf_names";
+		else
+			return "DW_AT_sf_names";
+	case DW_AT_src_info:
+		if (ellipsis)
+			return "src_info";
+		else
+			return "DW_AT_src_info";
+	case DW_AT_mac_info:
+		if (ellipsis)
+			return "mac_info";
+		else
+			return "DW_AT_mac_info";
+	case DW_AT_src_coords:
+		if (ellipsis)
+			return "src_coords";
+		else
+			return "DW_AT_src_coords";
+	case DW_AT_body_begin:
+		if (ellipsis)
+			return "body_begin";
+		else
+			return "DW_AT_body_begin";
+	case DW_AT_body_end:
+		if (ellipsis)
+			return "body_end";
+		else
+			return "DW_AT_body_end";
+	case DW_AT_GNU_vector:
+		if (ellipsis)
+			return "GNU_vector";
+		else
+			return "DW_AT_GNU_vector";
+	case DW_AT_GNU_guarded_by:
+		if (ellipsis)
+			return "GNU_guarded_by";
+		else
+			return "DW_AT_GNU_guarded_by";
+	case DW_AT_GNU_pt_guarded_by:
+		if (ellipsis)
+			return "GNU_pt_guarded_by";
+		else
+			return "DW_AT_GNU_pt_guarded_by";
+	case DW_AT_GNU_guarded:
+		if (ellipsis)
+			return "GNU_guarded";
+		else
+			return "DW_AT_GNU_guarded";
+	case DW_AT_GNU_pt_guarded:
+		if (ellipsis)
+			return "GNU_pt_guarded";
+		else
+			return "DW_AT_GNU_pt_guarded";
+	case DW_AT_GNU_locks_excluded:
+		if (ellipsis)
+			return "GNU_locks_excluded";
+		else
+			return "DW_AT_GNU_locks_excluded";
+	case DW_AT_GNU_exclusive_locks_required:
+		if (ellipsis)
+			return "GNU_exclusive_locks_required";
+		else
+			return "DW_AT_GNU_exclusive_locks_required";
+	case DW_AT_GNU_shared_locks_required:
+		if (ellipsis)
+			return "GNU_shared_locks_required";
+		else
+			return "DW_AT_GNU_shared_locks_required";
+	case DW_AT_GNU_odr_signature:
+		if (ellipsis)
+			return "GNU_odr_signature";
+		else
+			return "DW_AT_GNU_odr_signature";
+	case DW_AT_GNU_template_name:
+		if (ellipsis)
+			return "GNU_template_name";
+		else
+			return "DW_AT_GNU_template_name";
+	case DW_AT_GNU_call_site_value:
+		if (ellipsis)
+			return "GNU_call_site_value";
+		else
+			return "DW_AT_GNU_call_site_value";
+	case DW_AT_GNU_call_site_data_value:
+		if (ellipsis)
+			return "GNU_call_site_data_value";
+		else
+			return "DW_AT_GNU_call_site_data_value";
+	case DW_AT_GNU_call_site_target:
+		if (ellipsis)
+			return "GNU_call_site_target";
+		else
+			return "DW_AT_GNU_call_site_target";
+	case DW_AT_GNU_call_site_target_clobbered:
+		if (ellipsis)
+			return "GNU_call_site_target_clobbered";
+		else
+			return "DW_AT_GNU_call_site_target_clobbered";
+	case DW_AT_GNU_tail_call:
+		if (ellipsis)
+			return "GNU_tail_call";
+		else
+			return "DW_AT_GNU_tail_call";
+	case DW_AT_GNU_all_tail_call_sites:
+		if (ellipsis)
+			return "GNU_all_tail_call_sites";
+		else
+			return "DW_AT_GNU_all_tail_call_sites";
+	case DW_AT_GNU_all_call_sites:
+		if (ellipsis)
+			return "GNU_all_call_sites";
+		else
+			return "DW_AT_GNU_all_call_sites";
+	case DW_AT_GNU_all_source_call_sites:
+		if (ellipsis)
+			return "GNU_all_source_call_sites";
+		else
+			return "DW_AT_GNU_all_source_call_sites";
+	case DW_AT_ALTIUM_loclist:
+		if (ellipsis)
+			return "ALTIUM_loclist";
+		else
+			return "DW_AT_ALTIUM_loclist";
+	case DW_AT_SUN_template:
+		if (ellipsis)
+			return "SUN_template";
+		else
+			return "DW_AT_SUN_template";
+	case DW_AT_SUN_alignment:
+		if (ellipsis)
+			return "SUN_alignment";
+		else
+			return "DW_AT_SUN_alignment";
+	case DW_AT_SUN_vtable:
+		if (ellipsis)
+			return "SUN_vtable";
+		else
+			return "DW_AT_SUN_vtable";
+	case DW_AT_SUN_count_guarantee:
+		if (ellipsis)
+			return "SUN_count_guarantee";
+		else
+			return "DW_AT_SUN_count_guarantee";
+	case DW_AT_SUN_command_line:
+		if (ellipsis)
+			return "SUN_command_line";
+		else
+			return "DW_AT_SUN_command_line";
+	case DW_AT_SUN_vbase:
+		if (ellipsis)
+			return "SUN_vbase";
+		else
+			return "DW_AT_SUN_vbase";
+	case DW_AT_SUN_compile_options:
+		if (ellipsis)
+			return "SUN_compile_options";
+		else
+			return "DW_AT_SUN_compile_options";
+	case DW_AT_SUN_language:
+		if (ellipsis)
+			return "SUN_language";
+		else
+			return "DW_AT_SUN_language";
+	case DW_AT_SUN_browser_file:
+		if (ellipsis)
+			return "SUN_browser_file";
+		else
+			return "DW_AT_SUN_browser_file";
+	case DW_AT_SUN_vtable_abi:
+		if (ellipsis)
+			return "SUN_vtable_abi";
+		else
+			return "DW_AT_SUN_vtable_abi";
+	case DW_AT_SUN_func_offsets:
+		if (ellipsis)
+			return "SUN_func_offsets";
+		else
+			return "DW_AT_SUN_func_offsets";
+	case DW_AT_SUN_cf_kind:
+		if (ellipsis)
+			return "SUN_cf_kind";
+		else
+			return "DW_AT_SUN_cf_kind";
+	case DW_AT_SUN_vtable_index:
+		if (ellipsis)
+			return "SUN_vtable_index";
+		else
+			return "DW_AT_SUN_vtable_index";
+	case DW_AT_SUN_omp_tpriv_addr:
+		if (ellipsis)
+			return "SUN_omp_tpriv_addr";
+		else
+			return "DW_AT_SUN_omp_tpriv_addr";
+	case DW_AT_SUN_omp_child_func:
+		if (ellipsis)
+			return "SUN_omp_child_func";
+		else
+			return "DW_AT_SUN_omp_child_func";
+	case DW_AT_SUN_func_offset:
+		if (ellipsis)
+			return "SUN_func_offset";
+		else
+			return "DW_AT_SUN_func_offset";
+	case DW_AT_SUN_memop_type_ref:
+		if (ellipsis)
+			return "SUN_memop_type_ref";
+		else
+			return "DW_AT_SUN_memop_type_ref";
+	case DW_AT_SUN_profile_id:
+		if (ellipsis)
+			return "SUN_profile_id";
+		else
+			return "DW_AT_SUN_profile_id";
+	case DW_AT_SUN_memop_signature:
+		if (ellipsis)
+			return "SUN_memop_signature";
+		else
+			return "DW_AT_SUN_memop_signature";
+	case DW_AT_SUN_obj_dir:
+		if (ellipsis)
+			return "SUN_obj_dir";
+		else
+			return "DW_AT_SUN_obj_dir";
+	case DW_AT_SUN_obj_file:
+		if (ellipsis)
+			return "SUN_obj_file";
+		else
+			return "DW_AT_SUN_obj_file";
+	case DW_AT_SUN_original_name:
+		if (ellipsis)
+			return "SUN_original_name";
+		else
+			return "DW_AT_SUN_original_name";
+	case DW_AT_SUN_hwcprof_signature:
+		if (ellipsis)
+			return "SUN_hwcprof_signature";
+		else
+			return "DW_AT_SUN_hwcprof_signature";
+	case DW_AT_SUN_amd64_parmdump:
+		if (ellipsis)
+			return "SUN_amd64_parmdump";
+		else
+			return "DW_AT_SUN_amd64_parmdump";
+	case DW_AT_SUN_part_link_name:
+		if (ellipsis)
+			return "SUN_part_link_name";
+		else
+			return "DW_AT_SUN_part_link_name";
+	case DW_AT_SUN_link_name:
+		if (ellipsis)
+			return "SUN_link_name";
+		else
+			return "DW_AT_SUN_link_name";
+	case DW_AT_SUN_pass_with_const:
+		if (ellipsis)
+			return "SUN_pass_with_const";
+		else
+			return "DW_AT_SUN_pass_with_const";
+	case DW_AT_SUN_return_with_const:
+		if (ellipsis)
+			return "SUN_return_with_const";
+		else
+			return "DW_AT_SUN_return_with_const";
+	case DW_AT_SUN_import_by_name:
+		if (ellipsis)
+			return "SUN_import_by_name";
+		else
+			return "DW_AT_SUN_import_by_name";
+	case DW_AT_SUN_f90_pointer:
+		if (ellipsis)
+			return "SUN_f90_pointer";
+		else
+			return "DW_AT_SUN_f90_pointer";
+	case DW_AT_SUN_pass_by_ref:
+		if (ellipsis)
+			return "SUN_pass_by_ref";
+		else
+			return "DW_AT_SUN_pass_by_ref";
+	case DW_AT_SUN_f90_allocatable:
+		if (ellipsis)
+			return "SUN_f90_allocatable";
+		else
+			return "DW_AT_SUN_f90_allocatable";
+	case DW_AT_SUN_f90_assumed_shape_array:
+		if (ellipsis)
+			return "SUN_f90_assumed_shape_array";
+		else
+			return "DW_AT_SUN_f90_assumed_shape_array";
+	case DW_AT_SUN_c_vla:
+		if (ellipsis)
+			return "SUN_c_vla";
+		else
+			return "DW_AT_SUN_c_vla";
+	case DW_AT_SUN_return_value_ptr:
+		if (ellipsis)
+			return "SUN_return_value_ptr";
+		else
+			return "DW_AT_SUN_return_value_ptr";
+	case DW_AT_SUN_dtor_start:
+		if (ellipsis)
+			return "SUN_dtor_start";
+		else
+			return "DW_AT_SUN_dtor_start";
+	case DW_AT_SUN_dtor_length:
+		if (ellipsis)
+			return "SUN_dtor_length";
+		else
+			return "DW_AT_SUN_dtor_length";
+	case DW_AT_SUN_dtor_state_initial:
+		if (ellipsis)
+			return "SUN_dtor_state_initial";
+		else
+			return "DW_AT_SUN_dtor_state_initial";
+	case DW_AT_SUN_dtor_state_final:
+		if (ellipsis)
+			return "SUN_dtor_state_final";
+		else
+			return "DW_AT_SUN_dtor_state_final";
+	case DW_AT_SUN_dtor_state_deltas:
+		if (ellipsis)
+			return "SUN_dtor_state_deltas";
+		else
+			return "DW_AT_SUN_dtor_state_deltas";
+	case DW_AT_SUN_import_by_lname:
+		if (ellipsis)
+			return "SUN_import_by_lname";
+		else
+			return "DW_AT_SUN_import_by_lname";
+	case DW_AT_SUN_f90_use_only:
+		if (ellipsis)
+			return "SUN_f90_use_only";
+		else
+			return "DW_AT_SUN_f90_use_only";
+	case DW_AT_SUN_namelist_spec:
+		if (ellipsis)
+			return "SUN_namelist_spec";
+		else
+			return "DW_AT_SUN_namelist_spec";
+	case DW_AT_SUN_is_omp_child_func:
+		if (ellipsis)
+			return "SUN_is_omp_child_func";
+		else
+			return "DW_AT_SUN_is_omp_child_func";
+	case DW_AT_SUN_fortran_main_alias:
+		if (ellipsis)
+			return "SUN_fortran_main_alias";
+		else
+			return "DW_AT_SUN_fortran_main_alias";
+	case DW_AT_SUN_fortran_based:
+		if (ellipsis)
+			return "SUN_fortran_based";
+		else
+			return "DW_AT_SUN_fortran_based";
+	case DW_AT_use_GNAT_descriptive_type:
+		if (ellipsis)
+			return "use_GNAT_descriptive_type";
+		else
+			return "DW_AT_use_GNAT_descriptive_type";
+	case DW_AT_GNAT_descriptive_type:
+		if (ellipsis)
+			return "GNAT_descriptive_type";
+		else
+			return "DW_AT_GNAT_descriptive_type";
+	case DW_AT_upc_threads_scaled:
+		if (ellipsis)
+			return "upc_threads_scaled";
+		else
+			return "DW_AT_upc_threads_scaled";
+	case DW_AT_PGI_lbase:
+		if (ellipsis)
+			return "PGI_lbase";
+		else
+			return "DW_AT_PGI_lbase";
+	case DW_AT_PGI_soffset:
+		if (ellipsis)
+			return "PGI_soffset";
+		else
+			return "DW_AT_PGI_soffset";
+	case DW_AT_PGI_lstride:
+		if (ellipsis)
+			return "PGI_lstride";
+		else
+			return "DW_AT_PGI_lstride";
+	case DW_AT_APPLE_optimized:
+		if (ellipsis)
+			return "APPLE_optimized";
+		else
+			return "DW_AT_APPLE_optimized";
+	case DW_AT_APPLE_flags:
+		if (ellipsis)
+			return "APPLE_flags";
+		else
+			return "DW_AT_APPLE_flags";
+	case DW_AT_APPLE_isa:
+		if (ellipsis)
+			return "APPLE_isa";
+		else
+			return "DW_AT_APPLE_isa";
+	case DW_AT_APPLE_block:
+		if (ellipsis)
+			return "APPLE_block";
+		else
+			return "DW_AT_APPLE_block";
+	case DW_AT_APPLE_major_runtime_vers:
+		if (ellipsis)
+			return "APPLE_major_runtime_vers";
+		else
+			return "DW_AT_APPLE_major_runtime_vers";
+	case DW_AT_APPLE_runtime_class:
+		if (ellipsis)
+			return "APPLE_runtime_class";
+		else
+			return "DW_AT_APPLE_runtime_class";
+	case DW_AT_APPLE_omit_frame_ptr:
+		if (ellipsis)
+			return "APPLE_omit_frame_ptr";
+		else
+			return "DW_AT_APPLE_omit_frame_ptr";
+	case DW_AT_hi_user:
+		if (ellipsis)
+			return "hi_user";
+		else
+			return "DW_AT_hi_user";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown AT value 0x%x>",(int)val);
+		 fprintf(stderr,"AT of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_OP_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_OP_addr:
+		if (ellipsis)
+			return "addr";
+		else
+			return "DW_OP_addr";
+	case DW_OP_deref:
+		if (ellipsis)
+			return "deref";
+		else
+			return "DW_OP_deref";
+	case DW_OP_const1u:
+		if (ellipsis)
+			return "const1u";
+		else
+			return "DW_OP_const1u";
+	case DW_OP_const1s:
+		if (ellipsis)
+			return "const1s";
+		else
+			return "DW_OP_const1s";
+	case DW_OP_const2u:
+		if (ellipsis)
+			return "const2u";
+		else
+			return "DW_OP_const2u";
+	case DW_OP_const2s:
+		if (ellipsis)
+			return "const2s";
+		else
+			return "DW_OP_const2s";
+	case DW_OP_const4u:
+		if (ellipsis)
+			return "const4u";
+		else
+			return "DW_OP_const4u";
+	case DW_OP_const4s:
+		if (ellipsis)
+			return "const4s";
+		else
+			return "DW_OP_const4s";
+	case DW_OP_const8u:
+		if (ellipsis)
+			return "const8u";
+		else
+			return "DW_OP_const8u";
+	case DW_OP_const8s:
+		if (ellipsis)
+			return "const8s";
+		else
+			return "DW_OP_const8s";
+	case DW_OP_constu:
+		if (ellipsis)
+			return "constu";
+		else
+			return "DW_OP_constu";
+	case DW_OP_consts:
+		if (ellipsis)
+			return "consts";
+		else
+			return "DW_OP_consts";
+	case DW_OP_dup:
+		if (ellipsis)
+			return "dup";
+		else
+			return "DW_OP_dup";
+	case DW_OP_drop:
+		if (ellipsis)
+			return "drop";
+		else
+			return "DW_OP_drop";
+	case DW_OP_over:
+		if (ellipsis)
+			return "over";
+		else
+			return "DW_OP_over";
+	case DW_OP_pick:
+		if (ellipsis)
+			return "pick";
+		else
+			return "DW_OP_pick";
+	case DW_OP_swap:
+		if (ellipsis)
+			return "swap";
+		else
+			return "DW_OP_swap";
+	case DW_OP_rot:
+		if (ellipsis)
+			return "rot";
+		else
+			return "DW_OP_rot";
+	case DW_OP_xderef:
+		if (ellipsis)
+			return "xderef";
+		else
+			return "DW_OP_xderef";
+	case DW_OP_abs:
+		if (ellipsis)
+			return "abs";
+		else
+			return "DW_OP_abs";
+	case DW_OP_and:
+		if (ellipsis)
+			return "and";
+		else
+			return "DW_OP_and";
+	case DW_OP_div:
+		if (ellipsis)
+			return "div";
+		else
+			return "DW_OP_div";
+	case DW_OP_minus:
+		if (ellipsis)
+			return "minus";
+		else
+			return "DW_OP_minus";
+	case DW_OP_mod:
+		if (ellipsis)
+			return "mod";
+		else
+			return "DW_OP_mod";
+	case DW_OP_mul:
+		if (ellipsis)
+			return "mul";
+		else
+			return "DW_OP_mul";
+	case DW_OP_neg:
+		if (ellipsis)
+			return "neg";
+		else
+			return "DW_OP_neg";
+	case DW_OP_not:
+		if (ellipsis)
+			return "not";
+		else
+			return "DW_OP_not";
+	case DW_OP_or:
+		if (ellipsis)
+			return "or";
+		else
+			return "DW_OP_or";
+	case DW_OP_plus:
+		if (ellipsis)
+			return "plus";
+		else
+			return "DW_OP_plus";
+	case DW_OP_plus_uconst:
+		if (ellipsis)
+			return "plus_uconst";
+		else
+			return "DW_OP_plus_uconst";
+	case DW_OP_shl:
+		if (ellipsis)
+			return "shl";
+		else
+			return "DW_OP_shl";
+	case DW_OP_shr:
+		if (ellipsis)
+			return "shr";
+		else
+			return "DW_OP_shr";
+	case DW_OP_shra:
+		if (ellipsis)
+			return "shra";
+		else
+			return "DW_OP_shra";
+	case DW_OP_xor:
+		if (ellipsis)
+			return "xor";
+		else
+			return "DW_OP_xor";
+	case DW_OP_bra:
+		if (ellipsis)
+			return "bra";
+		else
+			return "DW_OP_bra";
+	case DW_OP_eq:
+		if (ellipsis)
+			return "eq";
+		else
+			return "DW_OP_eq";
+	case DW_OP_ge:
+		if (ellipsis)
+			return "ge";
+		else
+			return "DW_OP_ge";
+	case DW_OP_gt:
+		if (ellipsis)
+			return "gt";
+		else
+			return "DW_OP_gt";
+	case DW_OP_le:
+		if (ellipsis)
+			return "le";
+		else
+			return "DW_OP_le";
+	case DW_OP_lt:
+		if (ellipsis)
+			return "lt";
+		else
+			return "DW_OP_lt";
+	case DW_OP_ne:
+		if (ellipsis)
+			return "ne";
+		else
+			return "DW_OP_ne";
+	case DW_OP_skip:
+		if (ellipsis)
+			return "skip";
+		else
+			return "DW_OP_skip";
+	case DW_OP_lit0:
+		if (ellipsis)
+			return "lit0";
+		else
+			return "DW_OP_lit0";
+	case DW_OP_lit1:
+		if (ellipsis)
+			return "lit1";
+		else
+			return "DW_OP_lit1";
+	case DW_OP_lit2:
+		if (ellipsis)
+			return "lit2";
+		else
+			return "DW_OP_lit2";
+	case DW_OP_lit3:
+		if (ellipsis)
+			return "lit3";
+		else
+			return "DW_OP_lit3";
+	case DW_OP_lit4:
+		if (ellipsis)
+			return "lit4";
+		else
+			return "DW_OP_lit4";
+	case DW_OP_lit5:
+		if (ellipsis)
+			return "lit5";
+		else
+			return "DW_OP_lit5";
+	case DW_OP_lit6:
+		if (ellipsis)
+			return "lit6";
+		else
+			return "DW_OP_lit6";
+	case DW_OP_lit7:
+		if (ellipsis)
+			return "lit7";
+		else
+			return "DW_OP_lit7";
+	case DW_OP_lit8:
+		if (ellipsis)
+			return "lit8";
+		else
+			return "DW_OP_lit8";
+	case DW_OP_lit9:
+		if (ellipsis)
+			return "lit9";
+		else
+			return "DW_OP_lit9";
+	case DW_OP_lit10:
+		if (ellipsis)
+			return "lit10";
+		else
+			return "DW_OP_lit10";
+	case DW_OP_lit11:
+		if (ellipsis)
+			return "lit11";
+		else
+			return "DW_OP_lit11";
+	case DW_OP_lit12:
+		if (ellipsis)
+			return "lit12";
+		else
+			return "DW_OP_lit12";
+	case DW_OP_lit13:
+		if (ellipsis)
+			return "lit13";
+		else
+			return "DW_OP_lit13";
+	case DW_OP_lit14:
+		if (ellipsis)
+			return "lit14";
+		else
+			return "DW_OP_lit14";
+	case DW_OP_lit15:
+		if (ellipsis)
+			return "lit15";
+		else
+			return "DW_OP_lit15";
+	case DW_OP_lit16:
+		if (ellipsis)
+			return "lit16";
+		else
+			return "DW_OP_lit16";
+	case DW_OP_lit17:
+		if (ellipsis)
+			return "lit17";
+		else
+			return "DW_OP_lit17";
+	case DW_OP_lit18:
+		if (ellipsis)
+			return "lit18";
+		else
+			return "DW_OP_lit18";
+	case DW_OP_lit19:
+		if (ellipsis)
+			return "lit19";
+		else
+			return "DW_OP_lit19";
+	case DW_OP_lit20:
+		if (ellipsis)
+			return "lit20";
+		else
+			return "DW_OP_lit20";
+	case DW_OP_lit21:
+		if (ellipsis)
+			return "lit21";
+		else
+			return "DW_OP_lit21";
+	case DW_OP_lit22:
+		if (ellipsis)
+			return "lit22";
+		else
+			return "DW_OP_lit22";
+	case DW_OP_lit23:
+		if (ellipsis)
+			return "lit23";
+		else
+			return "DW_OP_lit23";
+	case DW_OP_lit24:
+		if (ellipsis)
+			return "lit24";
+		else
+			return "DW_OP_lit24";
+	case DW_OP_lit25:
+		if (ellipsis)
+			return "lit25";
+		else
+			return "DW_OP_lit25";
+	case DW_OP_lit26:
+		if (ellipsis)
+			return "lit26";
+		else
+			return "DW_OP_lit26";
+	case DW_OP_lit27:
+		if (ellipsis)
+			return "lit27";
+		else
+			return "DW_OP_lit27";
+	case DW_OP_lit28:
+		if (ellipsis)
+			return "lit28";
+		else
+			return "DW_OP_lit28";
+	case DW_OP_lit29:
+		if (ellipsis)
+			return "lit29";
+		else
+			return "DW_OP_lit29";
+	case DW_OP_lit30:
+		if (ellipsis)
+			return "lit30";
+		else
+			return "DW_OP_lit30";
+	case DW_OP_lit31:
+		if (ellipsis)
+			return "lit31";
+		else
+			return "DW_OP_lit31";
+	case DW_OP_reg0:
+		if (ellipsis)
+			return "reg0";
+		else
+			return "DW_OP_reg0";
+	case DW_OP_reg1:
+		if (ellipsis)
+			return "reg1";
+		else
+			return "DW_OP_reg1";
+	case DW_OP_reg2:
+		if (ellipsis)
+			return "reg2";
+		else
+			return "DW_OP_reg2";
+	case DW_OP_reg3:
+		if (ellipsis)
+			return "reg3";
+		else
+			return "DW_OP_reg3";
+	case DW_OP_reg4:
+		if (ellipsis)
+			return "reg4";
+		else
+			return "DW_OP_reg4";
+	case DW_OP_reg5:
+		if (ellipsis)
+			return "reg5";
+		else
+			return "DW_OP_reg5";
+	case DW_OP_reg6:
+		if (ellipsis)
+			return "reg6";
+		else
+			return "DW_OP_reg6";
+	case DW_OP_reg7:
+		if (ellipsis)
+			return "reg7";
+		else
+			return "DW_OP_reg7";
+	case DW_OP_reg8:
+		if (ellipsis)
+			return "reg8";
+		else
+			return "DW_OP_reg8";
+	case DW_OP_reg9:
+		if (ellipsis)
+			return "reg9";
+		else
+			return "DW_OP_reg9";
+	case DW_OP_reg10:
+		if (ellipsis)
+			return "reg10";
+		else
+			return "DW_OP_reg10";
+	case DW_OP_reg11:
+		if (ellipsis)
+			return "reg11";
+		else
+			return "DW_OP_reg11";
+	case DW_OP_reg12:
+		if (ellipsis)
+			return "reg12";
+		else
+			return "DW_OP_reg12";
+	case DW_OP_reg13:
+		if (ellipsis)
+			return "reg13";
+		else
+			return "DW_OP_reg13";
+	case DW_OP_reg14:
+		if (ellipsis)
+			return "reg14";
+		else
+			return "DW_OP_reg14";
+	case DW_OP_reg15:
+		if (ellipsis)
+			return "reg15";
+		else
+			return "DW_OP_reg15";
+	case DW_OP_reg16:
+		if (ellipsis)
+			return "reg16";
+		else
+			return "DW_OP_reg16";
+	case DW_OP_reg17:
+		if (ellipsis)
+			return "reg17";
+		else
+			return "DW_OP_reg17";
+	case DW_OP_reg18:
+		if (ellipsis)
+			return "reg18";
+		else
+			return "DW_OP_reg18";
+	case DW_OP_reg19:
+		if (ellipsis)
+			return "reg19";
+		else
+			return "DW_OP_reg19";
+	case DW_OP_reg20:
+		if (ellipsis)
+			return "reg20";
+		else
+			return "DW_OP_reg20";
+	case DW_OP_reg21:
+		if (ellipsis)
+			return "reg21";
+		else
+			return "DW_OP_reg21";
+	case DW_OP_reg22:
+		if (ellipsis)
+			return "reg22";
+		else
+			return "DW_OP_reg22";
+	case DW_OP_reg23:
+		if (ellipsis)
+			return "reg23";
+		else
+			return "DW_OP_reg23";
+	case DW_OP_reg24:
+		if (ellipsis)
+			return "reg24";
+		else
+			return "DW_OP_reg24";
+	case DW_OP_reg25:
+		if (ellipsis)
+			return "reg25";
+		else
+			return "DW_OP_reg25";
+	case DW_OP_reg26:
+		if (ellipsis)
+			return "reg26";
+		else
+			return "DW_OP_reg26";
+	case DW_OP_reg27:
+		if (ellipsis)
+			return "reg27";
+		else
+			return "DW_OP_reg27";
+	case DW_OP_reg28:
+		if (ellipsis)
+			return "reg28";
+		else
+			return "DW_OP_reg28";
+	case DW_OP_reg29:
+		if (ellipsis)
+			return "reg29";
+		else
+			return "DW_OP_reg29";
+	case DW_OP_reg30:
+		if (ellipsis)
+			return "reg30";
+		else
+			return "DW_OP_reg30";
+	case DW_OP_reg31:
+		if (ellipsis)
+			return "reg31";
+		else
+			return "DW_OP_reg31";
+	case DW_OP_breg0:
+		if (ellipsis)
+			return "breg0";
+		else
+			return "DW_OP_breg0";
+	case DW_OP_breg1:
+		if (ellipsis)
+			return "breg1";
+		else
+			return "DW_OP_breg1";
+	case DW_OP_breg2:
+		if (ellipsis)
+			return "breg2";
+		else
+			return "DW_OP_breg2";
+	case DW_OP_breg3:
+		if (ellipsis)
+			return "breg3";
+		else
+			return "DW_OP_breg3";
+	case DW_OP_breg4:
+		if (ellipsis)
+			return "breg4";
+		else
+			return "DW_OP_breg4";
+	case DW_OP_breg5:
+		if (ellipsis)
+			return "breg5";
+		else
+			return "DW_OP_breg5";
+	case DW_OP_breg6:
+		if (ellipsis)
+			return "breg6";
+		else
+			return "DW_OP_breg6";
+	case DW_OP_breg7:
+		if (ellipsis)
+			return "breg7";
+		else
+			return "DW_OP_breg7";
+	case DW_OP_breg8:
+		if (ellipsis)
+			return "breg8";
+		else
+			return "DW_OP_breg8";
+	case DW_OP_breg9:
+		if (ellipsis)
+			return "breg9";
+		else
+			return "DW_OP_breg9";
+	case DW_OP_breg10:
+		if (ellipsis)
+			return "breg10";
+		else
+			return "DW_OP_breg10";
+	case DW_OP_breg11:
+		if (ellipsis)
+			return "breg11";
+		else
+			return "DW_OP_breg11";
+	case DW_OP_breg12:
+		if (ellipsis)
+			return "breg12";
+		else
+			return "DW_OP_breg12";
+	case DW_OP_breg13:
+		if (ellipsis)
+			return "breg13";
+		else
+			return "DW_OP_breg13";
+	case DW_OP_breg14:
+		if (ellipsis)
+			return "breg14";
+		else
+			return "DW_OP_breg14";
+	case DW_OP_breg15:
+		if (ellipsis)
+			return "breg15";
+		else
+			return "DW_OP_breg15";
+	case DW_OP_breg16:
+		if (ellipsis)
+			return "breg16";
+		else
+			return "DW_OP_breg16";
+	case DW_OP_breg17:
+		if (ellipsis)
+			return "breg17";
+		else
+			return "DW_OP_breg17";
+	case DW_OP_breg18:
+		if (ellipsis)
+			return "breg18";
+		else
+			return "DW_OP_breg18";
+	case DW_OP_breg19:
+		if (ellipsis)
+			return "breg19";
+		else
+			return "DW_OP_breg19";
+	case DW_OP_breg20:
+		if (ellipsis)
+			return "breg20";
+		else
+			return "DW_OP_breg20";
+	case DW_OP_breg21:
+		if (ellipsis)
+			return "breg21";
+		else
+			return "DW_OP_breg21";
+	case DW_OP_breg22:
+		if (ellipsis)
+			return "breg22";
+		else
+			return "DW_OP_breg22";
+	case DW_OP_breg23:
+		if (ellipsis)
+			return "breg23";
+		else
+			return "DW_OP_breg23";
+	case DW_OP_breg24:
+		if (ellipsis)
+			return "breg24";
+		else
+			return "DW_OP_breg24";
+	case DW_OP_breg25:
+		if (ellipsis)
+			return "breg25";
+		else
+			return "DW_OP_breg25";
+	case DW_OP_breg26:
+		if (ellipsis)
+			return "breg26";
+		else
+			return "DW_OP_breg26";
+	case DW_OP_breg27:
+		if (ellipsis)
+			return "breg27";
+		else
+			return "DW_OP_breg27";
+	case DW_OP_breg28:
+		if (ellipsis)
+			return "breg28";
+		else
+			return "DW_OP_breg28";
+	case DW_OP_breg29:
+		if (ellipsis)
+			return "breg29";
+		else
+			return "DW_OP_breg29";
+	case DW_OP_breg30:
+		if (ellipsis)
+			return "breg30";
+		else
+			return "DW_OP_breg30";
+	case DW_OP_breg31:
+		if (ellipsis)
+			return "breg31";
+		else
+			return "DW_OP_breg31";
+	case DW_OP_regx:
+		if (ellipsis)
+			return "regx";
+		else
+			return "DW_OP_regx";
+	case DW_OP_fbreg:
+		if (ellipsis)
+			return "fbreg";
+		else
+			return "DW_OP_fbreg";
+	case DW_OP_bregx:
+		if (ellipsis)
+			return "bregx";
+		else
+			return "DW_OP_bregx";
+	case DW_OP_piece:
+		if (ellipsis)
+			return "piece";
+		else
+			return "DW_OP_piece";
+	case DW_OP_deref_size:
+		if (ellipsis)
+			return "deref_size";
+		else
+			return "DW_OP_deref_size";
+	case DW_OP_xderef_size:
+		if (ellipsis)
+			return "xderef_size";
+		else
+			return "DW_OP_xderef_size";
+	case DW_OP_nop:
+		if (ellipsis)
+			return "nop";
+		else
+			return "DW_OP_nop";
+	case DW_OP_push_object_address:
+		if (ellipsis)
+			return "push_object_address";
+		else
+			return "DW_OP_push_object_address";
+	case DW_OP_call2:
+		if (ellipsis)
+			return "call2";
+		else
+			return "DW_OP_call2";
+	case DW_OP_call4:
+		if (ellipsis)
+			return "call4";
+		else
+			return "DW_OP_call4";
+	case DW_OP_call_ref:
+		if (ellipsis)
+			return "call_ref";
+		else
+			return "DW_OP_call_ref";
+	case DW_OP_form_tls_address:
+		if (ellipsis)
+			return "form_tls_address";
+		else
+			return "DW_OP_form_tls_address";
+	case DW_OP_call_frame_cfa:
+		if (ellipsis)
+			return "call_frame_cfa";
+		else
+			return "DW_OP_call_frame_cfa";
+	case DW_OP_bit_piece:
+		if (ellipsis)
+			return "bit_piece";
+		else
+			return "DW_OP_bit_piece";
+	case DW_OP_implicit_value:
+		if (ellipsis)
+			return "implicit_value";
+		else
+			return "DW_OP_implicit_value";
+	case DW_OP_stack_value:
+		if (ellipsis)
+			return "stack_value";
+		else
+			return "DW_OP_stack_value";
+	case DW_OP_GNU_push_tls_address:
+		if (ellipsis)
+			return "GNU_push_tls_address";
+		else
+			return "DW_OP_GNU_push_tls_address";
+	case DW_OP_GNU_uninit:
+		if (ellipsis)
+			return "GNU_uninit";
+		else
+			return "DW_OP_GNU_uninit";
+	case DW_OP_GNU_encoded_addr:
+		if (ellipsis)
+			return "GNU_encoded_addr";
+		else
+			return "DW_OP_GNU_encoded_addr";
+	case DW_OP_GNU_implicit_pointer:
+		if (ellipsis)
+			return "GNU_implicit_pointer";
+		else
+			return "DW_OP_GNU_implicit_pointer";
+	case DW_OP_GNU_entry_value:
+		if (ellipsis)
+			return "GNU_entry_value";
+		else
+			return "DW_OP_GNU_entry_value";
+	case DW_OP_HP_is_value:
+		if (ellipsis)
+			return "HP_is_value";
+		else
+			return "DW_OP_HP_is_value";
+	case DW_OP_HP_fltconst4:
+		if (ellipsis)
+			return "HP_fltconst4";
+		else
+			return "DW_OP_HP_fltconst4";
+	case DW_OP_HP_fltconst8:
+		if (ellipsis)
+			return "HP_fltconst8";
+		else
+			return "DW_OP_HP_fltconst8";
+	case DW_OP_HP_mod_range:
+		if (ellipsis)
+			return "HP_mod_range";
+		else
+			return "DW_OP_HP_mod_range";
+	case DW_OP_HP_unmod_range:
+		if (ellipsis)
+			return "HP_unmod_range";
+		else
+			return "DW_OP_HP_unmod_range";
+	case DW_OP_HP_tls:
+		if (ellipsis)
+			return "HP_tls";
+		else
+			return "DW_OP_HP_tls";
+	case DW_OP_INTEL_bit_piece:
+		if (ellipsis)
+			return "INTEL_bit_piece";
+		else
+			return "DW_OP_INTEL_bit_piece";
+	case DW_OP_PGI_omp_thread_num:
+		if (ellipsis)
+			return "PGI_omp_thread_num";
+		else
+			return "DW_OP_PGI_omp_thread_num";
+	case DW_OP_hi_user:
+		if (ellipsis)
+			return "hi_user";
+		else
+			return "DW_OP_hi_user";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown OP value 0x%x>",(int)val);
+		 fprintf(stderr,"OP of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_ATE_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_ATE_address:
+		if (ellipsis)
+			return "address";
+		else
+			return "DW_ATE_address";
+	case DW_ATE_boolean:
+		if (ellipsis)
+			return "boolean";
+		else
+			return "DW_ATE_boolean";
+	case DW_ATE_complex_float:
+		if (ellipsis)
+			return "complex_float";
+		else
+			return "DW_ATE_complex_float";
+	case DW_ATE_float:
+		if (ellipsis)
+			return "float";
+		else
+			return "DW_ATE_float";
+	case DW_ATE_signed:
+		if (ellipsis)
+			return "signed";
+		else
+			return "DW_ATE_signed";
+	case DW_ATE_signed_char:
+		if (ellipsis)
+			return "signed_char";
+		else
+			return "DW_ATE_signed_char";
+	case DW_ATE_unsigned:
+		if (ellipsis)
+			return "unsigned";
+		else
+			return "DW_ATE_unsigned";
+	case DW_ATE_unsigned_char:
+		if (ellipsis)
+			return "unsigned_char";
+		else
+			return "DW_ATE_unsigned_char";
+	case DW_ATE_imaginary_float:
+		if (ellipsis)
+			return "imaginary_float";
+		else
+			return "DW_ATE_imaginary_float";
+	case DW_ATE_packed_decimal:
+		if (ellipsis)
+			return "packed_decimal";
+		else
+			return "DW_ATE_packed_decimal";
+	case DW_ATE_numeric_string:
+		if (ellipsis)
+			return "numeric_string";
+		else
+			return "DW_ATE_numeric_string";
+	case DW_ATE_edited:
+		if (ellipsis)
+			return "edited";
+		else
+			return "DW_ATE_edited";
+	case DW_ATE_signed_fixed:
+		if (ellipsis)
+			return "signed_fixed";
+		else
+			return "DW_ATE_signed_fixed";
+	case DW_ATE_unsigned_fixed:
+		if (ellipsis)
+			return "unsigned_fixed";
+		else
+			return "DW_ATE_unsigned_fixed";
+	case DW_ATE_decimal_float:
+		if (ellipsis)
+			return "decimal_float";
+		else
+			return "DW_ATE_decimal_float";
+	case DW_ATE_ALTIUM_fract:
+		if (ellipsis)
+			return "ALTIUM_fract";
+		else
+			return "DW_ATE_ALTIUM_fract";
+	case DW_ATE_ALTIUM_accum:
+		if (ellipsis)
+			return "ALTIUM_accum";
+		else
+			return "DW_ATE_ALTIUM_accum";
+	case DW_ATE_HP_float128:
+		if (ellipsis)
+			return "HP_float128";
+		else
+			return "DW_ATE_HP_float128";
+	case DW_ATE_HP_complex_float128:
+		if (ellipsis)
+			return "HP_complex_float128";
+		else
+			return "DW_ATE_HP_complex_float128";
+	case DW_ATE_HP_floathpintel:
+		if (ellipsis)
+			return "HP_floathpintel";
+		else
+			return "DW_ATE_HP_floathpintel";
+	case DW_ATE_HP_imaginary_float80:
+		if (ellipsis)
+			return "HP_imaginary_float80";
+		else
+			return "DW_ATE_HP_imaginary_float80";
+	case DW_ATE_HP_imaginary_float128:
+		if (ellipsis)
+			return "HP_imaginary_float128";
+		else
+			return "DW_ATE_HP_imaginary_float128";
+	case DW_ATE_SUN_interval_float:
+		if (ellipsis)
+			return "SUN_interval_float";
+		else
+			return "DW_ATE_SUN_interval_float";
+	case DW_ATE_SUN_imaginary_float:
+		if (ellipsis)
+			return "SUN_imaginary_float";
+		else
+			return "DW_ATE_SUN_imaginary_float";
+	case DW_ATE_hi_user:
+		if (ellipsis)
+			return "hi_user";
+		else
+			return "DW_ATE_hi_user";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown ATE value 0x%x>",(int)val);
+		 fprintf(stderr,"ATE of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_DS_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_DS_unsigned:
+		if (ellipsis)
+			return "unsigned";
+		else
+			return "DW_DS_unsigned";
+	case DW_DS_leading_overpunch:
+		if (ellipsis)
+			return "leading_overpunch";
+		else
+			return "DW_DS_leading_overpunch";
+	case DW_DS_trailing_overpunch:
+		if (ellipsis)
+			return "trailing_overpunch";
+		else
+			return "DW_DS_trailing_overpunch";
+	case DW_DS_leading_separate:
+		if (ellipsis)
+			return "leading_separate";
+		else
+			return "DW_DS_leading_separate";
+	case DW_DS_trailing_separate:
+		if (ellipsis)
+			return "trailing_separate";
+		else
+			return "DW_DS_trailing_separate";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown DS value 0x%x>",(int)val);
+		 fprintf(stderr,"DS of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_END_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_END_default:
+		if (ellipsis)
+			return "default";
+		else
+			return "DW_END_default";
+	case DW_END_big:
+		if (ellipsis)
+			return "big";
+		else
+			return "DW_END_big";
+	case DW_END_little:
+		if (ellipsis)
+			return "little";
+		else
+			return "DW_END_little";
+	case DW_END_lo_user:
+		if (ellipsis)
+			return "lo_user";
+		else
+			return "DW_END_lo_user";
+	case DW_END_hi_user:
+		if (ellipsis)
+			return "hi_user";
+		else
+			return "DW_END_hi_user";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown END value 0x%x>",(int)val);
+		 fprintf(stderr,"END of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_ATCF_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_ATCF_lo_user:
+		if (ellipsis)
+			return "lo_user";
+		else
+			return "DW_ATCF_lo_user";
+	case DW_ATCF_SUN_mop_bitfield:
+		if (ellipsis)
+			return "SUN_mop_bitfield";
+		else
+			return "DW_ATCF_SUN_mop_bitfield";
+	case DW_ATCF_SUN_mop_spill:
+		if (ellipsis)
+			return "SUN_mop_spill";
+		else
+			return "DW_ATCF_SUN_mop_spill";
+	case DW_ATCF_SUN_mop_scopy:
+		if (ellipsis)
+			return "SUN_mop_scopy";
+		else
+			return "DW_ATCF_SUN_mop_scopy";
+	case DW_ATCF_SUN_func_start:
+		if (ellipsis)
+			return "SUN_func_start";
+		else
+			return "DW_ATCF_SUN_func_start";
+	case DW_ATCF_SUN_end_ctors:
+		if (ellipsis)
+			return "SUN_end_ctors";
+		else
+			return "DW_ATCF_SUN_end_ctors";
+	case DW_ATCF_SUN_branch_target:
+		if (ellipsis)
+			return "SUN_branch_target";
+		else
+			return "DW_ATCF_SUN_branch_target";
+	case DW_ATCF_SUN_mop_stack_probe:
+		if (ellipsis)
+			return "SUN_mop_stack_probe";
+		else
+			return "DW_ATCF_SUN_mop_stack_probe";
+	case DW_ATCF_SUN_func_epilog:
+		if (ellipsis)
+			return "SUN_func_epilog";
+		else
+			return "DW_ATCF_SUN_func_epilog";
+	case DW_ATCF_hi_user:
+		if (ellipsis)
+			return "hi_user";
+		else
+			return "DW_ATCF_hi_user";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown ATCF value 0x%x>",(int)val);
+		 fprintf(stderr,"ATCF of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_ACCESS_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_ACCESS_public:
+		if (ellipsis)
+			return "public";
+		else
+			return "DW_ACCESS_public";
+	case DW_ACCESS_protected:
+		if (ellipsis)
+			return "protected";
+		else
+			return "DW_ACCESS_protected";
+	case DW_ACCESS_private:
+		if (ellipsis)
+			return "private";
+		else
+			return "DW_ACCESS_private";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown ACCESS value 0x%x>",(int)val);
+		 fprintf(stderr,"ACCESS of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_VIS_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_VIS_local:
+		if (ellipsis)
+			return "local";
+		else
+			return "DW_VIS_local";
+	case DW_VIS_exported:
+		if (ellipsis)
+			return "exported";
+		else
+			return "DW_VIS_exported";
+	case DW_VIS_qualified:
+		if (ellipsis)
+			return "qualified";
+		else
+			return "DW_VIS_qualified";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown VIS value 0x%x>",(int)val);
+		 fprintf(stderr,"VIS of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_VIRTUALITY_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_VIRTUALITY_none:
+		if (ellipsis)
+			return "none";
+		else
+			return "DW_VIRTUALITY_none";
+	case DW_VIRTUALITY_virtual:
+		if (ellipsis)
+			return "virtual";
+		else
+			return "DW_VIRTUALITY_virtual";
+	case DW_VIRTUALITY_pure_virtual:
+		if (ellipsis)
+			return "pure_virtual";
+		else
+			return "DW_VIRTUALITY_pure_virtual";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown VIRTUALITY value 0x%x>",(int)val);
+		 fprintf(stderr,"VIRTUALITY of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_LANG_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_LANG_C89:
+		if (ellipsis)
+			return "C89";
+		else
+			return "DW_LANG_C89";
+	case DW_LANG_C:
+		if (ellipsis)
+			return "C";
+		else
+			return "DW_LANG_C";
+	case DW_LANG_Ada83:
+		if (ellipsis)
+			return "Ada83";
+		else
+			return "DW_LANG_Ada83";
+	case DW_LANG_C_plus_plus:
+		if (ellipsis)
+			return "C_plus_plus";
+		else
+			return "DW_LANG_C_plus_plus";
+	case DW_LANG_Cobol74:
+		if (ellipsis)
+			return "Cobol74";
+		else
+			return "DW_LANG_Cobol74";
+	case DW_LANG_Cobol85:
+		if (ellipsis)
+			return "Cobol85";
+		else
+			return "DW_LANG_Cobol85";
+	case DW_LANG_Fortran77:
+		if (ellipsis)
+			return "Fortran77";
+		else
+			return "DW_LANG_Fortran77";
+	case DW_LANG_Fortran90:
+		if (ellipsis)
+			return "Fortran90";
+		else
+			return "DW_LANG_Fortran90";
+	case DW_LANG_Pascal83:
+		if (ellipsis)
+			return "Pascal83";
+		else
+			return "DW_LANG_Pascal83";
+	case DW_LANG_Modula2:
+		if (ellipsis)
+			return "Modula2";
+		else
+			return "DW_LANG_Modula2";
+	case DW_LANG_Java:
+		if (ellipsis)
+			return "Java";
+		else
+			return "DW_LANG_Java";
+	case DW_LANG_C99:
+		if (ellipsis)
+			return "C99";
+		else
+			return "DW_LANG_C99";
+	case DW_LANG_Ada95:
+		if (ellipsis)
+			return "Ada95";
+		else
+			return "DW_LANG_Ada95";
+	case DW_LANG_Fortran95:
+		if (ellipsis)
+			return "Fortran95";
+		else
+			return "DW_LANG_Fortran95";
+	case DW_LANG_PLI:
+		if (ellipsis)
+			return "PLI";
+		else
+			return "DW_LANG_PLI";
+	case DW_LANG_ObjC:
+		if (ellipsis)
+			return "ObjC";
+		else
+			return "DW_LANG_ObjC";
+	case DW_LANG_ObjC_plus_plus:
+		if (ellipsis)
+			return "ObjC_plus_plus";
+		else
+			return "DW_LANG_ObjC_plus_plus";
+	case DW_LANG_UPC:
+		if (ellipsis)
+			return "UPC";
+		else
+			return "DW_LANG_UPC";
+	case DW_LANG_D:
+		if (ellipsis)
+			return "D";
+		else
+			return "DW_LANG_D";
+	case DW_LANG_Python:
+		if (ellipsis)
+			return "Python";
+		else
+			return "DW_LANG_Python";
+	case DW_LANG_OpenCL:
+		if (ellipsis)
+			return "OpenCL";
+		else
+			return "DW_LANG_OpenCL";
+	case DW_LANG_Go:
+		if (ellipsis)
+			return "Go";
+		else
+			return "DW_LANG_Go";
+	case DW_LANG_Modula3:
+		if (ellipsis)
+			return "Modula3";
+		else
+			return "DW_LANG_Modula3";
+	case DW_LANG_Haskel:
+		if (ellipsis)
+			return "Haskel";
+		else
+			return "DW_LANG_Haskel";
+	case DW_LANG_lo_user:
+		if (ellipsis)
+			return "lo_user";
+		else
+			return "DW_LANG_lo_user";
+	case DW_LANG_Mips_Assembler:
+		if (ellipsis)
+			return "Mips_Assembler";
+		else
+			return "DW_LANG_Mips_Assembler";
+	case DW_LANG_Upc:
+		if (ellipsis)
+			return "Upc";
+		else
+			return "DW_LANG_Upc";
+	case DW_LANG_ALTIUM_Assembler:
+		if (ellipsis)
+			return "ALTIUM_Assembler";
+		else
+			return "DW_LANG_ALTIUM_Assembler";
+	case DW_LANG_SUN_Assembler:
+		if (ellipsis)
+			return "SUN_Assembler";
+		else
+			return "DW_LANG_SUN_Assembler";
+	case DW_LANG_hi_user:
+		if (ellipsis)
+			return "hi_user";
+		else
+			return "DW_LANG_hi_user";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown LANG value 0x%x>",(int)val);
+		 fprintf(stderr,"LANG of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_ID_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_ID_case_sensitive:
+		if (ellipsis)
+			return "case_sensitive";
+		else
+			return "DW_ID_case_sensitive";
+	case DW_ID_up_case:
+		if (ellipsis)
+			return "up_case";
+		else
+			return "DW_ID_up_case";
+	case DW_ID_down_case:
+		if (ellipsis)
+			return "down_case";
+		else
+			return "DW_ID_down_case";
+	case DW_ID_case_insensitive:
+		if (ellipsis)
+			return "case_insensitive";
+		else
+			return "DW_ID_case_insensitive";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown ID value 0x%x>",(int)val);
+		 fprintf(stderr,"ID of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_CC_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_CC_normal:
+		if (ellipsis)
+			return "normal";
+		else
+			return "DW_CC_normal";
+	case DW_CC_program:
+		if (ellipsis)
+			return "program";
+		else
+			return "DW_CC_program";
+	case DW_CC_nocall:
+		if (ellipsis)
+			return "nocall";
+		else
+			return "DW_CC_nocall";
+	case DW_CC_lo_user:
+		if (ellipsis)
+			return "lo_user";
+		else
+			return "DW_CC_lo_user";
+	case DW_CC_GNU_borland_fastcall_i386:
+		if (ellipsis)
+			return "GNU_borland_fastcall_i386";
+		else
+			return "DW_CC_GNU_borland_fastcall_i386";
+	case DW_CC_ALTIUM_interrupt:
+		if (ellipsis)
+			return "ALTIUM_interrupt";
+		else
+			return "DW_CC_ALTIUM_interrupt";
+	case DW_CC_ALTIUM_near_system_stack:
+		if (ellipsis)
+			return "ALTIUM_near_system_stack";
+		else
+			return "DW_CC_ALTIUM_near_system_stack";
+	case DW_CC_ALTIUM_near_user_stack:
+		if (ellipsis)
+			return "ALTIUM_near_user_stack";
+		else
+			return "DW_CC_ALTIUM_near_user_stack";
+	case DW_CC_ALTIUM_huge_user_stack:
+		if (ellipsis)
+			return "ALTIUM_huge_user_stack";
+		else
+			return "DW_CC_ALTIUM_huge_user_stack";
+	case DW_CC_hi_user:
+		if (ellipsis)
+			return "hi_user";
+		else
+			return "DW_CC_hi_user";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown CC value 0x%x>",(int)val);
+		 fprintf(stderr,"CC of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_INL_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_INL_not_inlined:
+		if (ellipsis)
+			return "not_inlined";
+		else
+			return "DW_INL_not_inlined";
+	case DW_INL_inlined:
+		if (ellipsis)
+			return "inlined";
+		else
+			return "DW_INL_inlined";
+	case DW_INL_declared_not_inlined:
+		if (ellipsis)
+			return "declared_not_inlined";
+		else
+			return "DW_INL_declared_not_inlined";
+	case DW_INL_declared_inlined:
+		if (ellipsis)
+			return "declared_inlined";
+		else
+			return "DW_INL_declared_inlined";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown INL value 0x%x>",(int)val);
+		 fprintf(stderr,"INL of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_ORD_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_ORD_row_major:
+		if (ellipsis)
+			return "row_major";
+		else
+			return "DW_ORD_row_major";
+	case DW_ORD_col_major:
+		if (ellipsis)
+			return "col_major";
+		else
+			return "DW_ORD_col_major";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown ORD value 0x%x>",(int)val);
+		 fprintf(stderr,"ORD of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_DSC_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_DSC_label:
+		if (ellipsis)
+			return "label";
+		else
+			return "DW_DSC_label";
+	case DW_DSC_range:
+		if (ellipsis)
+			return "range";
+		else
+			return "DW_DSC_range";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown DSC value 0x%x>",(int)val);
+		 fprintf(stderr,"DSC of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_LNS_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_LNS_copy:
+		if (ellipsis)
+			return "copy";
+		else
+			return "DW_LNS_copy";
+	case DW_LNS_advance_pc:
+		if (ellipsis)
+			return "advance_pc";
+		else
+			return "DW_LNS_advance_pc";
+	case DW_LNS_advance_line:
+		if (ellipsis)
+			return "advance_line";
+		else
+			return "DW_LNS_advance_line";
+	case DW_LNS_set_file:
+		if (ellipsis)
+			return "set_file";
+		else
+			return "DW_LNS_set_file";
+	case DW_LNS_set_column:
+		if (ellipsis)
+			return "set_column";
+		else
+			return "DW_LNS_set_column";
+	case DW_LNS_negate_stmt:
+		if (ellipsis)
+			return "negate_stmt";
+		else
+			return "DW_LNS_negate_stmt";
+	case DW_LNS_set_basic_block:
+		if (ellipsis)
+			return "set_basic_block";
+		else
+			return "DW_LNS_set_basic_block";
+	case DW_LNS_const_add_pc:
+		if (ellipsis)
+			return "const_add_pc";
+		else
+			return "DW_LNS_const_add_pc";
+	case DW_LNS_fixed_advance_pc:
+		if (ellipsis)
+			return "fixed_advance_pc";
+		else
+			return "DW_LNS_fixed_advance_pc";
+	case DW_LNS_set_prologue_end:
+		if (ellipsis)
+			return "set_prologue_end";
+		else
+			return "DW_LNS_set_prologue_end";
+	case DW_LNS_set_epilogue_begin:
+		if (ellipsis)
+			return "set_epilogue_begin";
+		else
+			return "DW_LNS_set_epilogue_begin";
+	case DW_LNS_set_isa:
+		if (ellipsis)
+			return "set_isa";
+		else
+			return "DW_LNS_set_isa";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown LNS value 0x%x>",(int)val);
+		 fprintf(stderr,"LNS of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_LNE_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_LNE_end_sequence:
+		if (ellipsis)
+			return "end_sequence";
+		else
+			return "DW_LNE_end_sequence";
+	case DW_LNE_set_address:
+		if (ellipsis)
+			return "set_address";
+		else
+			return "DW_LNE_set_address";
+	case DW_LNE_define_file:
+		if (ellipsis)
+			return "define_file";
+		else
+			return "DW_LNE_define_file";
+	case DW_LNE_set_discriminator:
+		if (ellipsis)
+			return "set_discriminator";
+		else
+			return "DW_LNE_set_discriminator";
+	case DW_LNE_HP_negate_is_UV_update:
+		if (ellipsis)
+			return "HP_negate_is_UV_update";
+		else
+			return "DW_LNE_HP_negate_is_UV_update";
+	case DW_LNE_HP_push_context:
+		if (ellipsis)
+			return "HP_push_context";
+		else
+			return "DW_LNE_HP_push_context";
+	case DW_LNE_HP_pop_context:
+		if (ellipsis)
+			return "HP_pop_context";
+		else
+			return "DW_LNE_HP_pop_context";
+	case DW_LNE_HP_set_file_line_column:
+		if (ellipsis)
+			return "HP_set_file_line_column";
+		else
+			return "DW_LNE_HP_set_file_line_column";
+	case DW_LNE_HP_set_routine_name:
+		if (ellipsis)
+			return "HP_set_routine_name";
+		else
+			return "DW_LNE_HP_set_routine_name";
+	case DW_LNE_HP_set_sequence:
+		if (ellipsis)
+			return "HP_set_sequence";
+		else
+			return "DW_LNE_HP_set_sequence";
+	case DW_LNE_HP_negate_post_semantics:
+		if (ellipsis)
+			return "HP_negate_post_semantics";
+		else
+			return "DW_LNE_HP_negate_post_semantics";
+	case DW_LNE_HP_negate_function_exit:
+		if (ellipsis)
+			return "HP_negate_function_exit";
+		else
+			return "DW_LNE_HP_negate_function_exit";
+	case DW_LNE_HP_negate_front_end_logical:
+		if (ellipsis)
+			return "HP_negate_front_end_logical";
+		else
+			return "DW_LNE_HP_negate_front_end_logical";
+	case DW_LNE_HP_define_proc:
+		if (ellipsis)
+			return "HP_define_proc";
+		else
+			return "DW_LNE_HP_define_proc";
+	case DW_LNE_HP_source_file_correlation:
+		if (ellipsis)
+			return "HP_source_file_correlation";
+		else
+			return "DW_LNE_HP_source_file_correlation";
+	case DW_LNE_hi_user:
+		if (ellipsis)
+			return "hi_user";
+		else
+			return "DW_LNE_hi_user";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown LNE value 0x%x>",(int)val);
+		 fprintf(stderr,"LNE of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_ISA_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_ISA_UNKNOWN:
+		if (ellipsis)
+			return "UNKNOWN";
+		else
+			return "DW_ISA_UNKNOWN";
+	case DW_ISA_ARM_thumb:
+		if (ellipsis)
+			return "ARM_thumb";
+		else
+			return "DW_ISA_ARM_thumb";
+	case DW_ISA_ARM_arm:
+		if (ellipsis)
+			return "ARM_arm";
+		else
+			return "DW_ISA_ARM_arm";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown ISA value 0x%x>",(int)val);
+		 fprintf(stderr,"ISA of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_MACINFO_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_MACINFO_define:
+		if (ellipsis)
+			return "define";
+		else
+			return "DW_MACINFO_define";
+	case DW_MACINFO_undef:
+		if (ellipsis)
+			return "undef";
+		else
+			return "DW_MACINFO_undef";
+	case DW_MACINFO_start_file:
+		if (ellipsis)
+			return "start_file";
+		else
+			return "DW_MACINFO_start_file";
+	case DW_MACINFO_end_file:
+		if (ellipsis)
+			return "end_file";
+		else
+			return "DW_MACINFO_end_file";
+	case DW_MACINFO_vendor_ext:
+		if (ellipsis)
+			return "vendor_ext";
+		else
+			return "DW_MACINFO_vendor_ext";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown MACINFO value 0x%x>",(int)val);
+		 fprintf(stderr,"MACINFO of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_EH_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_EH_PE_absptr:
+		if (ellipsis)
+			return "PE_absptr";
+		else
+			return "DW_EH_PE_absptr";
+	case DW_EH_PE_uleb128:
+		if (ellipsis)
+			return "PE_uleb128";
+		else
+			return "DW_EH_PE_uleb128";
+	case DW_EH_PE_udata2:
+		if (ellipsis)
+			return "PE_udata2";
+		else
+			return "DW_EH_PE_udata2";
+	case DW_EH_PE_udata4:
+		if (ellipsis)
+			return "PE_udata4";
+		else
+			return "DW_EH_PE_udata4";
+	case DW_EH_PE_udata8:
+		if (ellipsis)
+			return "PE_udata8";
+		else
+			return "DW_EH_PE_udata8";
+	case DW_EH_PE_sleb128:
+		if (ellipsis)
+			return "PE_sleb128";
+		else
+			return "DW_EH_PE_sleb128";
+	case DW_EH_PE_sdata2:
+		if (ellipsis)
+			return "PE_sdata2";
+		else
+			return "DW_EH_PE_sdata2";
+	case DW_EH_PE_sdata4:
+		if (ellipsis)
+			return "PE_sdata4";
+		else
+			return "DW_EH_PE_sdata4";
+	case DW_EH_PE_sdata8:
+		if (ellipsis)
+			return "PE_sdata8";
+		else
+			return "DW_EH_PE_sdata8";
+	case DW_EH_PE_pcrel:
+		if (ellipsis)
+			return "PE_pcrel";
+		else
+			return "DW_EH_PE_pcrel";
+	case DW_EH_PE_textrel:
+		if (ellipsis)
+			return "PE_textrel";
+		else
+			return "DW_EH_PE_textrel";
+	case DW_EH_PE_datarel:
+		if (ellipsis)
+			return "PE_datarel";
+		else
+			return "DW_EH_PE_datarel";
+	case DW_EH_PE_funcrel:
+		if (ellipsis)
+			return "PE_funcrel";
+		else
+			return "DW_EH_PE_funcrel";
+	case DW_EH_PE_aligned:
+		if (ellipsis)
+			return "PE_aligned";
+		else
+			return "DW_EH_PE_aligned";
+	case DW_EH_PE_omit:
+		if (ellipsis)
+			return "PE_omit";
+		else
+			return "DW_EH_PE_omit";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown EH value 0x%x>",(int)val);
+		 fprintf(stderr,"EH of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_FRAME_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_FRAME_CFA_COL:
+		if (ellipsis)
+			return "CFA_COL";
+		else
+			return "DW_FRAME_CFA_COL";
+	case DW_FRAME_REG1:
+		if (ellipsis)
+			return "REG1";
+		else
+			return "DW_FRAME_REG1";
+	case DW_FRAME_REG2:
+		if (ellipsis)
+			return "REG2";
+		else
+			return "DW_FRAME_REG2";
+	case DW_FRAME_REG3:
+		if (ellipsis)
+			return "REG3";
+		else
+			return "DW_FRAME_REG3";
+	case DW_FRAME_REG4:
+		if (ellipsis)
+			return "REG4";
+		else
+			return "DW_FRAME_REG4";
+	case DW_FRAME_REG5:
+		if (ellipsis)
+			return "REG5";
+		else
+			return "DW_FRAME_REG5";
+	case DW_FRAME_REG6:
+		if (ellipsis)
+			return "REG6";
+		else
+			return "DW_FRAME_REG6";
+	case DW_FRAME_REG7:
+		if (ellipsis)
+			return "REG7";
+		else
+			return "DW_FRAME_REG7";
+	case DW_FRAME_REG8:
+		if (ellipsis)
+			return "REG8";
+		else
+			return "DW_FRAME_REG8";
+	case DW_FRAME_REG9:
+		if (ellipsis)
+			return "REG9";
+		else
+			return "DW_FRAME_REG9";
+	case DW_FRAME_REG10:
+		if (ellipsis)
+			return "REG10";
+		else
+			return "DW_FRAME_REG10";
+	case DW_FRAME_REG11:
+		if (ellipsis)
+			return "REG11";
+		else
+			return "DW_FRAME_REG11";
+	case DW_FRAME_REG12:
+		if (ellipsis)
+			return "REG12";
+		else
+			return "DW_FRAME_REG12";
+	case DW_FRAME_REG13:
+		if (ellipsis)
+			return "REG13";
+		else
+			return "DW_FRAME_REG13";
+	case DW_FRAME_REG14:
+		if (ellipsis)
+			return "REG14";
+		else
+			return "DW_FRAME_REG14";
+	case DW_FRAME_REG15:
+		if (ellipsis)
+			return "REG15";
+		else
+			return "DW_FRAME_REG15";
+	case DW_FRAME_REG16:
+		if (ellipsis)
+			return "REG16";
+		else
+			return "DW_FRAME_REG16";
+	case DW_FRAME_REG17:
+		if (ellipsis)
+			return "REG17";
+		else
+			return "DW_FRAME_REG17";
+	case DW_FRAME_REG18:
+		if (ellipsis)
+			return "REG18";
+		else
+			return "DW_FRAME_REG18";
+	case DW_FRAME_REG19:
+		if (ellipsis)
+			return "REG19";
+		else
+			return "DW_FRAME_REG19";
+	case DW_FRAME_REG20:
+		if (ellipsis)
+			return "REG20";
+		else
+			return "DW_FRAME_REG20";
+	case DW_FRAME_REG21:
+		if (ellipsis)
+			return "REG21";
+		else
+			return "DW_FRAME_REG21";
+	case DW_FRAME_REG22:
+		if (ellipsis)
+			return "REG22";
+		else
+			return "DW_FRAME_REG22";
+	case DW_FRAME_REG23:
+		if (ellipsis)
+			return "REG23";
+		else
+			return "DW_FRAME_REG23";
+	case DW_FRAME_REG24:
+		if (ellipsis)
+			return "REG24";
+		else
+			return "DW_FRAME_REG24";
+	case DW_FRAME_REG25:
+		if (ellipsis)
+			return "REG25";
+		else
+			return "DW_FRAME_REG25";
+	case DW_FRAME_REG26:
+		if (ellipsis)
+			return "REG26";
+		else
+			return "DW_FRAME_REG26";
+	case DW_FRAME_REG27:
+		if (ellipsis)
+			return "REG27";
+		else
+			return "DW_FRAME_REG27";
+	case DW_FRAME_REG28:
+		if (ellipsis)
+			return "REG28";
+		else
+			return "DW_FRAME_REG28";
+	case DW_FRAME_REG29:
+		if (ellipsis)
+			return "REG29";
+		else
+			return "DW_FRAME_REG29";
+	case DW_FRAME_REG30:
+		if (ellipsis)
+			return "REG30";
+		else
+			return "DW_FRAME_REG30";
+	case DW_FRAME_REG31:
+		if (ellipsis)
+			return "REG31";
+		else
+			return "DW_FRAME_REG31";
+	case DW_FRAME_FREG0:
+		if (ellipsis)
+			return "FREG0";
+		else
+			return "DW_FRAME_FREG0";
+	case DW_FRAME_FREG1:
+		if (ellipsis)
+			return "FREG1";
+		else
+			return "DW_FRAME_FREG1";
+	case DW_FRAME_FREG2:
+		if (ellipsis)
+			return "FREG2";
+		else
+			return "DW_FRAME_FREG2";
+	case DW_FRAME_FREG3:
+		if (ellipsis)
+			return "FREG3";
+		else
+			return "DW_FRAME_FREG3";
+	case DW_FRAME_FREG4:
+		if (ellipsis)
+			return "FREG4";
+		else
+			return "DW_FRAME_FREG4";
+	case DW_FRAME_FREG5:
+		if (ellipsis)
+			return "FREG5";
+		else
+			return "DW_FRAME_FREG5";
+	case DW_FRAME_FREG6:
+		if (ellipsis)
+			return "FREG6";
+		else
+			return "DW_FRAME_FREG6";
+	case DW_FRAME_FREG7:
+		if (ellipsis)
+			return "FREG7";
+		else
+			return "DW_FRAME_FREG7";
+	case DW_FRAME_FREG8:
+		if (ellipsis)
+			return "FREG8";
+		else
+			return "DW_FRAME_FREG8";
+	case DW_FRAME_FREG9:
+		if (ellipsis)
+			return "FREG9";
+		else
+			return "DW_FRAME_FREG9";
+	case DW_FRAME_FREG10:
+		if (ellipsis)
+			return "FREG10";
+		else
+			return "DW_FRAME_FREG10";
+	case DW_FRAME_FREG11:
+		if (ellipsis)
+			return "FREG11";
+		else
+			return "DW_FRAME_FREG11";
+	case DW_FRAME_FREG12:
+		if (ellipsis)
+			return "FREG12";
+		else
+			return "DW_FRAME_FREG12";
+	case DW_FRAME_FREG13:
+		if (ellipsis)
+			return "FREG13";
+		else
+			return "DW_FRAME_FREG13";
+	case DW_FRAME_FREG14:
+		if (ellipsis)
+			return "FREG14";
+		else
+			return "DW_FRAME_FREG14";
+	case DW_FRAME_FREG15:
+		if (ellipsis)
+			return "FREG15";
+		else
+			return "DW_FRAME_FREG15";
+	case DW_FRAME_FREG16:
+		if (ellipsis)
+			return "FREG16";
+		else
+			return "DW_FRAME_FREG16";
+	case DW_FRAME_FREG17:
+		if (ellipsis)
+			return "FREG17";
+		else
+			return "DW_FRAME_FREG17";
+	case DW_FRAME_FREG18:
+		if (ellipsis)
+			return "FREG18";
+		else
+			return "DW_FRAME_FREG18";
+	case DW_FRAME_FREG19:
+		if (ellipsis)
+			return "FREG19";
+		else
+			return "DW_FRAME_FREG19";
+	case DW_FRAME_FREG20:
+		if (ellipsis)
+			return "FREG20";
+		else
+			return "DW_FRAME_FREG20";
+	case DW_FRAME_FREG21:
+		if (ellipsis)
+			return "FREG21";
+		else
+			return "DW_FRAME_FREG21";
+	case DW_FRAME_FREG22:
+		if (ellipsis)
+			return "FREG22";
+		else
+			return "DW_FRAME_FREG22";
+	case DW_FRAME_FREG23:
+		if (ellipsis)
+			return "FREG23";
+		else
+			return "DW_FRAME_FREG23";
+	case DW_FRAME_FREG24:
+		if (ellipsis)
+			return "FREG24";
+		else
+			return "DW_FRAME_FREG24";
+	case DW_FRAME_FREG25:
+		if (ellipsis)
+			return "FREG25";
+		else
+			return "DW_FRAME_FREG25";
+	case DW_FRAME_FREG26:
+		if (ellipsis)
+			return "FREG26";
+		else
+			return "DW_FRAME_FREG26";
+	case DW_FRAME_FREG27:
+		if (ellipsis)
+			return "FREG27";
+		else
+			return "DW_FRAME_FREG27";
+	case DW_FRAME_FREG28:
+		if (ellipsis)
+			return "FREG28";
+		else
+			return "DW_FRAME_FREG28";
+	case DW_FRAME_FREG29:
+		if (ellipsis)
+			return "FREG29";
+		else
+			return "DW_FRAME_FREG29";
+	case DW_FRAME_FREG30:
+		if (ellipsis)
+			return "FREG30";
+		else
+			return "DW_FRAME_FREG30";
+	case DW_FRAME_FREG31:
+		if (ellipsis)
+			return "FREG31";
+		else
+			return "DW_FRAME_FREG31";
+	case DW_FRAME_FREG32:
+		if (ellipsis)
+			return "FREG32";
+		else
+			return "DW_FRAME_FREG32";
+	case DW_FRAME_FREG33:
+		if (ellipsis)
+			return "FREG33";
+		else
+			return "DW_FRAME_FREG33";
+	case DW_FRAME_FREG34:
+		if (ellipsis)
+			return "FREG34";
+		else
+			return "DW_FRAME_FREG34";
+	case DW_FRAME_FREG35:
+		if (ellipsis)
+			return "FREG35";
+		else
+			return "DW_FRAME_FREG35";
+	case DW_FRAME_FREG36:
+		if (ellipsis)
+			return "FREG36";
+		else
+			return "DW_FRAME_FREG36";
+	case DW_FRAME_FREG37:
+		if (ellipsis)
+			return "FREG37";
+		else
+			return "DW_FRAME_FREG37";
+	case DW_FRAME_FREG38:
+		if (ellipsis)
+			return "FREG38";
+		else
+			return "DW_FRAME_FREG38";
+	case DW_FRAME_FREG39:
+		if (ellipsis)
+			return "FREG39";
+		else
+			return "DW_FRAME_FREG39";
+	case DW_FRAME_FREG40:
+		if (ellipsis)
+			return "FREG40";
+		else
+			return "DW_FRAME_FREG40";
+	case DW_FRAME_FREG41:
+		if (ellipsis)
+			return "FREG41";
+		else
+			return "DW_FRAME_FREG41";
+	case DW_FRAME_FREG42:
+		if (ellipsis)
+			return "FREG42";
+		else
+			return "DW_FRAME_FREG42";
+	case DW_FRAME_FREG43:
+		if (ellipsis)
+			return "FREG43";
+		else
+			return "DW_FRAME_FREG43";
+	case DW_FRAME_FREG44:
+		if (ellipsis)
+			return "FREG44";
+		else
+			return "DW_FRAME_FREG44";
+	case DW_FRAME_FREG45:
+		if (ellipsis)
+			return "FREG45";
+		else
+			return "DW_FRAME_FREG45";
+	case DW_FRAME_FREG46:
+		if (ellipsis)
+			return "FREG46";
+		else
+			return "DW_FRAME_FREG46";
+	case DW_FRAME_FREG47:
+		if (ellipsis)
+			return "FREG47";
+		else
+			return "DW_FRAME_FREG47";
+	case DW_FRAME_FREG48:
+		if (ellipsis)
+			return "FREG48";
+		else
+			return "DW_FRAME_FREG48";
+	case DW_FRAME_FREG49:
+		if (ellipsis)
+			return "FREG49";
+		else
+			return "DW_FRAME_FREG49";
+	case DW_FRAME_FREG50:
+		if (ellipsis)
+			return "FREG50";
+		else
+			return "DW_FRAME_FREG50";
+	case DW_FRAME_FREG51:
+		if (ellipsis)
+			return "FREG51";
+		else
+			return "DW_FRAME_FREG51";
+	case DW_FRAME_FREG52:
+		if (ellipsis)
+			return "FREG52";
+		else
+			return "DW_FRAME_FREG52";
+	case DW_FRAME_FREG53:
+		if (ellipsis)
+			return "FREG53";
+		else
+			return "DW_FRAME_FREG53";
+	case DW_FRAME_FREG54:
+		if (ellipsis)
+			return "FREG54";
+		else
+			return "DW_FRAME_FREG54";
+	case DW_FRAME_FREG55:
+		if (ellipsis)
+			return "FREG55";
+		else
+			return "DW_FRAME_FREG55";
+	case DW_FRAME_FREG56:
+		if (ellipsis)
+			return "FREG56";
+		else
+			return "DW_FRAME_FREG56";
+	case DW_FRAME_FREG57:
+		if (ellipsis)
+			return "FREG57";
+		else
+			return "DW_FRAME_FREG57";
+	case DW_FRAME_FREG58:
+		if (ellipsis)
+			return "FREG58";
+		else
+			return "DW_FRAME_FREG58";
+	case DW_FRAME_FREG59:
+		if (ellipsis)
+			return "FREG59";
+		else
+			return "DW_FRAME_FREG59";
+	case DW_FRAME_FREG60:
+		if (ellipsis)
+			return "FREG60";
+		else
+			return "DW_FRAME_FREG60";
+	case DW_FRAME_FREG61:
+		if (ellipsis)
+			return "FREG61";
+		else
+			return "DW_FRAME_FREG61";
+	case DW_FRAME_FREG62:
+		if (ellipsis)
+			return "FREG62";
+		else
+			return "DW_FRAME_FREG62";
+	case DW_FRAME_FREG63:
+		if (ellipsis)
+			return "FREG63";
+		else
+			return "DW_FRAME_FREG63";
+	case DW_FRAME_FREG64:
+		if (ellipsis)
+			return "FREG64";
+		else
+			return "DW_FRAME_FREG64";
+	case DW_FRAME_FREG65:
+		if (ellipsis)
+			return "FREG65";
+		else
+			return "DW_FRAME_FREG65";
+	case DW_FRAME_FREG66:
+		if (ellipsis)
+			return "FREG66";
+		else
+			return "DW_FRAME_FREG66";
+	case DW_FRAME_FREG67:
+		if (ellipsis)
+			return "FREG67";
+		else
+			return "DW_FRAME_FREG67";
+	case DW_FRAME_FREG68:
+		if (ellipsis)
+			return "FREG68";
+		else
+			return "DW_FRAME_FREG68";
+	case DW_FRAME_FREG69:
+		if (ellipsis)
+			return "FREG69";
+		else
+			return "DW_FRAME_FREG69";
+	case DW_FRAME_FREG70:
+		if (ellipsis)
+			return "FREG70";
+		else
+			return "DW_FRAME_FREG70";
+	case DW_FRAME_FREG71:
+		if (ellipsis)
+			return "FREG71";
+		else
+			return "DW_FRAME_FREG71";
+	case DW_FRAME_FREG72:
+		if (ellipsis)
+			return "FREG72";
+		else
+			return "DW_FRAME_FREG72";
+	case DW_FRAME_FREG73:
+		if (ellipsis)
+			return "FREG73";
+		else
+			return "DW_FRAME_FREG73";
+	case DW_FRAME_FREG74:
+		if (ellipsis)
+			return "FREG74";
+		else
+			return "DW_FRAME_FREG74";
+	case DW_FRAME_FREG75:
+		if (ellipsis)
+			return "FREG75";
+		else
+			return "DW_FRAME_FREG75";
+	case DW_FRAME_FREG76:
+		if (ellipsis)
+			return "FREG76";
+		else
+			return "DW_FRAME_FREG76";
+	case DW_FRAME_HIGHEST_NORMAL_REGISTER:
+		if (ellipsis)
+			return "HIGHEST_NORMAL_REGISTER";
+		else
+			return "DW_FRAME_HIGHEST_NORMAL_REGISTER";
+	case DW_FRAME_LAST_REG_NUM:
+		if (ellipsis)
+			return "LAST_REG_NUM";
+		else
+			return "DW_FRAME_LAST_REG_NUM";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown FRAME value 0x%x>",(int)val);
+		 fprintf(stderr,"FRAME of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_CHILDREN_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_CHILDREN_no:
+		if (ellipsis)
+			return "CHILDREN_no";
+		else
+			return "DW_CHILDREN_no";
+	case DW_CHILDREN_yes:
+		if (ellipsis)
+			return "CHILDREN_yes";
+		else
+			return "DW_CHILDREN_yes";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown CHILDREN value 0x%x>",(int)val);
+		 fprintf(stderr,"CHILDREN of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
+/* ARGSUSED */
+extern string
+get_ADDR_name (Dwarf_Debug dbg, Dwarf_Half val)
+{
+	switch (val) {
+	case DW_ADDR_none:
+		if (ellipsis)
+			return "ADDR_none";
+		else
+			return "DW_ADDR_none";
+	default:
+		{ 
+		    char buf[100]; 
+		    char *n; 
+		    sprintf(buf,"<Unknown ADDR value 0x%x>",(int)val);
+		 fprintf(stderr,"ADDR of %d (0x%x) is unknown to dwarfdump. " 
+ 		 "Continuing. \n",(int)val,(int)val );  
+		    n = makename(buf);
+		    return n; 
+		} 
+	}
+/*NOTREACHED*/
+}
+
diff --git a/tools/kgraft/dwarf_names.h b/tools/kgraft/dwarf_names.h
new file mode 100644
index 000000000000..5a9ffaef9059
--- /dev/null
+++ b/tools/kgraft/dwarf_names.h
@@ -0,0 +1,53 @@
+/* automatically generated routines */
+extern string get_TAG_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_children_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_FORM_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_AT_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_OP_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_ATE_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_DS_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_END_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_ATCF_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_ACCESS_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_VIS_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_VIRTUALITY_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_LANG_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_ID_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_CC_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_INL_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_ORD_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_DSC_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_LNS_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_LNE_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_ISA_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_MACINFO_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_EH_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_FRAME_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_CHILDREN_name (Dwarf_Debug dbg, Dwarf_Half val);
+
+extern string get_ADDR_name (Dwarf_Debug dbg, Dwarf_Half val);
+
diff --git a/tools/kgraft/extract-syms.sh b/tools/kgraft/extract-syms.sh
new file mode 100755
index 000000000000..280b1829b25b
--- /dev/null
+++ b/tools/kgraft/extract-syms.sh
@@ -0,0 +1,18 @@
+#!/bin/bash
+TOOLPATH=`dirname $0`
+if ! test -f vmlinux.o; then
+    echo "vmlinux.o needs to exist in cwd"
+    exit 1
+fi
+if test -z "$1"; then
+    echo "usage: $0 [list of symbols to extract]"
+    exit 2
+fi
+
+rm -f symlist symlist.rename extracted.o
+for i in $@; do
+    echo $i >> symlist
+    echo $i new_$i >> symlist.rename
+done
+$TOOLPATH/objcopy-hacked --strip-unneeded -j .doesntexist. --keep-symbols symlist --redefine-syms symlist.rename vmlinux.o extracted.o
+nm extracted.o
diff --git a/tools/kgraft/it2rev.pl b/tools/kgraft/it2rev.pl
new file mode 100644
index 000000000000..3e0cf8a55138
--- /dev/null
+++ b/tools/kgraft/it2rev.pl
@@ -0,0 +1,40 @@
+#!/usr/bin/perl -w
+
+my $prefix='';
+foreach (@ARGV) {
+    if (/^-/) {
+    } else {
+	$prefix = $_;
+    }
+}
+my %files=();
+my $func='';
+my $file='';
+my $ffref=0;
+while(<STDIN>) {
+    chomp;
+    if (/^U/) {
+	#print "ignore $_\n";
+    } elsif (/^D (.*):([^: ]*)$/) {
+	#print "func $2 in $1\n";
+	$func=$2;
+	($file = $1) =~ s/^$prefix//;
+    } elsif (/^I (.*):([^: ]*)$/) {
+	#print "inline $2 in $1\n";
+	my $t = $1;
+	my $u = $2;
+	$t =~ s/^$prefix//;
+	$files{$t}->{$u}->{$file}->{$func} = 1;
+    }
+}
+foreach (sort keys %files) {
+    foreach my $inlinee (sort keys %{$files{$_}}) {
+	print "$_:$inlinee";
+	foreach my $ifile (sort keys %{$files{$_}->{$inlinee}}) {
+	    foreach my $ifunc (sort keys %{$files{$_}->{$inlinee}->{$ifile}}) {
+		print " $ifile:$ifunc";
+	    }
+	}
+	print "\n";
+    }
+}
diff --git a/tools/kgraft/objcopy.diff b/tools/kgraft/objcopy.diff
new file mode 100644
index 000000000000..53697612f696
--- /dev/null
+++ b/tools/kgraft/objcopy.diff
@@ -0,0 +1,131 @@
+diff --git a/binutils/objcopy.c b/binutils/objcopy.c
+index 14f6b96..a6d59de 100644
+--- a/binutils/objcopy.c
++++ b/binutils/objcopy.c
+@@ -1301,7 +1301,14 @@ filter_symbols (bfd *abfd, bfd *obfd, asymbol **osyms,
+ 	keep = TRUE;
+ 
+       if (keep && is_strip_section (abfd, bfd_get_section (sym)))
+-	keep = FALSE;
++	{
++	  if (relocatable && used_in_reloc)
++	    {
++	      sym->section = bfd_und_section_ptr;
++	    }
++	  else
++	    keep = FALSE;
++	}
+ 
+       if (keep)
+ 	{
+@@ -1564,6 +1571,72 @@ copy_unknown_object (bfd *ibfd, bfd *obfd)
+   return TRUE;
+ }
+ 
++static bfd_boolean traverse_reloc_changed;
++
++static void
++traverse_relocs (bfd *ibfd, sec_ptr isection, void *symbolsarg)
++{
++  asymbol **symbols = (asymbol **) symbolsarg;
++  long relsize;
++  arelent **relpp;
++  long relcount, i;
++
++  /* If we don't keep this section, don't look at it.  */
++  if (!find_section_list (bfd_get_section_name (ibfd, isection),
++			  FALSE, SECTION_CONTEXT_COPY))
++    return;
++
++  relsize = bfd_get_reloc_upper_bound (ibfd, isection);
++  if (relsize < 0)
++    {
++      /* Do not complain if the target does not support relocations.  */
++      if (relsize == -1 && bfd_get_error () == bfd_error_invalid_operation)
++	return;
++      bfd_fatal (bfd_get_filename (ibfd));
++    }
++
++  if (relsize == 0)
++    return;
++
++  relpp = (arelent **) xmalloc (relsize);
++  relcount = bfd_canonicalize_reloc (ibfd, isection, relpp, symbols);
++  if (relcount < 0)
++    bfd_fatal (bfd_get_filename (ibfd));
++
++  /* Examine each symbol used in a relocation.  If it's not one of the
++     special bfd section symbols, then mark it with BSF_KEEP.  */
++  for (i = 0; i < relcount; i++)
++    {
++      asymbol *sym = *relpp[i]->sym_ptr_ptr;
++      asection *sec;
++      if (sym != bfd_com_section_ptr->symbol
++	  && sym != bfd_abs_section_ptr->symbol
++	  && sym != bfd_und_section_ptr->symbol)
++	{
++	  if (sym->flags & BSF_KEEP)
++	    continue;
++	  sym->flags |= BSF_KEEP;
++	}
++      /* We need to copy sections defining stuff we need for section-based
++         relocs.  For the others we can just emit undef symbols.  */
++      if (!(sym->flags & BSF_SECTION_SYM))
++	continue;
++      sec = bfd_get_section (sym);
++      if (find_section_list (bfd_get_section_name (ibfd, sec),
++			     FALSE, SECTION_CONTEXT_COPY))
++	continue;
++      printf ("copying section %s because of symbol %s (reloc from %s).\n",
++	      bfd_get_section_name (ibfd, sec), bfd_asymbol_name (sym),
++	      bfd_get_section_name (ibfd, isection));
++      find_section_list (bfd_get_section_name (ibfd, sec), TRUE,
++			 SECTION_CONTEXT_COPY);
++      traverse_reloc_changed = TRUE;
++    }
++
++  if (relpp != NULL)
++    free (relpp);
++}
++
+ /* Copy object file IBFD onto OBFD.
+    Returns TRUE upon success, FALSE otherwise.  */
+ 
+@@ -1746,6 +1819,37 @@ copy_object (bfd *ibfd, bfd *obfd, const bfd_arch_info_type *input_arch)
+       return FALSE;
+     }
+ 
++  if (1)
++    {
++      long i;
++      for (i = 0; i < symcount; i++)
++	{
++	  asymbol *sym = isympp[i];
++	  asection *sec;
++	  char *name = (char *) bfd_asymbol_name (sym);
++	  bfd_boolean undefined;
++
++	  sec = bfd_get_section (sym);
++	  undefined = bfd_is_und_section (sec);
++	  if (!undefined
++	      && is_specified_symbol (name, keep_specific_htab))
++	    {
++	      find_section_list (bfd_get_section_name (ibfd, sec),
++				 TRUE, SECTION_CONTEXT_COPY);
++	      sections_copied = TRUE;
++	      traverse_reloc_changed = TRUE;
++	      printf ("copying section %s because of symbol %s.\n",
++		      bfd_get_section_name (ibfd, sec), name);
++	    }
++	}
++      /* Now mark all sections copied that are referred to from
++         relocations of sections that are already copied, transitively.  */
++      while (traverse_reloc_changed)
++	{
++	  traverse_reloc_changed = FALSE;
++	  bfd_map_over_sections (ibfd, traverse_relocs, isympp);
++	}
++    }
+   /* BFD mandates that all output sections be created and sizes set before
+      any output is done.  Thus, we traverse all sections multiple times.  */
+   bfd_map_over_sections (ibfd, setup_section, obfd);
diff --git a/tools/kgraft/symlist b/tools/kgraft/symlist
new file mode 100644
index 000000000000..79a58de6e1ca
--- /dev/null
+++ b/tools/kgraft/symlist
@@ -0,0 +1 @@
+in_app
-- 
1.9.2

