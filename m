Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3JCQWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:22:24 -0400
Received: from relay.parallels.com ([195.214.232.42]:48696 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3JCQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:22:23 -0400
Message-ID: <524D99BC.1030007@parallels.com>
Date: Thu, 3 Oct 2013 20:22:20 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] fuse: writepages: crop secondary requests
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru> <20131002173823.31188.77171.stgit@dhcp-10-30-17-2.sw.ru> <20131003095749.GB14242@tucsk.piliscsaba.szeredi.hu> <524D70FE.5000701@parallels.com> <20131003151432.GE14242@tucsk.piliscsaba.szeredi.hu> <524D925A.8050402@parallels.com> <CAJfpeguzpFcZnZV7nfbeETRKcu9zn1AA--N6cOA2qF+zMgEANA@mail.gmail.com>
In-Reply-To: <CAJfpeguzpFcZnZV7nfbeETRKcu9zn1AA--N6cOA2qF+zMgEANA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 08:09 PM, Miklos Szeredi wrote:
> On Thu, Oct 3, 2013 at 5:50 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
>> On 10/03/2013 07:14 PM, Miklos Szeredi wrote:
>>> On Thu, Oct 03, 2013 at 05:28:30PM +0400, Maxim Patlasov wrote:
>>>
>>>> 1. There is an in-flight primary request with a chain of secondary ones.
>>>> 2. User calls ftruncate(2) to extend file; fuse_set_nowrite() makes
>>>> fi->writectr negative and starts waiting for completion of that
>>>> in-flight request
>>>> 3. Userspace fuse daemon ACKs the request and fuse_writepage_end()
>>>> is called; it calls __fuse_flush_writepages(), but the latter does
>>>> nothing because fi->writectr < 0
>>>> 4. fuse_do_setattr() proceeds extending i_size and calling
>>>> __fuse_release_nowrite(). But now new (increased) i_size will be
>>>> used as 'crop' arg of __fuse_flush_writepages()
>>>>
>>>> stale data can leak to the server.
>>> So, lets do this then: skip fuse_flush_writepages() and call
>>> fuse_send_writepage() directly.  It will ignore the NOWRITE logic, but
>>> that's
>>> okay, this happens rarely and cannot happen more than once in a row.
>>>
>>> Does this look good?
>>
>> Yes, but let's at least add a comment explaining why it's safe. There are
>> three different cases and what you write above explains only one of them:
>>
>> 1st case (trivial): there are no concurrent activities using
>> fuse_set/release_nowrite. Then we're on safe side because
>> fuse_flush_writepages() would call fuse_send_writepage() anyway.
>> 2nd case: someone called fuse_set_nowrite and it is waiting now for
>> completion of all in-flight requests. Here what you wrote about "happening
>> rarely and no more than once" is applicable.
>> 3rd case: someone (e.g. fuse_do_setattr()) is in the middle of
>> fuse_set_nowrite..fuse_release_nowrite section. The fact that
>> fuse_set_nowrite returned implies that all in-flight requests were completed
>> along with all its secondary requests (because we increment writectr for a
>> secondry before decrementing it for the primary -- that's how
>> fuse_writepage_end is implemeted). Further requests are blocked by negative
>> writectr. Hence there cannot be any in-flight requests and no invocations of
>> fuse_writepage_end while we're in fuse_set_nowrite..fuse_release_nowrite
>> section.
>>
>> It looks obvious now, but I'm not sure we'll able to recollect it later.
> Added your analysis as a comment and all patches pushed to writepages.v2.

Great! So I can proceed with re-basing the rest of 
writeback-cache-policy pile to writepages.v2 soon.

>
>>> Can you actually trigger this path with your testing?
>>
>> No.
> Hmm, did you do any testing with the wait-for-page-writeback disabled
> in fuse_mkwrite()?

Yes, of course. I've been doing that for a week on two very different 
h/w nodes, but I'm using ordinary fsx (not some artificial hand-crafted 
mmap-writer) and I usually get only a dozen "rewrite: 1" messages per 
night. This is enough to make sure that rewrite code main-path is OK, 
but not enough to be sure that all corner cases are covered.

Thanks,
Maxim

