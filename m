Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3JNNu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:50:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3JNNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:50:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131014125858.GH19604@quack.suse.cz>
References: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
	<20131014125858.GH19604@quack.suse.cz>
Date: Mon, 14 Oct 2013 21:50:54 +0800
Message-ID: <CACVXFVPpkJdw_AVwd=dRpD8ju6frjaU3QhKorr_PNNGu_D0jAQ@mail.gmail.com>
Subject: Re: [PATCH] ext4: fix checking on nr_to_write
From: Ming Lei <ming.lei@canonical.com>
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 8:58 PM, Jan Kara <jack@suse.cz> wrote:
>   Umm, I guess I see what are you pointing at. Thanks for catching that.
> mpage_process_page_bufs() always adds a buffer to mpd even if nr_to_write
> is already <= 0. But I would somewhat prefer not to call
> mpage_prepare_extent_to_map() at all when nr_to_write <= 0. So a patch
> like:
>                 ret = mpage_prepare_extent_to_map(&mpd);
>                 if (!ret) {
> -                       if (mpd.map.m_len)
> +                       if (mpd.map.m_len) {
>                                 ret = mpage_map_and_submit_extent(handle, &mpd,
>                                         &give_up_on_write);
> -                       else {
> +                               done = (wbc->nr_to_write <= 0);
> +                       } else {
>
> Should also fix your problem, am I right?

I am afraid it can't, because we need to stop scanning page cache
if end of file is reached.

nr_to_write will become negative inside mpage_map_and_submit_extent(),
that is why I fix it inside mpage_prepare_extent_to_map().


Thanks,
--
Ming Lei
