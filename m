Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaLDOIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:08:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbaLDOIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:08:38 -0500
Date: Thu, 4 Dec 2014 15:08:35 +0100
From: Jan Kara <jack@suse.cz>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jan Kara <jack@suse.cz>, Dong Aisheng <dongas86@gmail.com>,
        Tejun Heo <tj@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.or>,
        Dong Aisheng-B29396 <b29396@freescale.com>, r64343@freescale.com
Subject: Re: WARNING: at fs/fs-writeback.c when plug out SD card after system
 suspend/resume
Message-ID: <20141204140835.GA15108@quack.suse.cz>
References: <CAA+hA=R2x5dUkZAh9=nHLsmaqA5YiAjEya-vQnjLx6i7fruV1w@mail.gmail.com>
 <20141204124139.GC8569@quack.suse.cz>
 <CAPDyKFphwNUUV-e8SuZDEutMCu_a-S9cEP08V0DwUJywa6PtOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFphwNUUV-e8SuZDEutMCu_a-S9cEP08V0DwUJywa6PtOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-12-14 14:36:03, Ulf Hansson wrote:
> On 4 December 2014 at 13:41, Jan Kara <jack@suse.cz> wrote:
> > On Thu 04-12-14 11:43:17, Dong Aisheng wrote:
> >> Hi ALL,
> >>
> >> We met an filesystem issue when do stable kernel upgrade from 3.10.31 to
> >> 3.10.53. And we found it's caused by the following commit bf0972039 which
> >> introduced in 3.10.53.
> >> After applying this patch, after system suspend/resume, plug out a SD card
> >> will cause the following WARNING if SD card has a filesystem mounted.
> >> If revert it, no such WARNING shows.
> >>
> >> I also tried the latest linux-next tree, it also has such issue.
> >>
> >> Looks the patch is used to fixing a potential system crashing.
> >> We're not sure whether this WARNING is as expected and reasonable
> >> or a BUG because there's no such WARNING before this patch.
> >>
> >> Can someone explain about it?
> >   The warning happens because bdi disappeared from under filesystem (likely
> > it was even freed) but filesystem still has references to it. Previously,
> > we were just silenly using freed memory, now we warn about it because we
> > now clear the BDI_registered bit before freeing the bdi.
> >
> > So for now the best advice I can give you is: Don't remove device from
> > under mounted filesystem (even when the system is suspended). I may easily
> > crash your machine.
> 
> When you are dealing with removable devices, we can't protect us
> against such scenarios.
  Yes, I understand. I agree it's a kernel bug to not deal with the hot
remove properly. It's just not simple to fix.

> Moreover, during system suspend phase the mmc block device are not
> being removed (even if the physical mmc card gets removed). Instead
> that will be handled first when a PM_POST_SUSPEND|HIBERNATION|RESTORE
> notifier is received by the mmc subsystem.
  Yeah, but for the filesystem on top it doesn't really matter. Filesystems
simply don't expect underlying structures can disappear. Changing all
filesystems to deal with that would be too difficult so we have to make bdi
stay in memory as needed and just detach it from the device (request queue)
which goes away.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
