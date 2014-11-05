Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbaKERSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:18:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbaKERSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:18:21 -0500
Date: Wed, 5 Nov 2014 18:18:16 +0100
From: Jan Kara <jack@suse.cz>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>,
        "Sergey \"Shnatsel\" Davidoff" <sergey@elementaryos.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141105171816.GE30558@quack.suse.cz>
References: <1413881397.30379.7.camel@hadess.net>
 <loom.20141021T140216-28@post.gmane.org>
 <20141027092311.GA9807@amd>
 <CABaUXi4CkosMHDuNMMhTg3Ahrts5re-rJsPxN4JNp0Wu3AbKdA@mail.gmail.com>
 <20141031093618.GB30321@quack.suse.cz>
 <5457C7B7.7050302@gmx.de>
 <20141104092809.GB2953@quack.suse.cz>
 <54592F23.9000102@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54592F23.9000102@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-11-14 20:55:15, Heinrich Schuchardt wrote:
> On 04.11.2014 10:28, Jan Kara wrote:
> 
> >>If inotify_add_watch() would allow to mark a complete mount (like
> >>fanotify_mark() called with FAN_MOUNT) events for all files on this
> >>mount could be detected. If furthermore inotify_read() would return
> >>the complete relative path of the changed file relative to the mount
> >>in inotify_event->name, it would be obvious what the meaning of the
> >>event is.
> >   There are two catches though:
> >1) Getting of the path itself is unreliable due to presence of other fs
> >changes happening in parallel to you traversing the directory tree.
> >
> >2) The name you get from inotify_event->name is unreliable because by the
> >time you read the event, directory tree may be completely different.
> >
> >   These are the reasons why fanotify passes file descriptors with the
> >events instead of names.
> >
> >   Also for mountpoint wide notification your app has to be much faster
> >processing events so that the event queue doesn't overflow (and thus forces
> >you to do full rescan). fanotify deals with this by not limiting event
> >queue length at all but that's one of the reason why it's restricted to
> >CAP_SYS_ADMIN users.
> 
> This is reflected in fanotify_init already by explicitly checking
> CAP_SYS_ADMIN when using flag FAN_UNLIMITED_QUEUE.
  Right. So this is already handled, although we'd possibly need to have
the user limit tunable, not a compile time constant.

> >   So all in all I would find it better to extend fanotify to provide
> >directory events (that was originally planned but the support was dropped
> >due to technical issues),
> 
> I had a brief look at the systemd coding. They use at least:
> IN_ATTRIB
> IN_CLOSE_WRITE
> IN_CLOSE_NOWRITE
> IN_CREATE
> IN_DELETE
> IN_DELETE_SELF
> IN_MODIFY
> IN_MOVE_SELF
> IN_MOVED_FROM
> IN_MOVED_TO
> 
> Most of the sources of these events are passed as dentry and not as
> path. Bug 86781 describes that fanotify does not create events for
> double mounted file systems. It suggest to use the mount list of the
> superblock (which the dentry points to) instead of the mount
> indicated by a path.
> https://bugzilla.kernel.org/show_bug.cgi?id=86781
  I think there was a reason for this behavior but I forgot...

> Using dentries would allow to minimize code changes outside the core
> of the notification framework. Hence this is a central design
> decision to take before implementing the additional fanotify events.
> 
> > solve problems with unlimited event queues,
> 
> Isn't this already solved by
> group->max_events = FANOTIFY_DEFAULT_MAX_EVENTS?
  Mostly.

> > add some permission checking for passed file descriptors
> 
> This brings us back to
> https://lkml.org/lkml/2014/4/19/151
> (fanotify: check permissions when creating file descriptor)
  Yeah, somewhat. So when we'd open fanotify for ordinary users, we have to
add permission checks. Not only to the inode about whose change the event
notifies but also to all the path that leads to the inode (and that's going
to be tricky). Otherwise you could get file descriptors of files you'd
otherwise never be able to open. Hum, that's ugly.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
