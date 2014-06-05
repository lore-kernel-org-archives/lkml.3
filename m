Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaFEJ3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:29:36 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59960 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaFEJ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:29:34 -0400
MIME-Version: 1.0
In-Reply-To: <CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-10-git-send-email-eranian@google.com>
	<CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
Date: Thu, 5 Jun 2014 11:29:33 +0200
Message-ID: <CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Stephane Eranian <eranian@google.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 10:32 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On 4 June 2014 22:34, Stephane Eranian <eranian@google.com> wrote:
>> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>>
>> This patch adds a sysfs entry:
>>
>>         /sys/devices/cpu/ht_bug_workaround
>>
>> to activate/deactivate the PMU HT bug workaround.
>>
>> To activate (activated by default):
>>  # echo 1 > /sys/devices/cpu/ht_bug_workaround
>>
>> To deactivate:
>>  # echo 0 > /sys/devices/cpu/ht_bug_workaround
>
> If your hardware contains this erratum, why would you ever want to
> disable the workaround? Providing the user with the option of turning
> this off seems like a bad idea.
>
> I suspect that users will rarely know whether they can legitimately
> disable this.

If you know what you are doing (poweruser), then there are measurements
which works fine with the HT erratum.  This is why we have the option.

For instance if you only measure events 4x4 in system-wide mode
and you know which counters these event are going to use, you don't
need the workaround. For instance:

# perf stat -a -e r81d0,r01d1,r08d0,r20d1 sleep 5

Works well if you have a uniform workload across all CPUs.
All those events leak, but the leaks balance themselves and you
get the correct counts in the end. The advantage is that you don't
have to multiplex. With the workaround enable, this would multiplex
a lot.

But as I said, this is for experts only.

Another reason is for systems with HT disabled. It turned out to be
very difficult to determine at kernel BOOT TIME if HT was enabled
or not. Note what I said: ENABLED and not SUPPORTED. The latter is
easy to detect. The former needs some model specific code which is
quite complicated. I wish the kernel had this capability abstracted
somehow. Consequently, the workaround is always enabled. When
HT is disabled, there won't be multiplexing because there will never
be conflict, but you pay a little price for accessing the extra data
state. An init script could well detect HT is off and thus disable the
workaround altogether.

Those are the two main reasons for this control in sysfs.
