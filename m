Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaANNol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:44:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaANNok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:44:40 -0500
Message-ID: <52D53F11.3090005@redhat.com>
Date: Tue, 14 Jan 2014 14:43:45 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] zram: rework reported to end-user zram statistics
References: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com> <1389692260-4421-4-git-send-email-sergey.senozhatsky@gmail.com> <52D513BD.7000800@redhat.com> <20140114111012.GC2180@swordfish.minsk.epam.com>
In-Reply-To: <20140114111012.GC2180@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 12:10 PM, Sergey Senozhatsky wrote:
> On (01/14/14 11:38), Jerome Marchand wrote:
>> On 01/14/2014 10:37 AM, Sergey Senozhatsky wrote:
>>> 1) Introduce ZRAM_ATTR_RO macro to generate zram atomic64_t stats
>>> `show' functions and reduce code duplication.
>>>
>>> 2) Account and report back to user numbers of failed READ and WRITE
>>> operations.
>>>
>>> 3) Remove `good' and `bad' compressed sub-requests stats. RW request may
>>> cause a number of RW sub-requests. zram used to account `good' compressed
>>> sub-queries (with compressed size less than 50% of original size), `bad'
>>> compressed sub-queries (with compressed size greater that 75% of original
>>> size), leaving sub-requests with compression size between 50% and 75% of
>>> original size not accounted and not reported.
>>
>> That's weird: good/bad_compress are accounted, but it seems to me that
>> they are to never used in any way. If so, there is indeed no reason to
>> keep them.
>>
>>
>>> Account each sub-request
>>> compression size so we can calculate real device compression ratio.
>>
>> Your patch doesn't change the way pages_stored and compr[essed]_size
>> are accounted. What does your patch change that allow us to calculate
>> the "real" compression ratio?
>>
>>>
>>> 4) reported zram stats:
>>>   - num_writes  -- number of writes
>>>   - num_reads  -- number of reads
>>>   - pages_stored -- number of pages currently stored
>>>   - compressed_size -- compressed size of pages stored
>>
>> Wouldn't it be more practical to report the original and compressed
>> data sizes using the same units as it is currently done?
>>
> 
> hm, do we really need pages_stored stats? what kind of unseful information it
> shows to end user?.. perhaps, it's better to replace it with accounted passed
> bvec->bv_len (as uncompressed_size).
> 

That's really going to complicates things. We would need to keep track
of which sectors of a particular page has been written to. It's much
easier to keep current page granularity and consider any partial I/O
as an whole page I/O.

> 	-ss
> 
>> Jerome
>>
>>>   - pages_zero  -- number of zero filled pages
>>>   - failed_read -- number of failed reads
>>>   - failed_writes -- can happen when memory is too low
>>>   - invalid_io   -- non-page-aligned I/O requests
>>>   - notify_free  -- number of swap slot free notifications
>>>   - memory_used -- zs pool zs_get_total_size_bytes()
>>>
>>> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>


