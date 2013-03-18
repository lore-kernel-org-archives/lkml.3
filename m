Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3CRVAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:00:39 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:58354 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3CRVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:00:37 -0400
Subject: Re: [ 04/21] target/pscsi: Fix page increment
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Asias He <asias@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <20130318053519.GE6232@hj.localdomain>
References: <20130312223245.109098379@linuxfoundation.org>
	 <20130312223245.664885170@linuxfoundation.org>
	 <1363399822.3937.161.camel@deadeye.wl.decadent.org.uk>
	 <20130318053519.GE6232@hj.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Mar 2013 14:00:34 -0700
Message-ID: <1363640434.3156.36.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 13:35 +0800, Asias He wrote:
> On Sat, Mar 16, 2013 at 02:10:22AM +0000, Ben Hutchings wrote:
> > On Tue, 2013-03-12 at 15:44 -0700, Greg Kroah-Hartman wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Asias He <asias@redhat.com>
> > > 
> > > commit 472b72f2db7831d7dbe22ffdff4adee3bd49b05d upstream.
> > > 
> > > The page++ is wrong. It makes bio_add_pc_page() pointing to a wrong page
> > > address if the 'while (len > 0 && data_len > 0) { ... }' loop is
> > > executed more than one once.
> > > 
> > > Signed-off-by: Asias He <asias@redhat.com>
> > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > ---
> > >  drivers/target/target_core_pscsi.c |    1 -
> > >  1 file changed, 1 deletion(-)
> > > 
> > > --- a/drivers/target/target_core_pscsi.c
> > > +++ b/drivers/target/target_core_pscsi.c
> > > @@ -1210,7 +1210,6 @@ static int __pscsi_map_task_SG(
> > >  				bio = NULL;
> > >  			}
> > >  
> > > -			page++;
> > >  			len -= bytes;
> > >  			data_len -= bytes;
> > >  			off = 0;
> > 
> > So in case a fragment crosses a page boundary, we wrap around to the
> > beginning of the same page?  That doesn't look right.
> 
> If the fragment crosses a page boundary, what is the correct page
> for it?
> 
> Nicholas, can we assume sg->length + sg->offset should be less than PAGE_SIZE here?
> 

sg->length + sg->offset can be less than or equal to PAGE_SIZE here.

For everything other than tcm_loop + tcm_vhost using externally
allocated SGLs, we can expect fragments to never cross the page
boundary.

For tcm_loop + tcm_vhost, there are a few special cases with control CDB
paylaods (usually going through scsi-generic) where we can have a non
zero sg->offset, but at least in the cases I've seen this is still not
using SGL elements that exceed PAGE_SIZE.

So, I think this logic is OK for SGLs that cross page boundries, given
that it's done outside of the inner loop where *page is set during each
for_each_sg().  The case where this logic is broken, and that the 'page
++' was addressing is when sg->length > PAGE_SIZE.

--nab

