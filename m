Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbbANQgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:36:39 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64994 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbbANQgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:36:38 -0500
Message-ID: <54B69B12.50409@gmail.com>
Date: Wed, 14 Jan 2015 09:36:34 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v2 2/4] perf tools: Add link argument to dso__find_symbol_by_name()
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org> <1421234288-22758-2-git-send-email-namhyung@kernel.org>
In-Reply-To: <1421234288-22758-2-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/15 4:18 AM, Namhyung Kim wrote:
> @@ -414,10 +414,24 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
>   		else if (cmp > 0)
>   			n = n->rb_right;
>   		else
> -			return &s->sym;
> +			break;
>   	}
>
> -	return NULL;
> +	if (n == NULL)
> +		return NULL;
> +
> +	/* return first symbol that has same name (if any) */
> +	for (n = rb_prev(n); n; n = rb_prev(n)) {
> +		struct symbol_name_rb_node *tmp;
> +
> +		tmp = rb_entry(n, struct symbol_name_rb_node, rb_node);
> +		if (strcmp(tmp->sym.name, s->sym.name))

strcmp() == 0?

> +			break;
> +
> +		s = tmp;
> +	}
> +
> +	return &s->sym;
>   }
>
>   struct symbol *dso__find_symbol(struct dso *dso,

