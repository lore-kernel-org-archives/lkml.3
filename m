Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936494Ab3DRS0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:26:09 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:50968 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077Ab3DRS0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:26:07 -0400
Message-ID: <51703ABE.5080104@akamai.com>
Date: Thu, 18 Apr 2013 14:26:06 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: racy jump label users
References: <20130322195551.GQ19692@tassilo.jf.intel.com>
In-Reply-To: <20130322195551.GQ19692@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Agreed. However, other users of 'static_key_enabled()', provide their own
locking. For example, in kernel/tracepoint.c, 'static_key_enabled()',
relies on
the tracepoints_mutex. Were there any other users that are problematic?

I agree a 'setstate' would be nice. Maybe something like:

static_key_slow_set_true();
static_key_slow_set_false();

Thanks,

-Jason

On 03/22/2013 03:55 PM, Andi Kleen wrote:
> Jason,
>
> I noticed that a lot of the jump label users are racy,
> because they implement something like this
>
> static void sched_feat_disable(int i)
> {
>         if (static_key_enabled(&sched_feat_keys[i]))
>                 static_key_slow_dec(&sched_feat_keys[i]);
> }
>
> static void sched_feat_enable(int i)
> {
>         if (!static_key_enabled(&sched_feat_keys[i]))
>                 static_key_slow_inc(&sched_feat_keys[i]);
> }
>
> with no extra locking, controlled by sysfs. If two
> CPUs do this in parallel the reference can be set multiple
> times, which gives very unexpected semantics for a sysfs boolean.
>
> Most likely you need a static_key_slow_setstate()
> that does the check and set inside the jump label lock.
>
> I understand that for inside kernel use reference
> counts are the right semantics, but they are not so
> good for sysfs interfaces.
>
> -Andi
>

