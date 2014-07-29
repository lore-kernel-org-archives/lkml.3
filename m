Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaG2PNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:13:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:56182 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaG2PM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:12:59 -0400
Date: Tue, 29 Jul 2014 12:12:53 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
Message-ID: <20140729151253.GR7831@kernel.org>
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
 <20140729050246.GC22707@bbox>
 <20140729123305.GO7831@kernel.org>
 <20140729132657.GA5022@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729132657.GA5022@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 29, 2014 at 10:26:57PM +0900, Minchan Kim escreveu:
> On Tue, Jul 29, 2014 at 09:33:05AM -0300, Arnaldo Carvalho de Melo wrote:
> > Can you please try the patch below instead?
> 
> Tested. It works.
> And I'd like to say that [2/2] in patchset is handy to me.

Ok, here it is, refreshed, will apply with Namhyung as author as the
change should be functionally equivalent to what he did.

Please check that it works as expected,

Thanks,

- Arnaldo

---

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c3549d5955ea..223a7ffe0d93 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1862,13 +1862,21 @@ int symbol__init(void)
 		       symbol_conf.sym_list_str, "symbol") < 0)
 		goto out_free_comm_list;
 
+	if (symbol_conf.symfs[0] != '\0') {
+		symfs = realpath(symbol_conf.symfs, NULL);
+		if (symfs == NULL) {
+			pr_debug("Cannot apply symfs: %s: %s\n",
+				symbol_conf.symfs, strerror(errno));
+			return -1;
+		}
+	} else {
+		symfs = symbol_conf.symfs;
+	}
+
 	/*
 	 * A path to symbols of "/" is identical to ""
 	 * reset here for simplicity.
 	 */
-	symfs = realpath(symbol_conf.symfs, NULL);
-	if (symfs == NULL)
-		symfs = symbol_conf.symfs;
 	if (strcmp(symfs, "/") == 0)
 		symbol_conf.symfs = "";
 	if (symfs != symbol_conf.symfs)
