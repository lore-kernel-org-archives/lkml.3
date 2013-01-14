Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3ANNoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:44:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab3ANNoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:44:23 -0500
Date: Mon, 14 Jan 2013 10:44:16 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] perf: tui: Fix segfault when drawing out-of-bounds jumps
Message-ID: <20130114134416.GA8768@infradead.org>
References: <20130112000043.GC32415@ks398093.ip-192-95-24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130112000043.GC32415@ks398093.ip-192-95-24.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 11, 2013 at 07:00:43PM -0500, Frederik Deweerdt escreveu:
> Hi,
> 
> When perf.data contains out-of-symbol jumps,
> annotate_browser__mark_jump_targets() correctly avoids marking
> out-of-symbol jump targets. However, when moving the cursor on one of
> said jumps, annotate_browser__draw_current_jump() will end up with a
> bogus 'target' pointer, causing a bogus memory access when dereferencing
> 'bcursor' or 'btarget'
> 
> The following patch performs the same check as mark_jump_targets()
> in order to avoid drawing the bogus jump.

Thanks, I'll apply this one later today and introduce a
disasm_line__is_valid_jump(cursor) routine to be used in both mark and
draw routines, if you don't do it first :-)

- Arnaldo
 
> Regards,
> Frederik
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
> 
> diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
> index 5dab3ca..8b84246 100644
> --- a/tools/perf/ui/browsers/annotate.c
> +++ b/tools/perf/ui/browsers/annotate.c
> @@ -195,8 +195,9 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
>  	if (strstr(sym->name, "@plt"))
>  		return;
>  
> -	if (!cursor || !cursor->ins || !ins__is_jump(cursor->ins) ||
> -	    !disasm_line__has_offset(cursor))
> +	if (!cursor || !cursor->ins || !ins__is_jump(cursor->ins)
> +	    || !disasm_line__has_offset(cursor)
> +	    || cursor->ops.target.offset >= symbol__size(sym))
>  		return;
>  
>  	target = ab->offsets[cursor->ops.target.offset];
