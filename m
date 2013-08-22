Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3HVTGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:06:14 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:42953 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3HVTGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130822185317.GI31117@1wt.eu>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
 <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com> <20130822185317.GI31117@1wt.eu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 12:05:50 -0700
Message-ID: <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 11:53 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Thu, Aug 22, 2013 at 11:48:10AM -0700, Linus Torvalds wrote:
>> On Wed, Aug 21, 2013 at 12:14 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> >
>> > So let's be careful for now: only allow linkat(..., AT_EMPTY_PATH)
>> > if the target is I_LINKABLE.
>>
>> So I really detest this just because it's such a special case. Now
>> this is only useful for that one special case, and the thing very
>> fundamentally checks that one special case in a place that is
>> impossible to check for the /proc case, so the proc case remains
>> totally separate.
>>
>> Which just bothers me.

Agreed.  It sucks.  See below (the bottom).

>>
>> I think we could easily at least allow the "file->f_creds ==
>> current->creds" case (and yes, I literally mean comparing the pointers
>> - not only is it cheaper, but it literally means "nothing odd has
>> happened in between opening and the lookup").

I thought about that, but it won't catch chroot.  (Admittedly, chroot
without changing creds is asking for trouble.)

>>
>> And I'm wondering if we shouldn't actually do that at "path_init"
>> time. Right now the code says:
>>
>>                 /* Caller must check execute permissions on the
>> starting path component */
>>                 struct fd f = fdget_raw(dfd);
>>
>> and then uses the struct file mindlessly.
>>
>> I'm wondering if we should just do some validation in that place, and say:
>>
>>  - for directories, we require exec permissions here
>>  - for everything else, we require that f->f_cred == current->cred check.

Does this work for the procfs case?  As far as I understand it (which
isn't saying much), it goes through the symlink-following path.

>>
>> I dunno. But that I_LINKABLE thing just bothers me. It screams "I'm
>> hacky" to me.
>
> I agreed, simply because the condition here is different from the one in /proc.
>
> I have read some code last evening to try to understand how /proc/pid/fd
> entries were granted access to various processes, because I would love to
> see the same condition being used in both places. Unfortunately, it's beyond
> my skills, and I stopped after my random attempts gave me some panics.

What if we added another field to struct nameidata that's indicates
what restrictions need to be enforced when following magical symlinks
and then enforcing them when nd_jump_link gets used.  (There are only
two of these, both in procfs.)

Then open could check that the original fd was opened for a superset
of the requested permissions (or that the caller has
CAP_DAC_OVERRIDE), linkat could check whatever it feels like checking,
etc.

This would allow all of these issues to be fixed for real (controlled
by sysctl, presumably).

--Andy

>
> Willy
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
