Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaATLqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:46:35 -0500
Received: from relay.parallels.com ([195.214.232.42]:43715 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaATLqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:46:30 -0500
Message-ID: <52DD0C93.6010402@parallels.com>
Date: Mon, 20 Jan 2014 15:46:27 +0400
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
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru> <20131010131113.10089.57270.stgit@dhcp-10-30-17-2.sw.ru> <20131112171707.GB10813@tucsk.piliscsaba.szeredi.hu> <52B45A30.10808@parallels.com> <20140106164319.GF16230@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20140106164319.GF16230@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.28.216]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 08:43 PM, Miklos Szeredi wrote:
> On Fri, Dec 20, 2013 at 06:54:40PM +0400, Maxim Patlasov wrote:
>> Hi Miklos,
>>
>> Sorry for delay, see please inline comments below.
>>
>> On 11/12/2013 09:17 PM, Miklos Szeredi wrote:
>>> On Thu, Oct 10, 2013 at 05:11:25PM +0400, Maxim Patlasov wrote:
>>>> Move the code filling and sending read request to a separate function. Future
>>>> patches will use it for .write_begin -- partial modification of a page
>>>> requires reading the page from the storage very similarly to what fuse_readpage
>>>> does.
>>>>
>>>> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
>>>> ---
>>>>   fs/fuse/file.c |   55 +++++++++++++++++++++++++++++++++++++------------------
>>>>   1 file changed, 37 insertions(+), 18 deletions(-)
>>>>
>>>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>>>> index b4d4189..77eb849 100644
>>>> --- a/fs/fuse/file.c
>>>> +++ b/fs/fuse/file.c
>>>> @@ -700,21 +700,14 @@ static void fuse_short_read(struct fuse_req *req, struct inode *inode,
>>>>   	}
>>>>   }
>>>> -static int fuse_readpage(struct file *file, struct page *page)
>>>> +static int __fuse_readpage(struct file *file, struct page *page, size_t count,
>>>> +			   int *err, struct fuse_req **req_pp, u64 *attr_ver_p)
>>> Signature of this helper looks really ugly.  A quick look tells me that neither
>>> caller actually needs 'req'.
>> fuse_readpage() passes 'req' to fuse_short_read(). And the latter
>> uses req->pages[] to nullify a part of request.
> I don't get it.  __fuse_readpage() itself call's fuse_short_read(), not callers
> of __fuse_readpage().  Or do they?

fuse_readpage() is a caller of __fuse_readpage() and it looks (after 
applying the patch) like this:

 > static int fuse_readpage(struct file *file, struct page *page)
 > {
 > ...
 >    num_read = __fuse_readpage(file, page, count, &err, &req, &attr_ver);
 >    if (!err) {
 >        /*
 >         * Short read means EOF.  If file size is larger, truncate it
 >         */
 >        if (num_read < count)
 >            fuse_short_read(req, inode, attr_ver);
 >
 >        SetPageUptodate(page);
 >    }

Thanks,
Maxim

>
>>> And fuse_get_attr_version() can be moved to the
>>> one caller that needs it.
>> Yes, it's doable. But this would make attr_version mechanism less
>> efficient (under some loads): suppose the file on server was
>> truncated externally, then fuse_readpage() acquires
>> fc->attr_version, then some innocent write bumps fc->attr_version
>> while we're waiting for fuse writeback, then fuse_read_update_size()
>> would noop. In the other words, it's beneficial to keep the time
>> interval between acquiring fc->attr_version and subsequent
>> comparison as short as possible.
> Okay, lets try to keep this the way it is.  I don't like it very much, but I
> fear changing user visible behavior.
>
> Thanks,
> Miklos
>

