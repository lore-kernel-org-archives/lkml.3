Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaHXFH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 01:07:26 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:38875 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaHXFHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 01:07:24 -0400
Date: Sun, 24 Aug 2014 07:07:16 +0200
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andreas Mohr <andi@lisas.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140824050716.GA523@rhlx01.hs-esslingen.de>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
 <20140820051815.GA1109@core.coreip.homeip.net>
 <s5hwqa3hetu.wl-tiwai@suse.de>
 <20140820063130.GA11226@core.coreip.homeip.net>
 <s5htx57hc89.wl-tiwai@suse.de>
 <s5h4mx6rshs.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h4mx6rshs.wl-tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 01:29:03PM +0200, Takashi Iwai wrote:
> I did a quick hack and it seems working on my box.
> The patch is below.

Thanks!!

Further comments below.

I will be testing this ASAP.
> +static bool use_ktime = true;
> +module_param(use_ktime, bool, 0400);

Towards final commit, should probably add param docs on what may be switched here and why.

> +
>  /*
>   * gameport_mutex protects entire gameport subsystem and is taken
>   * every time gameport port or driver registrered or unregistered.
> @@ -76,6 +80,36 @@ static unsigned int get_time_pit(void)
>  
>  static int gameport_measure_speed(struct gameport *gameport)
>  {
> +	unsigned int i, t, tx;
> +	u64 t1, t2;
> +	unsigned long flags;
> +
> +	if (gameport_open(gameport, NULL, GAMEPORT_MODE_RAW))
> +		return 0;
> +
> +	tx = ~0;
> +
> +	for (i = 0; i < 50; i++) {
> +		local_irq_save(flags);
> +		t1 = ktime_get_ns();
> +		for (t = 0; t < 50; t++)
> +			gameport_read(gameport);
> +		t2 = ktime_get_ns();
> +		local_irq_restore(flags);
> +		udelay(i * 10);
> +		if (t2 - t1 < tx)
> +			tx = t2 - t1;

This impl is not doing the more complex t3, t2, t1 calculation
that the PIT impl is doing (likely for the uncommented purpose
of eliminating timer I/O delay from timing consideration).
Do/don't ktime/TSC impls better need such an I/O timing correction,
or are they so fast relative to gameport I/O delays
that it does not matter? (probably the case for TSC at least).


Oh, and any reason that such a speed calculation remains painfully duplicated
in both source files? That's possibly done for layering reasons,
but I'd have to analyze it further.

> +static inline u64 get_time(void)
> +{
> +	if (use_ktime) {
> +		return ktime_get_ns();
> +	} else {
> +		unsigned int x;
> +		GET_TIME(x);
> +		return x;
> +	}
> +}

It might be useful to have a first commit to introduce these helpers,
and a second commit to then add ktime support (to keep review code size
down).

Thanks,

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
