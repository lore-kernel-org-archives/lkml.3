Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbaD2IGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:06:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022AbaD2IGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:06:35 -0400
Date: Tue, 29 Apr 2014 10:06:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Richard Yao <ryao@gentoo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf machine: Search for modules in %s/lib/modules/%s
Message-ID: <20140429080617.GA26967@krava.brq.redhat.com>
References: <1398532675-13684-1-git-send-email-ryao@gentoo.org>
 <20140427100556.GB1111@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140427100556.GB1111@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:05:56PM +0200, Jiri Olsa wrote:
> On Sat, Apr 26, 2014 at 01:17:55PM -0400, Richard Yao wrote:
> > Modules installed outside of the kernel's build system should go into
> > "%s/lib/modules/%s/extra", but at present, perf will only look at them
> > when they are in "%s/lib/modules/%s/kernel". Lets encourage good
> > citizenship by relaxing this requirement to "%s/lib/modules/%s". This
> > way open source modules that are out-of-tree have no incentive to start
> > populating a directory reserved for in-kernel modules and I can stop
> > hex-editing my system's perf binary when profiling OSS out-of-tree
> > modules.
> > 
> > Feedback from Namhyung Kim correctly revealed that the hex-edits that I
> > had been doing meant that perf was also traversing the build and source
> > symlinks in %s/lib/modules/%s. That is undesireable, so we explicitly
> > exclude them from traversal with a minor tweak to the traversal routine.
> 
> looks good to me, Namhyung?

just realized Namhyung wasn't CC-ed on this one ;-)

jirka

> 
> thanks,
> jirka
> 
> > 
> > Signed-off-by: Richard Yao <ryao@gentoo.org>
> > ---
> >  tools/perf/util/machine.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> > index a53cd0b..27c2a5e 100644
> > --- a/tools/perf/util/machine.c
> > +++ b/tools/perf/util/machine.c
> > @@ -717,7 +717,7 @@ static char *get_kernel_version(const char *root_dir)
> >  }
> >  
> >  static int map_groups__set_modules_path_dir(struct map_groups *mg,
> > -				const char *dir_name)
> > +				const char *dir_name, int depth)
> >  {
> >  	struct dirent *dent;
> >  	DIR *dir = opendir(dir_name);
> > @@ -742,7 +742,15 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
> >  			    !strcmp(dent->d_name, ".."))
> >  				continue;
> >  
> > -			ret = map_groups__set_modules_path_dir(mg, path);
> > +			/* Do not follow top-level source and build symlinks */
> > +			if (depth == 0) {
> > +				if (!strcmp(dent->d_name, "source") ||
> > +				    !strcmp(dent->d_name, "build"))
> > +					continue;
> > +			}
> > +
> > +			ret = map_groups__set_modules_path_dir(mg, path,
> > +							       depth + 1);
> >  			if (ret < 0)
> >  				goto out;
> >  		} else {
> > @@ -786,11 +794,11 @@ static int machine__set_modules_path(struct machine *machine)
> >  	if (!version)
> >  		return -1;
> >  
> > -	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
> > +	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s",
> >  		 machine->root_dir, version);
> >  	free(version);
> >  
> > -	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path);
> > +	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path, 0);
> >  }
> >  
> >  static int machine__create_module(void *arg, const char *name, u64 start)
> > -- 
> > 1.8.3.2
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
