Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab3EYKY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 06:24:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:18005 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab3EYKY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 06:24:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,740,1363158000"; 
   d="scan'208";a="342990157"
Date: Sat, 25 May 2013 18:25:44 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: lkp@linux.intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86, mm: fix boot hang regression
Message-ID: <20130525102544.GP2663@yliu-dev.sh.intel.com>
References: <1369456201-24910-1-git-send-email-yuanhan.liu@linux.intel.com>
 <CAE9FiQVZyizrB4=FV56hjeb_-vX_YWJ=Ur54ptTEeFpaekv16Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVZyizrB4=FV56hjeb_-vX_YWJ=Ur54ptTEeFpaekv16Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 12:31:43AM -0700, Yinghai Lu wrote:
> On Fri, May 24, 2013 at 9:30 PM, Yuanhan Liu
> <yuanhan.liu@linux.intel.com> wrote:
> > Commit 8d57470d introduced a kernel panic while setting mem=2G at
> > boot time, and commit c9b3234a6 turns the the kernel panic to hang.
> >
> > While, the reason is the same: the are accessing a BAD address; I mean
> > the mapping is broken.
> >
> > Here is a mem mapping range dumped at boot time:
> >     [mem 0x00000000-0x000fffff] page 4k  (0)
> >     [mem 0x7fe00000-0x7fffffff] page 1G  (1)
> >     [mem 0x7c000000-0x7fdfffff] page 1G  (2)
> >     [mem 0x00100000-0x001fffff] page 4k  (3)
> >     [mem 0x00200000-0x7bffffff] page 2M  (4)
> >
> ...
> > I reported this panic regression long time ago, and I didn't notic the above
> > panic->hang change before, which might confuse Yinghai for understanding
> > what happened from 2 logs I sent before(one is from 8d57470d, another is
> > from the HEAD commit at that time, which turn to a hang as stated).
> > More, it seems that Yinghai can't produce it. And I was busying at
> > something else. And I finally got a day yesterday(and a good mood ;).
> >
> > Last, Thanks Changlong's effort for bisecting the 2 above commit.
> > ---
> >  arch/x86/mm/init_64.c |   51 +++++++++++++++++++++++++++++++++++++++++-------
> >  1 files changed, 43 insertions(+), 8 deletions(-)
> 
> oh, I know the reason, my intel box has acpi or reserved area just below 2GiB.

Due to the 1GB page mapping support, it seems that this issue does not
exist on platform before Sandybridge.

> 
> your patch is not right fix.
> 
> Attached patch should fix the problem.

Firstly, your patch works and feel free to add:
	Tested-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>

While, your patch fixes this issue on source side. I thought that
before, too.  But I think it's better to fix it on root side.
That's why I sent a patch to try to fix it at mapping stage; Meanwhile,
I was trying to sent another patch to fix this issue on source
side later. And you did that.

On the other hand, since we support splitting PUD(and PMD), I guess we
should make it do the right work just in case will meet such case later.

So, I still think my patch does fix something and should be merged,
unless I did it wrongly. And please correct me if I'm wrong.

Thanks.

	--yliu
