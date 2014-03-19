Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbaCSXfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:35:40 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46825 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaCSXfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:35:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140319152521.04fe6665c67efe0c6a70d8a5@linux-foundation.org>
References: <1395163080-6290-1-git-send-email-keescook@chromium.org>
	<1395163080-6290-2-git-send-email-keescook@chromium.org>
	<20140319152521.04fe6665c67efe0c6a70d8a5@linux-foundation.org>
Date: Wed, 19 Mar 2014 16:35:37 -0700
X-Google-Sender-Auth: E_zQlkNP-2QJ77WfKMcIKz0Q208
Message-ID: <CAGXu5jJH3RKTZJq0Yy71DeCMAGJpgOPnvtixSpGzSYn4MyG8WA@mail.gmail.com>
Subject: Re: [PATCH 1/2] sysctl: fix incorrect write position handling
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Aaron Tomlin <atomlin@redhat.com>, Andrew Shewmaker <agshew@gmail.com>,
        Li Zefan <lizefan@huawei.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 3:25 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 18 Mar 2014 10:17:59 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> When writing to a sysctl string, each write, regardless of VFS position,
>> began writing the string from the start. This meant the contents of
>> the last write to the sysctl controlled the string contents instead of
>> the first:
>>
>> open("/proc/sys/kernel/modprobe", O_WRONLY)   = 1
>> write(1, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"..., 4096) = 4096
>> write(1, "/bin/true", 9)                = 9
>> close(1)                                = 0
>>
>> $ cat /proc/sys/kernel/modprobe
>> /bin/true
>
> Yes, procfs writes have always been weird.
>
> Why are we fixing this?

This misbehavior was featured in an exploit against Chrome OS. While
it's not in itself a vulnerability, it's a weirdness that isn't on the
mind of most auditors. "This filter looks correct, it wouldn't resolve
to a real path." doesn't apply here, since the size of the write and
the contents of the final write are what matter when writing to
procfs.

> Perhaps there's an existing application which holds an fd open
> and periodically writes to it expecting some result.  This patch
> would break such an app?
>
>
> And what about something like this?
>
> while true
> do
>         echo 1
>         sleep 60
> done > /proc/sys/vm/drop_caches

Yes, my current change would break this. I could remove the changes to
the numeric values?

> To be consistent with the proposed alteration to string writes, this
> would have to write 1 then change that to 11 then to 111.  Or
> something, makes my head spin.

Well, no, the procfs writes stop processing at newlines.

>> Expected behaviour would be to have the sysctl be "AAAA..." capped at
>> maxlen (in this case KMOD_PATH_LEN: 256), instead of truncating to the
>> contents of the second write. Similarly, multiple short writes would not
>> append to the sysctl.
>
> So if we do
>
> (
>         echo foo
>         echo bar
> ) > /proc/sys/kernel/modprobe
>
> we get foo and later we get foobar?

No. Currently you get "bar" due to line endings. After, the change, it
would only be "foo" since the file position would be beyond "foo"
(buffer holds 3 bytes, write wrote 4 (with newline), so the next write
would be ignored).

>> This fixes the unexpected behavior for strings, and disallows non-zero
>> file position when writing numeric sysctls (similar to what is already
>> done when reading from non-zero file positions).
>
> So my script which writes drop_caches will break?

Yes, it would. When considering this, it seemed to me that people
would write such a script as:

while true
do
    echo 1 > /proc/sys/vm/drop_caches
    sleep 60
done

The behavior is pretty weird, and it seems like something we should
fix. My specific case is to fix the situation of writing garbage
followed by real information and allowing the write length size to
dictate what is being thrown away.

I wonder if there is a solution here involving the existing
acknowledgement of \0 or \n in string writes? The case I want to stop
lacked \0 or \n until the end ("AAAA..../bin/true\n") but the
write-length chunking meant the garbage part got thrown away instead
of correctly appending.

Should \0 and \n really mean "start again" here, and that and "open"
should be the only thing that rewinds the buffer to index 0? That way
"(echo foo; echo bar) > /proc/..." works as "bar", but "(echo -n foo;
echo bar) > /proc/..." results in "foobar". I'm not sure that's any
less an unexpected behavior, though.

-Kees

-- 
Kees Cook
Chrome OS Security
