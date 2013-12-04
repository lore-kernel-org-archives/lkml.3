Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3LDLBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:01:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab3LDLBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:01:17 -0500
Date: Wed, 4 Dec 2013 10:29:34 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 22/28] tools lib traceevent: Remove malloc_or_die from
 event-plugin.c
Message-ID: <20131204092934.GB1219@krava.brq.redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
 <1386076182-14484-23-git-send-email-jolsa@redhat.com>
 <20131203111601.540ed5f7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203111601.540ed5f7@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:16:01AM -0500, Steven Rostedt wrote:
> On Tue,  3 Dec 2013 14:09:36 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > Removing malloc_or_die calls from event-plugin.c,
> > replacing them with standard malloc and error path.
> > 
> > Suggested-by: Namhyung Kim <namhyung@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: David Ahern <dsahern@gmail.com>
> > ---
> >  tools/lib/traceevent/event-plugin.c | 19 ++++++++++++++++---
> >  1 file changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
> > index d272d87..125f567 100644
> > --- a/tools/lib/traceevent/event-plugin.c
> > +++ b/tools/lib/traceevent/event-plugin.c
> > @@ -47,7 +47,11 @@ load_plugin(struct pevent *pevent, const char *path,
> >  	char *plugin;
> >  	void *handle;
> >  
> > -	plugin = malloc_or_die(strlen(path) + strlen(file) + 2);
> > +	plugin = malloc(strlen(path) + strlen(file) + 2);
> > +	if (!plugin) {
> > +		warning("could not allocate plugin memory\n");
> > +		return;
> 
> This should be changed to return an error code. Yes it will require
> other places to change for that update as well.

Any chance this could be a separated feature? ;-)

AFACIS there's no technical problem with the current code.
If the load_plugin fails (due to ENOMEM or interface error)
it's not added on the plugin_list, which is the output/handle
of plugin interface (and there's warning ;-)).

I think we need some complex/unified error handling for the
whole library and add that globally.

jirka
