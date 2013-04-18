Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923Ab3DRNjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:39:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934480Ab3DRNjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:39:41 -0400
Date: Thu, 18 Apr 2013 09:39:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Pan, Zhenjie" <zhenjie.pan@intel.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
Message-ID: <20130418133927.GJ79013@redhat.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
 <1366285369.19383.19.camel@laptop>
 <CABPqkBTpzSBEezx4ScwYYX6L8ir4GLBG9MMYJuAb6YA0QbiurQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTpzSBEezx4ScwYYX6L8ir4GLBG9MMYJuAb6YA0QbiurQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 02:04:00PM +0200, Stephane Eranian wrote:
> On Thu, Apr 18, 2013 at 1:42 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2013-04-16 at 06:57 +0000, Pan, Zhenjie wrote:
> >> Watchdog use performance monitor of cpu clock cycle to generate NMI to detect hard lockup.
> >> But when cpu's frequency changes, the event period will also change.
> >> It's not as expected as the configration.
> >> For example, set the NMI event handler period is 10 seconds when the cpu is 2.0GHz.
> >> If the cpu changes to 800MHz, the period will be 10*(2000/800)=25 seconds.
> >> So it may make hard lockup detect not work if the watchdog timeout is not long enough.
> >> Now, set a notifier to listen to the cpu frequency change.
> >> And dynamic re-config the NMI event to make the event period correct.
> >>
> >
> >
> > Urgh,. does this really matter.. all we really want is for that NMI to
> > hit eventually in the not too distant future. Does the frequency really
> > matter _that_ much?
> >
> I agree, it does not really matter. Set the watchdog to a couple of minutes
> and it should be fine, shouldn't it?

I believe it mattered to the Chrome folks. They want the watchdog to be as
tight as possible so the user experience isn't a hang but a quick reboot
instead.  They like setting the watchdog to something like 2 seconds.

There was a patch a few months ago that tried to hack around this issue
and I suggested this approach as a better solution.  I forgot what the
original problem was.  Perhaps someone can jump in and explain the problem
being solved (other than the watchdog isn't always 10 seconds)?

Cheers,
Don

> 
> > Also, can't we simply pick an event that's invariant to the cpufreq
> > nonsense? Something like CPU_CLK_UNHALTED.REF -- or better the
> > fixed_ctr2 which nobody ever uses anyway.
> >
> You don't want to use fixed counter 2 for NMI watchdog because it's pinned.
> No other counter can count this event. And it is very useful. I use it often.
