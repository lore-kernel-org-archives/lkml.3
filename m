Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3DJSgo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 10 Apr 2013 14:36:44 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:35128 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3DJSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130408093125.GA6847@quack.suse.cz>
References: <CALkWK0nRQi+vZeVR4LVzLewhR-dUZqYANRV7yH8grp-1J7=g8Q@mail.gmail.com>
 <20130405155534.GC21852@quack.suse.cz> <20130405161229.GC4068@ZenIV.linux.org.uk>
 <20130408093125.GA6847@quack.suse.cz>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 11 Apr 2013 00:06:02 +0530
Message-ID: <CALkWK0kHGZGPsk2f_9Cd_dutNVucf=V-9qH8bsxfYr2_EU-nsw@mail.gmail.com>
Subject: Re: Beyond inotify recursive watches
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dropping git people from the CC, as this is not relevant to git anymore]

Okay, let me attempt to understand this.

Jan Kara wrote:
> On Fri 05-04-13 17:12:29, Al Viro wrote:
>> On Fri, Apr 05, 2013 at 05:55:34PM +0200, Jan Kara wrote:
>>
>> > What your question reminds me is an idea of recursive modification time
>> > stamp on directories. That is a time stamp that gets updated whenever
>> > anything in the tree under the directory changes. Now this would be too
>> > expensive to maintain so there's also a trick implemented that you update
>> > the time stamp (and continue updating recursive time stamps upwards) only
>> > if a special flag is set on the directory. And you clear the flag at that
>> > moment. So until someone checks the time stamp and resets the flag no
>> > further updates of the recursive modification time happen.

If I understand correctly, I'll have to set a flag on the toplevel
directory of the repository, and this recursive timestamp update magic
will apply to my entire worktree.  How exactly?  Are you going to
store that path somewhere? Whenever there's any modification on the
filesystem, you can look at the path of the inode you're modifying,
and see if it's under this path.  If it is, we'll have to keep update
the container dentry's timestamp, and continue recursively until we
hit the toplevel dentry.  On the toplevel dentry, you'll flip a flag
in addition to modifying the timestamp.

Later, I'll have to check if the timestamp changed from what I have
remembered in git.  If there is a change, I'll look through the
timestamp of every dentry downwards until I find the modified inode:
certainly much fewer fs calls.  After updating the git index with
fresh information, I'll have to flip the flag on the toplevel
directory again.

>> > This scheme works for arbitrary number of processes interested in recursive
>> > time stamps (only updates of the time stamps get more frequent). What is
>> > somewhat inconvenient is that this only tells you something in the
>> > directory or its subtree changed so you still have to scan all the
>> > directories on the path to modified file. So I'm not sure of how much use
>> > this would be to you.

I think it's a very useful feature to have in general, not just for
git or version control systems.

>> Feel free to write up the details of locking you'll need for that.  It will
>> *not* be fun...

Is this what you mean: What happens if two inodes under the toplevel
directory change nearly simultaneously?  The two propagation threads
will conflict.

>   Actually, it shouldn't be too bad if we don't guarantee we walk exactly
> the path used for modification. Then it is enough to do the same thing as
> following .. from each directory.

I have no idea what this means.

> And for userspace that should be enough because if timestamp update races
> with renames or similar actions somewhere up in the three then these
> operations will generate modification events and update time stamps as
> well. So userspace will notice there was a change.

Do you mean: as long as updating the timestamp is atomic, it doesn't
matter than many threads race to update it (it is guaranteed that
every thread does a successful update)?

> So this part should be doable. But as I wrote before, we might need some
> fs-internal index to allow efficient tracking of what has changed in one
> directory anyway and locking rules / costs for that are non-obvious.

Why does it have to be fs-internal, and not at the VFS layer?  I don't
know what VFS looks like, but of the little I know about btrfs:
There's one global B+ tree where dentry paths are keyed by their CRC32
hashes.  The dentry contains many inodes, and you're worried about
efficiently tracking which inodes have changed.  Why does there have
to be an efficiency concern there?  I suppose multiple inodes'
timestamp changing simultaneously can spawn threads that race to
update the dentry's timestamp.  Why is this challenge different from
the recursive propagation challenge?
