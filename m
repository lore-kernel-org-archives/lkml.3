Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbbACJee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 04:34:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbbACJec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 04:34:32 -0500
Message-ID: <54A7B7A3.7060002@redhat.com>
Date: Sat, 03 Jan 2015 10:34:27 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Joe Mario <jmario@redhat.com>
Subject: Re: [PATCH akpm/next] lib: crc32: conditionally constify crc32 lookup
 table
References: <1420052608-30515-1-git-send-email-dborkman@redhat.com> <20150102153537.2251ca287e96446eaf229ae2@linux-foundation.org> <54A733FB.8010904@redhat.com> <20150102170828.3bb15c0a.akpm@linux-foundation.org>
In-Reply-To: <20150102170828.3bb15c0a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2015 02:08 AM, Andrew Morton wrote:
> On Sat, 03 Jan 2015 01:12:43 +0100 Daniel Borkmann <dborkman@redhat.com> wrote:
>
>>> Seems a lot of fuss.  Why are these tables cacheline aligned anyway?
>>> To avoid one cache miss (most of the time, presumably) in a 16k table.
>>> Pretty marginal benefit, I suspect.
>>
>> I guess, it actually came in with the slice-by-8 algorithm (e.g. used
>> in SCTP checksumming if no offloading is available) that was added back
>> then, that is, commit 324eb0f17d9dc ("crc32: add slice-by-8 algorithm
>> to existing code").
>
> non-responsive ;)  By far the simplest solution is to remove the
> cacheline alignment.

Alternatively, I'm thinking of const + ____cacheline_aligned (w/o the gcc
test case). In case some people run gcc versions that have the bug, it's
worst case just as good as const only, and in the majority of cases aligned
as expected.

> Are there other places where CC_HAVE_CONST_ALIGN can be used?  I'm seeing
>
> z:/usr/src/linux-3.19-rc2> grep -r cacheline_aligned . | grep const
> ./arch/x86/um/sys_call_table_32.c:const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
> ./arch/x86/um/sys_call_table_64.c:const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {

I'll investigate these two above and send a patch, thanks. They should
actually be using ____cacheline_aligned instead!

> ./include/net/netfilter/nf_tables.h:    const struct nft_set_ops        *ops ____cacheline_aligned;
> ./net/ethernet/eth.c:const struct header_ops eth_header_ops ____cacheline_aligned = {
