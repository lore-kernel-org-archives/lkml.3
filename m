Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3ENNzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:55:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab3ENNzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:55:43 -0400
Date: Tue, 14 May 2013 15:51:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
Message-ID: <20130514135101.GB17587@redhat.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com> <1368494338-7069-5-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368494338-7069-5-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Kent Overstreet wrote:
>
> +int percpu_ref_kill(struct percpu_ref *ref)
> +{
> +	unsigned __percpu *pcpu_count;
> +	unsigned __percpu *old;
> +	unsigned count = 0;
> +	int cpu;
> +
> +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> +
> +	do {
> +		if (!pcpu_count)
> +			return 0;
> +
> +		old = pcpu_count;
> +		pcpu_count = cmpxchg(&ref->pcpu_count, old, NULL);
> +	} while (pcpu_count != old);

This is purely cosmetic, feel free to ignore. But afaics all we
need is

	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
	if (!cmpxchg(&ref->pcpu_count, pcpu_count, NULL))
		return 0;

Oleg.

