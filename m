Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3JIIUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:20:34 -0400
Received: from relay.parallels.com ([195.214.232.42]:37903 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3JIIU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:20:28 -0400
Message-ID: <525511CA.5010601@parallels.com>
Date: Wed, 9 Oct 2013 12:20:26 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "miklos@szeredi.hu" <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [fuse-devel] [PATCH 2/4] fuse: writepages: crop secondary requests
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru> <20131002173823.31188.77171.stgit@dhcp-10-30-17-2.sw.ru> <20131003095749.GB14242@tucsk.piliscsaba.szeredi.hu> <524D70FE.5000701@parallels.com> <20131003151432.GE14242@tucsk.piliscsaba.szeredi.hu> <524D925A.8050402@parallels.com> <CAJfpeguzpFcZnZV7nfbeETRKcu9zn1AA--N6cOA2qF+zMgEANA@mail.gmail.com> <524D99BC.1030007@parallels.com>
In-Reply-To: <524D99BC.1030007@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On 10/03/2013 08:22 PM, Maxim Patlasov wrote:
> On 10/03/2013 08:09 PM, Miklos Szeredi wrote:
>> On Thu, Oct 3, 2013 at 5:50 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
>>> On 10/03/2013 07:14 PM, Miklos Szeredi wrote:
>>>> On Thu, Oct 03, 2013 at 05:28:30PM +0400, Maxim Patlasov wrote:
>>>>
>>>>> 1. There is an in-flight primary request with a chain of secondary ones.
>>>>> 2. User calls ftruncate(2) to extend file; fuse_set_nowrite() makes
>>>>> fi->writectr negative and starts waiting for completion of that
>>>>> in-flight request
>>>>> 3. Userspace fuse daemon ACKs the request and fuse_writepage_end()
>>>>> is called; it calls __fuse_flush_writepages(), but the latter does
>>>>> nothing because fi->writectr < 0
>>>>> 4. fuse_do_setattr() proceeds extending i_size and calling
>>>>> __fuse_release_nowrite(). But now new (increased) i_size will be
>>>>> used as 'crop' arg of __fuse_flush_writepages()
>>>>>
>>>>> stale data can leak to the server.
>>>> So, lets do this then: skip fuse_flush_writepages() and call
>>>> fuse_send_writepage() directly.  It will ignore the NOWRITE logic, but
>>>> that's
>>>> okay, this happens rarely and cannot happen more than once in a row.
>>>>
>>>> Does this look good?
>>> Yes, but let's at least add a comment explaining why it's safe. There are
>>> three different cases and what you write above explains only one of them:
>>>
>>> 1st case (trivial): there are no concurrent activities using
>>> fuse_set/release_nowrite. Then we're on safe side because
>>> fuse_flush_writepages() would call fuse_send_writepage() anyway.
>>> 2nd case: someone called fuse_set_nowrite and it is waiting now for
>>> completion of all in-flight requests. Here what you wrote about "happening
>>> rarely and no more than once" is applicable.
>>> 3rd case: someone (e.g. fuse_do_setattr()) is in the middle of
>>> fuse_set_nowrite..fuse_release_nowrite section. The fact that
>>> fuse_set_nowrite returned implies that all in-flight requests were completed
>>> along with all its secondary requests (because we increment writectr for a
>>> secondry before decrementing it for the primary -- that's how
>>> fuse_writepage_end is implemeted). Further requests are blocked by negative
>>> writectr. Hence there cannot be any in-flight requests and no invocations of
>>> fuse_writepage_end while we're in fuse_set_nowrite..fuse_release_nowrite
>>> section.
>>>
>>> It looks obvious now, but I'm not sure we'll able to recollect it later.
>> Added your analysis as a comment and all patches pushed to writepages.v2.
> Great! So I can proceed with re-basing the rest of
> writeback-cache-policy pile to writepages.v2 soon.

More testing (with writeback-cache-policy enabled) revealed another bug 
in that implementation. The problem deals with a write(2) extending i_size:

1. There is an in-flight primary request now. It was properly cropped 
against i_size which was valid then and is valid now. So there is a page 
in the request that will be written to the server partially.
2. write(2) to a distant offset makes a hole and extends i_size.
3. write(2) populates that whole page by new user data.
4. Writeback happens and fuse_writepage_in_flight() attaches a secondary 
request to the primary request.
5. fuse_writepage_end() for the primary request calls 
fuse_send_writepage() with 'crop' arg equal to "inarg->offset + 
inarg->size". But inarg->size was calculated before i_size extension, so 
the second request will be cropped as well as primary. The result is 
that the tail of secondary request populated by valid actual user data 
won't be stored on the server.

The problem will be hidden by adding fuse_wait_on_page_writeback() to 
write_begin fuse method, but the implementation will remain unsafe if we 
believe a re-dirty may happen spontaneously. Straightforward solution 
would be to crop secondary requests at the time of their queuing (using 
actual i_size). Then fuse_send_writepage() would crop further only if 
i_size shrunk. Please let me know if you come up with a smarter idea.

Thanks,
Maxim
