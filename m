Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaGVTSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:18:53 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44831 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaGVTSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:18:52 -0400
Message-ID: <1406056727.29265.2.camel@gmail.com>
Subject: Re: [RFC] 3.16-rc6 -- fs/direct-io.c:1011 from and to uninitialized.
From: Ian Kumlien <ian.kumlien@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 21:18:47 +0200
In-Reply-To: <CAFLxGvwViHHZyX7se1gLkzDNnhp3raSmdV0=fieMssEZ=9BTQw@mail.gmail.com>
References: <1406055834.23587.1.camel@gmail.com>
	 <CAFLxGvwViHHZyX7se1gLkzDNnhp3raSmdV0=fieMssEZ=9BTQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tis, 2014-07-22 at 21:12 +0200, Richard Weinberger wrote:
> On Tue, Jul 22, 2014 at 9:03 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > This is a resend, try two...
> 
> Please see "[PATCH v3] direct-io: fix uninitialized warning in do_direct_IO()".

That looks like a better approach, couldn't find it before i started
sending this and my emails are autofiltered if you send via the web
ui.. ;)

> > ---
> > Hi,
> >
> > While playing around compiling the kernel i noticed the following:
> > fs/direct-io.c: In function ‘do_blockdev_direct_IO’:
> > fs/direct-io.c:1022:29: warning: ‘from’ may be used uninitialized in
> > this function [-Wmaybe-uninitialized]
> >     ret = submit_page_section(dio, sdio, page,
> >                              ^
> > fs/direct-io.c:913:10: note: ‘from’ was declared here
> >    size_t from, to;
> >           ^
> > fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this
> > function [-Wmaybe-uninitialized]
> >     u = (to - from) >> blkbits;
> >             ^
> > fs/direct-io.c:913:16: note: ‘to’ was declared here
> >    size_t from, to;
> >                 ^
> > ---
> >
> >
> > And while the fix is simple, something along the lines of:
> > diff --git a/fs/direct-io.c b/fs/direct-io.c
> > index 98040ba..64a8286 100644
> > --- a/fs/direct-io.c
> > +++ b/fs/direct-io.c
> > @@ -910,7 +910,7 @@ static int do_direct_IO(struct dio *dio, struct
> > dio_submit *sdi
> >
> >         while (sdio->block_in_file < sdio->final_block_in_request) {
> >                 struct page *page;
> > -               size_t from, to;
> > +               size_t from, to = {0};
> >                 page = dio_get_page(dio, sdio, &from, &to);
> >                 if (IS_ERR(page)) {
> >                         ret = PTR_ERR(page);
> > ---
> >
> > I however don't know if it's in the correct C standard, it compiles fine
> > though... (or if this is more gcc speific)
> >
> >
> >
> 
> 
> 


