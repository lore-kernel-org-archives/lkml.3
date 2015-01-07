Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbbAGHPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:15:35 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48992 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbAGHPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:15:34 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 7 Jan 2015 16:13:23 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC/PATCHSET 00/37] perf tools: Speed-up perf report by using
 multi thread (v1)
Message-ID: <20150107071323.GC849@sejong>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <20150105184811.GQ2915@two.firstfloor.org>
 <CABPqkBQ_mcMr=mfaFoECm6YFWvgz3JWudQ4wdT2Q61yJZOok1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBQ_mcMr=mfaFoECm6YFWvgz3JWudQ4wdT2Q61yJZOok1w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Tue, Jan 06, 2015 at 10:50:44AM -0500, Stephane Eranian wrote:
> On Mon, Jan 5, 2015 at 1:48 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > > This also requires to handle multiple files and to find a
> > > corresponding machine state when processing samples.  On a large
> > > profiling session, many tasks were created and exited so pid might be
> > > recycled (even more than once!).  To deal with it, I managed to have
> > > thread, map_groups and comm in time sorted.  The only remaining thing
> > > is symbol loading as it's done lazily when sample requires it.
> >
> > FWIW there's often a lot of unnecessary information in this
> > (e.g. mmaps that are not used). The Quipper page
> > claims large saving in data files by avoided redundancies.
> >
> > It would be probably better if perf record avoided writing redundant
> > information better (I realize that's not easy)
> > >
> > > With that being done, the stage 2 can be done by multiple threads.  I
> > > also save each sample data (per-cpu or per-thread) in separate files
> > > during record.  On perf report time, each file will be processed by
> > > each thread.  And symbol loading is protected by a mutex lock.
> >
> > I really don't like the multiple files. See above. Also it could easily
> > cause additional seeking on spinning disks.
> >
> having to manage two separate files is a major change which I don't
> particularly like. It will cause problems. I don't see why this cannot
> be appended to the perf.data file with a index at the beginning. There
> is already an index for sections in file mode.

I just thought it's easier to handle with multiple thread.  Maybe we
can concatenate the files after recording.


> 
> We use the pipe mode a lot and this would not work there. So no,
> I don't like the 2 files solution. But I like the idea of using multiple
> threads to speed up processing.

Actually it's not 2 files, it's 1 + N files. :)  Anyway, I think the
single file + index approach requires seeking to process them, is it
ok for pipe-mode?

Thanks,
Namhyung
