Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaIKQOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:14:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:41852 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbaIKQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:14:10 -0400
Message-ID: <5411CA4F.7040006@parallels.com>
Date: Thu, 11 Sep 2014 20:14:07 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Anand Avati <avati@gluster.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] fuse: fix synchronous case of fuse_file_put()
References: <20140821160304.11005.15166.stgit@localhost.localdomain>	<20140821160916.11005.37344.stgit@localhost.localdomain> <CAJfpegsWoaqR1vQRq8QpYdwUX9Ace9XTe77eOkOUy2VyHUeEdQ@mail.gmail.com>
In-Reply-To: <CAJfpegsWoaqR1vQRq8QpYdwUX9Ace9XTe77eOkOUy2VyHUeEdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 06:08 PM, Miklos Szeredi wrote:
> On Thu, Aug 21, 2014 at 6:09 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
>> If fuse_file_put() is called with sync==true, the user may be blocked for
>> a while, until userspace ACKs our FUSE_RELEASE request. This blocking must be
>> uninterruptible. Otherwise request could be interrupted, but file association
>> in user space remains.
>>
>> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
>> ---
>>   fs/fuse/file.c |    4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>> index cd55488..b92143a 100644
>> --- a/fs/fuse/file.c
>> +++ b/fs/fuse/file.c
>> @@ -136,6 +136,10 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
>>                          path_put(&req->misc.release.path);
>>                          fuse_put_request(ff->fc, req);
>>                  } else if (sync) {
>> +                       /* Must force. Otherwise request could be interrupted,
>> +                        * but file association in user space remains.
>> +                        */
>> +                       req->force = 1;
>>                          req->background = 0;
>>                          fuse_request_send(ff->fc, req);
>>                          path_put(&req->misc.release.path);
>>
>
> Some thought needs to go into this:  if RELEASE is interrupted, then
> we should possibly allow that, effectively backgrounding the request.
>
> The synchronous nature is just an optimization and we really don't
> know where we are being interrupted, possibly in a place which very
> much *should* allow interruption.

I really need your help to proceed with this patch. Could you please 
explain what those places are where we should allow interruption.

BTW, as for "just an optimization", I've recently noticed that __fput() 
calls locks_remove_file(). So guarantees provided by the patch-set are 
on the same level as flock(2) behaviour.

>
> Also fuse really should distinguish fatal and non-fatal interruptions
> and handle them accordingly...

And elaborate on this concern, please.

Thanks,
Maxim
