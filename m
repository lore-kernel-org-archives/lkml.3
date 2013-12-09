Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3LIKjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:39:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57890 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab3LIKj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:39:29 -0500
Date: Mon, 9 Dec 2013 11:39:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/2] perf tool: Carve out fs.* stuff
Message-ID: <20131209103924.GA31650@pd.tnic>
References: <20131205174725.GF10333@ghostprotocols.net>
 <52A4AF98.8040001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52A4AF98.8040001@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 10:42:48AM -0700, David Ahern wrote:
> Something is missing. From tools/perf:
>
> $ make O=/tmp/perf
>
> Assembler messages:
> Fatal error: can't create /tmp/perf/fs/fs.o: No such file or directory

That's because we have the sublibs in subdirs now :-\. That should take
care of it:

--
diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
index 2a354292d781..ce00f7ee6455 100644
--- a/tools/lib/api/Makefile
+++ b/tools/lib/api/Makefile
@@ -1,4 +1,5 @@
 include ../../scripts/Makefile.include
+include ../../perf/config/utilities.mak		# QUIET_CLEAN
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
@@ -27,14 +28,17 @@ $(LIBFILE): $(LIB_OBJS)
 
 $(LIB_OBJS): $(LIB_H)
 
-$(OUTPUT)%.o: %.c
+libapi_dirs:
+	$(QUIET_MKDIR)mkdir -p $(OUTPUT)fs/
+
+$(OUTPUT)%.o: %.c libapi_dirs
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
-$(OUTPUT)%.s: %.c
+$(OUTPUT)%.s: %.c libapi_dirs
 	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
-$(OUTPUT)%.o: %.S
+$(OUTPUT)%.o: %.S libapi_dirs
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
 
 clean:
-	$(RM) $(LIB_OBJS) $(LIBFILE)
+	$(call QUIET_CLEAN, libapi) $(RM) $(LIB_OBJS) $(LIBFILE)
 
 .PHONY: clean

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
