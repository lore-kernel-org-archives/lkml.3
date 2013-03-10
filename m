Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3CJEvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 23:51:33 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:52078 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3CJEvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 23:51:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAKRKD_W8pW+8kUO2HvgCQrtqnHOZzgeGiwAF5ER3Yad4OMcizg@mail.gmail.com>
References: <201211011352.42476.Martin@lichtvoll.de>
	<6898338.Kmf2pUBmi1@deuteros>
	<201211101753.46211.Martin@lichtvoll.de>
	<10569573.iu1a6eiZCO@deuteros>
	<CAKRKD_W8pW+8kUO2HvgCQrtqnHOZzgeGiwAF5ER3Yad4OMcizg@mail.gmail.com>
Date: Sat, 9 Mar 2013 23:51:30 -0500
Message-ID: <CAKRKD_XvW3hjpboNJELMwDkFAsu80gvWXXtedgRmSpjZE6dSug@mail.gmail.com>
Subject: Fwd: [Nepomuk] Better support for (desktop) file search / indexing applications
From: Simeon Bird <bladud@gmail.com>
To: Linux Filesystem Development Mailinglist 
	<linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sent again in plain-text - apologies.

---------- Forwarded message ----------
From: Simeon Bird <bladud@gmail.com>
Date: 9 March 2013 23:49
Subject: Re: [Nepomuk] Better support for (desktop) file search /
indexing applications
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Jan Kara <jack@suse.cz>,
Robert Love <rlove@rlove.org>, linux-kernel@vger.kernel.org, Eric
Paris <eparis@redhat.com>, Nepomuk Mailing List <nepomuk@kde.org>,
Linux Filesystem Development Mailinglist
<linux-fsdevel@vger.kernel.org>, Eric Paris <eparis@parisplace.org>,
John McCutchan <john@johnmccutchan.com>


On 12 November 2012 04:10, Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk> wrote:
>
> On Saturday 10 November 2012 17:53:45 Martin Steigerwald wrote:
> > Still fanotify needs root access and thus this would need a daemon running
> > as root and some policy kit stuff to access it and in case of mount point
> > watches robust and secure code so that each user may only see his/her own
> > results.
>
> Perhaps then also extend fanotify to support user watches, from the top of my
> head I can't think of a reason it would be very difficult to implement. But it
> has been a few years since I actively worked with that code.
>
> Since you are not the only group having issues with fanotify feature set I can
> see this mini-project (together with extensions from me previous reply) being
> useful. It is also better to evolve it than neglect due a few shortcomings and
> then in a few years someone will come up with something completely new and
> then we will have yet another notification system.
>
> Tvrtko


Hi,

We (nepomuk) recently looked at using fanotify, and indeed we would
need user watches, support for moves and recursive directory watches
(we need to support the case where /home is not a separate filesystem)
before it would be useful to us. If you are interested in adding
these, we would be delighted to use nepomuk as a test-case for them.

We were wondering also if it would be possible to extend inotify a
little? Our wishlist is:

1) Recursive folder watches
2) When a file moves, some way to get the destination without watching
the directory it moved to, so moves can be tracked without watching
every file on the system.

I understand that there are reasons of security and performance why
you cannot implement 1), but is 2) possible? Maybe by extending
IN_MOVED_TO, or adding a new event type?

2) is actually in some ways the more severe problem for us. As well as
being an indexer, nepomuk is a system that allows you to store file
metadata such as ratings. When users move the files, they want the
metadata to move too, so we need to track where the file moved, and
thus at the moment we recursively watch everything. This is
particularly problematic with removable media; because a lot of people
will plug in an external drive and then move files onto it, we have to
watch every drive as soon as it is plugged in. If we were able to get
the destination of move events without watching the destination
directory, we could watch only those directories with interesting
metadata in, which would make things a lot easier.

inotify move tracking would also be useful for other things - eg, a
text editor could use inotify to see if a file it has open has moved
and offer to re-open the file in its new location, which is impossible
at the moment.

Since the lack of recursive watches is really a problem because we
have a tendency to run out of watches, it would also really help if
the default limit was a bit higher -  most people seem to have > 8000
folders, but I suspect far fewer have > 32000 (probably excepting
those who are indexing kernel source trees: I have 21000, and half of
that is KDE source).

Would any of this be possible? If you happen to know of a better way
to track moves using existing tools, that would be even better.

Thanks,
Simeon
