Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaICQeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:34:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbaICQeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:34:01 -0400
Message-ID: <540742D1.3010102@redhat.com>
Date: Wed, 03 Sep 2014 12:33:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>
CC: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: task_numa_fault() && TASK_DEAD
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com> <20140901153935.GQ27892@worktop.ger.corp.intel.com> <20140901175851.GA15210@redhat.com> <20140901190931.GD5806@worktop.ger.corp.intel.com> <20140902155208.GA28668@redhat.com> <20140902164714.GA17033@redhat.com> <20140903160819.GA7682@redhat.com>
In-Reply-To: <20140903160819.GA7682@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/03/2014 12:08 PM, Oleg Nesterov wrote:
> On 09/02, Oleg Nesterov wrote:
>> 
>> The usage of TASK_DEAD in task_numa_fault() is wrong in any
>> case.
> 
> Rik, I can't understand why task_numa_fault() needs this check at
> all, but "if (p->state == TASK_DEAD)" looks certainly wrong. You
> could replace this check with BUG_ON(p->state == TASK_DEAD).
> Perhaps you meant PF_EXITING?

I do not know why that code is in there, either.

I suspect it was added after some conversation on irc, with
either Peter or Mel.

> And a stupid (really, I don't understand this code) question:
> 
> /* for example, ksmd faulting in a user's mm */ if (!p->mm) 
> return;
> 
> OK, but perhaps it make sense to pass "mm" as another argument and
> do
> 
> /* ksmd faulting in a user's mm, or debugger, or kthread use_mm()
> caller */ if (p->mm != mm) return;

I suppose that makes sense, since it would be possible for one task
to cause a page fault in another task's mm, with eg. ptrace peek/poke
or similar code paths.

Currently the numa code could end up accounting such a fault in the
wrong mm, when it would be better to not account the fault at all.

This is a bit of a corner case, and probably not the highest priority
thing to fix right now, but it would be fairly easy.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUB0LQAAoJEM553pKExN6DGBEIALBBKq0N3GlzjRWBzxI361dg
+Xn/C789TZFhk2tvZMNYwJgZRS7xaTRr6IfNcMZNlT9enVlXtrPj2BFiTJ1dF+bh
iwr2eS8c+VVHM+lvzEyiNbrTnvgVNgECI76qsjpvuS0BiUKLh51JSTNLdHA4/CEZ
yJrd+WyulTrv9dHchIO53MQ8+ttCNdzQv/1JK+L2R7vizGnnwA6FysTVQFOPLDxd
ZdvdlAb16uouYQ+1skufxwftvydkbv5voDzp2kb7W0vtwp45MEmj72KPCjHvm1JV
XoX6x1tdNuuZtGdY6WQvFup9ABUnMnILHaX4bkYvxxUqE6/NbfNGOC0CBO41IjE=
=NFQx
-----END PGP SIGNATURE-----
