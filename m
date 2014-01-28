Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaA1MEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:04:37 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35930 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbaA1MEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:04:36 -0500
Date: Tue, 28 Jan 2014 13:04:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Message-ID: <20140128120432.GA26347@gmail.com>
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
 <CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com>
 <20140126201928.GA8224@gmail.com>
 <20140126202509.GA10275@gmail.com>
 <CAMuHMdUzGhpa0Bxa2X69-+5jFE3Y3+Kqyof5Te3Y+aUeRPzCWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUzGhpa0Bxa2X69-+5jFE3Y3+Kqyof5Te3Y+aUeRPzCWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Sun, Jan 26, 2014 at 9:25 PM, Ingo Molnar <mingo@kernel.org> wrote:
> > * Ingo Molnar <mingo@kernel.org> wrote:
> >> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >> > On Sun, Jan 26, 2014 at 4:27 AM, David Howells <dhowells@redhat.com> wrote:
> >> > > -       p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
> >> > > +       p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
> >> > > -       p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
> >> > > +       p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
> >> >
> >> > So the S_IFREG isn't necessary.
> >> >
> >> > And quite frankly, I personally think S_IRUGO | S_IWUSR is _less_
> >> > readable than 0644. It's damn hard to parse those random letter
> >> > combinations, and at least I have to really think about it, in a way
> >> > that the octal representation does *not* make me go "I have to think
> >> > about that".
> >> >
> >> > So my personal preference would be to just see that simple 0644 in
> >> > proc_create. Hmm?
> >>
> >> Perhaps we could also generate the most common variants as:
> >>
> >>  #define PERM__rw_r__r__              0644
> >>  #define PERM__r________              0400
> >>  #define PERM__r__r__r__              0444
> >>  #define PERM__r_xr_xr_x              0555
> 
> I like it (also without the PERM prefix, cfr. Alexey's old patch).
> 
> >> or something similar, more or less matching the output of 'ls -l'?
> >
> > Another variant of this would be to do the following macro:
> >
> >         PERM(R_X, R_X, R_X)
> >         PERM(R__, R__, R__)
> >         PERM(RW_, R__, R__)
> 
> IMHO, this is again less outstanding.
> 
> > With the advantage of separating the groups better and reducing the
> > number of constants needed.
> 
> Only a limited number of combinations is in active use, right?

Correct - and in fact that kind of limitation is also a security 
feature: using patterns _outside_ of the typical, already defined 
group of permission patterns would in itself be a 'is that really 
justified?' red flag during review.

I'm fine with Alexey's shorter variant as well.

Would someone be interested in sending a real patch for it, defining a 
usable set of initial flags such as 0644, 0444, 0555 and 0600?

  comet:~/tip> for N in $(git grep -E '\.\<mode\>.*=.*0' arch/x86/ kernel/ | cut -d: -f2-); do echo $N; done | sort | grep ^0[0-7] | cut -c1-4 | uniq -c | sort -n
      1 0200
      1 0666
      5 0600
     15 0555
     16 0444
    148 0644

I'd definitely convert most of kernel/ and arch/x86/ to use them.

Thanks,

	Ingo
