Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3CETV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:21:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25829 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3CETVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:21:55 -0500
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gbv-QcFlf00A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=8qTMOilz3ZcA:10 a=z6gsHLkEAAAA:8 a=Hz4M5SUGhm5sNDVxS5kA:9 a=PUjeQqilurYA:10 a=UvJCa7pecocA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362511312.31874.34.camel@gandalf.local.home>
Subject: Re: [RFC][RT][PATCH RESEND] mm: Do not use stop_machine() for
 __zone_pcp_udpate() for CONFIG_PREEMPT_RT_FULL
From: Steven Rostedt <rostedt@goodmis.org>
To: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        frank.rowand@am.sony.com, tim.bird@am.sony.com, jamshed.a@ap.sony.com,
        takuzo.ohara@ap.sony.com, amit.agarwal@ap.sony.com,
        kan.iibuchi@jp.sony.com
Date: Tue, 05 Mar 2013 14:21:52 -0500
In-Reply-To: <CAEtiSatJh-FpoMAWykPBaJgwOy6d6qhhdH-jLGw8ZFkiKRXpMQ@mail.gmail.com>
References: <CAEtiSauEdKP3Jsi_O6Q=yc9AWkSKDvNrLe0faicQWJGqdKxLwg@mail.gmail.com>
	 <CAEtiSatJh-FpoMAWykPBaJgwOy6d6qhhdH-jLGw8ZFkiKRXpMQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 00:10 +0530, Aaditya Kumar wrote:
> The code path of __zone_pcp_update() has following locks, which in
> CONFIG_PREEMPT_RT_FULL=y are rt-mutex.
>   - pa_lock locked by cpu_lock_irqsave()
>   - zone->lock locked by free_pcppages_bulk()
> 
> Since __zone_pcp_update() is called from stop_machine(), so with
> CONFIG_PREEMPT_RT_FULL=y
> we get following backtrace when __zone_pcp_update() is called during
> memory hot plugging while
> doing heavy file I/O.
> 
> stop_machine() may not be required for calling __zone_pcp_update()

"may not be required" is not a technical sufficient reason for a change.

Why is this called from stop_machine() in mainline, and what exactly
makes it "OK" to not use it in PREEMPT_RT? Just because the routine uses
mutexes doesn't mean that its safe.

Actually, spinlocks are meaningless when used in stop_machine(), thus a
question can be made, why is it taking spinlocks in a stop_machine()
routine in the first place. As stop_machine() will stop all other CPUs
from running there should not be any need for spinlocks. Is it just
because it's using routines that are used in normal operations?

Note, stop_machine() synchronizes things outside of locks. Which means
if it's needed for mainline it is most likely needed for PREEMPT_RT as
well.

The real solution is to figure out why stop_machine() is required in the
first place, and remove it completely if possible. Both from PREEMPT_RT
*and* mainline!

-- Steve

> in case of CONFIG_PREEMPT_RT_FULL=y as acquiring pa_lock in __zone_pcp_update()
> should be sufficient to isolate pcp pages and to setup per cpu pagesets.
> 
> 
> The backtrace that this patch fixes:
>  BUG: scheduling while atomic: migration/0/7/0x00000002
>  Modules linked in: v2p
>  Backtrace:
>  [<800111a0>] (dump_backtrace+0x0/0x10c) from [<802d7b7c>]
> (dump_stack+0x18/0x1c)
>   r6:80c8fc28 r5:80c8f9a0 r4:00000000 r3:60000013
>  [<802d7b64>] (dump_stack+0x0/0x1c) from [<8001e81c>] (__schedule_bug+0x64/0x74)
>  [<8001e7b8>] (__schedule_bug+0x0/0x74) from [<802d7fa0>]
> (__schedule+0x68/0x604)
>   r4:8051bf00 r3:00000000
>  [<802d7f38>] (__schedule+0x0/0x604) from [<802d8a78>] (schedule+0x98/0xbc)
>  [<802d89e0>] (schedule+0x0/0xbc) from [<802d9e14>]
> (rt_spin_lock_slowlock+0x168/0x240)
>   r4:805228f4 r3:00000000
>  [<802d9cac>] (rt_spin_lock_slowlock+0x0/0x240) from [<802da234>]
> (rt_spin_lock+0x10/0x14)
>  [<802da224>] (rt_spin_lock+0x0/0x14) from [<8008694c>]
> (__zone_pcp_update+0x58/0xd8)
>  [<800868f4>] (__zone_pcp_update+0x0/0xd8) from [<800603ec>]
> (stop_machine_cpu_stop+0xb0/0x104)
>  [<8006033c>] (stop_machine_cpu_stop+0x0/0x104) from [<80060200>]
> (cpu_stopper_thread+0xd4/0x188)
> 
> 
> Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
> 
> ---
>  mm/page_alloc.c |    4         4 +     0 -     0 !
>  1 file changed, 4 insertions(+)
> 
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3868,7 +3868,11 @@ static int __zone_pcp_update(void *data)
> 
>  void zone_pcp_update(struct zone *zone)
>  {
> +#ifndef CONFIG_PREEMPT_RT_FULL
>         stop_machine(__zone_pcp_update, zone, NULL);
> +#else
> +       __zone_pcp_update(zone);
> +#endif
>  }
> 
>  static __meminit void zone_pcp_init(struct zone *zone)


