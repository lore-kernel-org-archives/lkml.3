Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3KZNH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:07:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab3KZNHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:07:54 -0500
Date: Tue, 26 Nov 2013 14:07:13 +0100
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
Message-ID: <20131126130712.GK1267@krava.brq.redhat.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-4-git-send-email-jolsa@redhat.com>
 <20131125194032.GC27323@ghostprotocols.net>
 <20131126100324.GB1267@krava.brq.redhat.com>
 <20131126124213.GA14838@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126124213.GA14838@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 09:42:13AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 26, 2013 at 11:03:24AM +0100, Jiri Olsa escreveu:
> > On Mon, Nov 25, 2013 at 04:40:32PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Fri, Nov 22, 2013 at 03:24:28PM +0100, Jiri Olsa escreveu:
> > > > Using the perf_data_file object to handle output
>  
> > SNIP
>  
> > > > +	if (!perf_data_file__is_pipe(&inject->output))
> > > >  		return 0;
> 
> > > >  	return perf_event__repipe_synth(tool, event);
> > > > @@ -351,10 +343,12 @@ static int __cmd_inject(struct perf_inject *inject)
> > > >  {
> > > >  	struct perf_session *session;
> > > >  	int ret = -EINVAL;
> > > > -	struct perf_data_file file = {
> > > > +	struct perf_data_file file_in = {
> > > 
> > > Why don't leave it as 'file', and on a follow up patch _then_ rename it
> > > to file_in? This way patch review gets easier, i.e. try avoiding doing
> > > multiple things per patch.
> > 
> > the input file needed to be renamed, because new 'output' file was added
> 
> Why? Is 'file' going to be reused somehow?

nope, just having file_in and file_out seemed symmetric,
but nevermind.. I can switch to file and file_out ;-)

SNIP

> > 
> > well, inject->output->fd is used on 2 places within the function,
> > so it seems logical to put it into variable and use it like that
> 
> What I'm trying to convey here is that for both this case and the other,
> having looking at these two lines:
> 
> -                 inject->output
> +                 inject->output->fd
> 
> Makes me instantaneously understand that inject->output now
> encapsulates, among other things (probably), the file descriptor that
> was called just inject->output, i.e. this patch probably isn't doing
> anything more than using a new abstraction, the code flow probably
> wasn't altered.

yes, that's what happened.. encapsulating output file processing
and getting rid of common code that's now handled by perf_data_file
object..

> 
> I.e. the smaller the patch, the better.

I dont think thats always true.. I prefer readable code
despite of 'unreadable' patches ;-)

> 
> > > > -	if (!inject->pipe_output) {
> > > > +	if (!perf_data_file__is_pipe(file_out)) {
> > > >  		session->header.data_size = inject->bytes_written;
> > > > -		perf_session__write_header(session, session->evlist, inject->output, true);
> +		perf_session__write_header(session, session->evlist, inject->output->fd, true);
> > > 
> > > Why a line for 'true' all by itself?
> > 
> > line was crossing 80 chars limit
> 
> [1]+  Stopped                 mutt
> [acme@zoo ~]$ 
> [acme@zoo ~]$ echo $COLUMNS
> 173
> [acme@zoo ~]$ 
> 
> I'm not really that strict with that old convention :-\ All in one line
> would make it ~95 columns, not a big deal, even more since it _was_
> already more than 80 columns.

I see.. I'm using checkpatch script that screams about this
so I tend to keep to that rule

> 
> I.e. your change was to replace 'inject->output' with 'out_fd', but you
> did that _and_ reflowed, i.e. two changes into one. ;-)

the smaller the patch, the better, right? :-)

> 
> Looking at this line makes me think: why do we have to pass 'session'
> _and_ 'session->evlist', i.e. the 2nd parameter can be obtained from the
> 1st. Fixing that could get us more compact code _and_ a shorter line.

we do actually, and the reason is this code, because
the session keeps the input file, while we are using
it for output file..

> 
> Will check that.
> 
> > > > -		OPT_STRING('o', "output", &output_name, "file",
> > > > +		OPT_STRING('o', "output", &inject.output.path, "file",
> > > 
> > > see, here you directly access a perf_data_file member instead of having
> > > another wrapper :-)
> > 
> > yes
> > 
> > I dont have strong opinions about wrappers, sometimes it seems
> > appropriate, sometimes it does not.. tell me the guidance here
> > and I'll kick the patch to fit ;-)
> 
> Well, a wrapper like perf_data_file__is_pipe(file_out) that maps to
> file_out->is_pipe and will produce the same results at every call and
> that we don't have the slightest intention of somehow hooking, I would
> do away with it and use file_out->is_pipe directly.

ok

thanks,
jirka
