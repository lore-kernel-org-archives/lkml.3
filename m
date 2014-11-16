Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaKPTE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:04:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37611 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaKPTE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:04:27 -0500
Date: Sun, 16 Nov 2014 14:04:22 -0500 (EST)
Message-Id: <20141116.140422.570375628237589645.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, luto@amacapital.net, dborkman@redhat.com,
        hannes@stressinduktion.org, edumazet@google.com,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 6/7] bpf: allow eBPF programs to use maps
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415929010-9361-7-git-send-email-ast@plumgrid.com>
References: <1415929010-9361-1-git-send-email-ast@plumgrid.com>
	<1415929010-9361-7-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Nov 2014 11:04:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Thu, 13 Nov 2014 17:36:49 -0800

> +static u64 bpf_map_lookup_elem(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5)
> +{
> +	/* verifier checked that R1 contains a valid pointer to bpf_map
> +	 * and R2 points to a program stack and map->key_size bytes were
> +	 * initialized
> +	 */
> +	struct bpf_map *map = (struct bpf_map *) (unsigned long) r1;
> +	void *key = (void *) (unsigned long) r2;
> +	void *value;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +
> +	value = map->ops->map_lookup_elem(map, key);
> +
> +	/* lookup() returns either pointer to element value or NULL
> +	 * which is the meaning of PTR_TO_MAP_VALUE_OR_NULL type
> +	 */
> +	return (unsigned long) value;
> +}

You should translate this into a true boolean '1' or '0' value so that
kernel pointers don't propagate to the user or his eBPF programs.
