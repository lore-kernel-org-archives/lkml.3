Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaLEU6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:58:11 -0500
Received: from imap.thunk.org ([74.207.234.97]:42276 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaLEU6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:58:09 -0500
Date: Fri, 5 Dec 2014 15:58:00 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [Bisected] linux-next 20141205 fails to mount ext4 fs on arm64
 with CONFIG_ARM64_64K_PAGES=y
Message-ID: <20141205205800.GA10309@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Liviu Dudau <Liviu.Dudau@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Will Deacon <will.deacon@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
References: <20141205183057.GO821@e106497-lin.cambridge.arm.com>
 <87oari6i77.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oari6i77.fsf@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:54:20PM +0400, Dmitry Monakhov wrote:
> Liviu Dudau <Liviu.Dudau@arm.com> writes:
> 
> Yes. This is my crap.
> - sbi->s_group_desc[group_desc]
> + gd_bh = *rcu_dereference(sbi->s_group_desc) + group_desc;
> 
> Ted I have to admit that I'm an idiot.
> I already have fix where I've fixed the typo and complain from sparse
> which was reported by kbuild01. In order to prevent similar shame in future I've wrote several
> tests for resize2fs and unfortunately they are failed even w/o my
> patches. It is appeared that resize2fs is broken for big disks.
> So feel free to drop the patch, and give me some tome to investigate the
> issues. I'll back with the patch-set in 24hrs.

I had fixed the typo locally, but I'll drop this for now pending your
further investigations.  BTW, I think the reason why we didn't notice
is because for smaller disks, it just worked out that

	*rcu_dereference(sbi->s_group_desc) + group_desc == 
	*(rcu_dereference(sbi->s_group_desc) + group_desc)

by pure luck based on how the allocator works, since all of the group
descriptor bh's get allocated back to back.

Let me know about your resize2fs failures on big disks; I had found
fixed a large number of problems with online and offline resizes with
huge disks, so I had done quite a bit of testing in that area.  I
thought I had caught all of them, but if there are some additional
e2fsprogs or online resize bugs in the kernel bugs, I'd really like to
know.   Thanks!!

						- Ted
