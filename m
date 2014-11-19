Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaKSOkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:40:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbaKSOkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:40:02 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel\@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf\@aepfle.de" <olaf@aepfle.de>,
        "apw\@canonical.com" <apw@canonical.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] tools: hv: ignore ENOBUFS in the KVP daemon
References: <1416394245-31717-1-git-send-email-decui@microsoft.com>
	<87lhn7forv.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E4F2FA@SIXPRD3002MB028.064d.mgd.msft.net>
	<87egszfjn6.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E4F3AA@SIXPRD3002MB028.064d.mgd.msft.net>
	<87a93nfiif.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E4F44B@SIXPRD3002MB028.064d.mgd.msft.net>
Date: Wed, 19 Nov 2014 15:39:46 +0100
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E4F44B@SIXPRD3002MB028.064d.mgd.msft.net>
	(Dexuan Cui's message of "Wed, 19 Nov 2014 13:13:49 +0000")
Message-ID: <871tozfe4t.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

>> -----Original Message-----
>> From: Vitaly Kuznetsov 
>> >> --
>> >>   Vitaly
>> >
>> > OK, I can add this new check:
>> > (I'll send out the v2 tomorrow in case  people have new comments)
>> >
>> 
>> Thanks!
>> 
>> > --- a/tools/hv/hv_kvp_daemon.c
>> > +++ b/tools/hv/hv_kvp_daemon.c
>> > @@ -1770,8 +1770,15 @@ kvp_done:
>> >
>> >                 len = netlink_send(fd, incoming_cn_msg);
>> >                 if (len < 0) {
>> > +                       int saved_errno = errno;
>> >                         syslog(LOG_ERR, "net_link send failed; error: %d %s", errno,
>> >                                         strerror(errno));
>> > +
>> > +                       if (saved_errno == ENOMEM || saved_errno ==  EAGAIN) {
>> 
>> Sorry for being pushy, but it seems ENOBUFS is also possible here (at
>> least man sendmsg mentions it).
> OK, I'll add this too. :-)
>
> BTW, I realized sendmsg() can't return EAGAIN here as that's for non-blocking
> socket.
>
> Here I simply ignore the error, hoping the other end will re-try.
>

I agree, it's sufficient to ignore ENOBUFS on recieve path and both
ENOMEM/ENOBUFS on send.

Thanks!

>> 
>> > +                               syslog(LOG_ERR, "send error: ignored");
>> > +                               continue;
>> > +                       }
>> > +
>> >                         exit(EXIT_FAILURE);
>> >                 }
>> >         }
>> >
>> > Thanks,
>> > -- Dexuan
>> 
>>   Vitaly
>
> -- Dexuan

-- 
  Vitaly
