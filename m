Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaKDJ2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:28:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKDJ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:28:14 -0500
Date: Tue, 4 Nov 2014 10:28:09 +0100
From: Jan Kara <jack@suse.cz>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>,
        "Sergey \"Shnatsel\" Davidoff" <sergey@elementaryos.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141104092809.GB2953@quack.suse.cz>
References: <1413881397.30379.7.camel@hadess.net>
 <loom.20141021T140216-28@post.gmane.org>
 <20141027092311.GA9807@amd>
 <CABaUXi4CkosMHDuNMMhTg3Ahrts5re-rJsPxN4JNp0Wu3AbKdA@mail.gmail.com>
 <20141031093618.GB30321@quack.suse.cz>
 <5457C7B7.7050302@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5457C7B7.7050302@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03-11-14 19:21:43, Heinrich Schuchardt wrote:
> On 31.10.2014 10:36, Jan Kara wrote:
> >On Mon 27-10-14 20:02:51, Sergey "Shnatsel" Davidoff wrote:
> >>>If "recursive mtime" was available, would that work for you?
> >>
> >>It would work for detecting "offline" changes. I suppose recursive
> >>mtime not viable for online monitoring, mostly because detecting file
> >>renaming would be a massive PITA (and we already have fanotify with
> >>exactly this problem).
> >   Yes, you'll get only "something has changed in a subtree" information for
> >each directory. You'd then have to rescan the directory to find out what
> >has changed. But there's no simple solution for this - either you have to
> >process tons of events for busy directory tree or you have to somehow
> >reduce the amount of information provided to userspace...
> 
> If inotify_add_watch() would allow to mark a complete mount (like
> fanotify_mark() called with FAN_MOUNT) events for all files on this
> mount could be detected. If furthermore inotify_read() would return
> the complete relative path of the changed file relative to the mount
> in inotify_event->name, it would be obvious what the meaning of the
> event is.
  There are two catches though:
1) Getting of the path itself is unreliable due to presence of other fs
changes happening in parallel to you traversing the directory tree.

2) The name you get from inotify_event->name is unreliable because by the
time you read the event, directory tree may be completely different.

  These are the reasons why fanotify passes file descriptors with the
events instead of names.

  Also for mountpoint wide notification your app has to be much faster
processing events so that the event queue doesn't overflow (and thus forces
you to do full rescan). fanotify deals with this by not limiting event
queue length at all but that's one of the reason why it's restricted to
CAP_SYS_ADMIN users.

  So all in all I would find it better to extend fanotify to provide
directory events (that was originally planned but the support was dropped
due to technical issues), solve problems with unlimited event queues, add
some permission checking for passed file descriptors and audit fanotify to
verify it's otherwise safe for regular users.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
