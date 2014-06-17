Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaFQTWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:22:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281AbaFQTW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:22:28 -0400
Date: Tue, 17 Jun 2014 12:26:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, stefanr@s5r6.in-berlin.de, joro@8bytes.org,
        jejb@parisc-linux.org, deller@gmx.de, bhelgaas@google.com, clm@fb.com,
        Josef Bacik <jbacik@fb.com>, swhiteho@redhat.com, bharrosh@panasas.com,
        bhalevy@primarydata.com, ccaulfie@redhat.com, teigland@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        jaegeuk@kernel.org, cm224.lee@samsung.com,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        casey@schaufler-ca.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/24] kobject: return actual error on kset_create_and_add
Message-ID: <20140617192623.GG4628@kroah.com>
References: <53A04FF7.5050900@oracle.com>
 <1403016160.27991.1.camel@dabdike.int.hansenpartnership.com>
 <53A05704.4070203@oracle.com>
 <20140617155030.GA14259@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617155030.GA14259@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 08:50:30AM -0700, Greg KH wrote:
> On Tue, Jun 17, 2014 at 10:56:04PM +0800, Jeff Liu wrote:
> > 
> > On 06/17/2014 22:42 PM, James Bottomley wrote:
> > > On Tue, 2014-06-17 at 22:25 +0800, Jeff Liu wrote:
> > >> From: Jie Liu <jeff.liu@oracle.com>
> > >>
> > >> It's better to return the actual error rather than NULL because
> > >> kset_register() can failed due to other reasons.
> > >>
> > >> Cc: Christoph Lameter <cl@linux-foundation.org>
> > >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >> Cc: Andrew Morton <akpm@linux-foundation.org>
> > >> Cc: Pekka Enberg <penberg@kernel.org>
> > >> Cc: Matt Mackall <mpm@selenic.com>
> > >> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > >> Cc: Paul Mackerras <paulus@samba.org>
> > >> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > >> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > >> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > >> Cc: David S. Miller <davem@davemloft.net>
> > >> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > >> Cc: Joerg Roedel <joro@8bytes.org>
> > >> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> > >> Cc: Helge Deller <deller@gmx.de>
> > >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> > >> Cc: Chris Mason <clm@fb.com>
> > >> Cc: Josef Bacik <jbacik@fb.com>
> > >> Cc: Steven Whitehouse <swhiteho@redhat.com>
> > >> Cc: Boaz Harrosh <bharrosh@panasas.com>
> > >> Cc: Benny Halevy <bhalevy@primarydata.com>
> > >> Cc: Christine Caulfield <ccaulfie@redhat.com>
> > >> Cc: David Teigland <teigland@redhat.com>
> > >> Cc: Theodore Ts'o <tytso@mit.edu>
> > >> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> > >> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> > >> Cc: Changman Lee <cm224.lee@samsung.com>
> > >> Cc: Mark Fasheh <mfasheh@suse.com>
> > >> Cc: Joel Becker <jlbec@evilplan.org>
> > >> Cc: Casey Schaufler <casey@schaufler-ca.com>
> > >> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > >> ---
> > >>  lib/kobject.c | 4 ++--
> > >>  1 file changed, 2 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/lib/kobject.c b/lib/kobject.c
> > >> index 58751bb..538c617 100644
> > >> --- a/lib/kobject.c
> > >> +++ b/lib/kobject.c
> > >> @@ -919,11 +919,11 @@ struct kset *kset_create_and_add(const char *name,
> > >>  
> > >>  	kset = kset_create(name, uevent_ops, parent_kobj);
> > >>  	if (!kset)
> > >> -		return NULL;
> > >> +		return ERR_PTR(-ENOMEM);
> > >>  	error = kset_register(kset);
> > >>  	if (error) {
> > >>  		kfree(kset);
> > >> -		return NULL;
> > >> +		return ERR_PTR(error);
> > >>  	}
> > >>  	return kset;
> > >>  }
> > > 
> > > This patch series isn't bisectable.  When changing an error signal from
> > > NULL to non-NULL, you have to do it as one patch, otherwise if a
> > > bisection lands in here we'll get error returns from all our kobject
> > > kset code and the kernel won't boot.
> > 
> > Thanks for pointing this out.
> > 
> > > It's fine if you're sending it out as 24 patches for review, but it has
> > > to be applied as a single one.
> > 
> > Ok, I'll post the v2 patch as a single one once this series has been reviewed.
> 
> Also, now that you sent a bunch of different patches out, some
> maintainers will not realize that this first one has to be applied (i.e.
> you gave them no sense that there was a dependancy.)
> 
> You will have to watch very carefully to ensure that those patches do
> not now get accepted, as they will break the existing code.

I've emailed a few responses to the patches that I could find, but
please follow-up and email everyone to not apply the patches as
responses to those patches so that everyone is properly notified.

greg k-h
