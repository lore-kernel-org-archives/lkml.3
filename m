Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3CSDS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:18:28 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:57824 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3CSDS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:18:26 -0400
Subject: Re: [ 04/21] target/pscsi: Fix page increment
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Asias He <asias@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <1363655903.3937.350.camel@deadeye.wl.decadent.org.uk>
References: <20130312223245.109098379@linuxfoundation.org>
	 <20130312223245.664885170@linuxfoundation.org>
	 <1363399822.3937.161.camel@deadeye.wl.decadent.org.uk>
	 <20130318053519.GE6232@hj.localdomain>
	 <1363640434.3156.36.camel@haakon2.linux-iscsi.org>
	 <1363649447.3937.348.camel@deadeye.wl.decadent.org.uk>
	 <20130319005659.GB15879@hj.localdomain>
	 <1363655903.3937.350.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Mar 2013 20:18:23 -0700
Message-ID: <1363663103.3156.158.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 01:18 +0000, Ben Hutchings wrote:
> On Tue, 2013-03-19 at 08:56 +0800, Asias He wrote:
> > On Mon, Mar 18, 2013 at 11:30:47PM +0000, Ben Hutchings wrote:
> > > On Mon, 2013-03-18 at 14:00 -0700, Nicholas A. Bellinger wrote:
> > > > On Mon, 2013-03-18 at 13:35 +0800, Asias He wrote:
> > > > > On Sat, Mar 16, 2013 at 02:10:22AM +0000, Ben Hutchings wrote:
> > > > > > On Tue, 2013-03-12 at 15:44 -0700, Greg Kroah-Hartman wrote:
> > > > > > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > > > > > 
> > > > > > > ------------------
> > > > > > > 
> > > > > > > From: Asias He <asias@redhat.com>
> > > > > > > 
> > > > > > > commit 472b72f2db7831d7dbe22ffdff4adee3bd49b05d upstream.
> > > > > > > 
> > > > > > > The page++ is wrong. It makes bio_add_pc_page() pointing to a wrong page
> > > > > > > address if the 'while (len > 0 && data_len > 0) { ... }' loop is
> > > > > > > executed more than one once.
> > > > > > > 
> > > > > > > Signed-off-by: Asias He <asias@redhat.com>
> > > > > > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > > 
> > > > > > > ---
> > > > > > >  drivers/target/target_core_pscsi.c |    1 -
> > > > > > >  1 file changed, 1 deletion(-)
> > > > > > > 
> > > > > > > --- a/drivers/target/target_core_pscsi.c
> > > > > > > +++ b/drivers/target/target_core_pscsi.c
> > > > > > > @@ -1210,7 +1210,6 @@ static int __pscsi_map_task_SG(
> > > > > > >  				bio = NULL;
> > > > > > >  			}
> > > > > > >  
> > > > > > > -			page++;
> > > > > > >  			len -= bytes;
> > > > > > >  			data_len -= bytes;
> > > > > > >  			off = 0;
> > > > > > 
> > > > > > So in case a fragment crosses a page boundary, we wrap around to the
> > > > > > beginning of the same page?  That doesn't look right.
> > > > > 
> > > > > If the fragment crosses a page boundary, what is the correct page
> > > > > for it?
> > > > > 
> > > > > Nicholas, can we assume sg->length + sg->offset should be less than PAGE_SIZE here?
> > > > > 
> > > > 
> > > > sg->length + sg->offset can be less than or equal to PAGE_SIZE here.
> > > >
> > > > For everything other than tcm_loop + tcm_vhost using externally
> > > > allocated SGLs, we can expect fragments to never cross the page
> > > > boundary.
> > > > 
> > > > For tcm_loop + tcm_vhost, there are a few special cases with control CDB
> > > > paylaods (usually going through scsi-generic) where we can have a non
> > > > zero sg->offset, but at least in the cases I've seen this is still not
> > > > using SGL elements that exceed PAGE_SIZE.
> > > >
> > > > So, I think this logic is OK for SGLs that cross page boundries, given
> > > > that it's done outside of the inner loop where *page is set during each
> > > > for_each_sg().
> > > 
> > > The page is set using sg_page() in the outer loop and was then
> > > incremented in the inner loop.
> > > 
> > > 	for_each_sg(sgl, sg, sgl_nents, i) {
> > > 		page = sg_page(sg);
> > > 		off = sg->offset;
> > > 		len = sg->length;
> > > 
> > > 		while (len > 0 && data_len > 0) {
> > > 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
> > > 			bytes = min(bytes, data_len);
> > > 			...
> > > 			/* page++; */
> > > 			len -= bytes;
> > > 			data_len -= bytes;
> > > 			off = 0;
> > > 		}
> > > 	}
> > > 
> > > The inner loop is apparently meant to iterate over pages of a segment,
> > > but is now just wrapping around a single page.
> > 
> > Yes, but we never loop more than once in the inner loop.
> 
> If you're sure of that, then:
> 
> > So, how about
> > 1) fail on  sg->offset + sg->length > PAGE_SIZE (we can not find a
> > proper page address in this case)
> > 2) remove the inner while loop, run the code was in the loop only once.
> 
> this is fine, but then I don't understand why you sent a no-op change to
> stable in the first place.
> 

It's my fault for mis-understanding this patch, and putting this into
the queue as a stable bug-fix.

