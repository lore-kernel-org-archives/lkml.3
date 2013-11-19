Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3KSCbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:31:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:47778 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751105Ab3KSCbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:31:33 -0500
Date: Mon, 18 Nov 2013 21:31:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: tools lib traceevent: Report better error message on bad
 function args
Message-ID: <20131118213131.57232871@gandalf.local.home>
In-Reply-To: <87siutt9hf.fsf@sejong.aot.lge.com>
References: <20131118191131.165034f8@gandalf.local.home>
	<87siutt9hf.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013 11:23:56 +0900
Namhyung Kim <namhyung@kernel.org> wrote:
 
> >  	arg->type = PRINT_FUNC;
> > @@ -2708,15 +2707,19 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
> >  		}
> >  
> >  		type = process_arg(event, farg, &token);
> > -		if (i < (func->nr_args - 1))
> > -			test = ",";
> > -		else
> > -			test = ")";
> > -
> > -		if (test_type_token(type, token, EVENT_DELIM, test)) {
> > -			free_arg(farg);
> > -			free_token(token);
> > -			return EVENT_ERROR;
> > +		if (i < (func->nr_args - 1)) {
> > +			if (type != EVENT_DELIM || strcmp(token, ",") != 0) {
> > +				warning("Error: function '%s()' expects %d arguments but event %s only uses %d",
> > +					func->name, func->nr_args,
> > +					event->name, i + 1);
> > +				return EVENT_ERROR;
> > +			}
> > +		} else {
> > +			if (type != EVENT_DELIM || strcmp(token, ")") != 0) {
> > +				warning("Error: function '%s()' only expects %d arguments but event %s has more",
> > +					func->name, func->nr_args, event->name);
> > +				return EVENT_ERROR;
> 
> It seems that you missed to free farg and token in error paths.
> 

Ug, you're right!

Thanks for the review. v2 coming up.

-- Steve
