Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbaGPMOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760152AbaGPMOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:14:44 -0400
Date: Wed, 16 Jul 2014 14:14:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140716121410.GA9441@krava.redhat.com>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
 <20140714111833.GU19379@twins.programming.kicks-ass.net>
 <20140714114359.GA17761@krava.redhat.com>
 <20140714130237.GX9918@twins.programming.kicks-ass.net>
 <20140714132223.GC17761@krava.redhat.com>
 <20140714133542.GZ9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714133542.GZ9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 03:35:42PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 03:22:23PM +0200, Jiri Olsa wrote:
> > > > if we dont do it, the event stays installed without owner and
> > > > perf fork callback will be called and fail on permission checking
> > > > (because of owner == NULL) ... so yes, I think it's needed
> > > 
> > > Oh, right. Alternatively, we don't need permission checking for inherits
> > > at all, if we're allowed to create the initial event, we should be good
> > > for inherits.
> > 
> > I could adress that in follow up patch.. or you want this instead
> > of this one? IMO we should close those events anyway..
> 
> I tend to agree that closing them all is nicer. But we need to be
> careful while doing it so as not to make the clone/fork path block on
> it.
> 
> I _think_ it might be best to separate these two issues for the moment,
> so cure the reported problem by avoiding the permission check for
> inherited events -- IFF you agree with the previous argument that
> install_exec_creds() should be sufficient.

install_exec_creds remove removes current events any time
suid binary is executed.. so it seems ok

        /*
         * Disable monitoring for regular users
         * when executing setuid binaries. Must
         * wait until new credentials are committed
         * by commit_creds() above
         */
        if (get_dumpable(current->mm) != SUID_DUMP_USER)
                perf_event_exit_task(current);

jirka
