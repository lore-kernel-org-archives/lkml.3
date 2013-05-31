Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3EaHnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:43:15 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46656 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3EaHnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <1369954895-20464-9-git-send-email-andi@firstfloor.org>
References: <1369954895-20464-1-git-send-email-andi@firstfloor.org>
	<1369954895-20464-9-git-send-email-andi@firstfloor.org>
Date: Fri, 31 May 2013 09:43:03 +0200
Message-ID: <CABPqkBQpWC+DnZ275mBRWL7MJn5k8Nc9d0PsZbHWXnjRqun-ag@mail.gmail.com>
Subject: Re: [PATCH 8/8] perf, x86: Enable PEBS mode automatically for
 mem-{loads,stores} v2
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 1:01 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> With the earlier patches to automatically try cpu// and add
> a precise sys attribute, we can now enable PEBS for the mem-loads,
> mem-stores events everywhere.
>
> This allows to use
>
> perf record -e mem-loads ...
>
> instead of
>
> perf record -e cpu/mem-loads/p ...
>
> Nehalem and Sandy Bridge only use precise mode == 1 as the off-by-one
> IP correction is quite expensive here (user can still override)
> On Haswell as it's basically free always use precise=2
>
I think overhead should not guide the choice here. You want to expose
a uniform behavior across CPUs as much as possible. I suggest you
use precise=2 whenever it is available. In other words, try to return
the load/store instruction address each time you can.

> Cc: eranian@google.com
> v2: Different white space
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index b1d4966..914243c 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -176,9 +176,12 @@ static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
>         EVENT_EXTRA_END
>  };
>
> -EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
> -EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
> -EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2");
> +EVENT_ATTR_STR(mem-loads, mem_ld_nhm,
> +               "event=0x0b,umask=0x10,ldlat=3,precise=1");
> +EVENT_ATTR_STR(mem-loads, mem_ld_snb,
> +               "event=0xcd,umask=0x1,ldlat=3,precise=1");
> +EVENT_ATTR_STR(mem-stores, mem_st_snb,
> +               "event=0xcd,umask=0x2,precise=1");
>
>  struct attribute *nhm_events_attrs[] = {
>         EVENT_PTR(mem_ld_nhm),
> @@ -2033,8 +2036,9 @@ static __init void intel_nehalem_quirk(void)
>         }
>  }
>
> -EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
> -EVENT_ATTR_STR(mem-stores,     mem_st_hsw,     "event=0xd0,umask=0x82")
> +EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,
> +               "event=0xcd,umask=0x1,ldlat=3,precise=2");
> +EVENT_ATTR_STR(mem-stores,     mem_st_hsw,  "event=0xd0,umask=0x82,precise=2")
>
>  static struct attribute *hsw_events_attrs[] = {
>         EVENT_PTR(mem_ld_hsw),
> --
> 1.8.1.4
>
