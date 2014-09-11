Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbaIKP1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:27:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:33487 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbaIKP1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:27:33 -0400
Date: Thu, 11 Sep 2014 12:27:26 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tools lib fd array: Do not set fd as non blocking evlist
Message-ID: <20140911152726.GJ10158@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-12-git-send-email-acme@kernel.org>
 <20140911150943.GD32722@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911150943.GD32722@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 11, 2014 at 05:09:43PM +0200, Jiri Olsa escreveu:
> On Wed, Sep 10, 2014 at 11:08:46AM -0300, Arnaldo Carvalho de Melo wrote:
> 
> SNIP
> 
> > +}
> > +
> > +void fdarray__exit(struct fdarray *fda)
> > +{
> > +	free(fda->entries);
> > +	fdarray__init(fda, 0);
> > +}
> > +
> > +void fdarray__delete(struct fdarray *fda)
> > +{
> > +	fdarray__exit(fda);
> > +	free(fda);
> > +}
> > +
> > +int fdarray__add(struct fdarray *fda, int fd, short revents)
> > +{
> > +	if (fda->nr == fda->nr_alloc &&
> > +	    fdarray__grow(fda, fda->nr_autogrow) < 0)
> > +		return -ENOMEM;
> > +
> > +	fcntl(fd, F_SETFL, O_NONBLOCK);
> 
> also I spot this one and couldn't think of reason for it, attached
> patch makes no behaviour difference for me..

Have to look why it is there, perhaps there is some changeset
specifically made for this, will do some research...
 
> I might be missing something, but I dont see any blocking operation
> in perf related data reads. The git log history says it was there
> since early days.

Oops, you did that research already, have you followed the history all
the way to when this code lived in Documentation/ ?

But yes, I agree with your comment that this is something up to the
users to do, not for a general purpose class as fdarray is set out to
be.

I think the way to do this is to not move this fcntl when introducing
the fdarray class, but instead leave it at the perf_evlist__add_pollfd()
function, then, in a later patch, if we determine that it is not needed
at all, nuke it, ok?

- Arnaldo
 
> jirka
> 
> 
> ---
> There's no reason for the current user of this API
> to have non blocking fds. Also it should be up to
> user to set this, not this object.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/api/fd/array.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
> index 3f6d1a0..0e636c4 100644
> --- a/tools/lib/api/fd/array.c
> +++ b/tools/lib/api/fd/array.c
> @@ -78,7 +78,6 @@ int fdarray__add(struct fdarray *fda, int fd, short revents)
>  	    fdarray__grow(fda, fda->nr_autogrow) < 0)
>  		return -ENOMEM;
>  
> -	fcntl(fd, F_SETFL, O_NONBLOCK);
>  	fda->entries[fda->nr].fd     = fd;
>  	fda->entries[fda->nr].events = revents;
>  	fda->nr++;
> -- 
> 1.7.7.6
> 
