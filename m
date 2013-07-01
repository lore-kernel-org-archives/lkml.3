Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3GARhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:37:14 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:43961 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3GARhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <1372697398.5019.1@driftwood>
References: <5f9a6b3ab75b12f2c5ba61ea1f6f3b08e9952b55.1372280661.git.luto@amacapital.net>
 <1372697398.5019.1@driftwood>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 1 Jul 2013 10:36:52 -0700
Message-ID: <CALCETrXcqnJJ3RGVjdepyvm1njr5cUo+p8r3BKL9jmNhneA64g@mail.gmail.com>
Subject: Re: [PATCH] proc: Document that /proc/<pid>/task/<tid>/children
 really is per-thread
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 9:49 AM, Rob Landley <rob@landley.net> wrote:
> On 06/26/2013 04:05:01 PM, Andy Lutomirski wrote:
>>
>> I was surprised to discover that a process can have a parent that isn't
>> a thread group leader.  (The usual ppid interfaces hide this, but the
>> children list exposes it.)
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> ---
>>  Documentation/filesystems/proc.txt | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/Documentation/filesystems/proc.txt
>> b/Documentation/filesystems/proc.txt
>> index fd8d0d5..205796a 100644
>> --- a/Documentation/filesystems/proc.txt
>> +++ b/Documentation/filesystems/proc.txt
>> @@ -1623,6 +1623,12 @@ This file provides a fast way to retrieve first
>> level children pids
>>  of a task pointed by <pid>/<tid> pair. The format is a space separated
>>  stream of pids.
>>
>> +This really is a per-thread list.  If a process's parent is a thread,
>> +then that process will appear in that thread's children list.  (This
>> +means that, for any pid, /proc/pid/task/*/children are disjoint lists.)
>> +This may be surprising, as /proc/pid/status's PPid field is parent's
>> +tgid as opposed to the parent's tid.
>
>
> I've read this twice and still don't quite understand what it's saying.
> (Possibly I need more than 3 hours of sleep.)
>
> It sounds like you're saying a thread can fork() and exec() and this makes
> proc look weird, because the ppid pooints to the thread group leader and not
> the thread, but the proc info listing us as a child belongs to the thread?

That is exactly right.  Is it unclear because I wrote it badly, or is
it unclear because it's really weird?

Perhaps I'll add something like:

For example, if thread group 100 has threads 100 (the leader) and 101,
and thread 101 forks and produces a child with tgid 102, then
/proc/100/task/100/children will be empty, /proc/100/task/101/children
will contain 102, and /proc/102/status will show 'Ppid: 100'.

>
> Is this a bug that should be fixed rather than documented? (Showing the
> right ppid for this corner case?)
>

I'm not qualified to say whether it's a bug or even, if it is a bug,
what the preferred behavior would be.

--Andy
