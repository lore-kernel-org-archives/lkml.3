Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3CZTmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:42:42 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53308 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3CZTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:42:40 -0400
Date: Tue, 26 Mar 2013 12:42:37 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 26/27] block: Add an explicit bio flag for bios that own
 their bvec
Message-ID: <20130326194237.GA24935@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
 <1361319761-23873-27-git-send-email-koverstreet@google.com>
 <20130326111106.dc255f73804de1f8577fea52@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326111106.dc255f73804de1f8577fea52@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 11:11:06AM -0700, Andrew Morton wrote:
> On Tue, 19 Feb 2013 16:22:40 -0800 Kent Overstreet <koverstreet@google.com> wrote:
> 
> > This is for the new bio splitting code. When we split a bio, if the
> > split occured on a bvec boundry we reuse the bvec for the new bio. But
> > that means bio_free() can't free it, hence the explicit flag.
> > 
> > --- a/include/linux/blk_types.h
> > +++ b/include/linux/blk_types.h
> > @@ -117,6 +117,7 @@ struct bio {
> >   * BIO_POOL_IDX()
> >   */
> >  #define BIO_RESET_BITS	12
> > +#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
> >  
> >  #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
> 
> The BIO_OWNS_VEC definition seems to be in the wrong place - it should
> be grouped with the "bio flags" group above?

No - BIO_OWNS_VEC is set by bio_alloc_bioset() and is used by bio_free()
to determine if it should free the biovec, so it's something we don't
want cleared if driver code uses bio_reset().
