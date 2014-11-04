Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaKDTzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:55:51 -0500
Received: from mout.gmx.net ([212.227.17.21]:59525 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbaKDTzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:55:49 -0500
Message-ID: <54592F23.9000102@gmx.de>
Date: Tue, 04 Nov 2014 20:55:15 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: "Sergey \"Shnatsel\" Davidoff" <sergey@elementaryos.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: A desktop environment[1] kernel wishlist
References: <1413881397.30379.7.camel@hadess.net> <loom.20141021T140216-28@post.gmane.org> <20141027092311.GA9807@amd> <CABaUXi4CkosMHDuNMMhTg3Ahrts5re-rJsPxN4JNp0Wu3AbKdA@mail.gmail.com> <20141031093618.GB30321@quack.suse.cz> <5457C7B7.7050302@gmx.de> <20141104092809.GB2953@quack.suse.cz>
In-Reply-To: <20141104092809.GB2953@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:nNFhUFCVhUZqgSkTiJ3pfHSe7ThzPIIssZErEsFeqOT5jxjbes/
 e3LLC1aBGfraAKAWT0LPsPVAqcaBoYDl2QeEOEHW/A49ZjcSOg10pe+f0ZAuXftZK/De+Mo
 N3+L5c7wIJWXPWXpRAl7AzncobkskHvm4qT5uzRWza6aWcjudwAeQWQ85i+V+Q+Jyd0d5MX
 1LJykxdjwkwhCLBFZza5g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.11.2014 10:28, Jan Kara wrote:

>> If inotify_add_watch() would allow to mark a complete mount (like
>> fanotify_mark() called with FAN_MOUNT) events for all files on this
>> mount could be detected. If furthermore inotify_read() would return
>> the complete relative path of the changed file relative to the mount
>> in inotify_event->name, it would be obvious what the meaning of the
>> event is.
>    There are two catches though:
> 1) Getting of the path itself is unreliable due to presence of other fs
> changes happening in parallel to you traversing the directory tree.
>
> 2) The name you get from inotify_event->name is unreliable because by the
> time you read the event, directory tree may be completely different.
>
>    These are the reasons why fanotify passes file descriptors with the
> events instead of names.
>
>    Also for mountpoint wide notification your app has to be much faster
> processing events so that the event queue doesn't overflow (and thus forces
> you to do full rescan). fanotify deals with this by not limiting event
> queue length at all but that's one of the reason why it's restricted to
> CAP_SYS_ADMIN users.

This is reflected in fanotify_init already by explicitly checking 
CAP_SYS_ADMIN when using flag FAN_UNLIMITED_QUEUE.

>
>    So all in all I would find it better to extend fanotify to provide
> directory events (that was originally planned but the support was dropped
> due to technical issues),

I had a brief look at the systemd coding. They use at least:
IN_ATTRIB
IN_CLOSE_WRITE
IN_CLOSE_NOWRITE
IN_CREATE
IN_DELETE
IN_DELETE_SELF
IN_MODIFY
IN_MOVE_SELF
IN_MOVED_FROM
IN_MOVED_TO

Most of the sources of these events are passed as dentry and not as 
path. Bug 86781 describes that fanotify does not create events for 
double mounted file systems. It suggest to use the mount list of the 
superblock (which the dentry points to) instead of the mount indicated 
by a path. https://bugzilla.kernel.org/show_bug.cgi?id=86781

Using dentries would allow to minimize code changes outside the core of 
the notification framework. Hence this is a central design decision to 
take before implementing the additional fanotify events.

 > solve problems with unlimited event queues,

Isn't this already solved by
group->max_events = FANOTIFY_DEFAULT_MAX_EVENTS?

 > add some permission checking for passed file descriptors

This brings us back to
https://lkml.org/lkml/2014/4/19/151
(fanotify: check permissions when creating file descriptor)

> and audit fanotify to
> verify it's otherwise safe for regular users.

Best regards

Heinrich Schuchardt

