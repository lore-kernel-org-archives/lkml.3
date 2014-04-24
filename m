Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbaDXKBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:01:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbaDXKBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:01:19 -0400
Date: Thu, 24 Apr 2014 12:01:15 +0200
From: Jan Kara <jack@suse.cz>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Eric Paris <eparis@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] fanotify: check permissions when creating file
 descriptor
Message-ID: <20140424100115.GK17824@quack.suse.cz>
References: <1397940833-6386-1-git-send-email-xypron.glpk@gmx.de>
 <20140422134044.GE366@quack.suse.cz>
 <CAKgNAkh=Shj6UO6x_KieQEYUoY+guokNute0iwUfiSYFJbeTfQ@mail.gmail.com>
 <20140422140747.GF366@quack.suse.cz>
 <5356D66E.4040504@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356D66E.4040504@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-04-14 22:51:58, Heinrich Schuchardt wrote:
> On 22.04.2014 16:07, Jan Kara wrote:
> >>>On Sat 19-04-14 22:53:53, Heinrich Schuchardt wrote:
> >>>>When monitoring a directory or a mount with the fanotify API
> >>>>the call to fanotify_init checks,
> >>>>  * the process has cap_sys_admin capability
> >>>>
> >>>>The call to fanotify_mark checks,
> >>>>  * the process has read authorization for directory or mount
> >>>>
> >>>>A directory or mount may contain files for which the process
> >>>>has no read or write authorization.
> >>>>Yet when reading from the fanotify file descriptor, structures
> >>>>fanotify_event_metadata are returned, which contain a file
> >>>>descriptor for these files, and will allow to read or write.
> >>>>
> >>>>The patch adds an authorization check for read and write
> >>>>permission. In case of missing permission, reading from the
> >>>>fanotify file descriptor returns EACCES.
> >>>   OK, am I right you are concerned about a situation where fanotify group
> >>>descriptor is passed to an unpriviledged process which handles all the
> >>>incoming events? I'm asking because the permission checking can be
> >>>relatively expensive (think of acls) so we better do it for a reason.
> >>>I'd prefer to hear from Eric what the original intention regarding
> >>>permissions was...
> >
> >Reviewed-by: Jan Kara <jack@suse.cz>
> >
> 
> before applying the patch I think another problem has to be solved.
> 
> fanotify_read can have one of the following outcomes:
> 
> 1) Everything works fine one or multiple struct fanotify_event_metadata
> are returned. fanotify_event_metadata->fd references the concerned
> files.
> 2) An overflow occured. fanotify_event_metadata->fd is set to FAN_NOFD.
> 3) An error occured. fanotify_read returns no
> struct fanotify_event_metadata but fails with an error code.
> 
> This means any error in create_fd (called by fanotify read) may lead to
> lost events, if the error does not occur in the first event handled by
> fanotify_read.
> And not only events are lost, but also references to file descriptors
> are lost.
> 
> Of cause create_fd can already fail with EMFILE, if no more file
> descriptors are available. (Not a good situation to lose references
> to file descriptors?)
> 
> If we add the patch to check permissions errors in create_fd will
> be much more of an issue. A malware might force such errors to
> occur by writing to a file with chmod 200.
  Yeah, so as I wrote in another email I don't think permission checking in
create_fd() is needed after all but still the problem you raised is valid.

> Hence we have to rethink how errors are to be handled.
> 
> Instead of having fanotify_read returning an error code it could
> set the concerned fanotify_event_metadata->fd to the
> negative value of the error code, and return this
> fanotify_event_metadata as the last event.
> 
> Unfortunately this might break existing code, if this code only
> checks fanotify_event_metadata->fd against FAN_NOFD.
> 
> Another solution would be to simply set
> fanotify_event_metadata->fd = FAN_NOFD
> and errno to the error code.
> 
> This would not break any existing code, because such code already
> has to be able to handle FAN_NOFD. And the error relating to
> FANO_NOFD can be recovered from errno.
> 
> What is your idea how fanotify_read should gracefully handle a
> situation were the last of many returned events has a problem?
  I think the best behavior would be the following:
If we are filling out the first event, return the error which happened. If
we are filling out second or further event, leave the problematic event in
the queue and only return events succesfully copied.

The implementation isn't trivial but should be doable - you can peek at the
head of the event queue, try to open a file, and only if that succeeded remove
the event from the queue. To avoid races with other readers removing event
from the head of the queue, you have to hold group->notification_mutex
while doing this. A more lightweight alternative is to just peek at the
head of the queue, take reference to 'path', drop notification_mutex, open
the file described by path. Then you take notification_mutex again and
recheck whether the head event has the same path you opened - if yes, you
proceed with what you have, if no, you close the file and try again.

Do you want to look into this or should I cook up some patch for it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
