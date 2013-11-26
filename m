Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3KZKEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:04:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab3KZKEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:04:10 -0500
Date: Tue, 26 Nov 2013 11:03:24 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 3/3] perf inject: Handle output file via perf_data_file
 object
Message-ID: <20131126100324.GB1267@krava.brq.redhat.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-4-git-send-email-jolsa@redhat.com>
 <20131125194032.GC27323@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125194032.GC27323@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 04:40:32PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 22, 2013 at 03:24:28PM +0100, Jiri Olsa escreveu:
> > Using the perf_data_file object to handle output

SNIP

> > +	if (!perf_data_file__is_pipe(&inject->output))
> >  		return 0;
> >  
> >  	return perf_event__repipe_synth(tool, event);
> > @@ -351,10 +343,12 @@ static int __cmd_inject(struct perf_inject *inject)
> >  {
> >  	struct perf_session *session;
> >  	int ret = -EINVAL;
> > -	struct perf_data_file file = {
> > +	struct perf_data_file file_in = {
> 
> Why don't leave it as 'file', and on a follow up patch _then_ rename it
> to file_in? This way patch review gets easier, i.e. try avoiding doing
> multiple things per patch.

the input file needed to be renamed, because new 'output' file was added

> 
> >  		.path = inject->input_name,
> >  		.mode = PERF_DATA_MODE_READ,
> >  	};
> > +	struct perf_data_file *file_out = &inject->output;
> > +	int out_fd = perf_data_file__fd(file_out);
> >  
> >  	signal(SIGINT, sig_handler);
> >  
> > @@ -365,7 +359,7 @@ static int __cmd_inject(struct perf_inject *inject)
> >  		inject->tool.tracing_data = perf_event__repipe_tracing_data;
> >  	}
> >  
> > -	session = perf_session__new(&file, true, &inject->tool);
> > +	session = perf_session__new(&file_in, true, &inject->tool);
> 
> This hunk, for example, wouldn't be here, the this patch would be
> shorter, easier to review.
> 
> >  	if (session == NULL)
> >  		return -ENOMEM;
> >  
> > @@ -391,14 +385,15 @@ static int __cmd_inject(struct perf_inject *inject)
> >  		}
> >  	}
> >  
> > -	if (!inject->pipe_output)
> > -		lseek(inject->output, session->header.data_offset, SEEK_SET);
> > +	if (!perf_data_file__is_pipe(file_out))
> > +		lseek(out_fd, session->header.data_offset, SEEK_SET);
> 
> Couldn't this be left as:
> 
> -	if (!inject->pipe_output)
> -		lseek(inject->output, session->header.data_offset, SEEK_SET);
> +	if (!perf_data_file__is_pipe(file_out))
> +		lseek(inject->output->fd, session->header.data_offset, SEEK_SET);
> 
> I.e. why wrap access to the fd like that?

well, inject->output->fd is used on 2 places within the function,
so it seems logical to put it into variable and use it like that

> 
> >  
> >  	ret = perf_session__process_events(session, &inject->tool);
> >  
> > -	if (!inject->pipe_output) {
> > +	if (!perf_data_file__is_pipe(file_out)) {
> >  		session->header.data_size = inject->bytes_written;
> > -		perf_session__write_header(session, session->evlist, inject->output, true);
> > +		perf_session__write_header(session, session->evlist, out_fd,
> > +					   true);
> 
> Why a line for 'true' all by itself?

line was crossing 80 chars limit

> 
> >  	}
> >  
> >  	perf_session__delete(session);
> > @@ -427,14 +422,17 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
> >  		},
> >  		.input_name  = "-",
> >  		.samples = LIST_HEAD_INIT(inject.samples),
> > +		.output = {
> > +			.path = "-",
> > +			.mode = PERF_DATA_MODE_WRITE,
> > +		},
> >  	};
> > -	const char *output_name = "-";
> >  	const struct option options[] = {
> >  		OPT_BOOLEAN('b', "build-ids", &inject.build_ids,
> >  			    "Inject build-ids into the output stream"),
> >  		OPT_STRING('i', "input", &inject.input_name, "file",
> >  			   "input file name"),
> > -		OPT_STRING('o', "output", &output_name, "file",
> > +		OPT_STRING('o', "output", &inject.output.path, "file",
> 
> see, here you directly access a perf_data_file member instead of having
> another wrapper :-)

yes

I dont have strong opinions about wrappers, sometimes it seems
appropriate, sometimes it does not.. tell me the guidance here
and I'll kick the patch to fit ;-)

thanks,
jirka
