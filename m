Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3GLIxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:53:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54931 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab3GLIxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:53:22 -0400
Date: Fri, 12 Jul 2013 01:52:43 -0700
From: tip-bot for Mike Frysinger <tipbot@zytor.com>
Message-ID: <tip-d14c496588733ec1b586ec068932c1db228dd770@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, vapier@gentoo.org, tglx@linutronix.de,
        vapier@chromium.org
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        vapier@gentoo.org, vapier@chromium.org, tglx@linutronix.de
In-Reply-To: <1368073064-18276-1-git-send-email-vapier@gentoo.org>
References: <1368073064-18276-1-git-send-email-vapier@gentoo.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix -ldw/
 -lelf link test when static linking
Git-Commit-ID: d14c496588733ec1b586ec068932c1db228dd770
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:52:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d14c496588733ec1b586ec068932c1db228dd770
Gitweb:     http://git.kernel.org/tip/d14c496588733ec1b586ec068932c1db228dd770
Author:     Mike Frysinger <vapier@chromium.org>
AuthorDate: Thu, 9 May 2013 00:17:44 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 10 Jul 2013 13:41:12 -0300

perf tools: Fix -ldw/-lelf link test when static linking

Since libelf sometimes uses libpthread, we have to list that after -lelf
when someone tries to build statically.  Else things go boom:

Makefile:479: *** No libelf.h/libelf found, please install \
	libelf-dev/elfutils-libelf-devel.  Stop.

Similarly, the -ldw test fails as it often uses -lz:

Makefile:462: No libdw.h found or old libdw.h found or elfutils is older \
	than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev

And if we add debugging to try-cc, we see:
+ echo '#include <dwarf.h>

int main(void)
{
        Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
        return (long)dbg;
}'
+ i686-pc-linux-gnu-gcc -x c - -O2 -pipe -march=atom -mtune=atom -mfpmath=sse -g \
	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE \
	-ldw -lelf -static -lpthread -lrt -lelf -lm -o .24368
/usr/lib/libdw.a(dwarf_begin_elf.o):function check_section.isra.1: error: undefined reference to 'inflateInit_'
/usr/lib/libdw.a(dwarf_begin_elf.o):function check_section.isra.1: error: undefined reference to 'inflate'
/usr/lib/libdw.a(dwarf_begin_elf.o):function check_section.isra.1: error: undefined reference to 'inflateReset'
/usr/lib/libdw.a(dwarf_begin_elf.o):function check_section.isra.1: error: undefined reference to 'inflateEnd'

+ echo '#include <libelf.h>

int main(void)
{
        Elf *elf = elf_begin(0, ELF_C_READ, 0);
        return (long)elf;
}'
+ i686-pc-linux-gnu-gcc -x c - -O2 -pipe -march=atom -mtune=atom -mfpmath=sse -g \
	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE \
	-static -lpthread -lrt -lelf -lm -o .19216
/usr/lib/libelf.a(elf_begin.o):function file_read_elf: error: undefined reference to 'pthread_rwlock_init'
/usr/lib/libelf.a(elf_begin.o):function __libelf_read_mmaped_file: error: undefined reference to 'pthread_rwlock_init'
/usr/lib/libelf.a(elf_begin.o):function __libelf_read_mmaped_file: error: undefined reference to 'pthread_rwlock_init'
/usr/lib/libelf.a(elf_begin.o):function read_file: error: undefined reference to 'pthread_rwlock_init'
/usr/lib/libelf.a(elf_begin.o):function lock_dup_elf.8072: error: undefined reference to 'pthread_rwlock_unlock'
/usr/lib/libelf.a(elf_begin.o):function lock_dup_elf.8072: error: undefined reference to 'pthread_rwlock_wrlock'
/usr/lib/libelf.a(elf_begin.o):function elf_begin: error: undefined reference to 'pthread_rwlock_rdlock'
/usr/lib/libelf.a(elf_begin.o):function elf_begin: error: undefined reference to 'pthread_rwlock_unlock'

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1368073064-18276-1-git-send-email-vapier@gentoo.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/lk/Makefile      | 2 +-
 tools/perf/config/Makefile | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index f0ecc0a..280dd82 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -29,7 +29,7 @@ LIB_OBJS += $(OUTPUT)debugfs.o
 LIBFILE = liblk.a
 
 CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
-EXTLIBS = -lpthread -lrt -lelf -lm
+EXTLIBS = -lelf -lpthread -lrt -lm
 ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f446895..b5d9238 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -85,7 +85,7 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
-EXTLIBS = -lpthread -lrt -lelf -lm
+EXTLIBS = -lelf -lpthread -lrt -lm
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
   CFLAGS += -fstack-protector-all
@@ -165,7 +165,7 @@ else
     LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
   endif
 
-  FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
+  FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lz -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
   ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
     msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
     NO_DWARF := 1
