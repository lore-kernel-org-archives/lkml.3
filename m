Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaKXFfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 00:35:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaKXFfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 00:35:12 -0500
Message-ID: <5472C366.8020905@redhat.com>
Date: Mon, 24 Nov 2014 13:34:30 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@infradead.org
Subject: Re: [PATCH 07/17] new helpers: skb_copy_datagram_from_iter() and
 zerocopy_sg_from_iter()
References: <20141119.165340.2162829993279387495.davem@davemloft.net>	 <20141120214753.GR7996@ZenIV.linux.org.uk>	 <20141120.182339.972861702759954603.davem@davemloft.net>	 <20141121.122615.1091044030302005883.davem@davemloft.net>	 <20141122042856.GZ7996@ZenIV.linux.org.uk>	 <20141122043320.GG30478@ZenIV.linux.org.uk> <1416787365.7215.63.camel@decadent.org.uk>
In-Reply-To: <1416787365.7215.63.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 08:02 AM, Ben Hutchings wrote:
> On Sat, 2014-11-22 at 04:33 +0000, Al Viro wrote:
> [...]
>> --- a/net/core/datagram.c
>> +++ b/net/core/datagram.c
>> @@ -572,6 +572,77 @@ fault:
>>  }
>>  EXPORT_SYMBOL(skb_copy_datagram_from_iovec);
>>  
> Missing kernel-doc.
>
>> +int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
>> +				 struct iov_iter *from,
>> +				 int len)
>> +{
>> +	int start = skb_headlen(skb);
>> +	int i, copy = start - offset;
>> +	struct sk_buff *frag_iter;
>> +
>> +	/* Copy header. */
>> +	if (copy > 0) {
>> +		if (copy > len)
>> +			copy = len;
>> +		if (copy_from_iter(skb->data + offset, copy, from) != copy)
>> +			goto fault;
>> +		if ((len -= copy) == 0)
>> +			return 0;
>> +		offset += copy;
>> +	}
>> +
>> +	/* Copy paged appendix. Hmm... why does this look so complicated? */
>> +	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
>> +		int end;
>> +		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
>> +
>> +		WARN_ON(start > offset + len);
>> +
>> +		end = start + skb_frag_size(frag);
>> +		if ((copy = end - offset) > 0) {
>> +			size_t copied;
> Blank line needed after a declaration.
>
>> +			if (copy > len)
>> +				copy = len;
>> +			copied = copy_page_from_iter(skb_frag_page(frag),
>> +					  frag->page_offset + offset - start,
>> +					  copy, from);
>> +			if (copied != copy)
>> +				goto fault;
>> +
>> +			if (!(len -= copy))
>> +				return 0;
> The other two instances of this condition are written as:
>
> 			if ((len -= copy) == 0)
>
> Similarly in skb_copy_bits().
>
>> +			offset += copy;
>> +		}
>> +		start = end;
>> +	}
>> +
>> +	skb_walk_frags(skb, frag_iter) {
>> +		int end;
>> +
>> +		WARN_ON(start > offset + len);
>> +
>> +		end = start + frag_iter->len;
>> +		if ((copy = end - offset) > 0) {
>> +			if (copy > len)
>> +				copy = len;
>> +			if (skb_copy_datagram_from_iter(frag_iter,
>> +							offset - start,
>> +							from, copy))
>> +				goto fault;
>> +			if ((len -= copy) == 0)
>> +				return 0;
>> +			offset += copy;
>> +		}
>> +		start = end;
>> +	}
>> +	if (!len)
>> +		return 0;
>> +
>> +fault:
>> +	return -EFAULT;
>> +}
>> +EXPORT_SYMBOL(skb_copy_datagram_from_iter);
>> +
>>  /**
>>   *	zerocopy_sg_from_iovec - Build a zerocopy datagram from an iovec
>>   *	@skb: buffer to copy
>> @@ -643,6 +714,50 @@ int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
>>  }
>>  EXPORT_SYMBOL(zerocopy_sg_from_iovec);
>>  
> Missing kernel-doc.
>
>> +int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
>> +{
>> +	int len = iov_iter_count(from);
>> +	int copy = min_t(int, skb_headlen(skb), len);
>> +	int i = 0;
>> +
>> +	/* copy up to skb headlen */
>> +	if (skb_copy_datagram_from_iter(skb, 0, from, copy))
>> +		return -EFAULT;
>> +
>> +	while (iov_iter_count(from)) {
>> +		struct page *pages[MAX_SKB_FRAGS];
>> +		size_t start;
>> +		ssize_t copied;
>> +		unsigned long truesize;
>> +		int n = 0;
>> +
>> +		copied = iov_iter_get_pages(from, pages, ~0U, MAX_SKB_FRAGS, &start);
>> +		if (copied < 0)
>> +			return -EFAULT;
>> +
>> +		truesize = DIV_ROUND_UP(copied + start, PAGE_SIZE) * PAGE_SIZE;
> PAGE_ALIGN(copied + start) ?
>
>> +		skb->data_len += copied;
>> +		skb->len += copied;
>> +		skb->truesize += truesize;
>> +		atomic_add(truesize, &skb->sk->sk_wmem_alloc);
>> +		while (copied) {
>> +			int off = start;
> This variable seems redundant.  Can't we use start directly and move the
> 'start = 0' to the bottom of the loop?
>
>> +			int size = min_t(int, copied, PAGE_SIZE - off);
>> +			start = 0;
>> +			if (i < MAX_SKB_FRAGS)
>> +				skb_fill_page_desc(skb, i, pages[n], off, size);
>> +			else
>> +				put_page(pages[n]);
> Why is this condition needed, given we told iov_iter_get_pages() to
> limit to MAX_SKB_FRAGS pages?

We don't want to send truncated packets and there's no other way to put
those pages since it was not in the frag array.
