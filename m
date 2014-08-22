Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaHVPYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbaHVPYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:24:12 -0400
Date: Fri, 22 Aug 2014 17:23:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] perf tools: Add +field argument support for --sort
 option
Message-ID: <20140822152354.GB22315@krava.brq.redhat.com>
References: <1408715919-25990-1-git-send-email-jolsa@kernel.org>
 <1408715919-25990-3-git-send-email-jolsa@kernel.org>
 <20140822151651.GC3473@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822151651.GC3473@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 12:16:51PM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> >  }
> >  
> > +static int setup_sort_order(void)
> > +{
> > +#define BUF_MAX 4096
> 
> This is an arbitrary value, and you will use this just here, so you
> could just have used a number and later used sizeof(buf).
> 
> Anyway, what bothers me is the use of yet another static buffer.
> 
> The thing to use here is asprintf, that will do it all for you, format
> _and_ allocate a buffer the size you need.
> 
> > +	static char buf[BUF_MAX];
> > +
> > +	if (!sort_order || is_strict_order(sort_order))
> > +		return 0;
> > +
> > +	if (!strlen(sort_order + 1)) {
> > +		error("Invalid --fields key: `+'");
> > +		return -EINVAL;
> > +	}
> > +
> > +	scnprintf(buf, BUF_MAX, "%s,%s",
> > +		  get_default_sort_order(),
> > +		  sort_order + 1);
> > +
> > +	sort_order = buf;
> 
> I.e. it would be better to have this as:
> 
> 	char *new_sort_order;
> 
> 	if (sort_order[1] == '\0') {
> 		error("Invalid --fields key: `+'");
> 		return -EINVAL;
> 	}
> 
> 	if (asprintf(&new_sort_order, "%s,%s",
> 		     get_default_sort_order(), sort_order + 1) < 0) {
> 		error("Not enough memory to set up --sort");
> 		return -ENOMEM;
> 	}

ok, will check the asprintf

> 		
> 	sort_order = new_sort_order;
> 
> > +	return 0;
> 
> 
> Also please fix the error message, there is a cut'n'paste error there :-)

aargh right ;-)

I'll send v2

thanks,
jirka
