Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaFMGZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:25:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaFMGZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:25:24 -0400
Date: Thu, 12 Jun 2014 23:25:03 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ca40e2af1f75eddf7eb2b93fde6391ea185d8fc8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-3-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-3-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Separate dso data related variables
Git-Commit-ID: ca40e2af1f75eddf7eb2b93fde6391ea185d8fc8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca40e2af1f75eddf7eb2b93fde6391ea185d8fc8
Gitweb:     http://git.kernel.org/tip/ca40e2af1f75eddf7eb2b93fde6391ea185d8fc8
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 7 May 2014 18:30:45 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:19 +0200

perf tools: Separate dso data related variables

Add separated structure/namespace for data related
variables. We are going to add mode of them, so this
way they will be clearly separated.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-3-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c | 8 ++++----
 tools/perf/util/dso.h | 7 ++++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 64453d6..1c3cdaf 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -292,7 +292,7 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 
 		cache->offset = cache_offset;
 		cache->size   = ret;
-		dso_cache__insert(&dso->cache, cache);
+		dso_cache__insert(&dso->data.cache, cache);
 
 		ret = dso_cache__memcpy(cache, offset, data, size);
 
@@ -310,7 +310,7 @@ static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
 {
 	struct dso_cache *cache;
 
-	cache = dso_cache__find(&dso->cache, offset);
+	cache = dso_cache__find(&dso->data.cache, offset);
 	if (cache)
 		return dso_cache__memcpy(cache, offset, data, size);
 	else
@@ -473,7 +473,7 @@ struct dso *dso__new(const char *name)
 		dso__set_short_name(dso, dso->name, false);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
-		dso->cache = RB_ROOT;
+		dso->data.cache = RB_ROOT;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->binary_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->loaded = 0;
@@ -506,7 +506,7 @@ void dso__delete(struct dso *dso)
 		dso->long_name_allocated = false;
 	}
 
-	dso_cache__free(&dso->cache);
+	dso_cache__free(&dso->data.cache);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
 	free(dso);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 38efe95..7637fdd 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -76,7 +76,6 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
-	struct rb_root	 cache;
 	void		 *a2l;
 	char		 *symsrc_filename;
 	unsigned int	 a2l_fails;
@@ -99,6 +98,12 @@ struct dso {
 	const char	 *long_name;
 	u16		 long_name_len;
 	u16		 short_name_len;
+
+	/* dso data file */
+	struct {
+		struct rb_root	 cache;
+	} data;
+
 	char		 name[0];
 };
 
