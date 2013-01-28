Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3A1RBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:01:42 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55075 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3A1RBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:01:41 -0500
Message-ID: <5106AEE8.4060003@linux.vnet.ibm.com>
Date: Mon, 28 Jan 2013 11:01:28 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: zsmalloc: add gfp flags to zs_create_pool
References: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com> <1359135978-15119-2-git-send-email-sjenning@linux.vnet.ibm.com> <20130128033944.GB3321@blaptop>
In-Reply-To: <20130128033944.GB3321@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012817-3620-0000-0000-000001043194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 09:39 PM, Minchan Kim wrote:
> Hi Seth,
> 
> On Fri, Jan 25, 2013 at 11:46:15AM -0600, Seth Jennings wrote:
>> zs_create_pool() currently takes a gfp flags argument
>> that is used when growing the memory pool.  However
>> it is not used in allocating the metadata for the pool
>> itself.  That is currently hardcoded to GFP_KERNEL.
>>
>> zswap calls zs_create_pool() at swapon time which is done
>> in atomic context, resulting in a "might sleep" warning.
>>
>> This patch changes the meaning of the flags argument in
>> zs_create_pool() to mean the flags for the metadata allocation,
>> and adds a flags argument to zs_malloc that will be used for
>> memory pool growth if required.
> 
> As I mentioned, I'm not strongly against with this patch but it
> should be last resort in case of not being able to address
> frontswap's init routine's dependency with swap_lock.
> 
> I sent a patch and am waiting reply of Konrand or Dan.
> If we can fix frontswap, it would be better rather than
> changing zsmalloc.

I agree that moving the call to frontswap_init() out of the swap_lock
would be a good thing.  However, it doesn't mean that we still
shouldn't allow the users to control the gfp mask for the allocation
done by zs_create_pool(). While moving the frontswap_init() outside
the lock removes the _need_ for this patch, I think that is it good
API design to allow the user to specify the gfp mask.

Seth

