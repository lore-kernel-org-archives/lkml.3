Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbaFLQYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:24:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:47003 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465AbaFLQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:24:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,466,1400050800"; 
   d="scan'208";a="546926345"
Date: Thu, 12 Jun 2014 10:24:31 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <axboe@fb.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
In-Reply-To: <5399BA00.7000705@bjorling.me>
Message-ID: <alpine.LRH.2.03.1406121015130.4699@AMR>
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR>
 <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com>
 <alpine.LRH.2.03.1406111641180.4699@AMR> <5399BA00.7000705@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-841927011-1402590279=:4699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-841927011-1402590279=:4699
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 12 Jun 2014, Matias Bjørling wrote:
> On 06/12/2014 12:51 AM, Keith Busch wrote:
>> So far so good: it passed the test that was previously failing. I'll
>> let the remaining xfstests run and see what happens.
>
> Great.
>
> The flushes was a fluke. I haven't been able to reproduce.

Cool, most of the tests are passing, except there is some really weird
stuff with the timeout handling. You've got two different places with the
same two prints, so I was a little confused where they were coming from.

I've got some more things to try to debug this, but this is thwat I have
so far:

It looks like the abort_complete callback is broken. First, the dev_warn
there makes no sense because you're pointing to the admin queue's abort
request, not the IO queue's request you're aborting. Then you call
cancel_cmd_info on the same command you're completing but it looks like
you're expecting to be doing this on the IO request you meant to abort,
but that could cause double completions.
--8323328-841927011-1402590279=:4699--
