Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3EISNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:13:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3EISNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:13:23 -0400
Date: Thu, 9 May 2013 20:10:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [systemd-devel] [PATCH 2/2] coredump: Handle programs with
	spaces in COMM
Message-ID: <20130509181004.GA15526@redhat.com>
References: <1367341939.6959.1.camel@localhost> <20130430174731.GC3394@in.waw.pl> <1367349331.6959.80.camel@localhost> <20130501164246.GA7647@redhat.com> <20130503150824.GB24114@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503150824.GB24114@tango.0pointer.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay, vacation.

On 05/03, Lennart Poettering wrote:
>
> On Wed, 01.05.13 18:42, Oleg Nesterov (oleg@redhat.com) wrote:
>
> > I wouldn't say this is bug... at least this is expected.
> >
> > Sure, it is possible to rewrite format_corename/argv_split interaction,
> > but this is a bit painful and I am not sure it worth the trouble.
>
> It sounds really wrong to first merge this into one string and then
> split it up again. It sounds much more sensible to instead just pass the
> string array around all the time. What's the reason to make this one
> string first?

!ispipe case.

OK. I have to admit that this doesn't look nice even if this is
"historical" behaviour. The fix should be simple I guess,
format_corename() should construct argv by hand, argv_split()
should be avoided.

But:

	- We do not want to complicate this (ugly) code more than
	  necessary. In particular we shouldn't forget about ispipe.

	  Oh, and realloc, we can't count argc in advance or we need
	  more changes to protect against proc_dostring_coredump().

	- We should cleanup format_corename() first. If nothing else,
	  cn_escape().

	- Hmm. it seems that we also need to fix it, format_corename()
	  can leak ->corename afaics.

In short: I'll try to do this when I have time.

Oleg.

