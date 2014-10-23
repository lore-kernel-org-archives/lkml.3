Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaJWPNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:13:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbaJWPNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:13:21 -0400
Date: Thu, 23 Oct 2014 17:13:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/powerpc: Cache the DWARF debug info
Message-ID: <20141023151306.GA25215@krava.brq.redhat.com>
References: <20141021185610.GA18366@us.ibm.com>
 <20141021190839.GA4160@kernel.org>
 <20141022000958.GB2228@us.ibm.com>
 <20141022081730.GB9860@krava.brq.redhat.com>
 <20141022174659.GA5119@us.ibm.com>
 <20141023133724.GE14687@kernel.org>
 <20141023141213.GA24079@krava.brq.redhat.com>
 <20141023142634.GF14687@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023142634.GF14687@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 11:26:34AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 23, 2014 at 04:12:13PM +0200, Jiri Olsa escreveu:
> > On Thu, Oct 23, 2014 at 10:37:24AM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Wed, Oct 22, 2014 at 10:46:59AM -0700, Sukadev Bhattiprolu escreveu:
> > > > Jiri Olsa [jolsa@redhat.com] wrote:
> > > > | > +			goto out;
> > > > | > +		}
> > > > | > +		dso->dwfl = dwfl;
> 
> > > > | so by this we get powerpc arch code sharing dw handle via dso object,
> > > > | but we have lot of generic code too ;-)
> 
> > > > Well, this applies to powerpc...
> 
> > > > | could you make this happen for unwind__get_entries.. probably
> > > > | both sharing same generic code I guess
> 
> > > > and unwind_get_entries() applies only to x86 and arm right ? ;-)
> > > > Or at least thats what the config/Makefile says.
> 
> > > > I can take a look at unwind_get_entries(), but can you please merge
> > > > this fix for now, since the current performance is bad?
> 
> > > Right, I think the way it is now is a good compromise, i.e. you seem to
> > > be using the right place to cache this, this is restricted to powerpc,
> > > i.e. if leaks or excessive memory usage happens in workloads with lots
> > > of DSOs having dwfl handlers open at the same times happens, it doesn't
> > > affect users in other arches.
> > > 
> > > Jiri: do you agree?
> > 
> > well it's powerpc specific now.. anyway the code in the patch
> > to open the dwfl is generic and should be in in generic
> > place.. like in some extern function that the x86 would call
> > to get the dwfl handle
> > 
> > also the current patch leaks the dso->dwfl, which is never freed -> dwfl_end-ed,
> > dwfl_end should be called of in dso__delete I think
> 
> Yeah, as my comment implies, I guess those are all valid concerns, i.e.
> the patch needs more work, I was willing to accept it as-is because it
> would hurt just Sukadev (i.e. powerpc), as he seems to be in a hurry to
> get the performance improved :-)
> 
> I will remove it from my tree for now, as in the end what I'm doing
> doesn't touch those specific functions.
> 
> But I think this will go on dragging extra work, i.e.: how to limit the
> number of dwfl handlers used? Should we have just a front end cache like
> what is done for machine__findnew_thread() (with just the last hit) and
> perhaps then have a few slots for keeping N dwfl open and when that
> number is up we check the one with less queries and close it?

I think this can stay in 'struct dso' which is limited
by that code you show below

I think we need just add generic functions that allocates/destroys
the dwfl handle and lazy allocate&store this handle whenever it's
needed and destroy it in dso__delete

> 
> Jiri, are you doing that on that cache stuff you did? I mean how do
> you keep this stuff:
> 
> /*
>  * Global list of open DSOs and the counter.
>  */
> static LIST_HEAD(dso__data_open);
> static long dso__data_open_cnt;
> 
> Also this should not be global at all, this should be on struct machine,
> since a DSO that is present on a machine may have the same name as the
> dso on another machine (two guests, hosts, etc) and thus should not be
> kept on the same list, etc.

the justification for this to be static is that dso__data_open_cnt
is checked against the rlimit for user and the point is to keep
'some amount' of dso object opened, so we dont waste time by reopening

the 'some amount' is currently the half of the allowed limit for user

you can check the logic in open_dso and check_data_close functions

> So reading a bit more you seem to check rlimit, do LRUing when hitting
> the limit, etc, that is why I thought about that stuff when Sukadev
> first posted this patch...
> 
> Sukadev, all this is in tools/perf/util/dso.c
> 
> That is why I thought it would be a compromise to put what he did, it
> would not make the existing situation that much worse, work needs to be
> done in this area :-\

I think we just need to put that libdw handle into dso object
as I suggested above

jirka
