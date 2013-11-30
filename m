Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab3K3VE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 16:04:28 -0500
Received: from peace.netnation.com ([204.174.223.2]:60918 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3K3VE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 16:04:27 -0500
Date: Sat, 30 Nov 2013 13:04:25 -0800
From: Simon Kirby <sim@hostway.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Applegate <ia@cloudflare.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
Message-ID: <20131130210425.GA9018@hostway.ca>
References: <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
 <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
 <20130820040648.GG27005@ZenIV.linux.org.uk>
 <CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
 <20130820072143.GJ27005@ZenIV.linux.org.uk>
 <CAEcaRjg7GJhEbQoduup6xQKea4Pn4+SOgv8GbbJUeU=xR74dVQ@mail.gmail.com>
 <20131126004456.GF19648@hostway.ca>
 <CA+55aFxmVteJApiC5e=d9NmYO6PSbNertq5ipLpunmVreCTYUQ@mail.gmail.com>
 <20131130094343.GA12573@hostway.ca>
 <CA+55aFy_Tb9kqZpa670MT9BW+W+LAizB+KoUxrJECgb1G_fGug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy_Tb9kqZpa670MT9BW+W+LAizB+KoUxrJECgb1G_fGug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 09:25:33AM -0800, Linus Torvalds wrote:

> On Sat, Nov 30, 2013 at 1:43 AM, Simon Kirby <sim@hostway.ca> wrote:
>
> > I turned on kmalloc-192 tracing to find what else is using it: struct
> > nfs_fh, struct bio, and struct cred. Poking around those, struct bio has
> > bi_cnt, but it is way down in the struct. struct cred has "usage", but it
> > comes first. Hmm. Nevertheless, I set:
> >
> > CONFIG_DEBUG_MUTEXES=y
> > CONFIG_DEBUG_LIST=y
> > CONFIG_DEBUG_CREDENTIALS=y
> >
> > And tried:
> >
> > diff --git a/include/linux/cred.h b/include/linux/cred.h
> > index 04421e8..2646fe9 100644
> > --- a/include/linux/cred.h
> > +++ b/include/linux/cred.h
> > @@ -205,7 +205,9 @@ static inline void validate_process_creds(void)
> >   */
> >  static inline struct cred *get_new_cred(struct cred *cred)
> >  {
> > -       atomic_inc(&cred->usage);
> > +       if (atomic_inc_return(&cred->usage) == 0x6c) {
> > +               WARN_ON(cred->uid == 0x6b);
> 
> Oh, damn, I thought you had found it, and got very excited and already
> wrote a long email about things I wanted you to try. And then I
> started looking closer...
> 
> That test is wrong. Both of those fields are 32-bit, so testing them
> against 0x6b/0x6c is bogus: you're just catching real cases. The
> reason it catches omreport is presumably because omreport runs as some
> special user that happens to have uid 107 (on my machine that happens
> to be qemu). And having a usage count of 108 isn't particularly
> strange either - creds get a lot of re-use.
> 
> So close. It *might* still be one of those cases, but it doesn't
> really sound very likely. "bi_cnt" is deep inside the struct bio, and
> "usage" is at offset 0, not offset 4. And the ns_fh isn't very
> interesting.

*head smack* Too much 8-bit AVR coding...

Makes sense now: uid=107(nagios) gid=109(nagios) groups=109(nagios)

Well, the chances of atomic_inc intentionally incrementing 0x6b6b6b6b are
probably pretty rare. I'll try that.

Simon-
