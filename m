Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3JNRfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:35:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab3JNRfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:35:01 -0400
Date: Mon, 14 Oct 2013 19:34:59 +0200
From: Jan Kara <jack@suse.cz>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] ext4: fix checking on nr_to_write
Message-ID: <20131014173459.GL19604@quack.suse.cz>
References: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
 <20131014125858.GH19604@quack.suse.cz>
 <CACVXFVPpkJdw_AVwd=dRpD8ju6frjaU3QhKorr_PNNGu_D0jAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPpkJdw_AVwd=dRpD8ju6frjaU3QhKorr_PNNGu_D0jAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-10-13 21:50:54, Ming Lei wrote:
> On Mon, Oct 14, 2013 at 8:58 PM, Jan Kara <jack@suse.cz> wrote:
> >   Umm, I guess I see what are you pointing at. Thanks for catching that.
> > mpage_process_page_bufs() always adds a buffer to mpd even if nr_to_write
> > is already <= 0. But I would somewhat prefer not to call
> > mpage_prepare_extent_to_map() at all when nr_to_write <= 0. So a patch
> > like:
> >                 ret = mpage_prepare_extent_to_map(&mpd);
> >                 if (!ret) {
> > -                       if (mpd.map.m_len)
> > +                       if (mpd.map.m_len) {
> >                                 ret = mpage_map_and_submit_extent(handle, &mpd,
> >                                         &give_up_on_write);
> > -                       else {
> > +                               done = (wbc->nr_to_write <= 0);
> > +                       } else {
> >
> > Should also fix your problem, am I right?
> 
> I am afraid it can't, because we need to stop scanning page cache
> if end of file is reached.
  That should be OK. mpage_process_page_bufs() won't add a buffer beyond
EOF so we end the extent at EOF and next time we don't add anything to the
extent. My change wouldn't change anything in this.

> nr_to_write will become negative inside mpage_map_and_submit_extent(),
> that is why I fix it inside mpage_prepare_extent_to_map().
  Yes, mpage_map_and_submit_extent() creates negative nr_to_write but only
because mpage_prepare_extent_to_map() asked for mapping too big extent. But
if I'm reading the code correctly we first ask for writing the extent of
just the right size (nr_to_write becomes 0) but then ext4_writepages() asks
mpage_prepare_extent_to_map() for another extent and it will create a single
page extent for mapping before it finds out nr_to_write <= 0 and
terminates. Am I understanding the problem correctly?

After thinking about it again, moving the condition in
mpage_prepare_extent_to_map() as you did is probably better that what I
suggested. Just move it more up in the loop - like after page->index > end
condition. So that we don't unnecessarily lock the page etc.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
