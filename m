Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaDDIAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:00:00 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:38817 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaDDH7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:59:52 -0400
Message-ID: <533E6673.4020606@gmail.com>
Date: Fri, 04 Apr 2014 09:59:47 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@redhat.com>,
        Lennart Poettering <lennart@poettering.net>, radu.voicilas@gmail.com,
        daniel@veillard.com
CC: mtk.manpages@gmail.com, Christoph Hellwig <hch@infradead.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>, gamin-list@gnome.org,
        lkml <linux-kernel@vger.kernel.org>,
        inotify-tools-general@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Things I wish I'd known about Inotify
References: <CAKgNAkjymzawYMKZGedK=fai55cwo4p=yeYe6GT8MdxWON__zw@mail.gmail.com> <871txeifsv.fsf@x220.int.ebiederm.org>
In-Reply-To: <871txeifsv.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC += Al Viro & Linux, since they also discussed the point about
remote filesystems and /proc and /sys here:
http://thread.gmane.org/gmane.linux.file-systems/83641/focus=83713 .]

On 04/03/2014 05:38 PM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> 
>> (To: == [the set of people I believe know a lot about inotify])
>>
>> Hello all,
>>
>> Lately, I've been studying the inotify API fairly thoroughly and
>> realized that there's a very big gap between knowing what the system
>> calls do versus using them to reliably and efficiently monitor the
>> state of a set of filesystem objects.
>>
>> With that in mind, I've drafted some substantial additions to the
>> inotify(7) man page. I would be very happy if folk on the "To:" list
>> could comment on the text below, since I believe you all have a lot of
>> practical experience with Inotify. (Of course, I also welcome comments
>> from anyone else.) In particular, I would like comments on the
>> accuracy of the various technical points (especially those relating to
>> matching up related IN_MOVED_FROM and IN_MOVED_TO events), as well as
>> pointers on any other pitfalls that the programmers should be wary of
>> that should be added to the page.
> 
> 
> Other pitfalls.
> 
> Inotify only report events that a user space program triggers through
> the filesystem API.  Which means inotify is limited for remote
> filesystems, and filesystems like proc and sys have no monitorable

Good point. I recently got CCed on that very point, but hadn't 
added it to the page. I've added it now. 

Revised text below, after incorporating changes from your comments and those
of Jan Kara.

Cheers,

Michael


   Limitations and caveats
       The inotify API provides no information about the user or process
       that triggered the inotify event.  In  particular,  there  is  no
       easy  way  for a process that is monitoring events via inotify to
       distinguish events that it triggers itself from  those  that  are
       triggered by other processes.

       Inotify  reports  only  events that a user-space program triggers
       through the filesystem API.  As  a  result,  it  does  not  catch
       remote  events  that occur on network filesystems.  (Applications
       must fall back to polling the filesystem to catch  such  events.)
       Furthermore, various virtual filesystems such as /proc, /sys, and
       /dev/pts are not monitorable with inotify.

       The inotify API identifies affected files by filename.   However,
       by  the time an application processes an inotify event, the file‐
       name may already have been deleted or renamed.

       The inotify API identifies events via watch descriptors.   It  is
       the  application's  responsibility  to cache a mapping (if one is
       needed) between watch descriptors and pathnames.  Be  aware  that
       directory renamings may affect multiple cached pathnames.

       Inotify  monitoring  of  directories is not recursive: to monitor
       subdirectories under a directory, additional watches must be cre‐
       ated.   This  can take a significant amount time for large direc‐
       tory trees.

       If monitoring an entire directory subtree, and a new subdirectory
       is  created in that tree or an existing directory is renamed into
       that tree, be aware that by the time you create a watch  for  the
       new  subdirectory,  new  files  (and  subdirectories) may already
       exist inside the subdirectory.  Therefore, you may want  to  scan
       the  contents  of  the  subdirectory immediately after adding the
       watch (and, if desired, recursively add watches for any subdirec‐
       tories that it contains).

       Note that the event queue can overflow.  In this case, events are
       lost.  Robust applications should handle the possibility of  lost
       events  gracefully.   For example, it may be necessary to rebuild
       part or all of the application cache.  (One simple, but  possibly
       expensive,  approach  is  to  close  the inotify file descriptor,
       empty the cache, create a new inotify file descriptor,  and  then
       re-create  watches  and cache entries for the objects to be moni‐
       tored.)

   Dealing with rename() events
       As noted above, the IN_MOVED_FROM and IN_MOVED_TO event pair that
       is  generated  by  rename(2)  can  be matched up via their shared
       cookie value.  However, the task of matching has some challenges.

       These two events are usually  consecutive  in  the  event  stream
       available  when  reading  from the inotify file descriptor.  How‐
       ever, this is not guaranteed.  If multiple processes are trigger‐
       ing  events  for  monitored  objects, then (on rare occasions) an
       arbitrary  number  of  other  events  may  appear   between   the
       IN_MOVED_FROM and IN_MOVED_TO events.

       Matching  up  the IN_MOVED_FROM and IN_MOVED_TO event pair gener‐
       ated by rename(2) is thus inherently racy.  (Don't forget that if
       an  object is renamed outside of a monitored directory, there may
       not even be an IN_MOVED_TO event.)  Heuristic  approaches  (e.g.,
       assume the events are always consecutive) can be used to ensure a
       match in most cases, but will inevitably miss some cases, causing
       the  application  to  perceive  the IN_MOVED_FROM and IN_MOVED_TO
       events as being unrelated.  If watch  descriptors  are  destroyed
       and  re-created as a result, then those watch descriptors will be
       inconsistent with the watch descriptors in  any  pending  events.
       (Re-creating the inotify file descriptor and rebuilding the cache
       may be useful to deal with this scenario.)

       Applications should also  allow  for  the  possibility  that  the
       IN_MOVED_FROM event was the last event that could fit in the buf‐
       fer returned by the current call to read(2), and the accompanying
       IN_MOVED_TO event might be fetched only on the next read(2).


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
