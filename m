Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbbABJ34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:29:56 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:64132 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbbABJ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:29:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mach-rpc: ecard:  Remove some unused functions
Date: Fri, 02 Jan 2015 10:29:43 +0100
Message-ID: <1988901.x1xNE8yBZx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420134912-1742-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420134912-1742-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:b1cn/8XBImLL3eOU7wTB2EqmPdxwho++dzLUV86lzhp113MNXM3
 84ayjbiCT94MeowMtwVkwGy+XDkvxMYOTQ/sPd5mybGGSM4FTnHP2aPz8IKfhwywiDQ/j2s
 MCuTiZV9TVeGryoa3DVJ3rSDRC41EjhNDEYpgSNTQW9kUxkL8JxB4+5pWYGX9KH7TA4FjtX
 v4xOccB8wDGr1YacX91vA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 January 2015 18:55:12 Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> ecard_disablefiq() ecard_enablefiq()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Looks like a correct change to me, very nice!

However looking a bit further you will notice that after this is removed,
there is more that becomes unused:

> -void ecard_enablefiq(unsigned int fiqnr)
> -{
> -	ecard_t *ec = slot_to_ecard(fiqnr);
> -
> -	if (ec) {
> -		if (!ec->ops)
> -			ec->ops = &ecard_default_ops;
> -
> -		if (ec->claimed && ec->ops->fiqenable)
> -			ec->ops->fiqenable(ec, fiqnr);
> -		else
> -			printk(KERN_ERR "ecard: rejecting request to "
> -				"enable FIQs for %d\n", fiqnr);
> -	}
> -}
> -
> -void ecard_disablefiq(unsigned int fiqnr)
> -{
> -	ecard_t *ec = slot_to_ecard(fiqnr);
> -
> -	if (ec) {
> -		if (!ec->ops)
> -			ec->ops = &ecard_default_ops;
> -
> -		if (ec->ops->fiqdisable)
> -			ec->ops->fiqdisable(ec, fiqnr);
> -	}
> -}

These are in fact the only references to the fiqenable/fiqdisable/fiqpending
callback pointers, so it would be helpful to remove them as well, along with
the stub implementation from 

Is cppcheck something you are working on yourself, or did you pick it up
from someone else? Is it possible to get cppcheck to also find those unused
callback pointers? I assume we have more of them in other code.

	Arnd
