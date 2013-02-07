Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab3BGRgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:36:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab3BGRgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:36:09 -0500
Date: Thu, 7 Feb 2013 18:34:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
	dequeuing signals (v2)
Message-ID: <20130207173447.GA5888@redhat.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org> <1359486181-29088-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359486181-29088-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey, sorry for delay.

As for API, I leave this to you and Michael. Not that I like these
new flags, but I agree that pread() hack was not pretty too.

On 01/29, Andrey Vagin wrote:
> +static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
> +				siginfo_t *info, loff_t *ppos, int queue_mask)
> +{
> +	loff_t seq = *ppos / sizeof(struct signalfd_siginfo);
> +	int signr = 0;
> +
> +	if (queue_mask & SIGQUEUE_PRIVATE)
> +		signr = peek_signal(&current->pending,
> +					&ctx->sigmask, info, &seq);
> +	else if (queue_mask & SIGQUEUE_SHARED)
> +		signr = peek_signal(&current->signal->shared_pending,
> +					 &ctx->sigmask, info, &seq);
> +	(*ppos) += sizeof(struct signalfd_siginfo);

Now that this can work even with normal read(), we will actually change
f_pos. Then perhaps signalfd_fops->llseek() should work too. But this
is minor...

Hmm. but since it works with read(), we shouldn't increment *ppos unless
signalfd_copyinfo() succeeds?

Btw, why do you pass seq by reference? Looks unneeded.

Oleg.

