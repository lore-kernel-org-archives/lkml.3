Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaCLKFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:05:18 -0400
Received: from smtp03.stone-is.org ([87.238.162.6]:35257 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaCLKFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:05:16 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53203156.4090902@acm.org>
Date: Wed, 12 Mar 2014 11:05:10 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_ida: Handle out-of-tags gracefully
References: <531DC851.5060400@acm.org> <20140311135137.GA22995@dhcp-26-207.brq.redhat.com> <531F518A.1070808@acm.org> <20140311204826.GA30105@dhcp-26-207.brq.redhat.com> <53200B2E.4060805@acm.org> <20140312084152.GA8838@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140312084152.GA8838@dhcp-26-207.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/14 09:41, Alexander Gordeev wrote:
> Still the hunk below (a) breaks the 'pool->percpu_max_size' threshold
> and (b) somehow suboptimal, because you wake another thread while a
> free tag was/is on this CPU. If it is still here we would better to
> grab it. If not, it was stolen by another thread and we do not need
> to wake one (not sure how could it be addressed, though).
> 
> In fact, did you try to remove this hunk at all? A following call to
> percpu_ida_free() both honors the threshold and wakes a thread, so
> your extra wake could be unnecessary.
> 
> @@ -189,6 +189,9 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
>  		spin_unlock(&pool->lock);
>  		local_irq_restore(flags);
>  
> +		if (tags->nr_free)
> +			wake_up(&pool->wait);
> +
>  		if (tag >= 0 || state == TASK_RUNNING)
>  			break;
>  
> 

Hello Alexander,

You are right, that hunk is not necessary and can be left out. That code
was added while chasing another (unrelated) bug. I will resend this
patch without that hunk.

Bart.
