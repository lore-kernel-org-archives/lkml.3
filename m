Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3EKV0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 17:26:17 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47646 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab3EKV0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 17:26:14 -0400
Date: Sat, 11 May 2013 17:26:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Daniel Phillips <daniel.raymond.phillips@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        tux3@tux3.org, linux-fsdevel@vger.kernel.org
Subject: Re: Tux3 Report: Faster than tmpfs, what?
Message-ID: <20130511212608.GA26298@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Daniel Phillips <daniel.raymond.phillips@gmail.com>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	tux3@tux3.org, linux-fsdevel@vger.kernel.org
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
 <20130510045049.GU24635@dastard>
 <CAEsagEism-SQB9LRC+EuPLoBiFOEHc0peLjh3cDxwrNe3Jz=2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsagEism-SQB9LRC+EuPLoBiFOEHc0peLjh3cDxwrNe3Jz=2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:12:27PM -0700, Daniel Phillips wrote:
> Hi Dave,
> 
> Thanks for the catch - I should indeed have noted that "modified
> dbench" was used for this benchmark, thus amplifying Tux3's advantage
> in delete performance.

Dropping fsync() does a lot more than "amplify Tux3's advantage in
delete performace".  Since fsync(2) is defined as not returning until
the data written to the file descriptor is flushed out to stable
storage --- so it is guaranteed to be seen after a system crash --- it
means that the foreground application must not continue until the data
is written by Tux3's back-end.

So it also means that any advantage of decoupling the front/back end
is nullified, since fsync(2) requires a temporal coupling.  In fact,
if there is any delays introdued between when the front-end sends the
fsync request, and when the back-end finishes writing the data and
then communicates this back to the front-end --- i.e., caused by
schedular latencies, this may end up being a disadvantage compared to
more traditional file system designs.

Like many things in file system design, there are tradeoffs.  It's
perhaps more quseful when having these discussions to be clear what
you are trading off for what; in this case, the front/back design may
be good for somethings, and less good for others, such as mail server
workloads where fsync(2) semantics is extremely important for
application correctness.

Best regards,

					- Ted
