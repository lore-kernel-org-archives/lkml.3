Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3ANLKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:10:06 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:42451 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3ANLKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:10:03 -0500
MIME-Version: 1.0
In-Reply-To: <1358128249.23942.6.camel@kjgkr>
References: <1357969323-9396-1-git-send-email-linkinjeon@gmail.com>
	<1358128249.23942.6.camel@kjgkr>
Date: Mon, 14 Jan 2013 20:10:01 +0900
Message-ID: <CAKYAXd-f_rLJ5YdtsOX40XiGcNFivPTiXJ5kt03E-AOpuinMMQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] f2fs: add blk plugging support in f2fs
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/14, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-01-12 (토), 14:42 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> With f2fs having different writepages support for data, node and
>> metapages.
>> It will not be covered under the generic blk plug support.
>
> Could you show any improvement points with this patch?
>
> Currently, there is no reason to use blk plugging, since f2fs itself
> gathers bios and then submit one big bio.
>
> Thanks,
Hi Jaegeuk,

There is no performance difference after introducing the block
plugging in F2FS.
We introduced this to reduced block lock contention for f2fs also.

For every BIO request queuing part to the request queue: it needs to
acquire lock->
spin_lock_irq(q->queue_lock);

Even though the F2FS - already is handling the requests part very
well. But still we can make use of blk_plug to reduce the block lock
contention.

When we introduce block plugging to F2FS part - all the requests will
first be maintained on TASK basis and then pushed to the request
queue. So, we do not have contention for the “queue lock”.

If we consider the normal data write path: initial block plug is
already taken care by generic write_pages(for f2fs readpages block
plug is already taken care by default path of:
read_pages()->mpage_readpages())),
but we can optimize this write path also as we shared the in patch.
Similarly, we introduced block plug for the node_page and meta_pages.

Please share your opinion on this.

Thanks!
>
> --
> Jaegeuk Kim
> Samsung
>
