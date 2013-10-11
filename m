Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab3JKNmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:42:05 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:64046 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3JKNmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:42:03 -0400
Date: Fri, 11 Oct 2013 10:41:53 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V6 3/8] perf tools: add map__find_other_map_symbol()
Message-ID: <20131011134153.GL28369@ghostprotocols.net>
References: <1381320078-16497-1-git-send-email-adrian.hunter@intel.com>
 <1381320078-16497-4-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381320078-16497-4-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 09, 2013 at 03:01:13PM +0300, Adrian Hunter escreveu:
> Add a function to find a symbol using an ip that
> might be on a different map.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Can you take a look at the following patch? Since we have an
addr_map_symbol struct and the method looks more appropriate to be at
the map_groups abstraction, I thought this is simpler, what do you
think?

This struct is used in the machine__resolve_{mem,bstack} functions.

- Arnaldo

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 17ee458a0870..8f80463d9d46 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -371,6 +371,22 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 	return NULL;
 }
 
+int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
+{
+	if (ams->addr < ams->map->start || ams->addr > ams->map->end) {
+		if (ams->map->groups == NULL)
+			return -1;
+		ams->map = map_groups__find(ams->map->groups, ams->map->type, ams->addr);
+		if (ams->map == NULL)
+			return -1;
+	}
+
+	ams->al_addr = ams->map->map_ip(ams->map, ams->addr);
+	ams->sym = map__find_symbol(ams->map, ams->al_addr, filter);
+
+	return ams->sym ? 0 : -1;
+}
+
 size_t __map_groups__fprintf_maps(struct map_groups *mg,
 				  enum map_type type, int verbose, FILE *fp)
 {
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 4886ca280536..0359b4a808f0 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -167,6 +167,10 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 					       struct map **mapp,
 					       symbol_filter_t filter);
 
+struct addr_map_symbol;
+
+int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter);
+
 static inline
 struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 						 const char *name, struct map **mapp,
