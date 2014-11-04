Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaKDJ6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:58:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbaKDJ6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:58:45 -0500
Message-ID: <5458A349.5020401@redhat.com>
Date: Tue, 04 Nov 2014 10:58:33 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] bpf: add array type of eBPF maps
References: <1415069656-14138-1-git-send-email-ast@plumgrid.com> <1415069656-14138-4-git-send-email-ast@plumgrid.com>
In-Reply-To: <1415069656-14138-4-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 03:54 AM, Alexei Starovoitov wrote:
> add new map type BPF_MAP_TYPE_ARRAY and its implementation
>
> - optimized for fastest possible lookup()
>    . in the future verifier/JIT may recognize lookup() with constant key
>      and optimize it into constant pointer. Can optimize non-constant
>      key into direct pointer arithmetic as well, since pointers and
>      value_size are constant for the life of the eBPF program.
>      In other words array_map_lookup_elem() may be 'inlined' by verifier/JIT
>      while preserving concurrent access to this map from user space
>
> - two main use cases for array type:
>    . 'global' eBPF variables: array of 1 element with key=0 and value is a
>      collection of 'global' variables which programs can use to keep the state
>      between events
>    . aggregation of tracing events into fixed set of buckets
>
> - all array elements pre-allocated and zero initialized at init time
>
> - key as an index in array and can only be 4 byte
>
> - map_delete_elem() returns EINVAL, since elements cannot be deleted
>
> - map_update_elem() replaces elements in an non-atomic way
>    (for atomic updates hashtable type should be used instead)
>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>

...
> +/* Called from syscall or from eBPF program */
> +static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
> +				 u64 map_flags)
> +{
> +	struct bpf_array *array = container_of(map, struct bpf_array, map);
> +	u32 index = *(u32 *)key;
> +
> +	if (map_flags > BPF_MAP_UPDATE_ONLY)
> +		/* unknown flags */
> +		return -EINVAL;
> +
> +	if (map_flags == BPF_MAP_CREATE_ONLY)
> +		return -EINVAL;
> +
> +	if (index >= array->map.max_entries)
> +		/* all elements were pre-allocated, cannot insert a new one */
> +		return -E2BIG;
> +
> +	memcpy(array->value + array->elem_size * index, value, array->elem_size);

What would protect this from concurrent updates?

> +	return 0;
> +}
