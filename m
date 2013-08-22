Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3HVULJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:11:09 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:52330 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab3HVULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:11:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
 <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
 <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
 <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 13:10:43 -0700
Message-ID: <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 12:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Aug 22, 2013 at 12:05 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Does this work for the procfs case?  As far as I understand it (which
>> isn't saying much), it goes through the symlink-following path.
>
> Right. The /proc case is still separate, and we really should do
> something about that too. But again, I don't think I_LINKABLE is the
> thing to use there either. We probably should tighten up the magic
> /proc follow-link a lot.
>
>> What if we added another field to struct nameidata that's indicates
>> what restrictions need to be enforced when following magical symlinks
>> and then enforcing them when nd_jump_link gets used.  (There are only
>> two of these, both in procfs.)
>
> Yes, I think that might be just the kind of thing to do. Except some
> tightening could well be quite regardless of any extra flags.
>

What's the point of nd_jump_link anyway?  The only way I can think of
for a magic symlink in /proc to point to another symlink is to open a
symlink with O_PATH | O_NOFOLLOW.  Actually trying to use the
resulting link in /proc results in -ELOOP.  (Even just trying to open
a normal symlink with O_NOFOLLOW and without O_PATH results in
-ELOOP.)

It might be a lot simpler to rig up nd_jump_link to immediately
terminate lookup and let the callers (or the outer level of lookup)
deal with it.  That way the checks could be (more) easily unified with
AT_EMPTY_PATH.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
