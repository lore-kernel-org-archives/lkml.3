Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3G3AWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab3G3AWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:22:00 -0400
Date: Mon, 29 Jul 2013 20:21:49 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: maarten.lankhorst@canonical.com, bskeggs@redhat.com
Subject: Re: drm/nouveau: do not allow negative sizes for now
Message-ID: <20130730002149.GA3853@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	maarten.lankhorst@canonical.com, bskeggs@redhat.com
References: <20130723230814.C82D766092E@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723230814.C82D766092E@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:08:14PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=0108bc808107b97e101b15af9705729626be6447
 > Commit:     0108bc808107b97e101b15af9705729626be6447
 > Author:     Maarten Lankhorst <maarten.lankhorst@canonical.com>
 > AuthorDate: Sun Jul 7 10:40:19 2013 +0200
 > Committer:  Ben Skeggs <bskeggs@redhat.com>
 > CommitDate: Wed Jul 10 10:48:07 2013 +1000
 > 
 >     drm/nouveau: do not allow negative sizes for now
 >     
 >     The API allows up to 64-bits allocations, but size is handled as int
 >     inside nouveau almost everywhere. Until this is fixed it's better to
 >     prevent negative sizes.
 >     
 >     The 256 kB before INT_MAX is paranoia, because of the large page
 >     aligning below that could flip it above INT_MAX.
 > 
 > diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
 > index 459a445..4e7ee5f 100644
 > --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
 > +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
 > @@ -198,6 +198,12 @@ nouveau_bo_new(struct drm_device *dev, int size, int align,
 >  	size_t acc_size;
 >  	int ret;
 >  	int type = ttm_bo_type_device;
 > +	int max_size = INT_MAX & ~((1 << drm->client.base.vm->vmm->lpg_shift) - 1);
 > +
 > +	if (size <= 0 || size > max_size) {
 > +		nv_warn(drm, "skipped size %x\n", (u32)size);
 > +		return -EINVAL;
 > +	}
 >  
 >  	if (sg)
 >  		type = ttm_bo_type_sg;

A few more lines down..

 222         if (drm->client.base.vm) {
 223                 if (!(flags & TTM_PL_FLAG_TT) && size > 256 * 1024)

Which implies we may now be dereferencing NULL in some situations.
Either the check needs moving higher, or removing.

Can we get here with a NULL client.base.vm ? 

	Dave

