Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbaLBVuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:50:17 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:53460 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaLBVuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:50:14 -0500
Date: Tue, 2 Dec 2014 13:50:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Srikanth Thokala <sriku.linux@gmail.com>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: memory-barriers: Fix typo in the first
 example
Message-ID: <20141202215006.GT25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1416285598-6630-1-git-send-email-sriku.linux@gmail.com>
 <CA+mB=1+4=eG6d-99+yZ6HgpqvU2uan+-13pXt1=H+GZ0HeRL1A@mail.gmail.com>
 <20141202161519.581ea1af@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202161519.581ea1af@lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120221-0029-0000-0000-0000060F1E2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 04:15:19PM -0500, Jonathan Corbet wrote:
> On Thu, 27 Nov 2014 12:19:26 +0530
> Srikanth Thokala <sriku.linux@gmail.com> wrote:
> 
> > Hi,
> > 
> > Kindly review the patch.
> 
> To me it looks right.  Something like this, though, needs an ack from
> Paul (cc'd) before I can be really confident.  Paul...?

I am guessing that this patch is against an old version of this file
(there have been two patches applied to this example in the last six
months).  I believe that the current version is correct, in other words,
that Alexey Dobriyan and Pranith Kumar beat you to this one.  ;-)

Please see below for the current version, which is in -tip as of
November 20th.

							Thanx, Paul

> jon
> 
> > Thanks
> > Srikanth
> > 
> > On Tue, Nov 18, 2014 at 10:09 AM, Srikanth Thokala
> > <sriku.linux@gmail.com> wrote:
> > > In the first example, the loads into 'x' and 'y' on CPU 2 doesn't
> > > match the sequence of events described below it.  To match the
> > > sequence of events, the values of 'A' and 'B' should be loaded
> > > into 'x' and 'y' respectively.
> > >
> > > Signed-off-by: Srikanth Thokala <sriku.linux@gmail.com>
> > > ---
> > >  Documentation/memory-barriers.txt | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> > > index 22a969c..2770bce 100644
> > > --- a/Documentation/memory-barriers.txt
> > > +++ b/Documentation/memory-barriers.txt
> > > @@ -115,8 +115,8 @@ For example, consider the following sequence of events:
> > >         CPU 1           CPU 2
> > >         =============== ===============
> > >         { A == 1; B == 2 }
> > > -       A = 3;          x = B;
> > > -       B = 4;          y = A;
> > > +       A = 3;          x = A;
> > > +       B = 4;          y = B;
> > >
> > >  The set of accesses as seen by the memory system in the middle can be arranged
> > >  in 24 different combinations:

For example, consider the following sequence of events:

	CPU 1		CPU 2
	===============	===============
	{ A == 1; B == 2 }
	A = 3;		x = B;
	B = 4;		y = A;

The set of accesses as seen by the memory system in the middle can be arranged
in 24 different combinations:

	STORE A=3,	STORE B=4,	y=LOAD A->3,	x=LOAD B->4
	STORE A=3,	STORE B=4,	x=LOAD B->4,	y=LOAD A->3
	STORE A=3,	y=LOAD A->3,	STORE B=4,	x=LOAD B->4
	STORE A=3,	y=LOAD A->3,	x=LOAD B->2,	STORE B=4
	STORE A=3,	x=LOAD B->2,	STORE B=4,	y=LOAD A->3
	STORE A=3,	x=LOAD B->2,	y=LOAD A->3,	STORE B=4
	STORE B=4,	STORE A=3,	y=LOAD A->3,	x=LOAD B->4
	STORE B=4, ...
	...

and can thus result in four different combinations of values:

	x == 2, y == 1
	x == 2, y == 3
	x == 4, y == 1
	x == 4, y == 3

