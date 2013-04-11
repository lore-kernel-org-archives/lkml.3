Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937242Ab3DKADr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:03:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935048Ab3DKADp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:03:45 -0400
Date: Wed, 10 Apr 2013 20:03:42 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk
Subject: Re: NULL pointer due to malformed bcache bio
Message-ID: <20130411000342.GA19451@redhat.com>
References: <20130410205439.GA18092@redhat.com>
 <20130410224914.GD30871@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410224914.GD30871@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10 2013 at  6:49pm -0400,
Kent Overstreet <koverstreet@google.com> wrote:

> On Wed, Apr 10, 2013 at 04:54:40PM -0400, Mike Snitzer wrote:
> > Hey,
> > 
> > So DM core clearly needs to be more defensive about the possibility for
> > a NULL return from bio_alloc_bioset() given I'm hitting a NULL pointer
> > in DM's alloc_tio() because nr_iovecs=512.  bio_alloc_bioset()'s call to
> > bvec_alloc() only supports nr_iovecs up to BIO_MAX_PAGES (256).
> > 
> > Seems bcache should be using bio_get_nr_vecs() or something else?
> > 
> > But by using a bcache bucket size of 2MB, with the bcache staged in
> > Jens' for-next, I've caused bcache to issue bios with nr_iovecs=512:
> 
> Argh. Why is dm using bi_max_vecs instead of bi_vcnt? I could hack
> around this in bcache but I think dm is doing the wrong thing here.

But even bio_alloc_bioset() sets: bio->bi_max_vecs = nr_iovecs;
And bio_clone_bioset() calls bio_alloc_bioset() with bio->bi_max_vecs.
Similarly, __bio_clone() is using bi_max_vecs when cloning the bi_io_vec.
So I'm missing why DM is doing the wrong thing.

> Unless I've missed something in my testing (and bcache's BIO_MAX_PAGES
> check isn't quite right, actually) bcache _is_ splitting its bios
> whenever bio_segments(bio) > BIO_MAX_PAGES, it's only bi_max_vecs that's
> potentially > BIO_MAX_PAGES.

OK, but why drive bi_max_vecs larger than BIO_MAX_PAGES?
