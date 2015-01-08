Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbbAHGRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 01:17:13 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:44436 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbbAHGRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 01:17:12 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 8 Jan 2015 15:15:09 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/30] perf build: Add libperf objects building
Message-ID: <20150108061509.GC7268@sejong>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
 <1420212972-21595-8-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420212972-21595-8-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 04:35:49PM +0100, Jiri Olsa wrote:
> Move the util objects building under build framework.
> 
> Add new libperf build object so it's separated from
> the rest of the perf code and could be librarized.
>


[SNIP]
> +$(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
> +	@$(call echo-cmd,bison)$(FLEX) -o $@ --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) util/parse-events.l
                         ^^^^^
s/bison/flex/ ?


> +
> +$(OUTPUT)util/parse-events-bison.c: util/parse-events.y
> +	@$(call echo-cmd,bison)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_

I guess we can simply use "-o $@" here.


> +
> +$(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
> +	@$(call echo-cmd,flex)$(FLEX) -o $@ --header-file=$(OUTPUT)util/pmu-flex.h util/pmu.l
> +
> +$(OUTPUT)util/pmu-bison.c: util/pmu.y
> +	@$(call echo-cmd,bison)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_

Ditto.

Thanks,
Namhyung


> +
> +CFLAGS_parse-events-flex.o  += -w
> +CFLAGS_pmu-flex.o           += -w
> +CFLAGS_parse-events-bison.o += -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w
> +CFLAGS_pmu-bison.o          += -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w
> +
> +$(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
> +$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
> +
> +CFLAGS_find_next_bit.o += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
> +CFLAGS_rbtree.o        += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
> +CFLAGS_parse-events.o  += -Wno-redundant-decls
> +
> +$(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c FORCE
> +	$(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)util/find_next_bit.o: ../lib/util/find_next_bit.c FORCE
> +	$(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c FORCE
> +	$(call if_changed_dep,cc_o_c)
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
