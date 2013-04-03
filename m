Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547Ab3DCNS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:18:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668Ab3DCNS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:18:56 -0400
Date: Wed, 3 Apr 2013 09:18:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
Message-ID: <20130403131842.GA5939@redhat.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
 <1364923183-316-4-git-send-email-yinghai@kernel.org>
 <20130402180606.GI29506@redhat.com>
 <CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
 <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
 <20130402191130.GB31760@redhat.com>
 <CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
 <20130402201148.GJ29506@redhat.com>
 <CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 01:36:02PM -0700, Yinghai Lu wrote:

[..]
> > You are just describing what your code does. There is no theme or
> > justification behind this behavior. There is no uniformity. A user can
> > question that so far you used to honor last crashkernel= parameter and
> > suddenly in 3.9 that's no more the case. Out of blue crashkernel=X,high is
> > overriding crashkernel=X and it is not obivious why.
> 
> Let me repeat again:
> we keep crashkernel=X old behavior with old kexec-tools.
> crashkernel=X;high is for new kexec-tools that support loading high.
> 
> If the user want to use ,high but still with old kexec-tools, that is
> not going to work.
> 
> Can we just keep it separated?

Kernel does not know about old kexec-tools or new kexec-tools. Neither
kernel can enforce what command line options are passed by user. So
kernel needs to define a clean interface here which is easily understood
and is extensible also in future.

[..]
> >
> > If user wants 128M in low memory, they will just specify
> > crashkernel=128M;low
> 
> in the kernel-parameter.txt, already says ;low is need to used with ;high.

But why are we tying ;low to ;high. One should be easily extend
crashkernel=X to be able to reserve memory above 4G if specified amount
is not available below 4G. In that case also one might want to reserve
some low memory?

For that matter crashkernel=range1:size,range2:size syntax should be
extendible too to reserve memory above 4G if desired size of memory
is not available in low memory.

Now in those cases too, one would like to have 72M of low memory
reserved. So ;low shoud not be tied to ;high necessarily.

In fact current code does not care whetehr ;high was specified or not.
If memory is reserved above 4G, ;low code will kick in.

> 
> >
> > If they want to control multiple ranges of memory, then that's the feature
> > we currently don't support. Currently we support only reserving one range
> > of memory.
> >
> > If you want to support multiple ranges of memory,then do it properly.
> > Parse all crashkernel= options, prepare a list of memory to be reserved
> > and unreserved, resolve all the conflicts between various options and
> > then reserve the memory. But that does not seem to be a requirement at
> > this point of time.
> 
> No we does not support multiple ranges, as it will need more changes
> in kexec-tools.
> 
> Can we stop here with those four patches?
> 
> Later, we can extend it if it is really needed.

crashkernel= options are already confusing. I think we with this patchset
we will just make them even more confusing and future extensions
difficult.

We really need to stick to the notion of only one crashkernel= option
is accepted and that is last one on command line. And if need be,
we need to work on multi range reservation feature where we process
and reserve ranges as specified by all crashkernel= parameters on
command line.

Creating new combinations where some crashkernel= are preferred over
others and some crashkernel= options work with only selected crashkernel=
options, is asking for trouble, especially keeping in mind future
extensions.

I prefer following for 3.9.

- process only right most crashkernel= option.
- implement crashkernel_no_auto_low option to opt out of auto reserved
  low memory
- implement crashkernel=X;high to support high memory reservations.

And now old kexec-tools user can use crashkernel=X while users needing
high memory reservation can use crashkernel=X;high.

If you really want to support user defined crashkernel=X;low along with
crashkernel=Y;high, that is really a multi range reservation feature and
need to be implemented properly instead of coming up with short cuts.

Thanks
Vivek
