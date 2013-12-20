Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3LTOyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:54:44 -0500
Received: from relay.parallels.com ([195.214.232.42]:52399 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3LTOym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:54:42 -0500
Message-ID: <52B45A30.10808@parallels.com>
Date: Fri, 20 Dec 2013 18:54:40 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <bfoster@redhat.com>,
        <linux-kernel@vger.kernel.org>, <jbottomley@parallels.com>,
        <linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <fengguang.wu@intel.com>, <devel@openvz.org>
Subject: Re: [PATCH 07/11] fuse: restructure fuse_readpage()
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru> <20131010131113.10089.57270.stgit@dhcp-10-30-17-2.sw.ru> <20131112171707.GB10813@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20131112171707.GB10813@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.28.216]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

Sorry for delay, see please inline comments below.

On 11/12/2013 09:17 PM, Miklos Szeredi wrote:
> On Thu, Oct 10, 2013 at 05:11:25PM +0400, Maxim Patlasov wrote:
>> Move the code filling and sending read request to a separate function. Future
>> patches will use it for .write_begin -- partial modification of a page
>> requires reading the page from the storage very similarly to what fuse_readpage
>> does.
>>
>> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
>> ---
>>   fs/fuse/file.c |   55 +++++++++++++++++++++++++++++++++++++------------------
>>   1 file changed, 37 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>> index b4d4189..77eb849 100644
>> --- a/fs/fuse/file.c
>> +++ b/fs/fuse/file.c
>> @@ -700,21 +700,14 @@ static void fuse_short_read(struct fuse_req *req, struct inode *inode,
>>   	}
>>   }
>>   
>> -static int fuse_readpage(struct file *file, struct page *page)
>> +static int __fuse_readpage(struct file *file, struct page *page, size_t count,
>> +			   int *err, struct fuse_req **req_pp, u64 *attr_ver_p)
> Signature of this helper looks really ugly.  A quick look tells me that neither
> caller actually needs 'req'.

fuse_readpage() passes 'req' to fuse_short_read(). And the latter uses 
req->pages[] to nullify a part of request.

> And fuse_get_attr_version() can be moved to the
> one caller that needs it.

Yes, it's doable. But this would make attr_version mechanism less 
efficient (under some loads): suppose the file on server was truncated 
externally, then fuse_readpage() acquires fc->attr_version, then some 
innocent write bumps fc->attr_version while we're waiting for fuse 
writeback, then fuse_read_update_size() would noop. In the other words, 
it's beneficial to keep the time interval between acquiring 
fc->attr_version and subsequent comparison as short as possible.

> And negative err can be returned.

Yes, but this will require some precautions for positive 
req->out.h.error. Like "err = (req->out.h.error <= 0) ? req->out.h.error 
: -EIO;". But this must be OK - filtering out positive req->out.h.error 
is a good idea, imho.


> And then all those
> ugly pointer args are gone and the whole thing is much simpler.

If you agree with my comments above, only 1 of 3 ugly pointers can be 
avoided. Another way would be to revert the code back to the initial 
implementation where fuse_readpage() and fuse_prepare_write() sent read 
requests independently.

Thanks,
Maxim
