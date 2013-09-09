Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3IINvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab3IINvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:51:36 -0400
Message-ID: <522DD25D.5030000@redhat.com>
Date: Mon, 09 Sep 2013 15:51:25 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: zram: remove init_done from zram struct
 (v2)
References: <20130906152120.GF2238@swordfish.minsk.epam.com> <20130909123448.GA19256@mwanda>
In-Reply-To: <20130909123448.GA19256@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 02:34 PM, Dan Carpenter wrote:
> On Fri, Sep 06, 2013 at 06:21:20PM +0300, Sergey Senozhatsky wrote:
>> @@ -558,14 +563,12 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>>  	flush_work(&zram->free_work);
>>  
>>  	down_write(&zram->init_lock);
>> -	if (!zram->init_done) {
>> +	if (!init_done(zram)) {
>>  		up_write(&zram->init_lock);
>>  		return;
>>  	}
>>  
>>  	meta = zram->meta;
>> -	zram->init_done = 0;
>> -
>>  	/* Free all pages that are still in this zram device */
>>  	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
>>  		unsigned long handle = meta->table[index].handle;
>> @@ -604,9 +607,7 @@ static void zram_init_device(struct zram *zram, struct zram_meta *meta)
>>  
>>  	/* zram devices sort of resembles non-rotational disks */
>>  	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
>> -
>>  	zram->meta = meta;
>> -	zram->init_done = 1;
>>  
>>  	pr_debug("Initialization done!\n");
>>  }
> 
> I am uncomfortable with the locking in zram_reset_device().  There
> should be a check for init_done() in zram_slot_free_notify() otherwise
> we could add more work at the same time we are calling flush_work().
> 
> It should be that as soon as we start to reset then we say init is not
> done, we stop loading more work, we any existing work and then clean up.
> (There are details involved that I haven't looked at, but the original
> code looks racy to me).

Good point! I wonder why flush_work() isn't protected by init_lock.
Minchan, any reason why you did it that way?

Jerome

> 
> regards,
> dan carpenter
> 
> 

