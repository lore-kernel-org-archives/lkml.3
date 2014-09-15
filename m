Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaIOPXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:23:08 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60832 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaIOPXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:23:06 -0400
Message-ID: <1410794580.7106.168.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 5/5] rhashtable: Per bucket locks & expansion/shrinking
 in work queue
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 08:23:00 -0700
In-Reply-To: <fe862eb8add076215918a0def9c3bd4fe8a104c7.1410782841.git.tgraf@suug.ch>
References: <cover.1410782841.git.tgraf@suug.ch>
	 <fe862eb8add076215918a0def9c3bd4fe8a104c7.1410782841.git.tgraf@suug.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 14:18 +0200, Thomas Graf wrote:

> +static int alloc_bucket_locks(struct rhashtable *ht, struct bucket_table *tbl)
> +{
> +	unsigned int i, size;
> +#if defined(CONFIG_PROVE_LOCKING)
> +	unsigned int nr_pcpus = 2;
> +#else
> +	unsigned int nr_pcpus = num_possible_cpus();
> +#endif
> +
> +	nr_pcpus = min_t(unsigned int, nr_pcpus, 32UL);
> +	size = nr_pcpus * ht->p.locks_mul;
> +

You need to roundup to next power of two.

> +	if (sizeof(spinlock_t) != 0) {
> +#ifdef CONFIG_NUMA
> +		if (size * sizeof(spinlock_t) > PAGE_SIZE)
> +			tbl->locks = vmalloc(size * sizeof(spinlock_t));
> +		else
> +#endif
> +		tbl->locks = kmalloc_array(size, sizeof(spinlock_t),
> +					   GFP_KERNEL);
> +		if (!tbl->locks)
> +			return -ENOMEM;
> +		for (i = 0; i < size; i++)
> +			spin_lock_init(&tbl->locks[i]);
> +	}
> +	tbl->locks_mask = size - 1;
> +
> +	return 0;
> +}


