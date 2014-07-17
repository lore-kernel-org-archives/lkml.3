Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbaGQXC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:02:28 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:60737 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaGQXC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <b29c17f74d39d1b9240385e7479f63f44c988b8b.1404160039.git.tony.luck@intel.com>
References: <20140630144017.2abc48ba@gandalf.local.home>
	<b29c17f74d39d1b9240385e7479f63f44c988b8b.1404160039.git.tony.luck@intel.com>
Date: Thu, 17 Jul 2014 16:02:26 -0700
Message-ID: <CA+8MBbKgHqwzLbY17-6o_Y-EULatnXgTdgn2kUhhOabELYGV6w@mail.gmail.com>
Subject: Re: [PATCH-v2] tracing: Fix wraparound problems in "uptime" tracer
From: Tony Luck <tony.luck@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        "<m.chehab@samsung.com> Xie XiuQi" <xiexiuqi@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 1:31 PM, Tony Luck <tony.luck@intel.com> wrote:
> +#else
> +       jiffy *= HZ_TO_NSEC_NUM;
> +       do_div(jiffy, HZ_TO_NSEC_DEN);
> +       return jiffy;
> +#endif

Well that didn't work either.  kernel/trace/trace_clock.c doesn't include
timeconst.h - so we fail the compile because HZ_TO_NSEC_{NUM,DEN}
aren't defined.  a #include looks dicey because timeconst.h is a generated
file up the the kernel/ level ... so getting Makefile dependencies right would
be ugly.

Do we really need to convert to nanoseconds? Couldn't we just return
jiffies:

u64 notrace trace_clock_jiffies(void)
{
       return jiffies_64 - INITIAL_JIFFIES;
}

and leave it as an exercise to userspace to interpret that?

-Tony

[Yes, this changes the UI . but there can't be any serious users
given that the existing UI only works for 1hr 11 minutes after each
boot]
