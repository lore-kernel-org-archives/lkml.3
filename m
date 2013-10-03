Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3JCNqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:46:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:49109 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab3JCNqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:46:07 -0400
Message-ID: <524D751D.90007@parallels.com>
Date: Thu, 3 Oct 2013 17:46:05 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <fuse-devel@lists.sourceforge.net>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] fuse: writepage: update bdi writeout when deleting
 secondary request
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru> <20131002173837.31188.34247.stgit@dhcp-10-30-17-2.sw.ru> <20131003102614.GC14242@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20131003102614.GC14242@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 02:26 PM, Miklos Szeredi wrote:
> On Wed, Oct 02, 2013 at 09:38:43PM +0400, Maxim Patlasov wrote:
>> BDI_WRITTEN counter is used to estimate bdi bandwidth. It must be incremented
>> every time as bdi ends page writeback. No matter whether it was fulfilled by
>> actual write or by discarding the request (e.g. due to shrunk i_size).
>>
>> Note that even before writepages patches, the case "Got truncated off
>> completely" was handled in fuse_send_writepage() by calling
>> fuse_writepage_finish() which updated BDI_WRITTEN unconditionally.
> Hmm, I'm not sure I can agree with this.  If BDI_WRITTEN is used for bandwidth
> estimation, then I think it's more correct not to count rewrites and truncated
> pages.

I thought about it before submitting the patch, but my understanding is 
a bit different. Look how balance_dirty_pages and friends juggle with 
BDI_WRITTEN and BDI_DIRTIED. That layer knows nothing about fuse and its 
internals. Imagine that right now (if actual backend throughput is about 
10MB/sec) you believe that dirtying 26 pages per 10 milliseconds is 
fine, but when they lapsed you discovers that BDI_DIRTIED delta is 26 
while BDI_WRITTEN delta is only 13. Logically, you must decide to cut 
dirty-rate by factor two, but the decision would be incorrect in case of 
unaccounted truncated rewrites.

>
> But I don't see this matter either way since this is just used as a heuristic
> and the occasional extra or lack of count shouldn't make a significant
> difference.

I agree, but for another reason. I think it won't make a significant 
difference because rewrites coinciding with writebacks coinciding with 
truncations will happen very rare in real life.

Thanks,
Maxim


>
> Thanks,
> Miklos
>
>> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
>> ---
>>   fs/fuse/file.c |    6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>> index a3c7123..5d323bd 100644
>> --- a/fs/fuse/file.c
>> +++ b/fs/fuse/file.c
>> @@ -1536,6 +1536,7 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
>>   			drop->inode->i_mapping->backing_dev_info;
>>   		dec_bdi_stat(bdi, BDI_WRITEBACK);
>>   		dec_zone_page_state(drop->pages[0], NR_WRITEBACK_TEMP);
>> +		bdi_writeout_inc(bdi);
>>   		fuse_writepage_free(fc, drop);
>>   		fuse_put_request(fc, drop);
>>   		drop = next;
>> @@ -1706,11 +1707,14 @@ static bool fuse_writepage_in_flight(struct fuse_req *new_req,
>>   
>>   	if (old_req->num_pages == 1 && (old_req->state == FUSE_REQ_INIT ||
>>   					old_req->state == FUSE_REQ_PENDING)) {
>> +		struct backing_dev_info *bdi = page->mapping->backing_dev_info;
>> +
>>   		copy_highpage(old_req->pages[0], page);
>>   		spin_unlock(&fc->lock);
>>   
>> -		dec_bdi_stat(page->mapping->backing_dev_info, BDI_WRITEBACK);
>> +		dec_bdi_stat(bdi, BDI_WRITEBACK);
>>   		dec_zone_page_state(page, NR_WRITEBACK_TEMP);
>> +		bdi_writeout_inc(bdi);
>>   		fuse_writepage_free(fc, new_req);
>>   		fuse_request_free(new_req);
>>   		goto out;
>>
>

