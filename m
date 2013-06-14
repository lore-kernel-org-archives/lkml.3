Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3FNH3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:29:24 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:33870 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3FNH3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:29:23 -0400
Date: Fri, 14 Jun 2013 09:29:18 +0200
From: Robert Richter <rric@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] perf tools: Retry mapping buffers readonly on EACCES
Message-ID: <20130614072918.GT12218@rric.localhost>
References: <1369991785-10499-1-git-send-email-rric@kernel.org>
 <1369991785-10499-5-git-send-email-rric@kernel.org>
 <87ip1h30lz.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip1h30lz.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.06.13 11:08:40, Namhyung Kim wrote:
> > -	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
> > +try_again2:
> > +	if (perf_evlist__mmap(evlist, opts->mmap_pages, opts->mmap_ro) < 0) {
> > +		if (!opts->mmap_ro && errno == EACCES) {
> > +			opts->mmap_ro = true;
> > +			goto try_again2;
> > +		}
> >  		ui__error("Failed to mmap with %d (%s)\n",
> >  			    errno, strerror(errno));
> >  		goto out_err;
> 
> 
> You will need this also:
> 
> 
> @@ -161,7 +161,8 @@ static int perf_record__mmap_read(struct perf_record *rec,
>         }
>  
>         md->prev = old;
> -       perf_mmap__write_tail(md, old);
> +       if (!rec->opts.mmap_ro)
> +               perf_mmap__write_tail(md, old);
>  
>  out:
>         return rc;

Yes, indeed. Will add your change

-Robert
