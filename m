Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbaDWOio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:38:44 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37814 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaDWOik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:38:40 -0400
Subject: Re: [PATCH v2 1/2] perf record: Propagate exit status of a command
 line workload
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CABPqkBSgRmtnoGzb2KfLKK4QNkhUVzceU81x+o+PTLwNL3uL+A@mail.gmail.com>
References: <1398235235-4239-1-git-send-email-namhyung@kernel.org>
	 <CABPqkBSgRmtnoGzb2KfLKK4QNkhUVzceU81x+o+PTLwNL3uL+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Apr 2014 23:38:34 +0900
Message-ID: <1398263914.1696.7.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

2014-04-23 (수), 14:11 +0200, Stephane Eranian:
> On Wed, Apr 23, 2014 at 8:40 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> > +out_child:
> > +       if (forks) {
> > +               int exit_status;
> >
> > -       return 0;
> > +               if (!child_finished)
> > +                       kill(rec->evlist->workload.pid, SIGTERM);
> > +
> > +               wait(&exit_status);
> > +
> > +               if (err < 0)
> Not quite this. Although this works with my test case with 'false'.
> It fails when I tried the opposite test case:
> 
> $ perf record true && echo yes || echo no
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.013 MB perf.data (~589 samples) ]
>   no
> 
> The return code in this case is 255. I tracked it down to err being last set
> by poll() which got interrupted by SIGCHLD. So I think the err value must
> be overridden somehow in this case. Maybe something like:
> 
>                         err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
>                         if (err < 0 &&  errno == EINTR && forks && done)
>                                 err = 0;

Hmm.. just checking "err < 0 && errno == EINTR" isn't enough?

And I guess the same problem can be occurred during record__mmap_read()
as it calls record__write() which eventually calls ion() and it seems
not to handle the above case..  I'll cook a patch for it too.

Thanks,
Namhyung



