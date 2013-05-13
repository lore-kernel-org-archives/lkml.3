Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3EMXW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:22:59 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:34803 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3EMXW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:22:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130511212608.GA26298@thunk.org>
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
	<20130510045049.GU24635@dastard>
	<CAEsagEism-SQB9LRC+EuPLoBiFOEHc0peLjh3cDxwrNe3Jz=2w@mail.gmail.com>
	<20130511212608.GA26298@thunk.org>
Date: Mon, 13 May 2013 16:22:56 -0700
Message-ID: <CAEsagEiFWxnLXWu7dH7jfH7xd4cRVaUdJr4zB+Rkk7V1kEemmA@mail.gmail.com>
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

Hi Ted,

You said:

> ...any advantage of decoupling the front/back end
> is nullified, since fsync(2) requires a temporal coupling

After after pondering it for a while, I realized that is not
completely accurate. The reduced delete latency will
allow the dbench process to proceed to the fsync point
faster, then if our fsync is reasonably efficient (not the
case today, but planned) we may still see an overall
speedup.

> if there is any delays introdued between when the
> front-end sends the fsync request, and when the back-
> end finishes writing the data and then communicates
> this back to the front-end --- i.e., caused by schedular
> latencies, this may end up being a disadvantage
> compared to more traditional file system designs.

Nothing stops our frontend from calling its backend
synchronously, which is just what we intend to do for
fsync. The real design issue for Tux3 fsync is writing
out the minimal set of blocks to update a single file.
As it is now, Tux3 commits all dirty file data at each
delta, which is fine for many common loads, but not
all. Two examples of loads where this may be less
than optimal:

  1) fsync (as you say)

  2) multiple tasks accessing different files

To excel under those loads, Tux3 needs to be able to
break its "always commit everything rule" in an
organized way. We have considered several design
options for this but not yet prototyped any because we
feel that that work can reasonably be attacked later. As
always, we will seek the most rugged, efficient and
simple solution.

Regards,

Daniel
