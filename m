Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaFSMG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:06:59 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:52436 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757442AbaFSMG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:06:58 -0400
X-Yandex-Uniq: 7793d61b-4d4a-46c4-b4f9-2afb0afe51a6
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Thu, 19 Jun 2014 16:06:52 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf trace: add support for pagefault tracing
Message-ID: <20140619120652.GF15620@stfomichev-desktop.yandex.net>
References: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
 <1403103565-6388-2-git-send-email-stfomichev@yandex-team.ru>
 <20140618154751.GC2702@kernel.org>
 <20140618174254.GD15620@stfomichev-desktop.yandex.net>
 <20140618200432.GA20252@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618200432.GA20252@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So make it default to the most common case :-)
Ok, agreed, will make --pf=all|maj|min and will default it to maj.

> That is my expectation, yes, if I ask for the map where address N is, it
> should return just that, where have you found this bug?
> 
> The thread__find_addr_map will end up calling maps__find() and it does
> this:
> 
>                 if (ip < m->start)
>                         p = &(*p)->rb_left;
>                 else if (ip > m->end)
>                         p = &(*p)->rb_right;
>                 else
>                         return m;
> 
> Where is the problem?
You're right, we don't need to check the range, if map is non-null it's a
valid one. I'll remove valid_dso and will just check al.map for null.

> Understood the intent, but the test here is really:
> 
> 		if (evsel->attr.type == PERF_TYPE_TRACEPOINT &&
> 		    sample.raw_data == NULL)
> 
> Ok?
Yes, makes more sense.

> Also, have you considered using:
> 
> [root@zoo ~]# perf list exceptions:page_fault*
>   exceptions:page_fault_user                         [Tracepoint event]
>   exceptions:page_fault_kernel                       [Tracepoint event]
> [root@zoo ~]#
> 
> Instead? I need to check if they're completely equivalent to what we
> need here...
Hm, didn't know there are two kinds of fault events :-/
But it seems these are x86 only.
