Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaAJA7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:59:24 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:58544 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaAJA7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:59:22 -0500
MIME-Version: 1.0
In-Reply-To: <20140109194930.1692fbbe@tlielax.poochiereds.net>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
 <1389277187-18211-14-git-send-email-jlayton@redhat.com> <52CF05B5.5080700@amacapital.net>
 <20140109194930.1692fbbe@tlielax.poochiereds.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 9 Jan 2014 16:58:59 -0800
Message-ID: <CALCETrXp-G2t9Lfd+tbyzWtXeBw+vLHWE4M7-297HQzyFDVU_g@mail.gmail.com>
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
To: Jeff Layton <jlayton@redhat.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 4:49 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Thu, 09 Jan 2014 12:25:25 -0800
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On 01/09/2014 06:19 AM, Jeff Layton wrote:
>> > It's not really feasible to do deadlock detection with FL_FILE_PVT
>> > locks since they aren't owned by a single task, per-se. Deadlock
>> > detection also tends to be rather expensive so just skip it for
>> > these sorts of locks.
>>
>> I just looked at the existing deadlock detector, and... eww.
>>
>
> Actually, I find it to be pretty clever, but it's only useful in some
> very limited cases. Also, the performance penalty it imposes on a
> lock-heavy workload is pretty significant (I had some numbers when I
> did the overhaul of the spinlocking around that code, but don't have
> them handy).
>
>> When I think of deadlocks caused by r/w locks (which these are), I think
>> of two kinds.  First is what the current code tries to detect: two
>> processes that are each waiting for each other.  I don't know whether
>> POSIX enshrines the idea of detecting that, but I wouldn't be surprised,
>> considering how awful the old POSIX locks are.
>>
>
> It can walk down a chain of dependencies (which is the cool part), so
> the two processes don't even need to be working on the same inode at
> all in order for it to detect a deadlock. The catch is that there is no
> real way to deal with stuff like threads with this mechanism.
>
> In any case, the spec is here:
>
>     http://pubs.opengroup.org/onlinepubs/009696899/functions/fcntl.html
>
> ...and it just says: "A potential for deadlock occurs if a process
> controlling a locked region is put to sleep by attempting to lock
> another process' locked region. If the system detects that sleeping
> until a locked region is unlocked would cause a deadlock, fcntl() shall
> fail with an [EDEADLK] error."
>
> Since it just says "if the system detects", I take it to mean that all
> of this deadlock detection stuff is entirely optional.
>
>> The sensible kind of detectable deadlock involves just one lock, and it
>> happens when two processes both hold read locks and try to upgrade to
>> write locks.  This should be efficiently detectable and makes upgrading
>> locks safe(r).
>>
>> I think I'd be happier if it's at least documented that the new fcntl
>> calls might (some day) detect that kind of deadlock.
>>
>>
>
> Sure, I can toss a comment in to that effect.
>
> Personally, I'm rather keen to avoid dealing with deadlock detection
> here since it's a rather large pain to deal with. Deadlock detection is
> the only reason we have a global spinlock in this code anymore. I
> seriously considered ripping it all out when I was overhauling this a
> few months ago.
>
> I was able to get it to perform more reasonably by turning the global
> list into a hash table, but I'd have preferred to remove it altogether.

For this kind of deadlock detection, nothing global is needed -- I'm
only talking about detecting deadlocks due to two tasks upgrading
locks on the same file (with overlapping ranges) at the same time.

This is actually useful for SQL-like things.  Imagine this scenario:

Program 1:

Open a file
BEGIN;
SELECT whatever;  -- acquires a read lock

Program 2:

Open the same file
BEGIN;
SELECT whatever;  -- acquires a read lock

Program 1:
UPDATE something;  -- upgrades to write

Now program 1 is waiting for program 2 to release its lock.  But if
program 2 tries to UPDATE, then it deadlocks.  A friendly MySQL
implementation (which, sadly, does not include sqlite) will fail the
abort the transaction instead.  It would be nice if the kernel
supported this.

Note that unlocking and then re-locking for write is incorrect -- it
would allow program 2 to write inconsistent data.

I think that implementing this could be as simple as having some way
to check if a struct file_lock is currently trying to upgrade from
read to write and, if you try to upgrade and end up waiting for such a
lock, aborting.  The nasty case, though, is if you try to write-lock a
range while holding a read-lock on only part of the range -- you could
end up acquiring part of the range and deadlocking on the rest.  Now
you need to remember enough state to be able to abort.

(Actually, what happens if you receive a signal which waiting on a file lock?)

I would personally be okay with removing the existing deadlock
detector entirely.  I wouldn't be surprised if no one relies on it.

--Andy
