Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaGJNu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:50:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:45878 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbaGJNu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:50:27 -0400
Date: Thu, 10 Jul 2014 10:50:22 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/16] perf hists browser: Override ui_browser
 refresh_dimensions method
Message-ID: <20140710135022.GB8014@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
 <1404846184-20075-5-git-send-email-acme@kernel.org>
 <20140709224849.GA23232@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709224849.GA23232@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 10, 2014 at 12:48:49AM +0200, Jiri Olsa escreveu:
> On Tue, Jul 08, 2014 at 04:02:52PM -0300, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> 
> SNIP
> 
> > index ca63564d203a..ef7abf896f5a 100644
> > --- a/tools/perf/ui/browsers/hists.c
> > +++ b/tools/perf/ui/browsers/hists.c
> > @@ -56,11 +56,19 @@ static u32 hist_browser__nr_entries(struct hist_browser *hb)
> >  	return nr_entries + hb->nr_callchain_rows;
> >  }
> >  
> > -static void hist_browser__refresh_dimensions(struct hist_browser *browser)
> > +static void hist_browser__refresh_dimensions(struct ui_browser *browser)
> >  {
> > +	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
> > +
> >  	/* 3 == +/- toggle symbol before actual hist_entry rendering */
> > -	browser->b.width = 3 + (hists__sort_list_width(browser->hists) +
> > -			     sizeof("[k]"));
> > +	browser->width = 3 + (hists__sort_list_width(hb->hists) + sizeof("[k]"));
> 
> why not remove this completely? it'll get overwritten in the
> following ui_browser__refresh_dimensions call anyway..

I thought I left a comment below it explaining that this would get fixed
at a later patch, but yeah, we can comment it out, leaving it just as a
hint at what needs to be done if we ever want to partition the screen
horizontally.
 
> > +	/*
> > + 	 * FIXME: Just keeping existing behaviour, but this really should be
> > + 	 *	  before updating browser->width, as it will invalidate the
> > + 	 *	  calculation above. Fix this and the fallout in another
> > + 	 *	  changeset.
> > + 	 */
> 
> extra whitespace above

Gack, thought I had that fixed, will check my pre-commit hooks... now:

  [acme@zoo linux]$ ls -la .git/hooks/pre-commit.sample 
  -rwxrwxr-x. 1 acme acme 1704 Abr 16  2013 .git/hooks/pre-commit.sample
  [acme@zoo linux]$ mv .git/hooks/pre-commit.sample .git/hooks/pre-commit
  [acme@zoo linux]$ vim .git/hooks/pre-commit
  [acme@zoo linux]$ tail -3 .git/hooks/pre-commit

  # If there are whitespace errors, print the offending file names and
  # fail.
  exec git diff-index --check --cached $against --
  [acme@zoo linux]

I guess I should catch those on this machine from now on.

- Arnaldo
