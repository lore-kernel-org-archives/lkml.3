Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3KMChC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:37:02 -0500
Received: from caiajhbdcbef.dreamhost.com ([208.97.132.145]:56972 "EHLO
	homiemail-a22.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755492Ab3KMCgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:36:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=novalis.org; h=message-id:subject
	:from:to:cc:date:in-reply-to:references:content-type
	:mime-version:content-transfer-encoding; q=dns; s=novalis.org;
	 b=DKLInUopxWI+g31ZRC8IMy4PUWaPwe5J0o8StWwQRxgmr8GmSZf46IWqMEAWo
	Sbu9g9xZ+LonjCWRhc7L07SABDwMojOCUvApKUBYAwhenkJTCeMNwVtk1sKd46vQ
	abLuPOfBPEu5a4DQXQKBq9p9fdfPs+E0k+ZbLON+1JRJkI=
Message-ID: <1384310211.8994.161.camel@chiang>
Subject: Re: [PATCH] ext4: explain encoding of 34-bit a,c,mtime values
From: David Turner <novalis@novalis.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Mark Harris <mhlk@osj.us>,
        Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 21:36:51 -0500
In-Reply-To: <20131112230335.GA10269@birch.djwong.org>
References: <1383808590.23882.13.camel@chiang>
	 <20131107160341.GA3850@quack.suse.cz> <1383864864.23882.33.camel@chiang>
	 <20131107231445.GG2054@quack.suse.cz> <1383866807.23882.41.camel@chiang>
	 <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
	 <1383981551.8994.27.camel@chiang>
	 <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com>
	 <1384070214.8994.47.camel@chiang> <20131112003018.GA30281@thunk.org>
	 <20131112230335.GA10269@birch.djwong.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 15:03 -0800, Darrick J. Wong wrote:
> On Mon, Nov 11, 2013 at 07:30:18PM -0500, Theodore Ts'o wrote:
> > On Sun, Nov 10, 2013 at 02:56:54AM -0500, David Turner wrote:
> > > b. Use Andreas's encoding, which is incompatible with pre-1970 files
> > > written on 64-bit systems.
> > >
> > > I don't care about currently-existing post-2038 files, because I believe
> > > that nobody has a valid reason to have such files.  However, I do
> > > believe that pre-1970 files are probably important to someone.
> > > 
> > > Despite this, I prefer option (b), because I think the simplicity is
> > > valuable, and because I hate to give up date ranges (even ones that I
> > > think we'll "never" need). Option (b) is not actually lossy, because we
> > > could correct pre-1970 files with e2fsck; under Andreas's encoding,
> > > their dates would be in the far future (and thus cannot be legitimate).
> > > 
> > > Would a patch that does (b) be accepted?  I would accompany it with a
> > > patch to e2fsck (which I assume would also go to the ext4 developers
> > > mailing list?).
> > 
> > I agree, I think this is the best way to go.  I'm going to drop your
> > earlier patch, and wait for an updated patch from you.  It may miss
> > this merge window, but as Andreas has pointed out, we still have a few
> > years to get this right.  :-)
> 
> Just to be clear... we're going with Andreas' fix, wherein
> 
> time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;
> 
> becomes:
> 
> time->tv_sec += (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;
> 
> "or" becomes "plus"?  So I can update fuse2fs.

Yes, but with a kernel-version-dependent change, which is something like
this:
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,20,0)
		time->tv_sec += (u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;
#else
		u64 extra_bits = le32_to_cpu(extra) & EXT4_EPOCH_MASK;
		if (extra_bits == 3)
			extra_bits = 0;
		time->tv_sec += extra_bits << 32;
#endif

> Also, can someone proofread [1] and make sure it's correct?

It's not quite right.  I've requested an account so that I can correct
it.

