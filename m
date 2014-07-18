Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbaGRItN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:49:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563AbaGRItI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:49:08 -0400
Date: Fri, 18 Jul 2014 10:49:06 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 1/4] printk: LOG_CONT and LOG_NEWLINE are separate
Message-ID: <20140718084905.GU6774@pathway.suse.cz>
References: <1405531620-9983-1-git-send-email-elder@linaro.org>
 <1405531620-9983-2-git-send-email-elder@linaro.org>
 <20140717083918.GP6774@pathway.suse.cz>
 <53C7BD7B.50007@linaro.org>
 <20140717144648.GT6774@pathway.suse.cz>
 <53C7F783.8040303@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53C7F783.8040303@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-07-17 11:19:15, Alex Elder wrote:
> On 07/17/2014 09:46 AM, Petr Mládek wrote:
> > On Thu 2014-07-17 07:11:39, Alex Elder wrote:
> >> On 07/17/2014 03:39 AM, Petr Mládek wrote:
> >>> On Wed 2014-07-16 12:26:57, Alex Elder wrote:
> >>>> Two log record flags--LOG_CONT and LOG_NEWLINE--are never both set
> >>>> at the same time in a log record flags field.  What follows is a
> >>>> great deal of explanation that aims to prove this assertion.
> >>
> >> Thank you so much for reviewing these patches.
> >>
> >> Your confirmation of the fact that LOG_CONT and LOG_NEWLINE
> >> should not go together is very valuable to me.  I have a set
> >> of follow-on patches that rely on this, and I didn't want to
> >> go ahead with proposing them until I knew this was right.
> > 
> > To be honest. My statement was based on a common sense. I simply
> > cannot imagine situatiuon when a text ends with "\n" and is continuous
> > at the same time. IMHO, it is against any logic.
> 
> Well, I thought so too, but it was hard to see that by
> just looking at the code.
> 
> > IMHO, it would make sense to have only one flag, either LOG_NEWLINE or
> > LOG_CONT. Well, I am not sure if we could remove it easily. AFAIK, the
> > ring buffer is read also by external tools, e.g. crash.
> 
> I took a very quick look at crash-7.0.7 and see dump_log_entry(),
> which seems to dump the contents of a log record but does not
> interpret any of the flags.

Good to know.

> This is a really important point, so if anybody knows of other
> utilities outside the kernel that interpret the log record flags
> I'd like to know about it.

AFAIK, also makedumpfile tool somehow access the private data.
See the comments for log_buf_kexec_setup()

[...]
 
> >> Thanks again for the review.  If you're willing after reading my
> >> explanations, please offer an ACK or Reviewed-by (or further
> >> questions and suggestions).  I'll have responses to your others
> >> shortly.
> > 
> > I would like to see the bigger picture before :-)
> 
> OK, the big picture for this is that I have a set of about
> 5 more patches, which have the end result of eliminating
> LOG_CONT and LOG_PREFIX.  The only thing that matters is
> LOG_NEWLINE, which indicates the log entry completes a
> sequence of one or more.  Most records will have that set;
> any that do not will be "continuation" records, which should
> be taken along with one or more successor records to make
> up a single logical log entry.  There is no need for
> LOG_PREFIX, because that is implied by the presence of
> LOG_NEWLINE in the previous log entry.  We're already tracking
> the previous record state where that's needed.

I wanted to think about this over night. And Kay actually confirmed my
doubts. There are various situations when the messages could get mixed
either when writing or when reading.

We do not care much about whole lines. Users are usually able to put
the right lines together by context.

Most of the hackery seems to be done for the continuous lines. The
following problematic situations come to my mind:


1. More tasks are printing at the same time. It is solved by flushing
   the cont buffer with newline when message from another task comes.

2. Someone prints continuous lines and forgets to put '\n' at the end.
   This is solved by flushing the cont buffer with newline when
   the same tasks prints new message with prefix.

3. Task is interrupted and the handler prints something. It is not
   currently detected. It is fine because it usually looks like
   the second scenario. The handler prints the first message with
   prefix...

4. There is a flood of messages. The readers, e.g. console, syslog,
   are not able to handle everything. They copy a continuous line and
   miss the rest. This is currently solved by resetting the flags
   for the previous message. I think that it is handled as if
   the previous line was newline.


The question is how many flags we need to handle the situations
reasonable way. We are discussing the three flags:

	   LOG_CONT
	   LOG_NEWLINE
	   LOG_PREFIX

Let's start with CONT and NEWLINE. The only situation when they
have the same value is when readers miss a message and reset the flag
for the previous message. It has the meaning: "we do not know".

IMHO, we do not need both CONT and NEWLINE flags. If we do not know
what was the last message, we need to decide somehow. It seems that we
currently do nothing special and expect that the last message ended
with newline. It means that the we could omit LOG_CONT flag and
simplify the code.


What about LOG_PREFIX? IMHO, we need it because the following
situations:

a) printk() could not modify flags of the previous messages. They
might be already proceed by readers, .e.g console, syslog. We could
not add LOG_NEWLINE flag to the previous message if suddenly new
message with prefix comes and the previous was already flushed
without newline.

b) Readers might miss messages. We might want to print '\n' if
the previous message was proceed without newline and the current
one has prefix.


What are the expectations from any changes?

The code is already too complex. IMHO, nobody wants to make it worse
just to fix the few remaining corner cases.

Any simplification is great if it keeps the output reasonable.

Best Regards,
Petr
