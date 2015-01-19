Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbbASPIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:08:46 -0500
Received: from mail.kernel.org ([198.145.29.136]:36515 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbbASPIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:08:45 -0500
Date: Mon, 19 Jan 2015 12:08:38 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf annotate: handle ins parsing failures
Message-ID: <20150119150838.GA3451@kernel.org>
References: <1421607621-15005-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421607621-15005-1-git-send-email-rabin@rab.in>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jan 18, 2015 at 08:00:20PM +0100, Rabin Vincent escreveu:
> Don't use the ins's ->sncprintf() if the parsing failed.
> 
> For example, this fixes the display of "imul %edx".  Without this patch:
> 
>        |      imul   (null),(null)
> 
> After this patch:
> 
>        |      imul   %edx

Thanks, both applied!

- Arnaldo
 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  tools/perf/util/annotate.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 79999ce..5ae428b 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -183,8 +183,9 @@ static int lock__parse(struct ins_operands *ops)
>  	if (!ops->locked.ins->ops)
>  		return 0;
>  
> -	if (ops->locked.ins->ops->parse)
> -		ops->locked.ins->ops->parse(ops->locked.ops);
> +	if (ops->locked.ins->ops->parse
> +	    && ops->locked.ins->ops->parse(ops->locked.ops) < 0)
> +		goto out_free_ops;
>  
>  	return 0;
>  
> @@ -531,8 +532,8 @@ static void disasm_line__init_ins(struct disasm_line *dl)
>  	if (!dl->ins->ops)
>  		return;
>  
> -	if (dl->ins->ops->parse)
> -		dl->ins->ops->parse(&dl->ops);
> +	if (dl->ins->ops->parse && dl->ins->ops->parse(&dl->ops) < 0)
> +		dl->ins = NULL;
>  }
>  
>  static int disasm_line__parse(char *line, char **namep, char **rawp)
> -- 
> 2.1.4
