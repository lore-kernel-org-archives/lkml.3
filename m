Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3KMEhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 23:37:14 -0500
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:59774 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787Ab3KMEhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 23:37:06 -0500
X-AuditID: 12074424-b7fa56d000000be4-68-528301f22e60
Date: Tue, 12 Nov 2013 23:37:02 -0500
From: Greg Price <price@MIT.EDU>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/11] random: code cleanups
Message-ID: <20131113043702.GZ8043@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
 <20131112042444.GC30281@thunk.org>
 <20131112224009.GX8043@ringworld.MIT.EDU>
 <20131113033205.GA9214@thunk.org>
 <5282F9C1.3020007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5282F9C1.3020007@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsUixG6nrvuJsTnIoGUxp8W0jeIWu+csZrG4
	vGsOmwOzx5kFR9g9Pm+S8zjR8oU1gDmKyyYlNSezLLVI3y6BK+PSJMeCy9wVf1bfYWtg3MrZ
	xcjJISFgInHm+j9WCFtM4sK99WxdjFwcQgKzmSQOfO6AcjYySuy+84sRwvnFKPF++jGwFhYB
	VYk7/9YzgthsAgoSP+avYwaxRQRUJKb//MQEYjMLZEqsu9EBViMsYCCxa2cXC4jNK2Aq8fPp
	EVaIoUcYJW4cusgMkRCUODnzCQtEs5bEjX8vgQZxANnSEsv/cYCYnAKaEi377UEqRIFWTTm5
	jW0Co+AsJM2zkDTPQmhewMi8ilE2JbdKNzcxM6c4NVm3ODkxLy+1SNdcLzezRC81pXQTIziY
	XVR2MDYfUjrEKMDBqMTDaxHTFCTEmlhWXJl7iFGSg0lJlLflL1CILyk/pTIjsTgjvqg0J7X4
	EKMEB7OSCK/0O6Acb0piZVVqUT5MSpqDRUmc9xaHfZCQQHpiSWp2ampBahFMVoaDQ0mCVxUY
	tUKCRanpqRVpmTklCGkmDk6Q4TxAw3cwANXwFhck5hZnpkPkTzEqSonzWoM0C4AkMkrz4Hph
	yeYVozjQK8K8/0DaeYCJCq77FdBgJqDBFsUgVxeXJCKkpBoYZV+IGaYXhkpMs4wzjDyu2cZ3
	W5l3XYr9kRP39CY/NKuU/HzOwHVOzuKLufyP/5zeW3dcPS1HmVfj9TvfzG37uTeI39lb//kX
	FztLUMOjsPZiqX8/jC0d21cx978NeH9yq3KzXtaOpv7pzsumKHGfS8zunMPiWey2NE6cI4rT
	48JjNw61xdeVWIozEg21mIuKEwHycch/EQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:02:09PM -0800, H. Peter Anvin wrote:
> One thing, too, if we are talking about anything other than
> boot-time-only blocking: going from a nonblocking to a blocking
> condition means being able to accept a short read, and right now *many*
> users of /dev/urandom are not ready to accept a short read.

I'm thinking only of boot-time blocking.  The idea is that once
/dev/urandom is seeded with, say, 128 bits of min-entropy in the
absolute, information-theoretic sense, it can produce an infinite
supply (or something like 2^128 bits, which amounts to the same thing)
of bits that can't be distinguished from random, short of breaking or
brute-forcing the crypto.  So once it's seeded, it's good forever.

We don't even strictly need to keep adding more entropy once it's
seeded, but it's good because (a) hey, it's cheap, (b) entropy
estimation is hard, and maybe in some situations we're too optimistic
and think we're well seeded before we really are, (c) some
cryptographers like to imagine having a PRNG recover from an attacker
learning its internal state by using fresh entropy.  Other
cryptographers think (c) is a little silly because an attacker that
can do that can probably keep doing it, or take over the machine
entirely, but it's not inconceivable, and there's (a) and (b).  So we
keep adding entropy when we have it, but if we don't have new entropy
for a long time there's no need to start blocking again.

Cheers,
Greg
