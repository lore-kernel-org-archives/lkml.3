Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbbALODh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:03:37 -0500
Received: from mail.kernel.org ([198.145.29.136]:53404 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbbALODg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:03:36 -0500
Date: Mon, 12 Jan 2015 11:03:31 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 4/4] perf probe: Propagate error code when write(2) failed
Message-ID: <20150112140331.GH12406@kernel.org>
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
 <1420886028-15135-4-git-send-email-namhyung@kernel.org>
 <54B3AD60.5000503@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B3AD60.5000503@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 12, 2015 at 08:17:52PM +0900, Masami Hiramatsu escreveu:
> (2015/01/10 19:33), Namhyung Kim wrote:
> > When it failed to write probe commands to the probe_event file in
> > debugfs, it needs to propagate the error code properly.  Current code
> > blindly uses the return value of the write(2) so it always uses
> > -1 (-EPERM) and it might confuse users.
> > 
> 
> Good catch! :)
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks, applied to perf/urgent
 
> > Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/probe-event.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> > index 6fe5aa357efc..ddc295885af0 100644
> > --- a/tools/perf/util/probe-event.c
> > +++ b/tools/perf/util/probe-event.c
> > @@ -2052,9 +2052,11 @@ static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
> >  	pr_debug("Writing event: %s\n", buf);
> >  	if (!probe_event_dry_run) {
> >  		ret = write(fd, buf, strlen(buf));
> > -		if (ret <= 0)
> > +		if (ret <= 0) {
> > +			ret = -errno;
> >  			pr_warning("Failed to write event: %s\n",
> >  				   strerror_r(errno, sbuf, sizeof(sbuf)));
> > +		}
> >  	}
> >  	free(buf);
> >  	return ret;
> > 
> 
> 
> -- 
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Research Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
