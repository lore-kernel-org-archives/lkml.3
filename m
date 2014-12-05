Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaLEHhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:37:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaLEHhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:37:40 -0500
Date: Thu, 4 Dec 2014 23:37:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] misc: suppress build warning
Message-Id: <20141204233754.286aa347.akpm@linux-foundation.org>
In-Reply-To: <20141204163032.GA29076@kroah.com>
References: <1417703910-2474-1-git-send-email-prabhakar.csengg@gmail.com>
	<12630889.EI0exeDoNc@wuerfel>
	<CA+V-a8vH9McTLVSWhQZun04AP7SZ7wGHeobBK1hA+EKn5fYgKw@mail.gmail.com>
	<20141204163032.GA29076@kroah.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014 08:30:32 -0800 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, Dec 04, 2014 at 03:13:00PM +0000, Prabhakar Lad wrote:
> > On Thu, Dec 4, 2014 at 2:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Thursday 04 December 2014 14:38:30 Lad, Prabhakar wrote:
> > >> this patch fixes following build warning:
> > >>
> > >> drivers/misc/ioc4.c: In function ___ioc4_probe___:
> > >> drivers/misc/ioc4.c:194:16: warning: ___start___ may be used uninitialized in this function [-Wmaybe-uninitialized]
> > >>   period = (end - start) /
> > >>                 ^
> > >> drivers/misc/ioc4.c:148:11: note: ___start___ was declared here
> > >>   uint64_t start, end, period;
> > >>
> > >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > >
> > > Please explain why the compiler thinks there is a bug, why you
> > > are sure that there isn't, and why you picked '0' as the
> > > initialization value.
> > >
> > Its a false positive, to suppress the warning '0' was picked.
> 
> Are you _sure_ it's a false positive?  That odd do/while loop looks like
> it might just not ever initialize the start variable, are you sure the
> logic there is correct?
> 

As long as IOC4_CALIBRATE_END is greater than IOC4_CALIBRATE_DISCARD (it is),
`start' is written to.

It would be nice to simplify the code, but I'm not sure how.

And I really dislike this initialize-it-to-zero-to-stop-the-warning
thing which we do all over the place.  The reader doesn't know *why*
it's initialized to zero and the initialization can conceal bugs if we
get a code path which should have written to it but forgot to.  And it
adds unneeded code to vlinux.

I much prefer unintialized_var() which fixes the documentation issue
and doesn't add code.  But Linus and Ingo had a dummy-spit over it.
