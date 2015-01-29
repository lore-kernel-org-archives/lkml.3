Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbbA2NXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:23:37 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55597 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbbA2NXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:23:36 -0500
Date: Thu, 29 Jan 2015 22:23:15 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 40/42] perf callchain: Save eh/debug frame offset for
 dwarf unwind
Message-ID: <20150129132315.GB29130@danjae>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
 <1422518843-25818-41-git-send-email-namhyung@kernel.org>
 <20150129123831.GT7220@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150129123831.GT7220@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 09:38:31AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jan 29, 2015 at 05:07:21PM +0900, Namhyung Kim escreveu:
> > When libunwind tries to resolve callchains it needs to know the offset
> > of .eh_frame_hdr or .debug_frame to access the dso.  Since it calls
> > dso__data_fd(), it'll try to grab dso->lock everytime for same
> > information.  So save it to dso_data struct and reuse it.
> > 
> > Note that there's a window between dso__data_fd() and actual use of
> > the fd.  The fd could be closed by other threads to deal with the open
> > file limit in dso cache code.  But I think it's ok since in that case
> > elf_section_offset() will return 0 so it'll be tried in next acess.
> 
> I know that you did this in the context of your multi threading
> patchkit, but this seems useful even without that patckhit, i.e. this
> can be cherry picked on the grounds that it speeds up things by caching
> something that doesn't change, right?

Right.

> 
> I.e. I'll probably just rewrite the comment and apply it before
> considering the other patches, so that other people can comment on the
> other patches, etc.

Thanks for doing that!
Namhyung


> 
> - Arnaldo
>  
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/dso.h              |  1 +
> >  tools/perf/util/unwind-libunwind.c | 31 ++++++++++++++++++++-----------
> >  2 files changed, 21 insertions(+), 11 deletions(-)
> > 
> > diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> > index c18fcc0e8081..323ee08d56fc 100644
> > --- a/tools/perf/util/dso.h
> > +++ b/tools/perf/util/dso.h
> > @@ -141,6 +141,7 @@ struct dso {
> >  		u32		 status_seen;
> >  		size_t		 file_size;
> >  		struct list_head open_entry;
> > +		u64		 frame_offset;
> >  	} data;
> >  
> >  	union { /* Tool specific area */
> > diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
> > index 7ed6eaf232b6..3219b20837b5 100644
> > --- a/tools/perf/util/unwind-libunwind.c
> > +++ b/tools/perf/util/unwind-libunwind.c
> > @@ -266,14 +266,17 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
> >  				     u64 *fde_count)
> >  {
> >  	int ret = -EINVAL, fd;
> > -	u64 offset;
> > +	u64 offset = dso->data.frame_offset;
> >  
> > -	fd = dso__data_fd(dso, machine);
> > -	if (fd < 0)
> > -		return -EINVAL;
> > +	if (offset == 0) {
> > +		fd = dso__data_fd(dso, machine);
> > +		if (fd < 0)
> > +			return -EINVAL;
> >  
> > -	/* Check the .eh_frame section for unwinding info */
> > -	offset = elf_section_offset(fd, ".eh_frame_hdr");
> > +		/* Check the .eh_frame section for unwinding info */
> > +		offset = elf_section_offset(fd, ".eh_frame_hdr");
> > +		dso->data.frame_offset = offset;
> > +	}
> >  
> >  	if (offset)
> >  		ret = unwind_spec_ehframe(dso, machine, offset,
> > @@ -287,14 +290,20 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
> >  static int read_unwind_spec_debug_frame(struct dso *dso,
> >  					struct machine *machine, u64 *offset)
> >  {
> > -	int fd = dso__data_fd(dso, machine);
> > +	int fd;
> > +	u64 ofs = dso->data.frame_offset;
> >  
> > -	if (fd < 0)
> > -		return -EINVAL;
> > +	if (ofs == 0) {
> > +		fd = dso__data_fd(dso, machine);
> > +		if (fd < 0)
> > +			return -EINVAL;
> >  
> > -	/* Check the .debug_frame section for unwinding info */
> > -	*offset = elf_section_offset(fd, ".debug_frame");
> > +		/* Check the .debug_frame section for unwinding info */
> > +		ofs = elf_section_offset(fd, ".debug_frame");
> > +		dso->data.frame_offset = ofs;
> > +	}
> >  
> > +	*offset = ofs;
> >  	if (*offset)
> >  		return 0;
> >  
> > -- 
> > 2.2.2
