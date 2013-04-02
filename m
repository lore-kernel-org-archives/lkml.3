Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab3DBUMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:12:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202Ab3DBUMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:12:01 -0400
Date: Tue, 2 Apr 2013 16:11:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
Message-ID: <20130402201148.GJ29506@redhat.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
 <1364923183-316-4-git-send-email-yinghai@kernel.org>
 <20130402180606.GI29506@redhat.com>
 <CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
 <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
 <20130402191130.GB31760@redhat.com>
 <CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 01:00:46PM -0700, Yinghai Lu wrote:
> On Tue, Apr 2, 2013 at 12:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Apr 02, 2013 at 11:49:13AM -0700, Yinghai Lu wrote:
> >> On Tue, Apr 2, 2013 at 11:42 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> > aka:
> >> > old kexec-tools stay with "crashkernel=X"
> >> > new kexec-tools stay with
> >> > 1. like old kexec tools
> >> > 2. or "crashkernel=X,high" or "crashkernel=X,high crashkernel=Y,low",
> >> > Y could be 100M or 0 etc.
> >>
> >> I keep the old logic like:
> >> if there are several "crashkernel=X,high", only last one is honored.
> >> if there are several "crashkernel=Y,low", only last one is honored.
> >
> > Yes but if different types of crashkernel= options are mixes then
> > behavior is not defined.
> 
> dmesg or /proc/iomem will show them what is finally reserved.
> 
> >
> > crashkernel=X,high crashkernel=X
> 
> ==> crashkernel=X is tossed away.

You are just describing what your code does. There is no theme or
justification behind this behavior. There is no uniformity. A user can
question that so far you used to honor last crashkernel= parameter and
suddenly in 3.9 that's no more the case. Out of blue crashkernel=X,high is
overriding crashkernel=X and it is not obivious why.

> 
> > crashkernel=X,high crashkernel=Y;low
> 
> normal case. if user want more or disable low range.

Again, behavior is not clear to user. Please stop describing your code
behavior. Discuss more in terms of presenting a consistent interface to
user.

> 
> > crashkernel=Y;low crashkernel=X
> 
> crashkernel=X will be used.

Why? When crashkernel=X is specified with crashkernel=Y;high, high takes
over but when crashkernel=X is specified with crashkernel=Y;low,
crashkernel=X takes over. These is highly unintutive.

> 
> >
> > And possibilities go on. So I think it makes life simpler if we always
> > parse last crashkernel= option and act upon that. And use
> > crashkernel_no_auto_low to opt out of auto reserved low memory area.
> 
> No, that is not just disable. User could want more like 128M instead of 72M.

If user wants 128M in low memory, they will just specify
crashkernel=128M;low

If they want to control multiple ranges of memory, then that's the feature
we currently don't support. Currently we support only reserving one range
of memory.

If you want to support multiple ranges of memory,then do it properly.
Parse all crashkernel= options, prepare a list of memory to be reserved
and unreserved, resolve all the conflicts between various options and
then reserve the memory. But that does not seem to be a requirement at
this point of time.

Thanks
Vivek
