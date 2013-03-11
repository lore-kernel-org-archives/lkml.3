Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3CKI25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:28:57 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62999 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3CKI24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:28:56 -0400
Date: Mon, 11 Mar 2013 09:28:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH]Skip unnecessary WARN_ON in panic case
Message-ID: <20130311082851.GC12742@gmail.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF5CB8B@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF5CB8B@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Seiji Aguchi <seiji.aguchi@hds.com> wrote:

> [Problem]
> 
> When kernel panics, unnecessary WARN_ON() may be printed after panic messages in a following scenario.
>  - A panicked cpu stops other cpus via smp_send_stop().
>  - Other cpus turn to be offline in stop_this_cpu().
>  - The panicked cpu enables interrupt.
>  - native_smp_send_reschedule() is called via a timer interrupt on the panicked cpu.
>  - The panicked cpu tries to send a reschedule IPI to other cpus
>  - The panicked cpu hits WARN_ON() because other cpus have already been offlined.
> 
> If an user has just a VGA console, panic messages may be missed because 
> they are floated outside a screen due to messages of the WARN_ON(). In 
> this case, it could be difficult to investigate the reason why a kernel 
> panicked.

So it appears the problem occurs because the other CPUs are not offlined 
correctly, and still have pending work which may generate wakeup IPIs to 
them?

The fix would be to either offline them properly - or, if we don't want to 
do that to keep panicking simple, why do we mark them offline? They aren't 
really offline in a proper way.

Thanks,

	Ingo
