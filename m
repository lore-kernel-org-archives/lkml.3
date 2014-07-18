Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbaGRJWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:22:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760821AbaGRJWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:22:07 -0400
Date: Fri, 18 Jul 2014 11:22:04 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: Kay Sievers <kay@vrfy.org>, akpm@linux-foundation.org, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] printk: more log flag simplification
Message-ID: <20140718092204.GW6774@pathway.suse.cz>
References: <1405619953-5475-1-git-send-email-elder@linaro.org>
 <CAPXgP13LZQTu7-LQp4Amj6YmEh7X+Jk3e27D-wUz60qmSYfOwQ@mail.gmail.com>
 <53C87E5B.2060505@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C87E5B.2060505@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-07-17 20:54:35, Alex Elder wrote:
> On 07/17/2014 08:37 PM, Kay Sievers wrote:
> > On Thu, Jul 17, 2014 at 7:59 PM, Alex Elder <elder@linaro.org> wrote:
> >> This series rearranges the log code in such a way that the LOG_CONT
> >> and LOG_PREFIX log record flags can be eliminated entirely.  The
> >> result should be considerably easier to understand than before.  It
> >> builds on another recently-posted series of patches:
> >>     https://lkml.org/lkml/2014/7/17/363
> >>
> >> The first patch exploits the fact that LOG_CONT and LOG_NEWLINE
> >> are inverses, and uses LOG_NEWLINE (or its negation) anywhere
> >> LOG_CONT is used.  As a result, LOG_CONT is no longer needed, so
> >> it's eliminated.

I think that only this part is usable. It would make sense to move it
to the other patch set.

> >> The next three patches together eliminate LOG_PREFIX.  The effect
> >> of LOG_PREFIX is to complete the previous log entry before recording
> >> a new one.  Patch 2 arranges to do this directly, marking the previous
> >> log record with LOG_NEWLINE whenever a new record is presented with
> >> LOG_PREFIX set.  Patch 3 stops saving LOG_PREFIX in any log records,
> >> and patch 4 finally gets rid of LOG_PREFIX.
>>>
> >> The last patch is just some cleanup of the code now that it's gone
> >> through this transformation.

The other patches would break readers. You could not modify older
records because the might already have been proceed.

You would need to add another hacks to the readers. I think that using
LOG_PREFIX is more clear and less hacky.

> > Continuation lines are racy and unreliable by definition, they create
> > a problem that cannot be solved properly, so we need to try to make
> > the best out of it. The idea of the record buffer flags was to record
> > what actually happened when things race against each other. A line
> > without a newline is recorded as a line without a newline.
> 
> Understood.
> 
> > Your simplifying patches changes the code to store how things will
> > *look* like when exported, not what actually *happened*; like it
> > pretends the earlier line had a newline, while that might not have
> > been the case.
> 
> What do you mean by "exported?"  Does the result in syslog
> or /proc/kmsg (or the console for that matter) actually
> differ?  I'll have to look again, but I think they do not.

Yes, they are asynchronous. Each of them has its own speed and
behavior.

Console is like a dog. It tries to process all new messages until
the very last one.

Syslog and kmsg are interfaces that are used by userspace tools,
e.g. syslogd, dmesg. They are asked to read selected part of
the ring buffer, usually the last messages. They might be asked to
seek, read everything again, ...

Syslog and kmsg have to release the logbuf_lock every time they copy
some line to the userspace. This is the time when the ring buffer
might get rotated and they might miss the end of continuous line.


Best Regards,
Petr
