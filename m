Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbaDVUwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:52:20 -0400
Received: from mout.gmx.net ([212.227.15.18]:54654 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbaDVUwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:52:14 -0400
Message-ID: <5356D66E.4040504@gmx.de>
Date: Tue, 22 Apr 2014 22:51:58 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: Eric Paris <eparis@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] fanotify: check permissions when creating file descriptor
References: <1397940833-6386-1-git-send-email-xypron.glpk@gmx.de> <20140422134044.GE366@quack.suse.cz> <CAKgNAkh=Shj6UO6x_KieQEYUoY+guokNute0iwUfiSYFJbeTfQ@mail.gmail.com> <20140422140747.GF366@quack.suse.cz>
In-Reply-To: <20140422140747.GF366@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:GVyxZ3jRsOQswMjnKPLR6dw/wzF8zu2YkR1s6TMMimTgC95T/dd
 LlriaqRNGbLClGyoQvJfVDgM3PG/nF+njJ7H4PGb2mmVKPKzOGCuX6fvlQLUn6M/1XRylbL
 nOM8zShRICHyF/t67tsf1HJNu+RIGYS/xNdg7vz6/71t7nkFIhfNVFN3uuOWvh60M428P78
 ErX5gUdJHTR3xiax0Cl2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.04.2014 16:07, Jan Kara wrote:
>>> On Sat 19-04-14 22:53:53, Heinrich Schuchardt wrote:
>>>> When monitoring a directory or a mount with the fanotify API
>>>> the call to fanotify_init checks,
>>>>   * the process has cap_sys_admin capability
>>>>
>>>> The call to fanotify_mark checks,
>>>>   * the process has read authorization for directory or mount
>>>>
>>>> A directory or mount may contain files for which the process
>>>> has no read or write authorization.
>>>> Yet when reading from the fanotify file descriptor, structures
>>>> fanotify_event_metadata are returned, which contain a file
>>>> descriptor for these files, and will allow to read or write.
>>>>
>>>> The patch adds an authorization check for read and write
>>>> permission. In case of missing permission, reading from the
>>>> fanotify file descriptor returns EACCES.
>>>    OK, am I right you are concerned about a situation where fanotify group
>>> descriptor is passed to an unpriviledged process which handles all the
>>> incoming events? I'm asking because the permission checking can be
>>> relatively expensive (think of acls) so we better do it for a reason.
>>> I'd prefer to hear from Eric what the original intention regarding
>>> permissions was...
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>

Hello Jan, hello Eric

before applying the patch I think another problem has to be solved.

fanotify_read can have one of the following outcomes:

1) Everything works fine one or multiple struct fanotify_event_metadata
are returned. fanotify_event_metadata->fd references the concerned
files.
2) An overflow occured. fanotify_event_metadata->fd is set to FAN_NOFD.
3) An error occured. fanotify_read returns no
struct fanotify_event_metadata but fails with an error code.

This means any error in create_fd (called by fanotify read) may lead to
lost events, if the error does not occur in the first event handled by
fanotify_read.
And not only events are lost, but also references to file descriptors
are lost.

Of cause create_fd can already fail with EMFILE, if no more file
descriptors are available. (Not a good situation to lose references
to file descriptors?)

If we add the patch to check permissions errors in create_fd will
be much more of an issue. A malware might force such errors to
occur by writing to a file with chmod 200.

Hence we have to rethink how errors are to be handled.

Instead of having fanotify_read returning an error code it could
set the concerned fanotify_event_metadata->fd to the
negative value of the error code, and return this
fanotify_event_metadata as the last event.

Unfortunately this might break existing code, if this code only
checks fanotify_event_metadata->fd against FAN_NOFD.

Another solution would be to simply set
fanotify_event_metadata->fd = FAN_NOFD
and errno to the error code.

This would not break any existing code, because such code already
has to be able to handle FAN_NOFD. And the error relating to
FANO_NOFD can be recovered from errno.

What is your idea how fanotify_read should gracefully handle a
situation were the last of many returned events has a problem?

Best regards

Heinrich Schuchardt
