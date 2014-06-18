Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966136AbaFRKDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:03:42 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:52297 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965419AbaFRKDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:03:38 -0400
X-IronPort-AV: E=Sophos;i="5.00,731,1396972800"; 
   d="scan'208";a="32085266"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        "Richard Weinberger" <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        Linux API <linux-api@vger.kernel.org>,
        "Michael Kerrisk-manpages" <mtk.manpages@gmail.com>
Subject: RE: [PATCH] ns: introduce getnspid syscall
Thread-Topic: [PATCH] ns: introduce getnspid syscall
Thread-Index: AQHPipUv5TGMUpp1ZEKRqyXdY2YAqJt2Fd6Q
Date: Wed, 18 Jun 2014 10:03:40 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E548592@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <87fvj3ngv0.fsf@x220.int.ebiederm.org>
In-Reply-To: <87fvj3ngv0.fsf@x220.int.ebiederm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5IA3lKF017277

Hi,

> -----Original Message-----
> From: Eric W. Biederman [mailto:ebiederm@xmission.com]
> Sent: Wednesday, June 18, 2014 9:31 AM
> To: Chen, Hanxiao/³Â êÏÏö
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> Andrew Morton; Serge Hallyn; Daniel P. Berrange; Oleg Nesterov; Al Viro; David
> Howells; Richard Weinberger; Pavel Emelyanov; Vasiliy Kulikov; Gotou, Yasunori/
> Îåu ¿µÎÄ; Linux API; Michael Kerrisk-manpages
> Subject: Re: [PATCH] ns: introduce getnspid syscall
> 
> Chen Hanxiao <chenhanxiao@cn.fujitsu.com> writes:
> 
> > We need a direct method of getting the pid inside containers.
> > If some issues occurred inside container guest, host user
> > could not know which process is in trouble just by guest pid:
> > the users of container guest only knew the pid inside containers.
> > This will bring obstacle for trouble shooting.
> 
> There is also some ongoing work to export this information via a proc
> file which seems more appropriate for solving your problem.  Certainly
> for debugging something easily human discoverable is needed.
> 

Do you mean this patch:
/proc/pid/status: show all sets of pid according to ns
https://lkml.org/lkml/2014/5/26/145

But no new comments on this patch,
Pavel suggested that a syscall should be a good choice.
Do we should continue this kind of work?

> > int getnspid(pid_t pid, int fd1, int fd2, int pidtype);
> 
> The pidtype is nonsense.  The translation of a pid does not depend upon
> type.  Using that kind of nonsense will lead you and others into confusion.
> 

I see.

> > pid: the pid number need to be translated.
> >
> > fd: a file descriptor referring to one of
> >     the namespace entries in a /proc/[pid]/ns/pid.
> >     fd1 for destination ns(ns1), where the pid came from.
> >     fd2 for reference ns(ns2), while fd2 = -2 means for current ns.
> >
> > pidtype: 0 PIDTYPE_PID; 1 PIDTYPE_PGID; 2 PIDTYPE_SID.
> >
> > return value:
> >     >0: translated pid in ns1(fd1) seen from ns2(fd2).
> >     <0: on failure.
> 
> Elsewhere we use 0 on pid translation failure.  Why be different here?
> 

It should be <=0. And <0 means some other failures.

> Eric
> 
> 
> > Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> > +
> > +	rcu_read_lock();
> > +	task = find_task_by_pid_ns(pid, ns1);
> 
> The functions you want to be using here are:
> find_pid_ns and pid_nr_ns.
> 

Thanks for your hint.

- Chen


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
