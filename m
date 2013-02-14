Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3BNHH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:07:56 -0500
Received: from fn.samba.org ([216.83.154.106]:54675 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab3BNHHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:07:54 -0500
Message-ID: <1360825669.1727.337.camel@jesse>
Subject: Re: Read support for fat_fallocate()? (was [v2] fat: editions to
 support fat_fallocate())
From: Andrew Bartlett <abartlet@samba.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Thu, 14 Feb 2013 18:07:49 +1100
In-Reply-To: <CAKYAXd9qmDYivsJduT3bFD2vPOc0DQ0f8RQTxQ7MXXTCQMMQQA@mail.gmail.com>
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	 <1360810114.1727.306.camel@jesse>
	 <CAKYAXd9qmDYivsJduT3bFD2vPOc0DQ0f8RQTxQ7MXXTCQMMQQA@mail.gmail.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 15:44 +0900, Namjae Jeon wrote:
> 2013/2/14, Andrew Bartlett <abartlet@samba.org>:
> > (apologies for the duplicate mail, I typo-ed the maintainers address)
> >
> > G'day,
> >
> > I've been looking into the patch "[v2] fat: editions to support
> > fat_fallocate()" and I wonder if there is a way we can split this issue
> > in two, so that we get at least some of the patch into the kernel.
> >
> > https://lkml.org/lkml/2012/10/13/75
> > https://patchwork.kernel.org/patch/1589161/
> >
> > What I'm wanting to discuss (and perhaps implement, with you if
> > possible) is splitting this patch into writing to existing pre-allocated
> > files, and creating a new pre-allocation.
> >
> > If Windows does, as you claim, simply read preallocations as zero, and
> > writes to them normally and without error, then Linux should do the
> > same.  Here of course I'm assuming that Windows is not preallocating,
> > but instead simply trying to recover gracefully and safely from a simple
> > 'file system corruption', where the sectors are allocated but not used.
> >
> > The bulk of this patch is implementing this transparent recovery, and it
> > seem relatively harmless to include this into the kernel.
> >
> > Then vendors doing TV streaming, or in my case copies of large files
> > onto Samba-mounted USB FAT devices, can add only the smaller patch to
> > implement fallocate, at their own risk and fully knowing that it will be
> > regarded as corrupt on Linux.
> >
> > If accepted read support will, over a period of years, trickle down to
> > other Linux users, broadening the base that can still read these
> > 'corrupt' drives, no matter the cause.
> >
> > I hope you agree that this is a practical way forward, and I look
> > forward to working with you on this.
> >
> > Thanks,
> Hi Andrew.
> 
> First, Thanks for your interest !
> A mismatch between inode size and reserved blocks can be either due to
> pre-allocation (after our changes) or due to corruption (sudden unplug
> of media etc).
> We don’t think it is right to include only read only support (i.e.
> without fallocate support) for such files because if such files are
> encountered it only means that the file is corrupted, as there is no
> current method to check if the issue is due to pre-allocation.
> If it is to be included in the kernel, then the whole patch has to go
> in. 

I don't see why that is the case. 

> But then again, since the FAT specifications do not accommodate
> for pre-allocation, then it is up to OGAWA to decide if this is
> acceptable.
> In any case, the patch will definitely break backward compatibility
> (on an older fat driver without fallocate support) and also in case
> for the two variants for the same kernel versions and only one has
> FALLOCATE enabled, in such cases also, the behavior will assume
> corruption in one case.

I agree that the sudden unplug is a concern, but why not make the
filesystem more robust against that inevitable occurrence?  If the
blocks appear to be allocated to the file, why not use them?

That is, while it is hard to predict the many different ways a
filesystem can be corrupted, what would go wrong if we did use these
clusters?  Do you fear that they might also be allocated to someone
else? 

That would, if I understand correctly just mean that that more broken,
not quite valid USB thumb drives and other FAT filesystems work equally
well on Windows and Linux, without administrative privileges.  (Given
that running fsck requires root, and isn't trivially available to normal
users in Linux, and I presume is similarly privileged in windows). 

What I'm doing is suggesting re-purposing your patch, from preallocation
to robustness.  In this light, do you think this worth pushing forward?

We can later address if there is any safe way to preallocate files on
FAT as a different question, hoping that this means it will 'just work'
on a broader range of other Linux hosts, just as it is claimed to 'just
work' on Windows.

Thanks,

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org


