Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971Ab3DDAzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:55:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57583 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761784Ab3DDAzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:55:37 -0400
X-AuditID: 9c930179-b7b2aae000000518-56-515ccf870471
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 09/10] perf hist browser: Use sort__has_sym
References: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
	<1364991979-3008-10-git-send-email-namhyung@kernel.org>
	<20130403170754.GA7238@ghostprotocols.net>
Date: Thu, 04 Apr 2013 09:55:35 +0900
In-Reply-To: <20130403170754.GA7238@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 3 Apr 2013 14:07:54 -0300")
Message-ID: <87li8zdshk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013 14:07:54 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Apr 03, 2013 at 09:26:18PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The TUI hist browser had a similar variable has_symbols for the same
>> purpose.  Let's get rid of the duplication.
>
> I'm ok with that, if it involves removing sort__has_sym, that is a
> global variable, making it impossible to use different sort orders in
> the same session, if we ever want to do that :-)

So you want to keep current code for a potential future change?

Anyway it seems current logic would fail if only "symbol_to" sort key
was used without "symbol_from" in branch mode.

Thanks,
Namhyung

>  
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/ui/browsers/hists.c | 9 ++-------
>>  1 file changed, 2 insertions(+), 7 deletions(-)
>> 
>> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
>> index cad8e37f05d9..a4268cab1921 100644
>> --- a/tools/perf/ui/browsers/hists.c
>> +++ b/tools/perf/ui/browsers/hists.c
>> @@ -25,7 +25,6 @@ struct hist_browser {
>>  	struct map_symbol   *selection;
>>  	int		     print_seq;
>>  	bool		     show_dso;
>> -	bool		     has_symbols;
>>  };
>>  
>>  extern void hist_browser__init_hpp(void);
>> @@ -1155,10 +1154,6 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
>>  		browser->b.refresh = hist_browser__refresh;
>>  		browser->b.seek = ui_browser__hists_seek;
>>  		browser->b.use_navkeypressed = true;
>> -		if (sort__mode == SORT_MODE__BRANCH)
>> -			browser->has_symbols = sort_sym_from.list.next != NULL;
>> -		else
>> -			browser->has_symbols = sort_sym.list.next != NULL;
>>  	}
>>  
>>  	return browser;
>> @@ -1386,7 +1381,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>>  			 */
>>  			goto out_free_stack;
>>  		case 'a':
>> -			if (!browser->has_symbols) {
>> +			if (!sort__has_sym) {
>>  				ui_browser__warning(&browser->b, delay_secs * 2,
>>  			"Annotation is only available for symbolic views, "
>>  			"include \"sym*\" in --sort to use it.");
>> @@ -1485,7 +1480,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>>  			continue;
>>  		}
>>  
>> -		if (!browser->has_symbols)
>> +		if (!sort__has_sym)
>>  			goto add_exit_option;
>>  
>>  		if (sort__mode == SORT_MODE__BRANCH) {
>> -- 
>> 1.7.11.7
