Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaKSNFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:05:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbaKSNF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:05:28 -0500
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
Date: Wed, 19 Nov 2014 14:05:12 +0100
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E4F3AA@SIXPRD3002MB028.064d.mgd.msft.net>
	(Dexuan Cui's message of "Wed, 19 Nov 2014 12:57:24 +0000")
Message-ID: <87a93nfiif.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

>> -----Original Message-----
>> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>> Sent: Wednesday, November 19, 2014 20:41 PM
>> To: Dexuan Cui
>> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
>> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> jasowang@redhat.com; Haiyang Zhang
>> Subject: Re: [PATCH] tools: hv: ignore ENOBUFS in the KVP daemon
>> 
>> Dexuan Cui <decui@microsoft.com> writes:
>> 
>> >> -----Original Message-----
>> >> From: Vitaly Kuznetsov
>> >> Sent: Wednesday, November 19, 2014 18:50 PM
>> >> To: Dexuan Cui
>> >> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
>> driverdev-
>> >> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> >> jasowang@redhat.com; Haiyang Zhang
>> >> Subject: Re: [PATCH] tools: hv: ignore ENOBUFS in the KVP daemon
>> >>
>> >> Dexuan Cui  writes:
>> >>
>> >> > Under high memory pressure and very high KVP R/W test pressure,
>> the netlink
>> >> > recvfrom() may transiently return ENOBUFS to the daemon -- we found
>> this
>> >> > during a 2-week stress test.
>> >> >
>> >> > We'd better not terminate the daemon on this failure, because a
>> typical KVP
>> >> > user can re-try the R/W and hopefully it will succeed next time.
>> >> >
>> >> > diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
>> >> > index 22b0764..9f4b303 100644
>> >> > --- a/tools/hv/hv_kvp_daemon.c
>> >> > +++ b/tools/hv/hv_kvp_daemon.c
>> >> > @@ -1559,8 +1559,15 @@ int main(int argc, char *argv[])
>> >> >  				addr_p, &addr_l);
>> >> >
>> >> >  		if (len < 0) {
>> >> > +			int saved_errno = errno;
>> >> >  			syslog(LOG_ERR, "recvfrom failed; pid:%u
>> error:%d %s",
>> >> >  					addr.nl_pid, errno, strerror(errno));
>> >> > +
>> >> > +			if (saved_errno == ENOBUFS) {
>> >>
>> >> is it possible to meet EAGAIN (or EWOULDBLOCK) here as well? I'd
>> suggest
>> >> we ignore these as well in such case. Ignoring ENOMEM here is doubtful,
>> >> I think. But possible.
>> >>
>> >>   Vitaly
>> >
>> > I don't think EAGAIN is possible  because "man recvfrom" says
>> >    "If  no messages are available at the socket, the receive calls wait for a
>> >      message to arrive, unless the socket is nonblocking (see fcntl(2)), in
>> which
>> >      case the value -1 is returned and  the  external variable  errno is set to
>> >     EAGAIN or EWOULDBLOCK".
>> >
>> > The same man page mention ENOMEM for recvmsg(), but not recvfrom().
>> 
>> Ah, sorry, I though your patch patches the other place: call to
>> netlink_send() which does sendmsg() (and my
>> EAGAIN/EWOULDBLOCK/ENOMEM
>> comment was about it). It could also make sense to patch them both as I
>> think it is possible to hit these as well.
>> 
>> > -- Dexuan
>> --
>>   Vitaly
>
> OK, I can add this new check:
> (I'll send out the v2 tomorrow in case  people have new comments)
>

Thanks!

> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1770,8 +1770,15 @@ kvp_done:
>
>                 len = netlink_send(fd, incoming_cn_msg);
>                 if (len < 0) {
> +                       int saved_errno = errno;
>                         syslog(LOG_ERR, "net_link send failed; error: %d %s", errno,
>                                         strerror(errno));
> +
> +                       if (saved_errno == ENOMEM || saved_errno ==  EAGAIN) {

Sorry for being pushy, but it seems ENOBUFS is also possible here (at
least man sendmsg mentions it).

> +                               syslog(LOG_ERR, "send error: ignored");
> +                               continue;
> +                       }
> +
>                         exit(EXIT_FAILURE);
>                 }
>         }
>
> Thanks,
> -- Dexuan

-- 
  Vitaly
