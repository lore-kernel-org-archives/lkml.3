Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935096Ab3DKMAV (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 11 Apr 2013 08:00:21 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:50799 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510Ab3DKMAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:00:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130410204029.GA31424@quack.suse.cz>
References: <CALkWK0nRQi+vZeVR4LVzLewhR-dUZqYANRV7yH8grp-1J7=g8Q@mail.gmail.com>
 <20130405155534.GC21852@quack.suse.cz> <20130405161229.GC4068@ZenIV.linux.org.uk>
 <20130408093125.GA6847@quack.suse.cz> <CALkWK0kHGZGPsk2f_9Cd_dutNVucf=V-9qH8bsxfYr2_EU-nsw@mail.gmail.com>
 <20130410204029.GA31424@quack.suse.cz>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 11 Apr 2013 17:29:39 +0530
Message-ID: <CALkWK0=kMGcPMfQWWt97Ae8JWvXDT+CGfAC-JWObF00KbYiZ_Q@mail.gmail.com>
Subject: Re: Beyond inotify recursive watches
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>   Initially, you will have to flip the flag on every directory in the
> subtree. But the flag is persistently stored on disk so you have to do it
> once when the directory is created and then each time you notice the
> directory has changed and the flag has been cleared.

How is this any better than setting up inotify recursively on the
directory tree?  I'll have to readdir() each directory in the tree,
looking for more directories to set the flag on.

>   I think Al is asking how do we lock kernel dentry cache so that we can
> safely walk up the tree and update time stamps in presence of other
> modifications happening to the directory tree in parallel.

>   It's not as much timestamp updates themselves racing against each other
> but rather things like moving directories in the directory tree racing with
> us walking up the tree and updating time stamps - in Linux, directory
> locking happens in top-bottom manner (like when you do lookup of a path) so
> when you are climbing up, one has to be careful not to introduce races.

Oh.  So we need to carefully code very fine-grained locking (so that
the entire fs isn't unusable when this recursive update is happening).

>   One reason why we need things to be fs-internal is that we want to store
> everything permanently on disk so that e.g. if there's reboot between
> modification of a git tree and 'git add -u', you will still find what has
> changed since last time you've checked (without walking the whole tree).

Makes sense.  However, doesn't this mean that we have to patch every
filesystem separately for this feature, as opposed to just patching
VFS?

>   My concern is that if you have a directory tree where there are lots of
> entries in each directory, then you still have to check a lot of entries
> before you find what has changed because you have to scan all entries in
> each directory on the modified path. If there was a way to iterate only
> through entries in a directory which had the flag cleared, things could be
> considerably faster.

What are your thoughts on introducing a version of readdir() that only
lists dentries with this flag?

Can you get deeper into the implementation, and point me to the parts
of the code to look at?  Do you have any WIP patches that I can look
at?
