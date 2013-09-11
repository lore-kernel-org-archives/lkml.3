Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3IKMWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:22:00 -0400
Received: from relay.parallels.com ([195.214.232.42]:44754 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3IKMV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:21:59 -0400
Message-ID: <52306065.6010802@parallels.com>
Date: Wed, 11 Sep 2013 16:21:57 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Brian Foster <bfoster@redhat.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH 2/2] fuse: wait for writeback in fuse_file_fallocate()
 -v2
References: <20130812163935.10366.88320.stgit@maximpc.sw.ru> <20130816112854.5630.1907.stgit@maximpc.sw.ru> <20130829154110.GB19636@tucsk.piliscsaba.szeredi.hu> <521F7672.7050407@parallels.com> <20130829163744.GC19636@tucsk.piliscsaba.szeredi.hu> <CAJfpegszfc9_ZkGGHg84VvOdmWz1=zWCnHRDbVOWf6_c-oJAXA@mail.gmail.com> <CAJfpegueaj7dF1SL68=pKSTO-q6RnbD-D=C65B8RGEPC4_DMfQ@mail.gmail.com> <52208313.6000700@parallels.com> <CAJfpeguOTuZQFVpKQ5aDVxEPDrmzt_bKwXpiNrXv5yVegoA0QA@mail.gmail.com>
In-Reply-To: <CAJfpeguOTuZQFVpKQ5aDVxEPDrmzt_bKwXpiNrXv5yVegoA0QA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 02:12 PM, Miklos Szeredi wrote:
> On Fri, Aug 30, 2013 at 1:33 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
>> 08/30/2013 01:13 PM, Miklos Szeredi пишет:
>>
>>> On Thu, Aug 29, 2013 at 6:41 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> BTW, isn't it enough to do the filemap_write_and_wait() *plus* the
>>>> fuse_set_nowrite()?
>>> Thought about it a bit and I think this should do fine.
>>>
>>> Any writes before the fallocate will go trough before the fallocate.
>>> i_mutex guarantees that only one instance of fuse_set_nowrite() is
>>> running.  Any mmaped writes during the fallocate() will go after the
>>> fallocate request and the page cache truncation and that's fine too.
>>> Page cache is consistent since it doens't contain pages for those
>>> writes to the hole.  Subsequent reads to that area will fill them in.
>>>
>>> Any other concerns?
>>
>> No. What you suggest looks as a neat and correct solution. I'll resend the
>> updated patch after some testing (since now till Monday).
>>
>> As for proof-of-correctness, all you wrote above is correct, but the first
>> point had been boiling my mind for a while. I came to the following
>> reasoning (hopefully it is what you meant):
>>
>> The fact that filemap_write_and_wait() returned infers that
>> end_page_writeback() was called for all relevant pages. And fuse doesn't
>> call it before adding request to fi->queued_writes and calling
>> fuse_flush_writepages(). And the latter, in turn, guarantees proper
>> accounting of request in fi->writectr. Here, of course, it's crucial that we
>> can't have concurrent fuse_set_nowrite(), as you explained. Hence, so far as
>> fi->writectr was bumped, fuse_set_nowrite() we call after
>> filemap_write_and_wait() would wait until all changes have gone to the
>> server.
> Any news about this?

Testing updated patch revealed a problem (fsx caught data corruption). 
Then I instrumented debug version to get a cue. The debug version 
survived several days of testing, but now I discovered that that test 
setup was not fully correct. I'll re-run it now.

Thanks,
Maxim

