Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaHOKJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 06:09:55 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46957 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaHOKJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 06:09:54 -0400
Message-ID: <53EDDC6B.40007@bjorling.me>
Date: Fri, 15 Aug 2014 12:09:47 +0200
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v11] NVMe: Convert to blk-mq
References: <1406365643-27020-1-git-send-email-m@bjorling.me> <1406365643-27020-2-git-send-email-m@bjorling.me> <CAOu_J6mW-2e2Jgm+khodLPah_-RZrD599SmSH+Mszd0AjterrQ@mail.gmail.com> <alpine.LRH.2.03.1408131519590.14603@AMR> <53EC7273.5060303@bjorling.me> <53ECD125.3080701@fb.com> <alpine.LRH.2.03.1408141651300.14603@AMR>
In-Reply-To: <alpine.LRH.2.03.1408141651300.14603@AMR>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 01:09 AM, Keith Busch wrote:
>
> The allocation and freeing of blk-mq parts seems a bit asymmetrical
> to me. The 'tags' belong to the tagset, but any request_queue using
> that tagset may free the tags. I looked to separate the tag allocation
> concerns, but that's more time than I have, so this is my quick-fix
> driver patch, forcing tag access through the hw_ctx.
>

I moved nvmeq->hctx->tags into nvmeq->tags in the last version. I missed 
the free's in blk_mq_map_swqueue. Good catch.

The previous method might have another problem. If there's two 
namespaces, sharing tag set. The hctx_init fn could be called with 
different hctx for an nvmeq, leading to false tag sharing between nvme 
queues.

