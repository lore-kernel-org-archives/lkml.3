Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaLFMVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 07:21:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbaLFMVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 07:21:02 -0500
Date: Sat, 6 Dec 2014 13:20:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Cody P Schafer <dev@codyps.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, hbabu@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v5 1/4] tools/perf: support parsing parameterized events
Message-ID: <20141206122016.GB1250@krava.brq.redhat.com>
References: <1417572578-9051-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1417572578-9051-2-git-send-email-sukadev@linux.vnet.ibm.com>
 <20141204124422.GA4195@krava.brq.redhat.com>
 <CAPoQQ-1m9oRQ7wLfRHFNNZyw7fvCoMa_DX7msP2QsY_i2QyHug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPoQQ-1m9oRQ7wLfRHFNNZyw7fvCoMa_DX7msP2QsY_i2QyHug@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 06:05:26PM -0500, Cody P Schafer wrote:
> On Thu, Dec 4, 2014 at 7:44 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Tue, Dec 02, 2014 at 06:09:35PM -0800, Sukadev Bhattiprolu wrote:
> >> From: Cody P Schafer <cody@linux.vnet.ibm.com>
> >>
> >> Enable event specification like:
> >>
> >>       pmu/event_name,param1=0x1,param2=0x4/
> >>
> >> Assuming that
> >>
> >>       /sys/bus/event_source/devices/pmu/events/event_name
> >>
> >> Contains something like
> >>
> >>       param2=$foo,bar=1,param1=$baz
> >
> > oops.. sorry to be PITA on this one.. I might have missed something
> > in the previous discussion but I guess I might have finally some
> > opinion on this ;-)
> >
> > here's how I think your patchset works:
> >
> > in /sys/bus/event_source/devices/pmu/events/event_name you can actually have:
> >
> >    param2=foo,bar=1,param1=baz
> >
> > notice no '$', thats what you add later in 'perf list' output, right?
> >
> > Moreover it actually does not matter whats in value 'param2=HERE',
> > because it's not used in the config code at all apart from the
> > 'perf list' display processing.
> >
> > So when we discussed the '$' name way, I thought it'd be like:
> >
> > in /sys/bus/event_source/devices/pmu/events/event_name you have:
> >   param2=$foo,bar=1,param1=$baz
> >
> > and on command line you'd use:
> >   pmu/event_name,foo=0x1,bar=0x4/
> >
> > to assign directly to the $var, which would justify the $var
> > syntax I think..
> >
> 
> Agreed, what you've described above sounds like a good idea.
> 
> Compared to monopolizing all strings (which is what I did when
> initialy writing this), using a '$' prefix would allow less pain when
> some events suddenly need non-integer parameters.
> 
> > anyway we could assign directly to the param term name as you do,
> > but I think we just need to mark the term as parametrized, like:
> >
> > in /sys/bus/event_source/devices/pmu/events/event_name you have:
> >   param2=?,bar=1,param1=?
> >
> > and on command line you'd use:
> >   pmu/event_name,param2=0x1,param1=0x4/
> >
> > while the config code would check that the param substitution is
> > done only for terms with '?' in value, like 'param2=?' and not
> > for all PARSE_EVENTS__TERM_TYPE_STR type terms (as of now)
> 
> I prefer the `foo=0x1` as mentioned previously: it makes the user
> interface much less painful as we can have event-specific names for
> register/hcall fields.
> 
> I'm pretty sure the code used to do this, not sure when it was removed
> (haven't been following this patchset closely).

right, I recall seeing the 2 indirect assignments earlier,
but it was without the '$' marks

> 
> That said: I haven't fiddled with this code in a while (it's Suka's at
> this point), and there might be arguments the other way on both of
> those.

I guess I'm ok with both ways, maybe slightly inclined to
the '$' variable style one ;-)

jirka
