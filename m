Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaA1Ijt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:39:49 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62095 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaA1Ijr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:39:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140126202509.GA10275@gmail.com>
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
	<CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com>
	<20140126201928.GA8224@gmail.com>
	<20140126202509.GA10275@gmail.com>
Date: Tue, 28 Jan 2014 09:39:46 +0100
X-Google-Sender-Auth: f-9AcvsvnPXIph7A1Kw0ChTSaG0
Message-ID: <CAMuHMdUzGhpa0Bxa2X69-+5jFE3Y3+Kqyof5Te3Y+aUeRPzCWg@mail.gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 9:25 PM, Ingo Molnar <mingo@kernel.org> wrote:
> * Ingo Molnar <mingo@kernel.org> wrote:
>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> > On Sun, Jan 26, 2014 at 4:27 AM, David Howells <dhowells@redhat.com> wrote:
>> > > -       p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
>> > > +       p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
>> > > -       p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
>> > > +       p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
>> >
>> > So the S_IFREG isn't necessary.
>> >
>> > And quite frankly, I personally think S_IRUGO | S_IWUSR is _less_
>> > readable than 0644. It's damn hard to parse those random letter
>> > combinations, and at least I have to really think about it, in a way
>> > that the octal representation does *not* make me go "I have to think
>> > about that".
>> >
>> > So my personal preference would be to just see that simple 0644 in
>> > proc_create. Hmm?
>>
>> Perhaps we could also generate the most common variants as:
>>
>>  #define PERM__rw_r__r__              0644
>>  #define PERM__r________              0400
>>  #define PERM__r__r__r__              0444
>>  #define PERM__r_xr_xr_x              0555

I like it (also without the PERM prefix, cfr. Alexey's old patch).

>> or something similar, more or less matching the output of 'ls -l'?
>
> Another variant of this would be to do the following macro:
>
>         PERM(R_X, R_X, R_X)
>         PERM(R__, R__, R__)
>         PERM(RW_, R__, R__)

IMHO, this is again less outstanding.

> With the advantage of separating the groups better and reducing the
> number of constants needed.

Only a limited number of combinations is in active use, right?
It should be difficult to create e.g. world-writable files that are
not accessable
by the owner.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
