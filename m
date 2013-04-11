Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936315Ab3DKVCt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 11 Apr 2013 17:02:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935153Ab3DKVCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:02:43 -0400
Date: Thu, 11 Apr 2013 23:02:41 +0200
From: Jan Kara <jack@suse.cz>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: Beyond inotify recursive watches
Message-ID: <20130411210241.GB9379@quack.suse.cz>
References: <CALkWK0nRQi+vZeVR4LVzLewhR-dUZqYANRV7yH8grp-1J7=g8Q@mail.gmail.com>
 <20130405155534.GC21852@quack.suse.cz>
 <20130405161229.GC4068@ZenIV.linux.org.uk>
 <20130408093125.GA6847@quack.suse.cz>
 <CALkWK0kHGZGPsk2f_9Cd_dutNVucf=V-9qH8bsxfYr2_EU-nsw@mail.gmail.com>
 <20130410204029.GA31424@quack.suse.cz>
 <CALkWK0=kMGcPMfQWWt97Ae8JWvXDT+CGfAC-JWObF00KbYiZ_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0=kMGcPMfQWWt97Ae8JWvXDT+CGfAC-JWObF00KbYiZ_Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-04-13 17:29:39, Ramkumar Ramachandra wrote:
> Jan Kara wrote:
> >   Initially, you will have to flip the flag on every directory in the
> > subtree. But the flag is persistently stored on disk so you have to do it
> > once when the directory is created and then each time you notice the
> > directory has changed and the flag has been cleared.
> 
> How is this any better than setting up inotify recursively on the
> directory tree?  I'll have to readdir() each directory in the tree,
> looking for more directories to set the flag on.
  With inotify you have to do this every time your watching application
starts. With my scheme you have to do this only once in a lifetime because
flags are persistent (stored on disk) once set.

> >   I think Al is asking how do we lock kernel dentry cache so that we can
> > safely walk up the tree and update time stamps in presence of other
> > modifications happening to the directory tree in parallel.
> 
> >   It's not as much timestamp updates themselves racing against each other
> > but rather things like moving directories in the directory tree racing with
> > us walking up the tree and updating time stamps - in Linux, directory
> > locking happens in top-bottom manner (like when you do lookup of a path) so
> > when you are climbing up, one has to be careful not to introduce races.
> 
> Oh.  So we need to carefully code very fine-grained locking (so that
> the entire fs isn't unusable when this recursive update is happening).
  Yes.

> >   One reason why we need things to be fs-internal is that we want to store
> > everything permanently on disk so that e.g. if there's reboot between
> > modification of a git tree and 'git add -u', you will still find what has
> > changed since last time you've checked (without walking the whole tree).
> 
> Makes sense.  However, doesn't this mean that we have to patch every
> filesystem separately for this feature, as opposed to just patching
> VFS?
  True. That's the downside of the flag being persistent. But the
persistency is necessary for some use cases (e.g. if you'd like to speedup
rsync with this, or if you'd like to keep cache of preparsed config files).
Also when the flag is persistent, inodes / dentries are not pinned in
memory which is another problem with using inotify for watching lots of
directories.

> >   My concern is that if you have a directory tree where there are lots of
> > entries in each directory, then you still have to check a lot of entries
> > before you find what has changed because you have to scan all entries in
> > each directory on the modified path. If there was a way to iterate only
> > through entries in a directory which had the flag cleared, things could be
> > considerably faster.
> 
> What are your thoughts on introducing a version of readdir() that only
> lists dentries with this flag?
  Yes, I was considering something like this. But again such list of
entries to return would have to be stored on disk so that we don't have to
lookup and load from disk inodes that don't have the flag set.

> Can you get deeper into the implementation, and point me to the parts
> of the code to look at?  Do you have any WIP patches that I can look
> at?
  Well, I have patches that were working in 2.6.37 and added support for
the feature in ext3 and ext4. But then I got stuck with the questions I
mentioned... But people keep asking for some feature like this so from time
to time I think it might be actually worth it to revive the patches.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
