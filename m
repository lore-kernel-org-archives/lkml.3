Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3KFUcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:32:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab3KFUcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:32:12 -0500
Date: Wed, 6 Nov 2013 15:31:02 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, NeilBrown <neilb@suse.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: block: Revert bio_clone() default behaviour
Message-ID: <20131106203102.GA2049@redhat.com>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Kent,

Digging a bit in the LKML archive I think this patch is in response to
this thread: https://lkml.org/lkml/2013/11/6/27

Might be good to give context for which reported problem(s) are being
fixed by this patch.

On Tue, Nov 05 2013 at 10:48pm -0500,
Kent Overstreet <kmo@daterainc.com> wrote:

> This patch reverts the default behaviour introduced by
> 9fc6286f347d00528adcdcf12396d220f47492ed - bio_clone_biovec() no clonger
> shares the source bio's biovec, cloning the biovec is once again the
> default.

Your focus, in terms of revert, seems to be on restoring
bio_clone_bioset, so: s/bio_clone_biovec/bio_clone_bioset/

Maybe best to say "effectively reverts" since you aren't reverting 
9fc6286f347d00528adcdcf12396d220f47492ed ?  Also s/clonger/longer/ typo ^

> Instead, we add a new bio_clone_biovec_fast(), which creates a clone
> that shares the source's biovec. This patch changes bcache and md to use

s/md/dm/

> __bio_clone_biovec_fast() since they're expecting the new behaviour due
> to other refactoring; most of the other uses of bio_clone() should be
> same to convert to the _fast() variant but that will be done more

s/same/safe/

> incrementally in other patches (bio_split() in particular).
> 
> Note that __bio_clone() isn't being readded - the reason being that with
> immutable biovecs allocating the right number of biovecs for the new
> clone is no longer trivial so we don't want drivers trying to do that
> themselves.
> 
> This patch also reverts febca1baea1cfe2d7a0271385d89b03d5fb34f94 -
> __bio_clone_fast() should not be setting bi_vcnt for bios that do not
> own the biovec (see Documentation/block/biovecs.txt for rationale) - in
> short, not setting it might cause bugs in the short term but long term
> it's likely to hide nastier more subtle bugs, we don't want code looking
> at bi_vcnt at all for bios it does not own. However, this patch
> _shouldn't_ cause any regressions because of this since we're reverting
> back to the old bio_clone() behaviour.
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Chris Mason <chris.mason@fusionio.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Olof Johansson <olof@lixom.net>
> ---
> Chris, Olaf, can you two in particular test this? I have tested the bounce
> buffer code (and bcache), but Jens told me today there was an md bug that I
> _still_ can't find any emails about so I'm not sure what to test for that.

/me assumes you really mean md here, given Chris's later reply in this thread.

Relative to DM, this patch looks fine to me:

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks,
Mike
