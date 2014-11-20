Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaKTGYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:24:44 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55863 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaKTGYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:24:43 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: "Liang\, Kan" <kan.liang@intel.com>
Cc: "acme\@kernel.org" <acme@kernel.org>,
        "jolsa\@redhat.com" <jolsa@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak\@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V4 3/3] perf tool: Add sort key symoff for perf diff
References: <1416328700-1836-1-git-send-email-kan.liang@intel.com>
	<1416328700-1836-4-git-send-email-kan.liang@intel.com>
	<87vbmbpu0j.fsf@sejong.aot.lge.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701671CE9@SHSMSX103.ccr.corp.intel.com>
Date: Thu, 20 Nov 2014 15:24:41 +0900
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701671CE9@SHSMSX103.ccr.corp.intel.com>
	(Kan Liang's message of "Wed, 19 Nov 2014 14:17:33 +0000")
Message-ID: <8761eapexi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kan,

On Wed, 19 Nov 2014 14:17:33 +0000, Kan Liang wrote:
>> 
>> On Tue, 18 Nov 2014 11:38:20 -0500, kan liang wrote:
>> > From: Kan Liang <kan.liang@intel.com>
>> >
>> > Sometime, especially debugging scaling issue, the function level diff
>> > may be high granularity. The user may want to do deeper diff analysis
>> > for some cache or lock issue. The "symoff" key can let the user sort
>> > differential profile by ips. This feature should only work when the
>> > perf.data comes from same binary.
>> 
>> I think the symoff sort key now works well for different (i.e. modified)
>> binaries too.
>
> For different binaries, the function may be changed. So the offset may
> point to different code. 
> What about this?
> "This feature should work when the perf.data comes from
> either same binary or same function of different binary."
> Or just simply remove this sentence.

I'd like to remove it. :)

>
>> 
>> >
>> >  -s::
>> >  --sort=::
>> > -	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline.
>> > -	Please see description of --sort in the perf-report man page.
>> > +	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline, symoff.
>> > +
>> > +	- symoff: exact symbol +  offset address executed at the time of
>> sample.
>> > +	(for same binary compare)
>> 
>> Ditto.  And symoff is not only for perf diff, but it should work for normal
>> perf report also.  So you'd better move the description to perf report man
>> page IMHO.
>
> OK, I will do it, and also remove "(for same binary compare)"

Thanks!

>
>> 
>> 
>> > +
>> > +	For other keys, please see description of --sort in the perf-report
>> man page.
>> >
>> >  -t::
>> >  --field-separator=::
>> > diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
>> > index 1ce425d..03a4001 100644
>> > --- a/tools/perf/builtin-diff.c
>> > +++ b/tools/perf/builtin-diff.c
>> > @@ -744,7 +744,7 @@ static const struct option options[] = {
>> >  	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str,
>> "symbol[,symbol...]",
>> >  		   "only consider these symbols"),
>> >  	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
>> > -		   "sort by key(s): pid, comm, dso, symbol, parent, cpu,
>> srcline, ..."
>> > +		   "sort by key(s): pid, comm, dso, symbol, parent, cpu,
>> srcline, symoff, ..."
>> >  		   " Please refer the man page for the complete list."),
>> >  	OPT_STRING('t', "field-separator", &symbol_conf.field_sep,
>> "separator",
>> >  		   "separator for columns, no spaces will be added between
>> "
>> > diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c index
>> > 6e88b9e..3d8a71b 100644
>> > --- a/tools/perf/util/hist.c
>> > +++ b/tools/perf/util/hist.c
>> > @@ -67,13 +67,14 @@ void hists__calc_col_len(struct hists *hists, struct
>> hist_entry *h)
>> >  		symlen = h->ms.sym->namelen + 4;
>> >  		if (verbose)
>> >  			symlen += BITS_PER_LONG / 4 + 2 + 3;
>> > -		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
>> >  	} else {
>> >  		symlen = unresolved_col_width + 4 + 2;
>> > -		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
>> >  		hists__set_unres_dso_col_len(hists, HISTC_DSO);
>> >  	}
>> >
>> > +	hists__new_col_len(hists, HISTC_SYMBOL, symlen);
>> > +	hists__new_col_len(hists, HISTC_SYMOFF, symlen);
>> 
>> SYMOFF will need larger length at least 6 (for "+0xYYY").  Idealy 3 + symbol
>> size in hexdigit?
>> 
>
> We also need to handle the case which doesn't have symbol available.
> What about this?

I'm fine with it (but I believe you'll fix the indentation).

Thanks,
Namhyung

>         /*
> +      * +6 accounts for '"+0xYYY ' symoff info
>          * +4 accounts for '[x] ' priv level info
>          * +2 accounts for 0x prefix on raw addresses
>          * +3 accounts for ' y ' symtab origin info
>          */	
>                  if (h->ms.sym) {
> 		symlen = h->ms.sym->namelen + 4;
> 		if (verbose)
> 			symlen += BITS_PER_LONG / 4 + 2 + 3;
> 		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
>
> +                              symlen = h->ms.sym->namelen + 6
> +	                hists__new_col_len(hists, HISTC_SYMOFF, symlen);
> 	} else {
> 		symlen = unresolved_col_width + 4 + 2;
> 		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
> 		hists__set_unres_dso_col_len(hists, HISTC_DSO);
> +                             symlen = unresolved_col_width + 2
> +                             hists__new_col_len(hists, HISTC_SYMOFF, symlen);
> 	}
