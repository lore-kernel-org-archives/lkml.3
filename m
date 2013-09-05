Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3IEU3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:29:23 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:25544 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab3IEU3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:29:20 -0400
Message-ID: <5228E992.5050901@hp.com>
Date: Thu, 05 Sep 2013 16:29:06 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v2 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
References: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com> <1378407316-59852-2-git-send-email-Waiman.Long@hp.com> <CA+55aFwShEG-bm2JuQJPF3DTq-O5CVdYXzwN5UpSckka0Wgm-A@mail.gmail.com>
In-Reply-To: <CA+55aFwShEG-bm2JuQJPF3DTq-O5CVdYXzwN5UpSckka0Wgm-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 03:35 PM, Linus Torvalds wrote:
> No. Stop all these stupid games.
>
> No d_lock, no trying to make d_name/d_len consistent.
>
> No "compare d_name against d_iname".
>
> No EINVAL.
>
> No idiotic racy "let's fetch each byte one-by one and test them
> against NUL", which is just racy and stupid.
>
> Just do what I told you to do: *copy* the name one byte at a time, and
> stop copying if you hit NUL. IOW, make prepend() just use "strncpy()"
> instead of "memcpy()". You don't even need to check the end result -
> if it's bogus, the sequence count will fix it.
>
> No special cases. No games. No crap. Just make "prepend()" able to
> handle the special case of "oops, the name length didn't match, but we
> must not ever go past the end of the buffer".
>
> We can optimize strncpy() to use word accesses if it ends up ever
> being a performance issue. I suspect it never even shows up, but it's
> not hard to do if if does.
>
>              Linus

It is not as simple as doing a strncpy(). The pathname was built from 
the leaf up to the root, and from the end of buffer toward the 
beginning. As it goes through the while loop, the buffer will look like:

"    /c"
"  /b/c"
"/a/b/c"

If the content of the string is unreliable, I have to do at least 2 passes:
1) Locate the end of the string and determine the actual length
2) Copy the whole string or byte-by-byte backward

That is why I am looking for the null byte. Using strncpy() alone won't 
work. However, if the actual length doesn't match that of the dlen, the 
name string will be invalid and there is no point in proceeding any further.

I also consider the possible, but unlikely, scenario that during a 
rename operation, a short old name could be freed and replaced by a long 
new name. The old name could then be allocated to another user filling 
it up with non-NULL byte. If the buffer happen to be the end of 
valid-to-invalid memory page boundary, the code may step over to an 
invalid address by looking for the null byte. The current code probably 
won't free the buffer while the RCU lock is being hold, but future code 
change may make this assumption not valid. Blindly taking the d_lock may 
be too expensive as the original code does. That is why I come up with 
the internal vs. external dname check and take the lock only for 
external dname for safety.

I can change the code to do just locating the end of string and copying 
it backward, but not using strncpy().

-Longman
