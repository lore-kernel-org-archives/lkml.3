Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3FDNiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:38:01 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54665 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3FDNhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:37:54 -0400
Date: Tue, 4 Jun 2013 09:37:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] jbd2: check bh->b_data for NULL in
 jbd2_journal_get_descriptor_buffer before memset()
Message-ID: <20130604133749.GB23132@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ruslan Bilovol <ruslan.bilovol@ti.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
 <1370253616-8173-2-git-send-email-ruslan.bilovol@ti.com>
 <20130603153323.GB20009@thunk.org>
 <CAB=otbT15wLGkb_A9pa7-U=wH-_gOPgOR9Ee4uSL7_P0BmXt4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=otbT15wLGkb_A9pa7-U=wH-_gOPgOR9Ee4uSL7_P0BmXt4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 02:15:57PM +0300, Ruslan Bilovol wrote:
> > Have you actually seen a case where bh is non-NULL, but bh->b_data is
> > NULL?  If not, it might be better to do something like this:
> 
> Yes, this is exactly the situation I observe (bh is non-NULL, but
> bh->b_data is NULL)

Hmm... so the stack trace you sent in the commit description was one
where bh->b_data was NULL?  I'm trying to make sure there isn't
something else going on that we don't understand.

Could you put some instrumentation in __find_get_block()?  Something like this:

struct buffer_head *
__find_get_block(struct block_device *bdev, sector_t block, unsigned size)
{
	struct buffer_head *bh = lookup_bh_lru(bdev, block, size);

	if (bh == NULL) {
		bh = __find_get_block_slow(bdev, block);
		if (bh->b_data == NULL) {
		   pr_crit("b_data NULL after find_get_block_slow\n);
		   WARN_ON(1);
		}
		if (bh)
			bh_lru_install(bh);
	} else {
		if (bh->b_data == NULL) {
			pr_crit("b_data NULL after lookup_bh_lru\n");
			WARN_ON(1);
		}
	}
	if (bh)
		touch_buffer(bh);
	return bh;
}

... and then send me the stack trace after running your reproduction
case.  If it turns out the problem is in __find_get_block_slow(),
could you put in similar debugging checks there and try to track it
down?

I'm pretty sure the case of bh non-NULL and bh->b_data NULL is never
supposed to happen, and while we could just put a check where you
suggested, there are plenty of other places which use __getblk(), and
there may be other bugs that are hiding here.

Regards,

						- Ted
