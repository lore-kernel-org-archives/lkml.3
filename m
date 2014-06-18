Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953AbaFRI2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:28:37 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:15482 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964998AbaFRI22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:28:28 -0400
X-IronPort-AV: E=Sophos;i="5.00,730,1396972800"; 
   d="scan'208";a="32079922"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: Pavel Emelyanov <xemul@parallels.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>
Subject: RE: [PATCH] ns: introduce getnspid syscall
Thread-Topic: [PATCH] ns: introduce getnspid syscall
Thread-Index: AQHPiiWS+ihuCJ4pL0CsKQBZW5Hzmpt2iWYQ
Date: Wed, 18 Jun 2014 08:28:30 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5483C2@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <53A030CE.6070101@parallels.com>
In-Reply-To: <53A030CE.6070101@parallels.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5I8TRxT016387



> -----Original Message-----
> From: Pavel Emelyanov [mailto:xemul@parallels.com]
> Sent: Tuesday, June 17, 2014 8:13 PM
> To: Chen, Hanxiao/³Â êÏÏö
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> Andrew Morton; Eric W. Biederman; Serge Hallyn; Daniel P. Berrange; Oleg Nesterov;
> Al Viro; David Howells; Richard Weinberger; Vasiliy Kulikov; Gotou, Yasunori/
> Îåu ¿µÎÄ
> Subject: Re: [PATCH] ns: introduce getnspid syscall
> 
> On 06/17/2014 02:21 PM, Chen Hanxiao wrote:
> > We need a direct method of getting the pid inside containers.
> > If some issues occurred inside container guest, host user
> > could not know which process is in trouble just by guest pid:
> > the users of container guest only knew the pid inside containers.
> > This will bring obstacle for trouble shooting.
> >
> > int getnspid(pid_t pid, int fd1, int fd2, int pidtype);
> >
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
> >
> > +	}
> > +
> > +	switch (pidtype) {
> 
> There's no need in switch, the __task_pid_nr_ns() accepts
> the type argument.
> 

Yes, I think we still have that kind of functions, so I used them...

> > +	case PIDTYPE_PID:
> > +		ret = task_pid_nr_ns(task, ns2);
> 
> But this is not correct. If task doesn't live in ns2, but ns2
> just has the ns->level small enough, then the wrong pid value
> would be reported.
> 

Right, we should check whether the task belonged to that namespace firstly.

Thanks,
- Chen

> > +		break;
> > +	case PIDTYPE_PGID:
> > +		ret = task_pgrp_nr_ns(task, ns2);
> > +		break;
> > +	case PIDTYPE_SID:
> > +		ret = task_session_nr_ns(task, ns2);
> > +		break;
> > +	default:
> > +		ret = -EINVAL;
> > +	}
> > +	ret = (ret == 0) ? -ESRCH : ret;
> > +
> > +out:
> > +	fput(file1);
> > +	if (file2)
> > +		fput(file2);
> > +	return ret;
> > +}
> > +
> >  int __init nsproxy_cache_init(void)
> >  {
> >  	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
> >
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
