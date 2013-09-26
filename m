Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3IZMVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:21:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab3IZMVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:21:14 -0400
Date: Thu, 26 Sep 2013 14:20:50 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.jf.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [RFC 00/21] perf tools: Add toggling events support
Message-ID: <20130926122049.GB1067@krava.brq.redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
 <CABPqkBR3cYDdwynxSvdjnWGaJqJ6iDR=J_sbuMs-7V5yEsMzGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBR3cYDdwynxSvdjnWGaJqJ6iDR=J_sbuMs-7V5yEsMzGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 01:31:06PM +0200, Stephane Eranian wrote:
> Jiri,
> 
> On Wed, Sep 25, 2013 at 2:50 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > hi,
> > sending *RFC* for toggling events support.
> >
> > Adding perf interface that allows to create toggle events, which can
> > enable or disable another event. Whenever the toggle event is triggered
> > (has overflow), it toggles another event state and either starts or
> > stops it.
> >
> > The goal is to be able to create toggling tracepoint events to enable and
> > disable HW counters, but the interface is generic enough to be used for
> > any kind of event.
> >
> > It's based on the Frederic's patchset:
> > https://lkml.org/lkml/2011/3/14/346
> >
> > Most of the changelogs info is on wiki:
> > https://perf.wiki.kernel.org/index.php/Jolsa_Features_Togle_Event
> >
> > In a nutshell:
> >   The interface is added to the sys_perf_event_open syscall
> >   and new ioctl was added for completeness, check:
> >     perf: Add event toggle sys_perf_event_open interface
> >     perf: Add event toggle ioctl interface
> >
> >   The perf tool interface is pretty rough at the moment. We use
> >   'on' and 'off' terms to specify the toggling event, like:
> >     -e 'cycles,irq_entry/on=cycles/,irq_exit/off=cycles/'
> >
> >   Meaning:
> >     - irq_entry toggles on (starts) cycles, and irq_exit toggled off (stops) cycles.
> >     - cycles is started as paused
> >
> >    Looking forward to some ideas for better interface in here ;-)
> >
> > The patchset is available at:
> > git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> > perf/core_toggle
> >
> > thanks for comments,
> 
> Such interface is indeed desirable. I received several requests for
> this feature internally and externally.
> I think it would need to be generalized for user-level code also, same
> user API, different trigger points.
> I would assume they would be uprobes instead of tracepoints.

not sure what you mean, this code work with uprobes:
https://perf.wiki.kernel.org/index.php/Jolsa_Features_Togle_Event#Example_-_using_u.28ret.29probes

> 
> And I agree with you, the current cmdline interface is not good
> enough, how about something more
> aligned with the current syntax:
>     -e cpu/event=0x3c,trigger_on=irq_entry,trigger_off=irq_exit/,
> 

that's basically oposite of what we have now, your example would be:
  -e cpu/event=0x3c,name=cycles/',irq_entry/on=cycles/',irq_exit/off=cycles/'


hm, the thing is that you also want to customize trigger events,
for example how would you set a filter for irq_entry/irq_exit
if needed?

maybe allowing extra refference of triggers
  -e cpu/event=0x3c,trigger_on=irq_entry,trigger_off=irq_exit/' -e 'irq_exit' --filter ...

jirka
