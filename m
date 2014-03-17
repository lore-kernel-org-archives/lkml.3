Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbaCQOxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439AbaCQOxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:53:18 -0400
Date: Mon, 17 Mar 2014 15:52:59 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/5] perf tools: Allocate thread map_groups dynamicaly
Message-ID: <20140317145259.GD6469@krava.brq.redhat.com>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
 <1394805606-25883-4-git-send-email-jolsa@redhat.com>
 <87d2hlthzi.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2hlthzi.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:13:53PM +0900, Namhyung Kim wrote:
> On Fri, 14 Mar 2014 15:00:04 +0100, Jiri Olsa wrote:
> > Moving towards sharing map groups within a process threads.
> >
> > Because of this we need the map groups to be dynamically
> > allocated. No other functional change is intended in here.
> > @@ -664,7 +664,7 @@ void thread__find_addr_map(struct thread *thread,
> >  	al->cpumode = cpumode;
> >  	al->filtered = false;
> >  
> > -	if (machine == NULL) {
> > +	if ((machine == NULL) || (mg == NULL)) {
> >  		al->map = NULL;
> >  		return;
> >  	}
> 
> What about the kernel threads?  I guess they're not using thread->mg but
> machine->kmaps instead?

The machine->kmaps is used to store kernel maps - core + modules.

All threads (including kernel ones) are using thread->mg,
kernel threads have empty /proc/x/maps file.

In case the sample address is detected within kernel space,
the machine->kmaps is used instead of thread->mg:

---
  void thread__find_addr_map(struct thread *thread, ...
  {
	struct map_groups *mg = thread__map_groups_get(thread);

  ...

        if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
                al->level = 'k';
                mg = &machine->kmaps;

  ...
	al->map = map_groups__find(mg, type, al->addr);
---

jirka
