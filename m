Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbbAUTNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:13:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbbAUTNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:13:15 -0500
Date: Wed, 21 Jan 2015 20:12:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/36] perf build: Add builtin objects building
Message-ID: <20150121191223.GF6835@krava.brq.redhat.com>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
 <1421771973-6022-9-git-send-email-jolsa@kernel.org>
 <54BFF557.1070809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BFF557.1070809@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 11:52:07AM -0700, David Ahern wrote:
> On 1/20/15 9:39 AM, Jiri Olsa wrote:
> >Move the rest of builtin objects (bench and test are
> >already in) building under build framework.
> >
> >Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
> >Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> >Cc: Borislav Petkov <bp@alien8.de>
> >Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> >Cc: David Ahern <dsahern@gmail.com>
> >Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >Cc: Ingo Molnar <mingo@kernel.org>
> >Cc: Namhyung Kim <namhyung@kernel.org>
> >Cc: Paul Mackerras <paulus@samba.org>
> >Cc: Peter Zijlstra <peterz@infradead.org>
> >Cc: Stephane Eranian <eranian@google.com>
> >---
> >  tools/perf/Build           | 29 +++++++++++++++++++++++++++++
> >  tools/perf/Makefile.perf   | 35 -----------------------------------
> >  tools/perf/config/Makefile |  4 ++++
> >  3 files changed, 33 insertions(+), 35 deletions(-)
> 
> This one fails to build:
> 
> $ git --no-pager log --oneline -1
> cd2a9b144028 perf build: Add builtin objects building
> 
> $ make O=/tmp/junk
> ...
> builtin-help.c:10:25: fatal error: common-cmds.h: No such file or directory
> compilation terminated.
>   CC       /tmp/junk/fs/fs.o
>   CC       /tmp/junk/builtin-script.o
>   CC       /tmp/junk/builtin-kmem.o
>   CC       /tmp/junk/perf-read-vdso32
>   CC       /tmp/junk/ui/gtk/browser.o
>   CC       /tmp/junk/fd/array.o
>   CC       /tmp/junk/ui/gtk/hists.o
>   CC       /tmp/junk/builtin-lock.o
> make[2]: *** [/tmp/junk/builtin-help.o] Error 1
> make[2]: *** Waiting for unfinished jobs....

hum I can't reproduce, but I can see why

on the commit you mentioned there're foolowing dependencies:

	$(PERF_IN): FORCE
		@$(MAKE) $(build)=perf

	$(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
		$(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \
			'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
			$(CFLAGS) -c $(filter %.c,$^) -o $@

	$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS) $(PERF_IN)
		$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
		       $(BUILTIN_OBJS) $(PERF_IN) $(LIBS) -o $@


so $(OUTPUT)common-cmds.h gets build only for perf.o, while
it's needed before we dive in to $(PERF_IN) target..

this get's fixed later on within commit:
  a07488a79e78 perf build: Add perf.o object building

where we have:
	$(PERF_IN): $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h FORCE
		$(Q)$(MAKE) $(build)=perf


I'll propagate the $(OUTPUT)common-cmds.h dependency to commit
  cd2a9b144028 perf build: Add builtin objects building

like attached change

thanks for testing,
jirka


---
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index b0df3ec91104..061289d25fa8 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -550,7 +550,7 @@ PERF_IN := $(OUTPUT)perf-in.o
 export srctree OUTPUT RM CC LD AR CFLAGS V
 build := -f $(srctree)/tools/build/Makefile.build dir=. obj
 
-$(PERF_IN): FORCE
+$(PERF_IN): FORCE $(OUTPUT)common-cmds.h
 	@$(MAKE) $(build)=perf
 
 $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
