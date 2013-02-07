Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab3BGQZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:25:54 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:38886 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:25:52 -0500
MIME-Version: 1.0
In-Reply-To: <20130207111025.GD8945@gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	<1360205415.2621.60.camel@gandalf.local.home>
	<20130207111025.GD8945@gmail.com>
Date: Thu, 7 Feb 2013 17:25:51 +0100
Message-ID: <CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Ingo Molnar <mingo@kernel.org>:
>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> I'll reply to this as I come up with comments.
>>
>> First thing is, don't call it NO_HZ_FULL. A better name would
>> be NO_HZ_CPU. I would like to reserve NO_HZ_FULL when we
>> totally remove jiffies :-)
>
> I don't think we want yet another config option named in a
> weird way.
>
> What we want instead is to just split NO_HZ up into its
> conceptual parts:
>
>    CONFIG_NO_HZ_IDLE

Renaming CONFIG_NO_HZ to CONFIG_NO_HZ_IDLE is something I considered.
I was just worried about this option being present in many defconfig.
Perhaps we can do that renaming and keep CONFIG_NO_HZ around a little
while for backward compatibility (pretty much like what we've done for
CONFIG_PERF_COUNTERS -> CONFIG_PERF_EVENTS).

>    CONFIG_NO_HZ_USER_SPACE
>    CONFIG_NO_HZ_KERNEL_SPACE
>
> Where the current status quo is NO_HZ_IDLE=y, and Frederic is
> about to introduce NO_HZ_USER_SPACE=y. When jiffies get removed
> we get NO_HZ_KERNEL_SPACE=y.

Note on my tree I stop the tick on both rings. I believe that
restarting the tick on kernel entry isn't something we should
seriously consider. It would be a costly operation that may make
things worse. And in fact there is no big difference. Just kernelspace
has more opportunities to be disturbed (RCU IPIs, async timer/work
scheduled by the kernel, etc...) and get its tick restarted sometimes.

>
> The 'CONFIG_NO_HZ' meta-option, which we should leave for easy
> configurability and for compatibility, should get us the
> currently recommended default, which for the time being might
> be:

Ah looks like you considered the compatibility as well :)

>
>    CONFIG_NO_HZ_IDLE=y
>    # CONFIG_NO_HZ_USER_SPACE is disabled
>
> Btw., you could add CONFIG_NO_HZ_KERNEL_SPACE right away, just
> keep it false all the time. That would document our future plans
> pretty well.
>
> Once CONFIG_NO_HZ_USER_SPACE is proven problem-free, we might
> default to:
>
>    CONFIG_NO_HZ_IDLE=y
>    CONFIG_NO_HZ_USER_SPACE=y
>
> The goal is to have this in the distant future:
>
>    CONFIG_NO_HZ=y
>
>    CONFIG_NO_HZ_IDLE=y
>    CONFIG_NO_HZ_USER_SPACE=y
>    CONFIG_NO_HZ_KERNEL_SPACE=y
>
> And eventually we might even be able to get rid of all the 3
> variants, and only offer full-on/off.
>
> Agreed?

At least for now we seem to agree on CONFIG_NO_HZ_IDLE and keep
CONFIG_NO_HZ for compatibility. Are you ok with that? If so I'll send
a patch.
