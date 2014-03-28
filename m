Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaC2P2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:28:06 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35223 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaC2P2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:28:02 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 26/29] ktap: add userspace binary Makefile(tools/ktap/Makefile)
Date: Fri, 28 Mar 2014 10:45:21 -0400
Message-Id: <1396017924-7754-27-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makefile for userspace binary.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/Makefile | 130 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)
 create mode 100644 tools/ktap/Makefile

diff --git a/tools/ktap/Makefile b/tools/ktap/Makefile
new file mode 100644
index 0000000..38aa113
--- /dev/null
+++ b/tools/ktap/Makefile
@@ -0,0 +1,130 @@
+#
+# Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
+# (this will also disable resolve resolving symbols in DSO functionality)
+#
+
+INC = ../../include/uapi/ktap
+KTAP_LIBS = -lpthread
+KTAPC_CFLAGS = -Wall -O2
+
+all: ktap
+
+# try-cc
+# Usage: option = $(call try-cc, source-to-build, cc-options, msg)
+ifneq ($(V),1)
+TRY_CC_OUTPUT= > /dev/null 2>&1
+endif
+TRY_CC_MSG=echo "    CHK $(3)" 1>&2;
+
+try-cc = $(shell sh -c							\
+         'TMP="/tmp/.$$$$";						\
+          $(TRY_CC_MSG)							\
+          echo "$(1)" |							\
+          $(CC) -x c - $(2) -o "$$TMP" $(TRY_CC_OUTPUT) && echo y;	\
+          rm -f "$$TMP"')
+
+
+define SOURCE_LIBELF
+#include <libelf.h>
+
+int main(void)
+{
+        Elf *elf = elf_begin(0, ELF_C_READ, 0);
+        return (long)elf;
+}
+endef
+
+FLAGS_LIBELF = -lelf
+
+ifdef NO_LIBELF
+	KTAPC_CFLAGS += -DNO_LIBELF
+else
+ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
+    $(warning No libelf found, disables symbol resolving, please install elfutils-libelf-devel/libelf-dev);
+    NO_LIBELF := 1
+    KTAPC_CFLAGS += -DNO_LIBELF
+else
+    KTAP_LIBS += -lelf
+endif
+endif
+
+kp_main.o: kp_main.c $(INC)/* KTAP-CFLAGS
+	$(QUIET_CC)$(CC) $(DEBUGINFO_FLAG) $(KTAPC_CFLAGS) -o $@ -c $<
+kp_lex.o: kp_lex.c $(INC)/* KTAP-CFLAGS
+	$(QUIET_CC)$(CC) $(DEBUGINFO_FLAG) $(KTAPC_CFLAGS) -o $@ -c $<
+kp_parse.o: kp_parse.c $(INC)/* KTAP-CFLAGS
+	$(QUIET_CC)$(CC) $(DEBUGINFO_FLAG) $(KTAPC_CFLAGS) -o $@ -c $<
+kp_bcwrite.o: kp_bcwrite.c $(INC)/* KTAP-CFLAGS
+	$(QUIET_CC)$(CC) $(DEBUGINFO_FLAG) $(KTAPC_CFLAGS) -o $@ -c $<
+kp_reader.o: kp_reader.c $(INC)/* KTAP-CFLAGS
+	$(QUIET_CC)$(CC) $(DEBUGINFO_FLAG) $(KTAPC_CFLAGS) -o $@ -c $<
+kp_util.o: kp_util.c $(INC)/* KTAP-CFLAGS
+	$(QUIET_CC)$(CC) $(DEBUGINFO_FLAG) $(KTAPC_CFLAGS) -o $@ -c $<
+kp_parse_events.o: kp_parse_events.c $(INC)/* KTAP-CFLAGS
+	$(QUIET_CC)$(CC) $(DEBUGINFO_FLAG) $(KTAPC_CFLAGS) -o $@ -c $<
+ifndef NO_LIBELF
+kp_symbol.o: kp_symbol.c KTAP-CFLAGS
+	$(QUIET_CC)$(CC) $(DEBUGINFO_FLAG) $(KTAPC_CFLAGS) -o $@ -c $<
+endif
+
+KTAPOBJS =
+KTAPOBJS += kp_main.o
+KTAPOBJS += kp_lex.o
+KTAPOBJS += kp_parse.o
+KTAPOBJS += kp_bcwrite.o
+KTAPOBJS += kp_reader.o
+KTAPOBJS += kp_util.o
+KTAPOBJS += kp_parse_events.o
+ifndef NO_LIBELF
+KTAPOBJS += kp_symbol.o
+endif
+
+ktap: $(KTAPOBJS) KTAP-CFLAGS
+	$(QUIET_LINK)$(CC) $(KTAPC_CFLAGS) -o $@ $(KTAPOBJS) $(KTAP_LIBS)
+
+install: ktap
+	install -c ktap /usr/bin/
+	mkdir -p ~/.vim/ftdetect
+	mkdir -p ~/.vim/syntax
+	cp vim/ftdetect/ktap.vim ~/.vim/ftdetect/
+	cp vim/syntax/ktap.vim ~/.vim/syntax/
+
+test: FORCE
+	#start testing
+	prove -j4 -r test/
+
+clean:
+	$(RM) ktap *.o KTAP-CFLAGS
+
+
+PHONY += FORCE
+FORCE:
+
+TRACK_FLAGS = KTAP
+ifdef NO_LIBELF
+TRACK_FLAGS += NO_LIBELF
+endif
+
+KTAP-CFLAGS: FORCE
+	@FLAGS='$(TRACK_FLAGS)'; \
+	if test x"$$FLAGS" != x"`cat KTAP-CFLAGS 2>/dev/null`" ; then \
+		echo "$$FLAGS" >KTAP-CFLAGS; \
+	fi
+
+#generate tags/etags/cscope index for editor.
+define all_sources
+        (find . -name '*.[ch]' -print)
+endef
+
+.PHONY: tags
+tags:
+	$(all_sources) | xargs ctags
+
+.PHONY: etags
+etags:
+	$(all_sources) | xargs etags
+
+.PHONY: cscope
+cscope:
+	$(all_sources) > cscope.files
+	cscope -k -b
-- 
1.8.1.4

