Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316Ab3BODto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 22:49:44 -0500
Received: from fn.samba.org ([216.83.154.106]:54287 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701Ab3BODtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 22:49:43 -0500
Message-ID: <1360900178.1727.393.camel@jesse>
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
Date: Fri, 15 Feb 2013 14:49:38 +1100
In-Reply-To: <CAKYAXd9tVzvP_Oa+BoUwKbpaMoVZKZgesDgrLirqoyk6AHrJ2A@mail.gmail.com>
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	 <1360810114.1727.306.camel@jesse>
	 <CAKYAXd9qmDYivsJduT3bFD2vPOc0DQ0f8RQTxQ7MXXTCQMMQQA@mail.gmail.com>
	 <1360825669.1727.337.camel@jesse>
	 <CAKYAXd9tVzvP_Oa+BoUwKbpaMoVZKZgesDgrLirqoyk6AHrJ2A@mail.gmail.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 18:52 +0900, Namjae Jeon wrote:
> [snip]
> >> >
> >> > Thanks,
> >> Hi Andrew.
> >>
> >> First, Thanks for your interest !
> >> A mismatch between inode size and reserved blocks can be either due to
> >> pre-allocation (after our changes) or due to corruption (sudden unplug
> >> of media etc).
> >> We don’t think it is right to include only read only support (i.e.
> >> without fallocate support) for such files because if such files are
> >> encountered it only means that the file is corrupted, as there is no
> >> current method to check if the issue is due to pre-allocation.
> >> If it is to be included in the kernel, then the whole patch has to go
> >> in.
> >
> > I don't see why that is the case.
> If we consider that there is no FALLOCATE support, then the condition
> of file size and blocks not matching can be only possible in case of
> corruption, right?

Sure.  I was just suggesting we transparently recover from that, by
using the blocks.  Think of it more as an online fsck not about
fallocate. 

Anyway, if you don't think it's reasonable to use those blocks, or to
'just fix it', then we just have to continue to do as we currently do.
That is on first sign of FS corruption just stop doing writes, and await
an FSCK.  

> >> But then again, since the FAT specifications do not accommodate
> >> for pre-allocation, then it is up to OGAWA to decide if this is
> >> acceptable.
> >> In any case, the patch will definitely break backward compatibility
> >> (on an older fat driver without fallocate support) and also in case
> >> for the two variants for the same kernel versions and only one has
> >> FALLOCATE enabled, in such cases also, the behavior will assume
> >> corruption in one case.
> >
> > I agree that the sudden unplug is a concern, but why not make the
> > filesystem more robust against that inevitable occurrence?  If the
> > blocks appear to be allocated to the file, why not use them?
> We also agree that there should be pre-allocation feature on FAT, and
> we had shared the scenarios where this could be required for a TV/
> recorder.
> But there are certain drawbacks which were raised by OGAWA with
> respect to compatibility and we also tend to agree on them.
> There could possibly be an issue where we are unable to distinguish
> between pre-allocation and corruption. Perhaps we could set a status
> bit on the file to indicate whether the file has pre-allocated blocks.
> This will make it clear whether the allocation is genuine through the
> FAT Fallocate request or is a result of corruption. Depending on the
> status of the flag - the decision can be made regard to reading
> blocks.
> But, the main issue in this will be storing this bit in on-disk
> directory entry for that file. From the feature and usability point of
> view, we should have fallocate on FAT too.
> 
> But it needs initial ACK from OGAWA to continue to work on this so
> that we can figure out the proper solution to move forward.

OK.  Given the need to find other approaches, I wanted to suggest some
ideas - some of which you may have already considered:

What about having a shadow FAT in a file, say called 'allocated space',
that would contain inode -> cluster list pairs, and where that file
would itself contain the free space the 'belongs' to other files?

As new clusters become needed in a file, they would simply be removed
from the 'allocated space' file, and assigned to the file they really
belong to.  That way, another OS just sees a large file, nothing more. 

Or, if we cannot make any changes to the on-disk format, what about
keeping such a database in memory, allocating some of the existing free
list to files that have had fallocate() called on them?  (Naturally,
this makes it non-persistent, and instead more of a 'hint', but could at
least solve our mutual performance issues). 

Or, could we leave allocated but unused clusters in the free cluster
list, but maintain a file with a hint that a particular file should use
a particular free cluster next, if available?  That list of 'allocated
free' clusters could be honoured by fallocate-aware OSs to reduce df and
increase du, but be ignored by other OSs, ensuring you could not run out
of space expanding a file in another OS.  

If a cluster was observed no longer to be in the real free list, it
would be ignored in the 'allocated free' list, to avoid corruption. 

In short, I see the restriction on not breaking existing implementations
as a difficult, but certainty not impossible problem. 

Thanks,

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org


