Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbbAOA0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:26:35 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56526 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbbAOA0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:26:32 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 15 Jan 2015 09:23:59 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v2 2/4] perf tools: Add link argument to
 dso__find_symbol_by_name()
Message-ID: <20150115002359.GB2096@sejong>
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
 <1421234288-22758-2-git-send-email-namhyung@kernel.org>
 <54B69B12.50409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54B69B12.50409@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 09:36:34AM -0700, David Ahern wrote:
> On 1/14/15 4:18 AM, Namhyung Kim wrote:
> >@@ -414,10 +414,24 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
> >  		else if (cmp > 0)
> >  			n = n->rb_right;
> >  		else
> >-			return &s->sym;
> >+			break;
> >  	}
> >
> >-	return NULL;
> >+	if (n == NULL)
> >+		return NULL;
> >+
> >+	/* return first symbol that has same name (if any) */
> >+	for (n = rb_prev(n); n; n = rb_prev(n)) {
> >+		struct symbol_name_rb_node *tmp;
> >+
> >+		tmp = rb_entry(n, struct symbol_name_rb_node, rb_node);
> >+		if (strcmp(tmp->sym.name, s->sym.name))
> 
> strcmp() == 0?

No, at this point the 's' points to the first symbol that has same
name.  And if it finds another symbol (tmp) that has same name, it
updates the s to point to the tmp and continues.  Otherwise it returns
with the existing symbol (s).

Thanks,
Namhyung


> 
> >+			break;
> >+
> >+		s = tmp;
> >+	}
> >+
> >+	return &s->sym;
> >  }
> >
> >  struct symbol *dso__find_symbol(struct dso *dso,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
