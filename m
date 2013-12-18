Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3LRE3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 23:29:41 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56787 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3LRE3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 23:29:40 -0500
X-AuditID: 9c930179-b7d01ae000005b41-1e-52b124b2a2df
Subject: Re : Re: [PATCH] Squashfs: add asynchronous read support
References: <1387171826-20110-1-git-send-email-chanho.min@lge.com>
In-Reply-To: <1387171826-20110-1-git-send-email-chanho.min@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
MIME-Version: 1.0
Reply-To: "Chanho Min" <chanho.min@lge.com>
X-Priority: 3 (Normal)
Auto-Submitted: auto-generated
From: "Chanho Min" <chanho.min@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        =?EUC-KR?B?wNPIv8HY?= <hyojun.im@lge.com>,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Message-ID: <OF0A0B2022.F34682B9-ON49257C45.0018AF5F-49257C45.0018AF60@lge.com>
Date: Wed, 18 Dec 2013 13:29:37 +0900
X-MIMETrack: Serialize by Router on LGEKRHQMS17A/LGE/LG Group(Release 8.5.3FP3HF583 | August
 9, 2013) at 2013/12/18 13:29:37
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I did test it on x86 with USB stick and ARM with eMMC on my Nexus 4.
> In experiment, I couldn't see much gain like you both system and even it
> was regressed at bs=32k test, maybe workqueue allocation/schedule of work
> per I/O.
> Your test is rather special or what I am missing?
Can you specify your test result on ARM with eMMC.

> Before that, I'd like to know fundamental reason why your implementation
> for asynchronous read enhance. At a first glance, I thought it's caused by
> readahead from MM layer but when I read code, I found I was wrong.
> MM's readahead logic works based on PageReadahead marker but squashfs
> invalidates by grab_cache_page_nowait so it wouldn't work as we expected.
>
> Another possibility is block I/O merging in block layder by plugging logic,
> which was what I tried a few month ago although implementation was really
> bad. But it wouldn't work with your patch because do_generic_file_read
> will unplug block layer by lock_page without merging enough I/O.
>
> So, what do you think real actuator for enhance your experiment?
> Then, I could investigate why I can't get a benefit.
Currently, squashfs adds request to the block device queue synchronously with
wait for competion. mmc takes this request one by one and push them to host driver,
But it allows mmc to be idle frequently. This patch allows to add block requset
asynchrously without wait for competion, mmcqd can fetch a lot of request from block
at a time. As a result, mmcqd get busy and use a more bandwidth of mmc.
For test, I added two count variables in mmc_queue_thread as bellows
and tested same dd transfer.

static int mmc_queue_thread(void *d)
{
..
	do {
		if (req || mq->mqrq_prev->req) {
			fetch++;
		} else {
			idle++;
		}
	} while (1);
..
}

without patch:
 fetch: 920, idle: 460

with patch
 fetch: 918, idle: 40

Thanks
Chanho.

