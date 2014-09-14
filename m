Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaINKTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:19:34 -0400
Received: from forward4l.mail.yandex.net ([84.201.143.137]:47331 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaINKTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:19:31 -0400
X-Yandex-Uniq: a2e73bcc-2869-43c5-a330-46b1aca69efb
Authentication-Results: smtp8.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 2/3] core: Save list of built-in drivers names
From: Kirill Tkhai <tkhai@yandex.ru>
To: mmarek@suse.cz, arnd@arndb.de, linux-kbuild@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, grant.likely@secretlab.ca, ebiederm@xmission.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, sam@ravnborg.org
Date: Sun, 14 Sep 2014 14:18:35 +0400
Message-ID: <20140914101831.3745.78412.stgit@localhost>
In-Reply-To: <20140914100545.3745.23394.stgit@localhost>
References: <20140914100545.3745.23394.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create section *(__builtin_drivers_list) to store the list of drivers names.

Every driver name "modname" from directory "moddir" will be stored in array:

const char moddir_modname[] __attribute__((section("__builtin_drivers_list")) = "modname";

Using moddir prefix for variables names to prevent linking breakage
on the set of all architectures where dupricate names present.
The name template should be transmormed in something like __modname__name
in the future to catch duplicates, but now it's impossible.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 include/asm-generic/vmlinux.lds.h |    3 +++
 scripts/Makefile.build            |   14 ++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5ba0360..5bc6d56 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -237,6 +237,9 @@
 		*(__tracepoints_ptrs)	/* Tracepoints: pointer array */\
 		VMLINUX_SYMBOL(__stop___tracepoints_ptrs) = .;		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
+		VMLINUX_SYMBOL(__start_builtin_drivers_list) = .;	\
+		*(__builtin_drivers_list)				\
+		VMLINUX_SYMBOL(__stop_builtin_drivers_list) = .;	\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index bf3e677..e158a4d 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -136,6 +136,7 @@ $(obj-m)              : quiet_modtag := [M]
 
 # Default for not multi-part modules
 modname = $(basetarget)
+modname_c_var = `echo $(kbuild-dir)/$(modname) | sed 's/\.\///g' | sed 's/-/_/g' | sed 's/\//__/g'`
 
 $(multi-objs-m)         : modname = $(modname-multi)
 $(multi-objs-m:.o=.i)   : modname = $(modname-multi)
@@ -376,11 +377,16 @@ $(filter $(addprefix $(obj)/,         \
 $($(subst $(obj)/,,$(@:.o=-objs)))    \
 $($(subst $(obj)/,,$(@:.o=-y)))), $^)
 
-quiet_cmd_link_multi-y = LD      $@
-cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps) $(cmd_secanalysis)
-
 quiet_cmd_link_multi-m = LD [M]  $@
-cmd_link_multi-m = $(cmd_link_multi-y)
+cmd_link_multi-m = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps) $(cmd_secanalysis)
+
+quiet_cmd_link_multi-y = LD      $@
+cmd_link_multi-y = \
+	echo "const char "$(modname_c_var)"[] __attribute__((section(\"__builtin_drivers_list\"))) " \
+	     "__attribute__ ((aligned(sizeof(unsigned long)))) = \""$(modname)"\";" > $(kbuild-dir)/.$(modname).c; \
+	$(CC) $(c_flags) -c $(kbuild-dir)/.$(modname).c -o $(kbuild-dir)/.$(modname).o; \
+	$(LD) $(ld_flags) -r -o $@ $(link_multi_deps) $(kbuild-dir)/.$(modname).o $(cmd_secanalysis); \
+	rm -f $(kbuild-dir)/.$(modname).c
 
 # We would rather have a list of rules like
 # 	foo.o: $(foo-objs)

