Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaIWL5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:57:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbaIWL5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:57:15 -0400
Date: Tue, 23 Sep 2014 13:56:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Milian Wolff <mail@milianw.de>
Subject: [PATCH] perf tools: Fix line number in the config file error message
Message-ID: <20140923115656.GC2979@krava.brq.redhat.com>
References: <1411434104-5307-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411434104-5307-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:01:39AM +0900, Namhyung Kim wrote:
> Hello,
> 
> This is patchset to add new callchain related config options so that
> users don't need to pass their preference to the cmdline everytime.
> 
> Following config options will be added, and users can set appropriate
> values to ~/.perfconfig file.  Note that the dump-size option is
> meaningful only if record-mode = dwarf.
> 
>   $ cat ~/.perfconfig
>   [call-graph]
>     record-mode = dwarf
>     dump-size = 4096
>     print-type = graph
>     order = callee
>     threshold = 0.5
>     print-limit = 128
>     sort-key = function
> 
>   $ perf record -vg sleep 1
>   callchain: type DWARF
>   callchain: stack dump size 4096
>   mmap size 528384B
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.054 MB perf.data (~2378 samples) ]
>   Looking at the vmlinux_path (7 entries long)
>   Using /lib/modules/3.16.3-1-ARCH/build/vmlinux for symbols
> 
> 
> Jiri and David, I kept your Acked-by and Reviewed-by in this version.
> Please take a look at the patch 4/5 which splits parser functions that
> it still looks okay to you.

looks ok to me, ACK for the patchset

During the testing I found wrong line is displayed in the parsing
error message. It's bug in the config code, attached patch should
fix it.

thanks,
jirka


---
If we fail to parse the config file within the callback function,
the line number counter 'could be' already on the next line.

This results in wrong line number report like:

  $ cat ~/.perfconfig
  [call-graph]
          sort-key = krava
  $ perf record ls
  Fatal: bad config file line 3 in /home/jolsa/.perfconfig

Fixing this by saving the current line number for this case.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/config.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 953512ed72ba..57ff826f150b 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -222,7 +222,8 @@ static int perf_parse_file(config_fn_t fn, void *data)
 	const unsigned char *bomptr = utf8_bom;
 
 	for (;;) {
-		int c = get_next_char();
+		int line, c = get_next_char();
+
 		if (bomptr && *bomptr) {
 			/* We are at the file beginning; skip UTF8-encoded BOM
 			 * if present. Sane editors won't put this in on their
@@ -261,8 +262,16 @@ static int perf_parse_file(config_fn_t fn, void *data)
 		if (!isalpha(c))
 			break;
 		var[baselen] = tolower(c);
-		if (get_value(fn, data, var, baselen+1) < 0)
+
+		/*
+		 * The get_value function might or might not reach the '\n',
+		 * so saving the current line number for error reporting.
+		 */
+		line = config_linenr;
+		if (get_value(fn, data, var, baselen+1) < 0) {
+			config_linenr = line;
 			break;
+		}
 	}
 	die("bad config file line %d in %s", config_linenr, config_file_name);
 }
-- 
1.8.3.1

