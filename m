Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaDUScv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:32:51 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34816 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaDUScs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:32:48 -0400
Message-ID: <5355644C.7000801@gmail.com>
Date: Mon, 21 Apr 2014 20:32:44 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>
CC: mtk.manpages@gmail.com, Jeff Layton <jlayton@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com> <20140421140246.GB26358@brightrain.aerifal.cx> <535529FA.8070709@gmail.com> <20140421161004.GC26358@brightrain.aerifal.cx>
In-Reply-To: <20140421161004.GC26358@brightrain.aerifal.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 06:10 PM, Rich Felker wrote:
> On Mon, Apr 21, 2014 at 04:23:54PM +0200, Michael Kerrisk (man-pages) wrote:
>> On 04/21/2014 04:02 PM, Rich Felker wrote:
>>> On Mon, Apr 21, 2014 at 09:45:35AM -0400, Jeff Layton wrote:
>>>> File-private locks have been merged into Linux for v3.15, and *now*
>>>> people are commenting that the name and macro definitions for the new
>>>> file-private locks suck.
>>>>
>>>> ....and I can't even disagree. The names and command macros do suck.
>>>>
>>>> We're going to have to live with these for a long time, so it's
>>>> important that we be happy with the names before we're stuck with them.
>>>>
>>>> The consensus on the lists so far is that they should be rechristened as
>>>> "file-description locks".
>>>>
>>>> This patch makes the following changes that I think are necessary before
>>>> v3.15 ships:
>>>>
>>>> 1) rename the command macros to their new names. These end up in the uapi
>>>>    headers and so are part of the external-facing API. It turns out that
>>>>    glibc doesn't actually use the fcntl.h uapi header, but it's hard to
>>>>    be sure that something else won't. Changing it now is safest.
>>>>
>>>> 2) make the the /proc/locks output display these as type "FDLOCK"
>>>>
>>>> The rest of the renaming can wait until v3.16, since everything else
>>>> isn't visible outside of the kernel.
>>>
>>> I'm sorry I didn't chime in on this earlier, but I really prefer the
>>> (somewhat bad) current naming ("private") to the
>>> ridiculously-confusing use of "FD" to mean "file descriptION" when
>>> everybody is used to it meaning "file descriptOR". The potential for
>>> confusion that these are "file descriptOR locks" (they're not) is much
>>> more of a problem, IMO, than the confusion about what "private" means
>>> (since it doesn't have an established meaning in this context.
>>>
>>> Thus my vote is for leaving things the way the kernel did it already.
>>
>> There's at least two problems to solve here:
>>
>> 1) "File private locks" is _meaningless_ as a term. Elsewhere
> 
> That's the benefit of it: it doesn't clash with any
> already-established meaning. I agree it's less than ideal, but all the
> alternatives I've seen so far are worse.
> 
>>    (http://thread.gmane.org/gmane.network.samba.internals/76414/focus=1685376),
>>    I suggested various alternatives. "File-handle locks [*]" was my
> 
> This is also bad. "Handle" also has a defined meaning in POSIX. See
> XSH 2.5.1:
> 
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html
> 
>>    initial preference, and I also suggested "file-description locks"
>>    and noted the drawbacks of that term. I think it's insufficient
>>    to say "stick with the existing poor name"--if you have
>>    something better, then please propose it. (Note by the way
>>    that for nearly a decade now, the open(2) man page has followed
>>    POSIX in using the term "open file description. Full disclosure:
>>    of course, I'm responsible for that change in the man page.)
> 
> I'm well aware of that. The problem is that the proposed API is using
> the two-letter abbreviation FD, which ALWAYS means file descriptor and
> NEVER means file description (in existing usage) to mean file
> description. That's what's wrong.

So, can you *please* answer this question: what do you call (i.e., 
what  everyday technical language term do use for) the thing
that sits between a file descriptor and an i-node? 

(Please don't say 'struct file' -- that is not is an implementation 
detail, and does not qualify as the kind of term that I could use 
when documenting this feature in man pages.)

POSIX uses (or invented, I am not sure which) the term file description
for a good reason: it is unambiguous, and therefore precise. I do agree
that there's a risk of confusion between 'open file descriptor" and 
'and file description'--it's the same kind of risk as between English 
terms such as 'arbitrator' and 'arbitration' (and any number of other
examples), and as language speakers we deal with this every day.

The real problem is that people are less familiar with the 
term 'open file description'. Instead people dance around with 
a number of other ambiguous terms such as 'file handle' and 'open
file table entry' and (if thinking as an implementer) 'struct file',
and sometimes need to check with one another that their differing
terminologies mean the same thing. POSIX did come up with a solution;
I think there is value in following POSIX, and making the terminology
more widespread: an 'open file description' is the thing referred
to by an 'open file descriptor'.

And just to beat this donkey further... Consider the problem of
documenting (and talking about) this new feature. Suppose we call them
'file-private locks' (FPLs). Now, suppose you are given the problem 
of explaining to someone what these new FPLs are associated with 
(and this was the point of my question above). What are you going to 
say? Are you going to quietly pretend there isn't an entity between 
open file descriptors and inodes, and just explain things in terms 
of the semantics? (I think that approach does programmers a disservice, 
since understanding that there is an entity there greatly helps
people in terms of understanding what really is going on). Or
are you going to say that 'file-private locks' are associated with
XXX, where XXX is (take your pick): 'file handle' or 'open file 
table entry' or some other term of your preference. For my part, 
I'll follow POSIX and say that FPLs refer to 'open file
descriptions'. But when I start writing funny sentences like that,
I end up asking myself: why did we introduce this new term
'file-private lock'? Why not just name it after the entity with
which it is associated: 'file handle', 'file description',
or <insert your preference here>.

>> 2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have names
>>    that are visually very close to the traditional POSIX lock names 
>>    (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to happen
>>    when someone mistypes in code and/or misses such a misttyping
>>    when reading code. That really must be fixed.
> 
> I agree, but I don't think making it worse is a solution.

I don't agree that it's making it worse. The real problem here is 
that people use no good unambiguous term for the thing between a file
descriptor and an inode. POSIX provides us with a solution that may
not seem perfect, but it is unambiguous, and I think it might feel
more comfortable if we used it often enough.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
