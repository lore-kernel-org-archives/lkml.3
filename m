Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3CSA5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:57:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab3CSA5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:57:18 -0400
Date: Tue, 19 Mar 2013 08:56:59 +0800
From: Asias He <asias@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [ 04/21] target/pscsi: Fix page increment
Message-ID: <20130319005659.GB15879@hj.localdomain>
References: <20130312223245.109098379@linuxfoundation.org>
 <20130312223245.664885170@linuxfoundation.org>
 <1363399822.3937.161.camel@deadeye.wl.decadent.org.uk>
 <20130318053519.GE6232@hj.localdomain>
 <1363640434.3156.36.camel@haakon2.linux-iscsi.org>
 <1363649447.3937.348.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363649447.3937.348.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 11:30:47PM +0000, Ben Hutchings wrote:
> On Mon, 2013-03-18 at 14:00 -0700, Nicholas A. Bellinger wrote:
> > On Mon, 2013-03-18 at 13:35 +0800, Asias He wrote:
> > > On Sat, Mar 16, 2013 at 02:10:22AM +0000, Ben Hutchings wrote:
> > > > On Tue, 2013-03-12 at 15:44 -0700, Greg Kroah-Hartman wrote:
> > > > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > > > 
> > > > > ------------------
> > > > > 
> > > > > From: Asias He <asias@redhat.com>
> > > > > 
> > > > > commit 472b72f2db7831d7dbe22ffdff4adee3bd49b05d upstream.
> > > > > 
> > > > > The page++ is wrong. It makes bio_add_pc_page() pointing to a wrong page
> > > > > address if the 'while (len > 0 && data_len > 0) { ... }' loop is
> > > > > executed more than one once.
> > > > > 
> > > > > Signed-off-by: Asias He <asias@redhat.com>
> > > > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > 
> > > > > ---
> > > > >  drivers/target/target_core_pscsi.c |    1 -
> > > > >  1 file changed, 1 deletion(-)
> > > > > 
> > > > > --- a/drivers/target/target_core_pscsi.c
> > > > > +++ b/drivers/target/target_core_pscsi.c
> > > > > @@ -1210,7 +1210,6 @@ static int __pscsi_map_task_SG(
> > > > >  				bio = NULL;
> > > > >  			}
> > > > >  
> > > > > -			page++;
> > > > >  			len -= bytes;
> > > > >  			data_len -= bytes;
> > > > >  			off = 0;
> > > > 
> > > > So in case a fragment crosses a page boundary, we wrap around to the
> > > > beginning of the same page?  That doesn't look right.
> > > 
> > > If the fragment crosses a page boundary, what is the correct page
> > > for it?
> > > 
> > > Nicholas, can we assume sg->length + sg->offset should be less than PAGE_SIZE here?
> > > 
> > 
> > sg->length + sg->offset can be less than or equal to PAGE_SIZE here.
> >
> > For everything other than tcm_loop + tcm_vhost using externally
> > allocated SGLs, we can expect fragments to never cross the page
> > boundary.
> > 
> > For tcm_loop + tcm_vhost, there are a few special cases with control CDB
> > paylaods (usually going through scsi-generic) where we can have a non
> > zero sg->offset, but at least in the cases I've seen this is still not
> > using SGL elements that exceed PAGE_SIZE.
> >
> > So, I think this logic is OK for SGLs that cross page boundries, given
> > that it's done outside of the inner loop where *page is set during each
> > for_each_sg().
> 
> The page is set using sg_page() in the outer loop and was then
> incremented in the inner loop.
> 
> 	for_each_sg(sgl, sg, sgl_nents, i) {
> 		page = sg_page(sg);
> 		off = sg->offset;
> 		len = sg->length;
> 
> 		while (len > 0 && data_len > 0) {
> 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
> 			bytes = min(bytes, data_len);
> 			...
> 			/* page++; */
> 			len -= bytes;
> 			data_len -= bytes;
> 			off = 0;
> 		}
> 	}
> 
> The inner loop is apparently meant to iterate over pages of a segment,
> but is now just wrapping around a single page.

Yes, but we never loop more than once in the inner loop.

So, how about
1) fail on  sg->offset + sg->length > PAGE_SIZE (we can not find a
proper page address in this case)
2) remove the inner while loop, run the code was in the loop only once.

> > The case where this logic is broken, and that the 'page
> > ++' was addressing is when sg->length > PAGE_SIZE.
> 
> That is a sufficient but not a necessary condition for the increment.
> 
> Ben.
> 
> -- 
> Ben Hutchings
> Never attribute to conspiracy what can adequately be explained by stupidity.

-- 
Asias
