Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882Ab3DCRhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:37:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593Ab3DCRhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:37:01 -0400
Date: Wed, 3 Apr 2013 13:36:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
Message-ID: <20130403173651.GF5939@redhat.com>
References: <1364923183-316-4-git-send-email-yinghai@kernel.org>
 <20130402180606.GI29506@redhat.com>
 <CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
 <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
 <20130402191130.GB31760@redhat.com>
 <CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
 <20130402201148.GJ29506@redhat.com>
 <CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
 <20130403131842.GA5939@redhat.com>
 <CAE9FiQUO-fLY-k_gmw6cg56YEN52VRvZuXr+f1EnywKr_cGc4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUO-fLY-k_gmw6cg56YEN52VRvZuXr+f1EnywKr_cGc4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 10:12:46AM -0700, Yinghai Lu wrote:

[..]
> >> Can we just keep it separated?
> >
> > Kernel does not know about old kexec-tools or new kexec-tools. Neither
> > kernel can enforce what command line options are passed by user. So
> > kernel needs to define a clean interface here which is easily understood
> > and is extensible also in future.
> 
> Looks you are chasing wrong direction.

I don't think so. Once we are defining bunch of crashkernel= parameters
we need to make sure it is well understood how do they work together.

> 
> Those four patches fixes the regression that Wang and you reported,
> User don't need to change their kexec-tools and boot command lines
> kdump still works.

I am not objecting to that. I am objecting to introducing unexpected
behavior in crashkernel= command line space and ignoring how does
it co-exist with existing syntax.

> 
> We will never can stop user doing crazy thing with their system.

Yes, but we need to make sure if bunch of crashkernel= are passed on
kernel command line then behavior is well defined and extensible for
future usage.

[..]
> > But why are we tying ;low to ;high. One should be easily extend
> > crashkernel=X to be able to reserve memory above 4G if specified amount
> > is not available below 4G. In that case also one might want to reserve
> > some low memory?
> 
> I want to keep crashkernel=X to the old behavior.
> 
> If you want to have crashkernel=X to allocate high above 4G, old kexec-tools
> will not work with new kernel.

It does not work anyway. Because current crashkernel=X will fail to
reserve memory if sufficient memory is not available below 896MB. So no
surprises there.

It will help new kexec-tools continue to work with crashkernel=X even
in high memory ranges.

> >
> > For that matter crashkernel=range1:size,range2:size syntax should be
> > extendible too to reserve memory above 4G if desired size of memory
> > is not available in low memory.
> >
> > Now in those cases too, one would like to have 72M of low memory
> > reserved. So ;low shoud not be tied to ;high necessarily.
> >
> > In fact current code does not care whetehr ;high was specified or not.
> > If memory is reserved above 4G, ;low code will kick in.
> 
> No, that is not right.
> 
> only when ;high is specified, kernel will try to allocate high above 4G.

As of today. But one can always extend crashkernel=X to allocate from
high addresses if memory is not available in low addresses without
breaking old tools.

Current ;low logic does not care whether high reservation was done using
crashkernel=X or crashkernel=X;high. And it should not. Tying ;low with
;high is the problem. Each crashkernel= directive should be able to 
specify its own range to reserve with constraints. There is no dependency
on other crashkernel= options passed. And that keeps the behavior well
defined.

If we start introducing dependency between various crashkernel= options
our behavior matrix will explode and it will be very difficult to explain
how does it work.

[..]
> > We really need to stick to the notion of only one crashkernel= option
> > is accepted and that is last one on command line. And if need be,
> > we need to work on multi range reservation feature where we process
> > and reserve ranges as specified by all crashkernel= parameters on
> > command line.
> 
> That is kept.
> 
> and only last high is honored

What about rest of the crashkernel=. I am not sure why are you not
seeing that you are stepping onto to already defined crashkernel=
command line option and breaking its semantics.

If you were defining crashkernel_foo, I couldn't care less.

Given the fact you are using crashkernel=, you need to take already
defined parameters in to consideration and stick to those semantics.

- Either support single range reservation and always use rightmost
  crashkernel= option.

- Or support multiple ranges and process all the crashkernel= options
  as specified on command line.

Please don't define more modes here.
 
> 
> >
> > Creating new combinations where some crashkernel= are preferred over
> > others and some crashkernel= options work with only selected crashkernel=
> > options, is asking for trouble, especially keeping in mind future
> > extensions.
> 
> I don't think so.
> 
> old conf that works before still use crashkernel= with high and low.
> old conf that does not work, could switch to crashkernel=;high/low
> with new kexec-tools

Please come out of this old conf and new conf mode. That is specific
usage of interface you are providing. But interface semantics should
still be well defined. And currently they are not.

> 
> >
> > I prefer following for 3.9.
> >
> > - process only right most crashkernel= option.
> 
> what is "right most" ?
> only last crashkernel=X is honored?
> I restored that already with those four patches.

only last crashkernel= is honored. It could be either crashkernel=X
or crashkernel=X;high or crashkernel=X;<option1>;<option2>;....

Point being crashkernel= space is taken and there is scope for defining
more options to it as our needs grow. 

> 
> > - implement crashkernel_no_auto_low option to opt out of auto reserved
> >   low memory
> 
> No, that is ugly.

It might be but it is better than special casing ;high or ;low.

> 
> > - implement crashkernel=X;high to support high memory reservations.
> >
> > And now old kexec-tools user can use crashkernel=X while users needing
> > high memory reservation can use crashkernel=X;high.
> 
> The four patches did not do that?

I am objecting to.

- Not parsing right most crashkernel=
- Tying ;high and ;low together.

> 
> >
> > If you really want to support user defined crashkernel=X;low along with
> > crashkernel=Y;high, that is really a multi range reservation feature and
> > need to be implemented properly instead of coming up with short cuts.
> 
> No it is not.
> 
> It's *you* want me to change "Crash kernel low" to "Crash kernel".
> 
> Do we need to drop second patch? So will still keep
> "Crash kernel low" in /proc/iomem?

No. I want to keep everything named "Crash kernel". There is no point
in naming low memory as "Crash kernel low".

Just that right now we don't support reserving multiple range feature,
execpt the exception of a low memory reserved automatically. And we
are providing a parameter to disable reservation of low memory.

If we don't support multiple ranges, don't try to special case it by
;high and ;low combination. Then one needs to parse all crashkernel=
options passed on command line (including crashkernel=X) and reserve
all the ranges as specified by various crashkernel= options.

You can't say, well ;high is specified so I am going to process only
crashkernel=X;high and crashkernel=Y;low and ignore rest of the
crashkernel= options. That does not make sense to me.

Thanks
Vivek
