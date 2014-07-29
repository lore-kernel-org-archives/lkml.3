Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaG2NnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:43:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:50952 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaG2NnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:43:13 -0400
Date: Tue, 29 Jul 2014 10:43:08 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
Message-ID: <20140729134308.GQ7831@kernel.org>
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
 <20140729050246.GC22707@bbox>
 <20140729123305.GO7831@kernel.org>
 <20140729132657.GA5022@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729132657.GA5022@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 29, 2014 at 10:26:57PM +0900, Minchan Kim escreveu:
> Hello,
> 
> On Tue, Jul 29, 2014 at 09:33:05AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Jul 29, 2014 at 02:02:46PM +0900, Minchan Kim escreveu:
> > > On Fri, Jul 25, 2014 at 10:31:47AM +0900, Namhyung Kim wrote:
> > > > Minchan reported that perf failed to load vmlinux if --symfs argument
> > > > doesn't end with '/' character.  So make sure that the symfs always
> > > > ends with the '/'.
> > > > 
> > > > Reported-by: Minchan Kim <minchan@kernel.org>
> > > > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > > 
> > > Both patches work and are handy to me.
> > > Thanks Namhyung.
> > 
> > I haven't said it is not :-) Just that it should be fixed in a different
> > way.
> 
> I just wanted to confirm Namhyung's patches work as reporter. :)
> 
> > 
> > Can you please try the patch below instead?
> 
> Tested. It works.

Thanks, Adding a Tested-by: you, in addition to the Reported-by: you
already there.

> And I'd like to say that [2/2] in patchset is handy to me.

I'll check it.
 
> Thanks.
> 
> > 
> > David, was there any reason not to do it like done in this patch?
> > 
> > - Arnaldo
> > 
> > ---
> >  annotate.c |    4 ++--
> >  dso.c      |    8 ++++----
> >  symbol.c   |    2 +-
> >  3 files changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> > index 809b4c50beae..e67ef4a2b356 100644
> > --- a/tools/perf/util/annotate.c
> > +++ b/tools/perf/util/annotate.c
> > @@ -900,7 +900,7 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
> >  	bool delete_extract = false;
> >  
> >  	if (filename) {
> > -		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
> > +		snprintf(symfs_filename, sizeof(symfs_filename), "%s/%s",
> >  			 symbol_conf.symfs, filename);
> >  	}
> >  
> > @@ -922,7 +922,7 @@ fallback:
> >  		 * DSO is the same as when 'perf record' ran.
> >  		 */
> >  		filename = (char *)dso->long_name;
> > -		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
> > +		snprintf(symfs_filename, sizeof(symfs_filename), "%s/%s",
> >  			 symbol_conf.symfs, filename);
> >  		free_filename = false;
> >  	}
> > diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> > index 90d02c661dd4..f81550583429 100644
> > --- a/tools/perf/util/dso.c
> > +++ b/tools/perf/util/dso.c
> > @@ -79,7 +79,7 @@ int dso__read_binary_type_filename(const struct dso *dso,
> >  		while (last_slash != dso->long_name && *last_slash != '/')
> >  			last_slash--;
> >  
> > -		len = scnprintf(filename, size, "%s", symbol_conf.symfs);
> > +		len = scnprintf(filename, size, "%s/", symbol_conf.symfs);
> >  		dir_size = last_slash - dso->long_name + 2;
> >  		if (dir_size > (size - len)) {
> >  			ret = -1;
> > @@ -108,17 +108,17 @@ int dso__read_binary_type_filename(const struct dso *dso,
> >  	case DSO_BINARY_TYPE__VMLINUX:
> >  	case DSO_BINARY_TYPE__GUEST_VMLINUX:
> >  	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
> > -		snprintf(filename, size, "%s%s",
> > +		snprintf(filename, size, "%s/%s",
> >  			 symbol_conf.symfs, dso->long_name);
> >  		break;
> >  
> >  	case DSO_BINARY_TYPE__GUEST_KMODULE:
> > -		snprintf(filename, size, "%s%s%s", symbol_conf.symfs,
> > +		snprintf(filename, size, "%s/%s/%s", symbol_conf.symfs,
> >  			 root_dir, dso->long_name);
> >  		break;
> >  
> >  	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
> > -		snprintf(filename, size, "%s%s", symbol_conf.symfs,
> > +		snprintf(filename, size, "%s/%s", symbol_conf.symfs,
> >  			 dso->long_name);
> >  		break;
> >  
> > diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> > index eb06746b06b2..c3549d5955ea 100644
> > --- a/tools/perf/util/symbol.c
> > +++ b/tools/perf/util/symbol.c
> > @@ -1468,7 +1468,7 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
> >  	if (vmlinux[0] == '/')
> >  		snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s", vmlinux);
> >  	else
> > -		snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s%s",
> > +		snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s/%s",
> >  			 symbol_conf.symfs, vmlinux);
> >  
> >  	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
> 
> -- 
> Kind regards,
> Minchan Kim
