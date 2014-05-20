Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbaETUWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:22:23 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55248 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaETUWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:22:21 -0400
Message-ID: <537BB979.4040406@gmail.com>
Date: Tue, 20 May 2014 22:22:17 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@poochiereds.net>
CC: mtk.manpages@gmail.com,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: OFD locks and deadlock detection
References: <537A0495.60107@gmail.com>	<20140519102802.16dee141@tlielax.poochiereds.net>	<537A4F3D.7000401@gmail.com> <20140520055402.6c132d60@tlielax.poochiereds.net>
In-Reply-To: <20140520055402.6c132d60@tlielax.poochiereds.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 11:54 AM, Jeff Layton wrote:
> On Mon, 19 May 2014 20:36:45 +0200
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:
> 
>> On 05/19/2014 04:28 PM, Jeff Layton wrote:
>>> On Mon, 19 May 2014 15:18:13 +0200
>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:
>>>
>>>> Hi Jeff,
>>>>
>>>> I just happened to notice :
>>>>
>>>>     commit 57b65325fe34ec4c917bc4e555144b4a94d9e1f7
>>>>     Author: Jeff Layton <jlayton@redhat.com>
>>>>     Date:   Mon Feb 3 12:13:09 2014 -0500
>>>>
>>>>         locks: skip deadlock detection on FL_FILE_PVT locks
>>>>
>>>> And then this thread:
>>>>
>>>>     http://thread.gmane.org/gmane.linux.file-systems/81318/focus=81327
>>>>     From: Jeff Layton <jlayton <at> redhat.com>
>>>>     Subject: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
>>>>     Date: 2014-01-09 14:19:46 GMT
>>>>
>>>> I think it's pretty important to document that. All implementations
>>>> of traditional process-associated (.k.a. "POSIX") locks that I've ever 
>>>> come across do detect deadlocks, so it's important to note that OFD locks 
>>>> do not.
>>>>
>>>> I plan to add the following text to the fcntl(2) page:
>>>>
>>>> [[
>>>> In the current implementation,
>>>> no deadlock detection is performed for open file description locks.
>>>> (This contrasts with process-associated record locks,
>>>> for which the kernel does perform deadlock detection.)
>>>> ]]
>>>>
>>>> Okay?
>>>>
>>>> cheers,
>>>>
>>>> Michael
>>>>
>>>>
>>>
>>> (note: I'm no longer with Red Hat, so jlayton@redhat.com no longer works)
>>
>> Ahh -- okay. Caches cleared.
>>
>>> Sounds fine to me.
>>
>> Okay.
>>
>>> FWIW, the deadlock detection for process-associated record locks is
>>> pretty worthless except in certain narrow circumstances.
>>
>> Can you say some more about that, please? Maybe there's something 
>> worth putting into the man page. (Are there cases where deadlocks
>> are not detected?)
>>
> 
> Both false negatives and false positives are possible.
> 
> Basically what the deadlock detector does is to walk down a chain of
> blocked locks and look to see if any of them are waiting on locks that
> the process currently owns.
> 
> Unfortunately, ownership is defined by the value of current->files. So
> if you call clone with CLONE_FILES, you can have two threads of
> execution that share lock ownership. If one is holding a lock that the
> other wants to wait on, you'll end up getting EDEADLK back even though
> it wouldn't necessarily have been a deadlock.
> 
> Also, the existing code gives up after searching a chain of 10
> dependencies, so it's possible to hit a deadlock anyway if you have a
> chain of dependencies that's longer than that.

Thanks, Jeff, How does the following text for the man page look to you:

       When placing locks with F_SETLKW, the  kernel  detects  dead‐
       locks, whereby two or more processes have their lock requests
       mutually blocked by locks held by the other  processes.   For
       example,  suppose process A holds a write lock on byte 100 of
       a file, and process B holds a write lock  on  byte  200.   If
       each process then attempts to lock the byte already locked by
       the other process  using  F_SETLKW,  then,  without  deadlock
       detection,  both processes would remain blocked indefinitely.
       When the kernel detects such deadlocks, it causes one of  the
       blocking  lock  requests  to  immediately fail with the error
       EDEADLK; an application that encounters such an error  should
       release some of its locks to allow other applications to pro‐
       ceed before attempting regain the  locks  that  it  requires.
       Circular deadlocks involving more than two processes are also
       detected.  Note, however, that there are limitations  to  the
       kernel's deadlock-detection algorithm; see BUGS.

   BUGS
     Deadlock detection
       The  deadlock-detection algorithm employed by the kernel when
       dealing with F_SETLKW requests can yield both false negatives
       (failures  to  detect  deadlocks, leaving a set of deadlocked
       processes blocked indefinitely) and false positives  (EDEADLK
       errors  when  there is no deadlock).  For example, the kernel
       limits the lock depth of its dependency search to  10  steps,
       meaning  that  circular deadlock chains that exceed that size
       will not be detected.  In addition, the  kernel  may  falsely
       indicate  a deadlock when two or more processes created using
       the clone(2) CLONE_FILES flag place locks that appear (to the
       kernel) to conflict.

?

>>> At some point, we probably should have a discussion as to whether
>>> deadlock detection is really something we want to keep. The current
>>> implementation requires a global spinlock which has obvious
>>> consequences for scalability.
>>
>> Could be tricky. I wonder if there's code out there that depends
>> on deadlock detection.
>>
> 
> What I'd probably do first is add Kconfig option so we could compile it
> out. Then we can lobby the distros to do so and see who complains.
> Deadlock detection is optional in POSIX, so we aren't required to
> support it.

Sounds like a reasonable plan. Given the limitations, I suppose
it would be a brave / foolish application that tried to rely
on the kernel's deadlock-detection algorithm, so perhaps
there will be no complaints.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
