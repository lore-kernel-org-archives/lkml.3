Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaANU3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:29:41 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:49668 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaANU3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:29:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140114192713.GA22262@fieldses.org>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
 <1389277187-18211-14-git-send-email-jlayton@redhat.com> <52CF05B5.5080700@amacapital.net>
 <20140109194930.1692fbbe@tlielax.poochiereds.net> <CALCETrXp-G2t9Lfd+tbyzWtXeBw+vLHWE4M7-297HQzyFDVU_g@mail.gmail.com>
 <20140114192713.GA22262@fieldses.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Jan 2014 12:29:17 -0800
Message-ID: <CALCETrWmOu-RVXNYmL--RMaiOiOMYVv5qd1+jfY0j8GZHh0rWg@mail.gmail.com>
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        drh@hwaci.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc: drh, who I suspect is responsible for the most widespread
userspace software that uses this stuff]

On Tue, Jan 14, 2014 at 11:27 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Thu, Jan 09, 2014 at 04:58:59PM -0800, Andy Lutomirski wrote:
>> On Thu, Jan 9, 2014 at 4:49 PM, Jeff Layton <jlayton@redhat.com> wrote:
>> > On Thu, 09 Jan 2014 12:25:25 -0800
>> > Andy Lutomirski <luto@amacapital.net> wrote:
>> >> When I think of deadlocks caused by r/w locks (which these are), I think
>> >> of two kinds.  First is what the current code tries to detect: two
>> >> processes that are each waiting for each other.  I don't know whether
>> >> POSIX enshrines the idea of detecting that, but I wouldn't be surprised,
>> >> considering how awful the old POSIX locks are.
> ...
>> >> The sensible kind of detectable deadlock involves just one lock, and it
>> >> happens when two processes both hold read locks and try to upgrade to
>> >> write locks.  This should be efficiently detectable and makes upgrading
>> >> locks safe(r).
>
> This also involves two processes waiting on each other, and the current
> code should detect either case equally well.
>
> ...
>> For this kind of deadlock detection, nothing global is needed -- I'm
>> only talking about detecting deadlocks due to two tasks upgrading
>> locks on the same file (with overlapping ranges) at the same time.
>>
>> This is actually useful for SQL-like things.  Imagine this scenario:
>>
>> Program 1:
>>
>> Open a file
>> BEGIN;
>> SELECT whatever;  -- acquires a read lock
>>
>> Program 2:
>>
>> Open the same file
>> BEGIN;
>> SELECT whatever;  -- acquires a read lock
>>
>> Program 1:
>> UPDATE something;  -- upgrades to write
>>
>> Now program 1 is waiting for program 2 to release its lock.  But if
>> program 2 tries to UPDATE, then it deadlocks.  A friendly MySQL
>> implementation (which, sadly, does not include sqlite) will fail the
>> abort the transaction instead.
>
> And then I suppose you'd need to get an exclusive lock when you retry,
> to guarantee forward progress in the face of multiple processes retrying
> at once.

I don't think so -- as long as deadlock detection is 100% reliable and
if you have writer priority, then all that readers need to do is to
drop and re-acquire the read lock.  (This property is critical to
avoid livelocks in SQL.  I rely on it here: a deadlocked UPDATE just
retries the entire transaction without any special exclusive locks.)

>
> I don't know, is this so useful?
>
>> It would be nice if the kernel
>> supported this.
>>
>> Note that unlocking and then re-locking for write is incorrect -- it
>> would allow program 2 to write inconsistent data.
>>
>> I think that implementing this could be as simple as having some way
>> to check if a struct file_lock is currently trying to upgrade from
>> read to write and, if you try to upgrade and end up waiting for such a
>> lock, aborting.
>
> You have to be clear what you mean by "such a lock".  What you really
> want to know is whether you'd be waiting on a lock that might be waiting
> on a lock you hold.

By "such a lock" I mean a read lock on the same file that's trying to
upgrade to write.  I think that's the main (only?) interesting case.
Checking for this has the nice property that you don't need to iterate
and you don't care whom the holder of that lock is waiting for -- if
it's upgrading and you overlap with it, you are certainly in the
deadlock case.

>
> To a first approximation, the current works with a graph with tasks as
> nodes and an arrow from node X to node Y if X is waiting on a lock held
> by node Y.  And it follows arrows in that graph looking for cycles.
>
> And sure I guess it would be a bit nicer if you only bothered checking
> for cycles that touch this one file.
>
> But I'd really rather avoid the complication of deadlock detection
> unless somebody can make a really strong case that they need it.

TBH, I suspect that the person you really want to ask is drh, who
writes/maintains sqlite (cc'd).  sqlite has fancy locks built on top
of fcntl locks.

>
>> The nasty case, though, is if you try to write-lock a
>> range while holding a read-lock on only part of the range -- you could
>> end up acquiring part of the range and deadlocking on the rest.  Now
>> you need to remember enough state to be able to abort.
>
> We wait until the entire lock can be applied, and then apply it all
> atomically (under i_lock).
>
>> (Actually, what happens if you receive a signal which waiting on a file lock?)
>
> Return -EINTR.
>
>> I would personally be okay with removing the existing deadlock
>> detector entirely.  I wouldn't be surprised if no one relies on it.
>
> I'd be in favor.
>
> --b.

--Andy
