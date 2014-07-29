Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaG2PSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:18:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaG2PSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:18:09 -0400
Message-ID: <53D7BAA5.8080404@redhat.com>
Date: Tue, 29 Jul 2014 11:15:49 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
References: <1406571388-3227-1-git-send-email-riel@redhat.com> <1406571388-3227-2-git-send-email-riel@redhat.com> <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com> <20140729145910.GH3935@laptop>
In-Reply-To: <20140729145910.GH3935@laptop>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/29/2014 10:59 AM, Peter Zijlstra wrote:
> On Tue, Jul 29, 2014 at 11:04:50AM +0200, Vincent Guittot wrote:
>>> In situations where all the domains are overloaded, or where
>>> only the busiest domain is overloaded, that code is also
>>> superfluous, since the normal env->imbalance calculation will
>>> figure out how much to move. Remove the load_above_capacity
>>> calculation.
>> 
>> IMHO, we should not remove that part which is used by
>> prefer_sibling
>> 
>> Originally, we had 2 type of busiest group: overloaded or
>> imbalanced. You add a new one which has only a avg_load higher
>> than other so you should handle this new case and keep the other
>> ones unchanged
> 
> Right, so we want that code for overloaded -> overloaded migrations
> such as not to cause idle cpus in an attempt to balance things.
> Idle cpus are worse than imbalance.
> 
> But in case of overloaded/imb -> !overloaded migrations we can
> allow it, and in fact want to allow it in order to balance idle
> cpus.

In case the destination is over the average load, or the source is under
the average load, fix_small_imbalance() determines env->imbalance.

The "load_above_capacity" calculation is only reached when busiest is
busier than average, and the destination is under the average load.
In that case, env->imbalance ends up as the minimum of busiest - avg
and avg - target.

Is there any case where limiting it further to "load - capacity" from
the busiest domain makes a difference?

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT17qlAAoJEM553pKExN6D/DgH/RbAK0Sr2Doa+zXVavx9VtU4
39pX1vh/0Rgcy1L1zCuPtKrKaV5sEGr50qH9Wui5rIXdPzykVZROYqp13d178SCY
N3wfbWsP1hAhOS5e2c4sR8WqxsTp/1Ofjyx4PoXwRautwVeWbjPE0I4Hbs2MPjwm
8idkTPpl+qBpe1NvppBm6NmZxtZEJUv5X/hoGcLxEwyAHhJaKfw22Tm1oib2/7Dj
TQy5XjqY1oiOz3/sf9AsRaZMYCmemtUPXCtCncP9rCJLxd04i/Gc0ggrU0qWHCDq
cZcrm9bCP/aYxV9QNyD8QhHuS/6C17zYCG4E2R7BpKXfJYDT8FRbb/FgSoLUVhE=
=iR13
-----END PGP SIGNATURE-----
