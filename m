Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab3KRT1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:27:39 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:58571 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3KRT1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:27:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131118191600.GA14679@redhat.com>
References: <20131101232521.GA23119@www.outflux.net>
	<20131114170337.GA11068@redhat.com>
	<CAGXu5jLXpLqjCAMFwKp7t7GpMq4+WBqNzSFC=up+CBvgGDuFCw@mail.gmail.com>
	<20131115203652.GA13476@redhat.com>
	<CAGXu5j+=LZYAczLVawGPAxd=9VX1FupWZq+2858GsrD1YprL3w@mail.gmail.com>
	<20131116190057.GA22666@redhat.com>
	<20131116190141.GC22666@redhat.com>
	<CAGXu5jK4sJ6zwi+rPqP-FjwY4C+6gsOVUOBfN7ztu9wNQYnk4g@mail.gmail.com>
	<20131118191600.GA14679@redhat.com>
Date: Mon, 18 Nov 2013 11:27:36 -0800
X-Google-Sender-Auth: kqoCoBy_Rv_aC9rYckVVjEuqM9w
Message-ID: <CAGXu5jKRvLqWkOF=3qoQ1ZdaKNLai_kai4Png5Ls3X1WAtdzJA@mail.gmail.com>
Subject: Re: [PATCH 2/3] kill MMF_DUMPABLE and MMF_DUMP_SECURELY
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasily Kulikov <segoon@openwall.com>,
        Petr Matousek <pmatouse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Alex Kelly <alex.page.kelly@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 11:16 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 11/18, Kees Cook wrote:
>>
>> On Sat, Nov 16, 2013 at 11:01 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > @@ -1629,24 +1628,13 @@ void set_dumpable(struct mm_struct *mm, int value)
>> >
>> >         do {
>> >                 old = ACCESS_ONCE(mm->flags);
>> > -               new = old & ~MMF_DUMPABLE_MASK;
>> > -
>> > -               switch (value) {
>> > -               case SUID_DUMP_ROOT:
>> > -                       new |= (1 << MMF_DUMP_SECURELY);
>> > -               case SUID_DUMP_USER:
>> > -                       new |= (1<< MMF_DUMPABLE);
>> > -               }
>> > -
>> > +               new = (old & ~MMF_DUMPABLE_MASK) | value;
>>
>> Just to make this safe against insane callers, perhaps mask the value as well?
>
> Well yes, before this patch set_dumpable() silently ignored the wrong
> value, perhaps you are right but see below.
>
>>     new = (old & ~MMF_DUMPABLE_MASK) | (value & MMF_DUMPABLE_MASK);
>                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> this doesn't really help, with this patch "mm->flags & MMF_DUMPABLE_MASK"
> has a room for yet another SUID_DUMP == 4 we do not have yet.
>
> And I don't really like the "silently ignore" logic, so perhaps
>
>                 if (WARN_ON(value > SUID_DUMP_ROOT))
>                         return;

Ah, good point about == 4. Yeah, I like the WARN_ON. No reason not to
be defensive as long as this code is getting changed.

-Kees

-- 
Kees Cook
Chrome OS Security
