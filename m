Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3JBPqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:46:44 -0400
Received: from relay.parallels.com ([195.214.232.42]:53665 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab3JBPqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:46:42 -0400
Message-ID: <524C3FDF.5030201@parallels.com>
Date: Wed, 2 Oct 2013 19:46:39 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] fuse: writepages: crop secondary requests on send
 -v2
References: <20131002110112.26932.68729.stgit@dhcp-10-30-17-2.sw.ru> <20131002111354.27362.70435.stgit@dhcp-10-30-17-2.sw.ru> <CAJfpegvdeea0rPTEkNE6bRmYYPzxuJ2aAj0fZ80e53ic+K-jYg@mail.gmail.com>
In-Reply-To: <CAJfpegvdeea0rPTEkNE6bRmYYPzxuJ2aAj0fZ80e53ic+K-jYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 07:07 PM, Miklos Szeredi wrote:
> On Wed, Oct 2, 2013 at 1:17 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
>> If writeback happens while fuse is in FUSE_NOWRITE condition, the request
>> will be queued but not processed immediately (see fuse_flush_writepages()).
>> Until FUSE_NOWRITE becomes relaxed, more writebacks can happen. They will
>> be queued as "secondary" requests to that first ("primary") request.
>>
>> When FUSE_NOWRITE is relaxed and fuse_send_writepage() is called, it must
>> crop both primary and secondary requests according to the actual i_size.
>> Otherwise, if only primary is cropped, an extending write(2) may increase
>> i_size soon and then secondary requests won't be cropped properly. The result
>> would be stale data written to the server to a file offset where zeros must be.
>>
>> Changed in v2:
>>   - avoid NULL pointer dereference in fuse_drop_writepage().
>>
>> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
>> ---
>>   fs/fuse/file.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 55 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>> index 575e44f..89a2e76 100644
>> --- a/fs/fuse/file.c
>> +++ b/fs/fuse/file.c
>> @@ -1435,6 +1435,51 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
>>          wake_up(&fi->page_waitq);
>>   }
>>
>> +/* Drop list of secondary writepage requests */
>> +static void fuse_drop_writepage(struct fuse_conn *fc, struct fuse_req *req)
>> +{
>> +       struct backing_dev_info *bdi = req ?
>> +               req->inode->i_mapping->backing_dev_info : NULL;
>> +
>> +       while (req) {
>> +               struct fuse_req *next = req->misc.write.next;
>> +               dec_bdi_stat(bdi, BDI_WRITEBACK);
>> +               dec_zone_page_state(req->pages[0], NR_WRITEBACK_TEMP);
>> +               fuse_writepage_free(fc, req);
>> +               fuse_put_request(fc, req);
>> +               req = next;
>> +       }
>> +}
>> +
>> +/* Crop the misc.write.in.size of parent and secondary writepage requests */
>> +static bool fuse_crop_writepage(struct fuse_conn *fc, struct fuse_req *req,
>> +                               loff_t size, struct fuse_req **drop_list)
>> +{
>> +       if (req->misc.write.in.offset >= size)
>> +               return true;
>> +
>> +       while (req) {
>> +               struct fuse_req *next = req->misc.write.next;
>> +               struct fuse_write_in *inarg = &req->misc.write.in;
>> +               __u64 data_size = inarg->size ? :
>> +                       req->num_pages * PAGE_CACHE_SIZE;
>> +
>> +               if (inarg->offset + data_size <= size) {
>> +                       inarg->size = data_size;
>> +               } else if (inarg->offset < size) {
>> +                       inarg->size = size - inarg->offset;
>> +               } else {
>> +                       /* Got truncated off completely */
>> +                       req->misc.write.next = *drop_list;
>> +                       *drop_list = req;
> This corrupts the list (the req is not taken off the list before being
> added to another).  It could be fixed, but why not check this instead
> in fuse_writepage_end() before queuing the next request?

Nice idea. This will make next patch ("crop on attach") redundant. I'll 
resend updated patch-set.

Thanks,
Maxim
