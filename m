Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbaLBUS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:18:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbaLBUS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:18:27 -0500
Date: Tue, 2 Dec 2014 21:18:25 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Julia Lawall <julia.lawall@lip6.fr>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Olof Johansson <olof@lixom.net>, netdev@vger.kernel.org,
        backports@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: net-PA Semi: Deletion of unnecessary checks before the
	function call "pci_dev_put"
Message-ID: <20141202201825.GP25677@wotan.suse.de>
References: <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547BC5AD.6090500@users.sourceforge.net> <1417465745.28610.0.camel@sipsolutions.net> <alpine.DEB.2.02.1412012134290.2076@localhost6.localdomain6> <1417539208.1841.1.camel@sipsolutions.net> <20141202183509.GI4994@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202183509.GI4994@mwanda>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:35:09PM +0300, Dan Carpenter wrote:
> On Tue, Dec 02, 2014 at 05:53:28PM +0100, Johannes Berg wrote:
> > On Mon, 2014-12-01 at 21:34 +0100, Julia Lawall wrote:
> > 
> > > > So this kind of evolution is no problem for the (automated) backports
> > > > using the backports project - although it can be difficult to detect
> > > > such a thing is needed.
> > > 
> > > That is exactly the problem...
> > 
> > I'm not convinced though that it should stop such progress in mainline.
> 
> Is it progress? 

I like to think of progress as using tools to help fix code where we know
it can be made simpler with a small ammendment: if you can extend the tools
to also vet for safety for backports to avoid crashes even better.

So its a small evolution but we can do better, which is the point you and
Julia are making.

> These patches match the code look simpler by passing
> hiding the NULL check inside a function call.  Calling pci_dev_put(NULL)
> doesn't make sense.  Just because a sanity check exists doesn't mean we
> should do insane things.

It'd crash the system if the function call didn't have the check in place
but having the code in question call pci_dev_put(NULL) is also ludicrious.
Either way in this case I think we shouldn't go beyond analyzing the
function call and if the error check was present before as it is a real
case that has introduced crashes before which Julia wanted to flag.

> It's easy enough to store which functions have a sanity check in a
> database,

This is easy but it adds complexities which I'd prefer to keep on
some other people's workstations. For the developer I think we should
strive to only have: a) git b) Coccinelle c) smatch.

> but to rememember all that as a human being trying to read the
> code is impossible.

Agreed. The problem statement presented by Julia is part of the effort
of addressing the "how do we evolve faster" problem on Linux kernel development,
what you describe adds to the mix of the complexities, and while Oleg does
note that part of this is academic there are those of us who are making things
which are academic immediately practical and a reality for Linux. This is also
how we evolve faster :)

> If we really wanted to make this code cleaner we would introduce more
> error labels with better names.

Can you describe a bit more what you mean here? If we had a label *in code*
on the caller, perhaps a comment, I can see tool-wise how it'd remove the
requirement for a database for immediate analysis for safety here, ie,
we hunt for a label on the code; but other than that its unclear what
you mean here.

If you folks agree with my simplication tool analsysi for safety can
we devise a tag for whitelisting this check for a series of routines?
Where would we put it, in the kernel or a tools package? If in the kernel
we could end up sharing it, so I think that's be better. Perhaps scripts/safety/ ?
Maybe use a header that describes the safety check that is vetted by the rule
present, followed by a list of routines vetted?

Then the Cocci file can preload this and a rule that wants this paranoid check
can include this db file for safety ?

The safety here would require vetting thirough history in git that the routine
has a check in place throughout the routines's history up to a certain point.
I propose we only care up to what kernels are listed on kernel.org as supported.

 Luis
