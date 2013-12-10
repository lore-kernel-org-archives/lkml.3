Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3LJMSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:18:17 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:58013 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3LJMSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:18:06 -0500
Date: Tue, 10 Dec 2013 13:18:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ben Cheng <bccheng@google.com>, David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
Message-ID: <20131210121801.GC30001@gmail.com>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
 <20131210111229.GB26659@gmail.com>
 <20131210114421.GI8098@ghostprotocols.net>
 <52A70558.90808@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A70558.90808@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Hunter <adrian.hunter@intel.com> wrote:

> -void dso__set_short_name(struct dso *dso, const char *name)
> +void dso__set_short_name(struct dso *dso, const char *name, bool sname_alloc)
>  {
>  	if (name == NULL)
>  		return;
> +	if (dso->sname_alloc)
> +		free((char *)dso->short_name);
> +	dso->sname_alloc = sname_alloc;

Calling the function option the same as the field name is asking for 
trouble - I'd suggest 'new_sname_alloc' for the parameter, or so.

And I'd also remove the 'const' from struct dso::short_name, it 
probably does not help code generation, because 'dso' is passed in as 
const in all the non-lifetime methods anyway.

That way the cast can be dropped from the free().

Similar problems exist with the usage of 'short_name' - it overloads 
the field name which makes it somewhat confusing, and it's also 
sometimes inconsistently named, such as 'name' in 
dso__set_short_name().

Ditto for 'long_name' handling.

Also, the 'sname_alloc' name sucks, it does not make it obvious that 
it's related to 'short_name', hiding its true significance (and hiding 
the broken life time handling of the flag/pointer combo). I'd rename 
it to something more descriptive, like ->short_name_allocated - or I'd 
rename everything to 'sname'/'lname' naming for short/long names.

Every time one runs into a crash like this it's a canary signal that 
cleanliness principles need hardening.

Thanks,

	Ingo
