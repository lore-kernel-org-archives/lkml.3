Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab3EVWUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:20:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab3EVWUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:20:10 -0400
Date: Wed, 22 May 2013 15:20:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernie Thompson <bhthompson@chromium.org>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] rtc: add in ability to push out an existing wakealarm
 using sysfs
Message-Id: <20130522152008.4aeaa834f4d50b750832bd65@linux-foundation.org>
In-Reply-To: <CAEKaZ2gSLkFhLUV01bxxTG78bxbgJxQnAWji54COJU5qCDjXjw@mail.gmail.com>
References: <1368233611-1690-1-git-send-email-bhthompson@chromium.org>
	<20130522145529.a03f3344f58b4b9ddacb25b7@linux-foundation.org>
	<CAEKaZ2gSLkFhLUV01bxxTG78bxbgJxQnAWji54COJU5qCDjXjw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 15:05:44 -0700 Bernie Thompson <bhthompson@chromium.org> wrote:

> On Wed, May 22, 2013 at 2:55 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Fri, 10 May 2013 17:53:31 -0700 Bernie Thompson <bhthompson@chromium.org> wrote:
> >
> > > This adds in the ability for the rtc sysfs code to handle += characters
> > > at the beginning of a wakealarm setting string. This will allow the user to
> > > attempt to push out an existing wakealarm by a provided amount.
> > >
> > > In the case that the += characters are provided but the alarm is not active
> > > -EVINVAL is returned.
> > >
> >
> > Well that sounds useful, but I'm not personally in a position to
> > confidently judge whether it's useful enough to merge the patch.  The
> > changelog doesn't make a compelling case and everybody else has chosen
> > to sit on their hands.
> >
> > So I really don't know what to do with this patch.
> >
> 
> Thank you for looking at this, I was just talking with Doug on CC this
> morning about
> explaining why this is useful, at least for my purposes in
> suspend/resume testing.
> The basic test goes something like:
> 
> 1. Set a wake alarm from userspace 5 seconds in the future
> 
> 2. Start the suspend process (echo mem > /sys/power/state)
> 
> 3. After ~2.5 seconds if userspace is still running (using another
> thread to check
> this), move the wake alarm 5 more seconds
> 
> If the "move" involves an unset of the wakealarm then there's a
> period of time where the system is midway through suspending but has
> no wake alarm. It will get stuck.
> 
> We'd rather not remove the "move" since the idea is to avoid a
> cancelled suspend when the alarm fires _during_ suspend.  It is
> difficult for the test to tell the difference between a suspend that
> was cancelled because the alarm fired too early and a suspend that was
> cancelled/failed for some other reason.

OK, I'm (easily) convinced.

I guess that if the alarm fires right in the middle of
rtc_sysfs_set_wakealarm() execution, everything collapses in a heap.

Why does the current code "Avoid accidentally clobbering active
alarms"?[*] I'd have thought that being able to reset the expiry time
of a pending alarm would be rather useful.

[*] repeat after me: comments should explain "what", not "why".  grr.
