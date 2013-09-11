Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3IKKMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:12:37 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62326 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3IKKMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:12:33 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <52208313.6000700@parallels.com>
References: <20130812163935.10366.88320.stgit@maximpc.sw.ru>
	<20130816112854.5630.1907.stgit@maximpc.sw.ru>
	<20130829154110.GB19636@tucsk.piliscsaba.szeredi.hu>
	<521F7672.7050407@parallels.com>
	<20130829163744.GC19636@tucsk.piliscsaba.szeredi.hu>
	<CAJfpegszfc9_ZkGGHg84VvOdmWz1=zWCnHRDbVOWf6_c-oJAXA@mail.gmail.com>
	<CAJfpegueaj7dF1SL68=pKSTO-q6RnbD-D=C65B8RGEPC4_DMfQ@mail.gmail.com>
	<52208313.6000700@parallels.com>
Date: Wed, 11 Sep 2013 12:12:31 +0200
Message-ID: <CAJfpeguOTuZQFVpKQ5aDVxEPDrmzt_bKwXpiNrXv5yVegoA0QA@mail.gmail.com>
Subject: Re: [PATCH 2/2] fuse: wait for writeback in fuse_file_fallocate() -v2
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Brian Foster <bfoster@redhat.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 1:33 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
> 08/30/2013 01:13 PM, Miklos Szeredi пишет:
>
>> On Thu, Aug 29, 2013 at 6:41 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>
>>> BTW, isn't it enough to do the filemap_write_and_wait() *plus* the
>>> fuse_set_nowrite()?
>>
>> Thought about it a bit and I think this should do fine.
>>
>> Any writes before the fallocate will go trough before the fallocate.
>> i_mutex guarantees that only one instance of fuse_set_nowrite() is
>> running.  Any mmaped writes during the fallocate() will go after the
>> fallocate request and the page cache truncation and that's fine too.
>> Page cache is consistent since it doens't contain pages for those
>> writes to the hole.  Subsequent reads to that area will fill them in.
>>
>> Any other concerns?
>
>
> No. What you suggest looks as a neat and correct solution. I'll resend the
> updated patch after some testing (since now till Monday).
>
> As for proof-of-correctness, all you wrote above is correct, but the first
> point had been boiling my mind for a while. I came to the following
> reasoning (hopefully it is what you meant):
>
> The fact that filemap_write_and_wait() returned infers that
> end_page_writeback() was called for all relevant pages. And fuse doesn't
> call it before adding request to fi->queued_writes and calling
> fuse_flush_writepages(). And the latter, in turn, guarantees proper
> accounting of request in fi->writectr. Here, of course, it's crucial that we
> can't have concurrent fuse_set_nowrite(), as you explained. Hence, so far as
> fi->writectr was bumped, fuse_set_nowrite() we call after
> filemap_write_and_wait() would wait until all changes have gone to the
> server.

Any news about this?

Thanks,
Miklos
