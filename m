Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaEYSLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:11:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64552 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaEYSLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:11:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140525101840.GA3588@Inspiron-3521>
References: <1400283807-27930-1-git-send-email-kroosec@gmail.com>
	<CAECXXi4_RJ-yk8Ct=sPPe-pq=shdU-4cKvRTT3yNvsoY42-8_Q@mail.gmail.com>
	<20140518091113.GA3770@Inspiron-3521>
	<20140525101840.GA3588@Inspiron-3521>
Date: Sun, 25 May 2014 14:11:13 -0400
Message-ID: <CAECXXi69w4HNUbZbb3JWxwZkqnyQf=dmm57UJEHOY0Xv6B4pEA@mail.gmail.com>
Subject: Re: [PATCH] nbd: Zero from and len fields in NBD_CMD_DISCONNECT.
From: Paul Clements <paul.clements@us.sios.com>
To: Hani Benhabiles <kroosec@gmail.com>
Cc: "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 6:18 AM, Hani Benhabiles <kroosec@gmail.com> wrote:
> On Sun, May 18, 2014 at 10:11:13AM +0100, Hani Benhabiles wrote:
>> On Fri, May 16, 2014 at 10:56:33PM -0400, Paul Clements wrote:
>> > Agreed. But better yet, the request structure should just be zeroed when
>> > it's allocated.
>> >
>>
>> It is already initialized  in __nbd_ioctl() with the blk_rq_init() call which
>> sets the __sector value to -1 (which is 0xfffffffffffffe00 after the left shifts.)
>>
>> This is the only (non-ugly / non-intrusive) way to do it afaict.
>>
>
> Ping!
>
> Anything blocking this patch ?

It's cleaner to just zero the struct and get rid of the conditional
zeroing of specific fields. I'll prepare a patch in the next few days.

Thanks,
Paul

>> > On Fri, May 16, 2014 at 7:43 PM, Hani Benhabiles <kroosec@gmail.com> wrote:
>> >
>> > > Len field is already set to zero, but not the from field which is sent as
>> > > 0xfffffffffffffe00. This makes no sense, and may cause confuse server
>> > > implementations doing sanity checks (qemu-nbd is an example.)
>> > >
>> > > Signed-off-by: Hani Benhabiles <hani@linux.com>
>> > > ---
>> > >  drivers/block/nbd.c | 2 +-
>> > >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > >
>> > > diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
>> > > index 3a70ea2..657bdac 100644
>> > > --- a/drivers/block/nbd.c
>> > > +++ b/drivers/block/nbd.c
>> > > @@ -246,7 +246,7 @@ static int nbd_send_req(struct nbd_device *nbd, struct
>> > > request *req)
>> > >         request.magic = htonl(NBD_REQUEST_MAGIC);
>> > >         request.type = htonl(nbd_cmd(req));
>> > >
>> > > -       if (nbd_cmd(req) == NBD_CMD_FLUSH) {
>> > > +       if (nbd_cmd(req) == NBD_CMD_FLUSH || nbd_cmd(req) == NBD_CMD_DISC)
>> > > {
>> > >                 /* Other values are reserved for FLUSH requests.  */
>> > >                 request.from = 0;
>> > >                 request.len = 0;
>> > > --
>> > > 1.8.3.2
>> > >
>> > >
