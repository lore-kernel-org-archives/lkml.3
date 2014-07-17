Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaGQLAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:00:09 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:46658 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaGQLAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:00:06 -0400
Message-ID: <53C7ACB1.90806@gmail.com>
Date: Thu, 17 Jul 2014 14:00:01 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
        Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        pramod.gurav.etc@gmail.com, Jason Cooper <jason@lakedaemon.net>,
        Markus Mayer <markus.mayer@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: direct-io: squelch maybe-uninitialized warning in do_direct_IO()
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>		 <20140713115022.GA6054@infradead.org> <53C6B199.2070606@gmail.com>		 <20140716175803.GA3631@infradead.org> <1405536124.4357.17.camel@x41>	 <53C79949.7010201@gmail.com> <1405590510.4808.16.camel@x220>
In-Reply-To: <1405590510.4808.16.camel@x220>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 12:48 PM, Paul Bolle wrote:
> Boaz,
> 
> On Thu, 2014-07-17 at 12:37 +0300, Boaz Harrosh wrote:
>> From: Paul Bolle <pebolle@tiscali.nl>
>>
>> The following warnings:
>>
>>   fs/direct-io.c: In function ‘__blockdev_direct_IO’:
>>   fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>   fs/direct-io.c:913:16: note: ‘to’ was declared here
>>   fs/direct-io.c:1011:12: warning: ‘from’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>   fs/direct-io.c:913:10: note: ‘from’ was declared here
>>
>> are false positive because dio_get_page() either fails, or sets both
>> 'from' and 'to'.
>>
>> Maybe it's better to move initializing "to" and "from" out of
>> dio_get_page(). That _might_ make it easier for both the the reader and
>> the compiler to understand what's going on. Something like this:
>>
>> Christoph Hellwig said ...
>> The fix of moving the code defintively looks nicer, while I think
>> uninitialized_var is horrible wart that won't get anywhere near my code.
>>
>> Boaz Harrosh I agree with Christoph and Paul
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> This is simply not coorect!

Sorry you are absolutely right, I only saw this after "send", is why
I ping you to make sure.

I have reviewed it fully, your initial code is correct *and tested).
Here is a new V2 patch without your sign-off

Thanks
Boaz

> 
>> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
>> ---
>>  fs/direct-io.c | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/direct-io.c b/fs/direct-io.c
>> index 98040ba..2f024fc 100644
>> --- a/fs/direct-io.c
>> +++ b/fs/direct-io.c
>> @@ -198,9 +198,8 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
>>   * L1 cache.
>>   */
>>  static inline struct page *dio_get_page(struct dio *dio,
>> -		struct dio_submit *sdio, size_t *from, size_t *to)
>> +		struct dio_submit *sdio)
>>  {
>> -	int n;
>>  	if (dio_pages_present(sdio) == 0) {
>>  		int ret;
>>  
>> @@ -209,10 +208,7 @@ static inline struct page *dio_get_page(struct dio *dio,
>>  			return ERR_PTR(ret);
>>  		BUG_ON(dio_pages_present(sdio) == 0);
>>  	}
>> -	n = sdio->head++;
>> -	*from = n ? 0 : sdio->from;
>> -	*to = (n == sdio->tail - 1) ? sdio->to : PAGE_SIZE;
>> -	return dio->pages[n];
>> +	return dio->pages[sdio->head];
>>  }
>>  
>>  /**
>> @@ -911,11 +907,15 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
>>  	while (sdio->block_in_file < sdio->final_block_in_request) {
>>  		struct page *page;
>>  		size_t from, to;
>> -		page = dio_get_page(dio, sdio, &from, &to);
>> +
>> +		page = dio_get_page(dio, sdio);
>>  		if (IS_ERR(page)) {
>>  			ret = PTR_ERR(page);
>>  			goto out;
>>  		}
>> +		from = sdio->head ? 0 : sdio->from;
>> +		to = (sdio->head == sdio->tail - 1) ? sdio->to : PAGE_SIZE;
>> +		sdio->head++;
>>  
>>  		while (from < to) {
>>  			unsigned this_chunk_bytes;	/* # of bytes mapped */
> 
> 
> Paul Bolle
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

