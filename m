Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaDXQFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:05:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176AbaDXQFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:05:32 -0400
Date: Thu, 24 Apr 2014 18:05:29 +0200
From: Jan Kara <jack@suse.cz>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Eric Paris <eparis@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] fanotify: check permissions when creating file
 descriptor
Message-ID: <20140424160529.GD13573@quack.suse.cz>
References: <1397940833-6386-1-git-send-email-xypron.glpk@gmx.de>
 <20140422134044.GE366@quack.suse.cz>
 <CAKgNAkh=Shj6UO6x_KieQEYUoY+guokNute0iwUfiSYFJbeTfQ@mail.gmail.com>
 <20140422140747.GF366@quack.suse.cz>
 <20140424090441.GA6723@quack.suse.cz>
 <5359177E.1070907@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5359177E.1070907@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-04-14 15:54:06, Heinrich Schuchardt wrote:
> On 24.04.2014 11:04, Jan Kara wrote:
> >On Tue 22-04-14 16:07:47, Jan Kara wrote:
> >>On Tue 22-04-14 15:50:26, Michael Kerrisk (man-pages) wrote:
> >>>On Tue, Apr 22, 2014 at 3:40 PM, Jan Kara <jack@suse.cz> wrote:
> >>>>On Sat 19-04-14 22:53:53, Heinrich Schuchardt wrote:
> >>>>>When monitoring a directory or a mount with the fanotify API
> >>>>>the call to fanotify_init checks,
> >>>>>  * the process has cap_sys_admin capability
> >>>>>
> >>>>>The call to fanotify_mark checks,
> >>>>>  * the process has read authorization for directory or mount
> >>>>>
> >>>>>A directory or mount may contain files for which the process
> >>>>>has no read or write authorization.
> >>>>>Yet when reading from the fanotify file descriptor, structures
> >>>>>fanotify_event_metadata are returned, which contain a file
> >>>>>descriptor for these files, and will allow to read or write.
> >>>>>
> >>>>>The patch adds an authorization check for read and write
> >>>>>permission. In case of missing permission, reading from the
> >>>>>fanotify file descriptor returns EACCES.
> >>>>   OK, am I right you are concerned about a situation where fanotify group
> >>>>descriptor is passed to an unpriviledged process which handles all the
> >>>>incoming events? I'm asking because the permission checking can be
> >>>>relatively expensive (think of acls) so we better do it for a reason.
> >>>>I'd prefer to hear from Eric what the original intention regarding
> >>>>permissions was...
> >>>
> >>>If I understand correctly, passing to an unprivileged process is the
> >>>point. The point is I think that supposedly one only needs to
> >>>CAP_SYS_ADMIN to use fanotify. However, once you have that capability,
> >>>then you implicitly get the effect of CAP_DAC_READ_SEARCH and
> >>>CAP_DAC_OVERRIDE as well.
> >>   Ah, OK. Thanks for explanation. Then I'm OK with the patch. So feel free
> >>to add:
> >>
> >>Reviewed-by: Jan Kara <jack@suse.cz>
> >   Hum, when digging more around this code, I've found out that
> >fanotify_mark() checks whether it has a read permission to a watched file
> >when creating the mark (in fanotify_find_path()). So I don't think it's
> >really worth it to recheck the permissions when creating a file .gnupg/secring.gpgdescriptor
> >for the event. Sure it may be somewhat surprising that read fd is created
> >after a process doesn't have access to the file anymore but OTOH it is
> >similar to a situation where the process has opened the file long time ago.
> >
> 
> fanotify_mark checks for the read authorization for the marked object,
> not for the object for which the event occurs.
> 
> This means a listener may have read authorization for /home and mark
> this mount.
> Afterwards, while you sign a git tag, it will receive a FAN_OPEN event
> and use the file descriptor supplied in the event to overwrite your
> /home/jankara/.gnupg/secring.pgp
> though the file is chmod 600 and the listener is neither root nor you.
  Ah, right. Thanks for explaining this to me. I'm not really too excited
about this as a security issue because once the process has CAP_SYS_ADMIN
it basically owns the machine (it is sadly one of those capabilities which
is too broad) but I agree checking permissions when creating the fd is
reasonable.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
