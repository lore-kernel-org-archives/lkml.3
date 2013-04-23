Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3DWMXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:23:42 -0400
Received: from relay.parallels.com ([195.214.232.42]:34410 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab3DWMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:23:41 -0400
Message-ID: <51767CD0.40507@parallels.com>
Date: Tue, 23 Apr 2013 16:21:36 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <bfoster@redhat.com>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH 2/6] fuse: add support of async IO
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru> <20121214152031.27155.82706.stgit@maximpc.sw.ru> <20130422163437.GA16238@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20130422163437.GA16238@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

04/22/2013 08:34 PM, Miklos Szeredi пишет:
> On Fri, Dec 14, 2012 at 07:20:41PM +0400, Maxim V. Patlasov wrote:
>> The patch implements a framework to process an IO request asynchronously. The
>> idea is to associate several fuse requests with a single kiocb by means of
>> fuse_io_priv structure. The structure plays the same role for FUSE as 'struct
>> dio' for direct-io.c.
>>
>> The framework is supposed to be used like this:
>>   - someone (who wants to process an IO asynchronously) allocates fuse_io_priv
>>     and initializes it setting 'async' field to non-zero value.
>>   - as soon as fuse request is filled, it can be submitted (in non-blocking way)
>>     by fuse_async_req_send()
>>   - when all submitted requests are ACKed by userspace, io->reqs drops to zero
>>     triggering aio_complete()
>>
>> In case of IO initiated by libaio, aio_complete() will finish processing the
>> same way as in case of dio_complete() calling aio_complete(). But the
>> framework may be also used for internal FUSE use when initial IO request
>> was synchronous (from user perspective), but it's beneficial to process it
>> asynchronously. Then the caller should wait on kiocb explicitly and
>> aio_complete() will wake the caller up.
>>
>> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
>> ---
>>   fs/fuse/file.c   |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/fuse/fuse_i.h |   17 ++++++++++
>>   2 files changed, 109 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>> index 6685cb0..8dd931f 100644
>> --- a/fs/fuse/file.c
>> +++ b/fs/fuse/file.c
>> @@ -503,6 +503,98 @@ static void fuse_release_user_pages(struct fuse_req *req, int write)
>>   	}
>>   }
>>   
>> +/**
>> + * In case of short read, the caller sets 'pos' to the position of
>> + * actual end of fuse request in IO request. Otherwise, if bytes_requested
>> + * == bytes_transferred or rw == WRITE, the caller sets 'pos' to -1.
>> + *
>> + * An example:
>> + * User requested DIO read of 64K. It was splitted into two 32K fuse requests,
>> + * both submitted asynchronously. The first of them was ACKed by userspace as
>> + * fully completed (req->out.args[0].size == 32K) resulting in pos == -1. The
>> + * second request was ACKed as short, e.g. only 1K was read, resulting in
>> + * pos == 33K.
>> + *
>> + * Thus, when all fuse requests are completed, the minimal non-negative 'pos'
>> + * will be equal to the length of the longest contiguous fragment of
>> + * transferred data starting from the beginning of IO request.
>> + */
>> +static void fuse_aio_complete(struct fuse_io_priv *io, int err, ssize_t pos)
>> +{
>> +	int left;
>> +
>> +	spin_lock(&io->lock);
>> +	if (err)
>> +		io->err = io->err ? : err;
>> +	else if (pos >= 0 && (io->bytes < 0 || pos < io->bytes))
>> +		io->bytes = pos;
>> +
>> +	left = --io->reqs;
>> +	spin_unlock(&io->lock);
>> +
>> +	if (!left) {
>> +		long res;
>> +
>> +		if (io->err)
>> +			res = io->err;
>> +		else if (io->bytes >= 0 && io->write)
>> +			res = -EIO;
>> +		else {
>> +			res = io->bytes < 0 ? io->size : io->bytes;
>> +
>> +			if (!is_sync_kiocb(io->iocb)) {
>> +				struct path *path = &io->iocb->ki_filp->f_path;
>> +				struct inode *inode = path->dentry->d_inode;
>> +				struct fuse_conn *fc = get_fuse_conn(inode);
>> +				struct fuse_inode *fi = get_fuse_inode(inode);
>> +
>> +				spin_lock(&fc->lock);
>> +				fi->attr_version = ++fc->attr_version;
>> +				spin_unlock(&fc->lock);
> Hmm, what is this?  Incrementing the attr version without setting any attributes
> doesn't make sense.

It makes sense at least for writes. __fuse_direct_write() always called 
fuse_write_update_size() and the latter always incremented attr_version, 
even if *ppos <= inode->i_size. I believed it was implemented in this 
way intentionally: if write succeeded, the file is changed on server, 
hence attrs requested from server early should be regarded as stale.

Adding async IO support to fuse, a case emerges when 
fuse_write_update_size() won't be called: incoming direct IO write is 
asynchronous (e.g. it came from libaio), it's not extending write, so 
it's allowable to process it by submitting fuse requests to background 
and return -EIOCBQUEUED without waiting for completions (see 4th patch 
of this patch-set). But in this case the file on server will be changed 
anyway. That's why I bump attr_version in fuse_aio_complete() -- to be 
consistent with the model we had before this patch-set.

The fact that I did the trick both for writes and reads was probably 
overlook. I'd suggest to fix it like this:

> -			if (!is_sync_kiocb(io->iocb)) {
> +			if (!is_sync_kiocb(io->iocb) && io->write) {

Thanks,
Maxim
