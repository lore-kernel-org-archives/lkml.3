Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3H1SDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:03:49 -0400
Received: from a194-81.smtp-out.amazonses.com ([199.255.194.81]:29917 "EHLO
	a194-81.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047Ab3H1SDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:03:46 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 14:03:46 EDT
Date: Wed, 28 Aug 2013 17:54:24 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [guv v2 23/31] tile: Replace __get_cpu_var uses
In-Reply-To: <521E312C.2050004@tilera.com>
Message-ID: <00000140c60fe2a0-aff878d7-06b3-4fe8-b97f-b319183f3f52-000000@email.amazonses.com>
References: <20130826204351.725357339@linux.com> <00000140bc69acdb-3b2967b0-e224-424b-ad08-973515704be6-000000@email.amazonses.com> <521BD523.3040706@tilera.com> <00000140c03f13d6-07480caf-b5b0-440b-af95-04878ee9f46c-000000@email.amazonses.com>
 <521E312C.2050004@tilera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013, Chris Metcalf wrote:

> Taken into the tile tree, with one extra change; in
> arch/tile/kernel/messaging.c, using "__this_cpu_read(msg_state)"
> generated warnings ("'pscr_ret__.opaque[1u]' is used uninitialized in
> this function", etc), since msg_state is a struct, so I changed it to be
> "*__this_cpu_ptr(&msg_state)".  Interrupts are disabled here so
> preemption is not a concern.

Well yes. __this_cpu_read can only be used to read scalars. If you want to
transfer a struct then memcpy needs to be used (or the compiler can do
that for you like above).

> In addition, I applied the following commit to clean up the remaining
> uses that are currently only being carried in the linux-tile tree.

You are going to merge these changes right? I can drop the tile patch from
my series?


One small issue below:

> diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
> index a7a41a1..30c2c34 100644
> --- a/arch/tile/kernel/time.c
> +++ b/arch/tile/kernel/time.c
> @@ -286,7 +286,7 @@ static int _set_clock_rate_barrier;
>  static int _set_clock_rate(void *arg)
>  {
>         struct _set_clock_rate_args *args = arg;
> -       struct clock_event_device *evt = &__get_cpu_var(tile_timer);
> +       struct clock_event_device *evt = get_cpu_ptr(&tile_timer);
					^^^^ this_cpu_ptr


