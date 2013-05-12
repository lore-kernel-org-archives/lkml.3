Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3ELE2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 00:28:49 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57469 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3ELE2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 00:28:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130511212608.GA26298@thunk.org>
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
	<20130510045049.GU24635@dastard>
	<CAEsagEism-SQB9LRC+EuPLoBiFOEHc0peLjh3cDxwrNe3Jz=2w@mail.gmail.com>
	<20130511212608.GA26298@thunk.org>
Date: Sat, 11 May 2013 21:28:46 -0700
Message-ID: <CAEsagEiRLhbv_uk6OhwtcyVufkLgv7KhHA1mLd-o2QDPeXjWKA@mail.gmail.com>
Subject: Re: Tux3 Report: Faster than tmpfs, what?
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        tux3@tux3.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resent as plain text)

On Sat, May 11, 2013 at 2:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Dropping fsync() does a lot more than "amplify Tux3's advantage in
> delete performace".  Since fsync(2) is defined as not returning until
> the data written to the file descriptor is flushed out to stable
> storage --- so it is guaranteed to be seen after a system crash --- it
> means that the foreground application must not continue until the data
> is written by Tux3's back-end.
>
> So it also means that any advantage of decoupling the front/back end
> is nullified, since fsync(2) requires a temporal coupling.  In fact,
> if there is any delays introdued between when the front-end sends the
> fsync request, and when the back-end finishes writing the data and
> then communicates this back to the front-end --- i.e., caused by
> schedular latencies, this may end up being a disadvantage compared to
> more traditional file system designs.
>
> Like many things in file system design, there are tradeoffs.  It's
> perhaps more quseful when having these discussions to be clear what
> you are trading off for what; in this case, the front/back design may
> be good for somethings, and less good for others, such as mail server
> workloads where fsync(2) semantics is extremely important for
> application correctness.

Exactly, Ted. We avoided measuring the fsync load on this particular
benchmark because we have not yet optimized fsync. When we do get to
it (not an immediate priority) I expect Tux3 to perform competitively,
because our delta commit scheme does manage the job with a minimal
number of block writes. To have a really efficient fsync we need to
isolate just the changes for the fsynced file into a special "half
delta" that gets its own commit, ahead of any other pending changes
to the filesystem. There is a plan for this, however we would rather
not get sidetracked on that project now while we are getting ready
for merge.

The point that seems to be getting a little lost in this thread is,
the benchmark just as we ran it models an important and common type
of workload, arguably the most common workload for real users, and
the resulting performance measurement is easily reproducible for
anyone who cares to try. In fact, I think we should prepare and
post a detailed recipe for doing just that, since the interest
level seems to be high.

Regards,

Daniel

PS for any Googlers reading: do you know that using Gmail to post to
LKML is simply maddening for all concerned? If you want to know why
then try it yourself. Plain text. Some people need it, and need it to
be reliable instead of gratuitously changing back to html at
surprising times. And static word wrap. Necessary.
