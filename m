Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3EQTGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:06:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43155 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3EQTGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:06:17 -0400
Message-ID: <51967F8E.2070400@oracle.com>
Date: Fri, 17 May 2013 15:05:50 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: koverstreet@google.com, akpm@linux-foundation.org, tytso@mit.edu,
        viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: aio: use correct integer overflow checks when creation
 aio ctx
References: <1368815034-844-1-git-send-email-sasha.levin@oracle.com> <20130517185317.GM1008@kvack.org>
In-Reply-To: <20130517185317.GM1008@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 02:53 PM, Benjamin LaHaise wrote:
> On Fri, May 17, 2013 at 02:23:54PM -0400, Sasha Levin wrote:
>> Commit "aio: percpu reqs_available" added some math to the nr_requests
>> calculation, but didn't correct the overflow calculations to handle that.
>>
>> This means that this:
>>
>> 	#include <linux/aio_abi.h>
>> 	void main(void)
>> 	{
>> 	        aio_context_t ctx_idp;
>> 	        io_setup(0x80000001, &ctx_idp);
>> 	}
>>
>> Would trigger the newly added BUG() couple of lines after the overflow
>> checks.
> 
> This BUG() isn't in Linus' tree, and probably should be removed before 
> it gets there.

It's not, it's in -next though.

>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> ---
>>  fs/aio.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 5b7ed78..0ae450a 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -411,7 +411,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
>>  
>>  	/* Prevent overflows */
>>  	if ((nr_events > (0x10000000U / sizeof(struct io_event))) ||
>> -	    (nr_events > (0x10000000U / sizeof(struct kiocb)))) {
>> +	    (nr_events > (0x10000000U / sizeof(struct kiocb))) ||
>> +	    (nr_events < num_possible_cpus() * 4)) {
>>  		pr_debug("ENOMEM: nr_events too high\n");
>>  		return ERR_PTR(-EINVAL);
> 
> This is completely wrong.  Enforcing a minimum needs to be done in a way 
> that doesn't fail for existing users that potentially use a minimum 
> smaller than what is newly required.  That is: an existing userland program 
> that only requests 16 events must not fail because of changes to the kernel 
> that increase the minimum number of requests.  So I have to NACK this patch 
> as it stands.

You didn't look around the context of the patch.

Couple of lines before that check, this happens:

        nr_events = max(nr_events, num_possible_cpus() * 4);
        nr_events *= 2;

The check I've added would only make sense if nr_events wrapped around, not if
nr_events was originally smaller than (num_possible_cpus() * 4).


Thanks,
Sasha

