Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaKCXBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:01:23 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:52700 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaKCXBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:01:22 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411032352161.5308@nanos>
References: <1414450545-14028-1-git-send-email-toshi.kani@hp.com>
 <1414450545-14028-5-git-send-email-toshi.kani@hp.com> <94D0CD8314A33A4D9D801C0FE68B4029593578ED@G9W0745.americas.hpqcorp.net>
 <1415052905.10958.39.camel@misato.fc.hp.com> <alpine.DEB.2.11.1411032352161.5308@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 15:01:00 -0800
Message-ID: <CALCETrXs0SotEmqs0B7rbnnqkLvMV+fzOJzNbp+y2U=zB+25OQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for WT
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Toshi Kani <toshi.kani@hp.com>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "hmh@hmh.eng.br" <hmh@hmh.eng.br>,
        "yigal@plexistor.com" <yigal@plexistor.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 2:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 3 Nov 2014, Toshi Kani wrote:
>> On Mon, 2014-11-03 at 22:10 +0000, Elliott, Robert (Server Storage)
>> wrote:
>>  :
>> > > Subject: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for
>> > > WT
>> > >
>> > > This patch adds pgprot_writethrough() for setting WT to a given
>> > > pgprot_t.
>> > >
>> > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
>> > > Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> > ...
>> > > diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
>> > > index a214f5a..a0264d3 100644
>> > > --- a/arch/x86/mm/pat.c
>> > > +++ b/arch/x86/mm/pat.c
>> > > @@ -896,6 +896,16 @@ pgprot_t pgprot_writecombine(pgprot_t prot)
>> > >  }
>> > >  EXPORT_SYMBOL_GPL(pgprot_writecombine);
>> > >
>> > > +pgprot_t pgprot_writethrough(pgprot_t prot)
>> > > +{
>> > > + if (pat_enabled)
>> > > +         return __pgprot(pgprot_val(prot) |
>> > > +                         cachemode2protval(_PAGE_CACHE_MODE_WT));
>> > > + else
>> > > +         return pgprot_noncached(prot);
>> > > +}
>> > > +EXPORT_SYMBOL_GPL(pgprot_writethrough);
>> > ...
>> >
>> > Would you be willing to use EXPORT_SYMBOL for the new
>> > pgprot_writethrough function to provide more flexibility
>> > for modules to utilize the new feature?  In x86/mm, 18 of 60
>> > current exports are GPL and 42 are not GPL.
>>
>> I simply used EXPORT_SYMBOL_GPL() since pgprot_writecombine() used
>> it. :-)  This interface is intended to be used along with
>> remap_pfn_range() and ioremap_prot(), which are both exported with
>> EXPORT_SYMBOL().  So, it seems reasonable to export it with
>> EXPORT_SYMBOL() as well.  I will make this change.
>
> NAK.
>
> This is new functionality and we really have no reason to give the GPL
> circumventors access to it.

I have mixed feelings about this.

On the one hand, I agree with your sentiment.

On the other hand, I thought that _GPL was supposed to be more about
whether the thing using it is inherently a derived work of the Linux
kernel.  Since WT is an Intel concept, not a Linux concept, then I
think that this is a hard argument to make.

Not that I mind encouraging HP to GPL everything.  Although my
experiences so far with HP servers have been so uniformly negative
that I really just want to stay far away from anything storage-related
by HP for several years, so I'm very unlikely to own an affected piece
of hardware any time soon.  (Sorry, HP.)

--Andy
