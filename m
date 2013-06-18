Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3FROO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:14:57 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:43550 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932868Ab3FROOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:14:54 -0400
Date: Tue, 18 Jun 2013 14:14:53 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Kent Overstreet <koverstreet@google.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org,
        axboe@kernel.dk, nab@linux-iscsi.org, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 4/4] idr: Percpu ida
In-Reply-To: <1371532754-14357-4-git-send-email-koverstreet@google.com>
Message-ID: <0000013f57a3643b-beb6be35-adb0-436e-837a-db93c19b445e-000000@email.amazonses.com>
References: <1371532754-14357-1-git-send-email-koverstreet@google.com> <1371532754-14357-4-git-send-email-koverstreet@google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.18-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013, Kent Overstreet wrote:

> +static inline unsigned alloc_local_tag(struct percpu_ida *pool,
> +				       struct percpu_ida_cpu *tags)
> +{
> +	int tag = -ENOSPC;
> +
> +	spin_lock(&tags->lock);
> +	if (tags->nr_free)
> +			tag = tags->freelist[--tags->nr_free];
> +	spin_unlock(&tags->lock);
> +
> +	return tag;
> +}

This could be made much faster by avoiding real atomics (coming with
spinlocks) and using per cpu atomics instead. Slub f.e. uses a single
linked per cpu list managed via this_cpu_cmpxchg.

In order to avoid locking completely the state of the percpu tag list must
fit into one word that can be handled via the local cmpxchg (or two with
the cmpxchg_double). May require some changes to the data structure.



