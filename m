Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3EOP1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:27:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51577 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905Ab3EOP1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:27:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Imre Deak <imre.deak@intel.com>
Subject: Re: [PATCH v2 1/8] time: add *_to_jiffies_timeout helpers to guarantee a minimum duration
Date: Wed, 15 May 2013 17:26:43 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Dong Zhu <bluezhudong@gmail.com>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com> <1368542918-8861-2-git-send-email-imre.deak@intel.com>
In-Reply-To: <1368542918-8861-2-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305151726.44017.arnd@arndb.de>
X-Provags-ID: V02:K0:6NfFJEnzOkHisCaCb9SzCwh1lvzaz9Nd8iD5jKO0V97
 22wfRQde+Ccc9ONY8YuIfmXlijvlnHLNDomyn0znMsRFatLafv
 Nu6kdsUbPON3SnOnE1liqMnV7P8DHzwak9Pi28Gryw/Hd7SAth
 qHeI/OIIrG4nnFUoPPAtb9B8iHUiOHIf34iKiZqE7VqOarHaWz
 Mz1x0CjFjlNqjECeoKsWyqBWi+i5BgR0+gvTqHXXZAkoDm0MkJ
 eu1hc3vN0fyaDrHraNdWsyg9iFF08o3kSOJmve1wrRHcvhEL5+
 cfpvpZIsqur6uvPsAXIkqmFnrG14g9nUsu08Lbv1ffOJGTLDYY
 bDQLU5T7yurE8DmIF3s4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 May 2013, Imre Deak wrote:
> The *_to_jiffies(x) macros return a jiffy value, which if used as a
> delta to wait for a specific amount of time, may result in a wait time
> that is less than x. Many callers already compensate for this by adding
> one to the returned value. Instead of having this adjustment open-coded
> at every call site add helpers that return the adjusted value. This will
> make the intention for the adjustment more explicit and also provide
> documentation for why it is needed.
> 
> Later patches will convert the currently open-coded call sites to use
> the new helpers.
> 
> Also this can serve as a basis for auditing those users of *_to_jiffies
> that most likely do the wrong thing - for example set a timeout value of
> msecs_to_jiffies(1) - and converting them to use the new helpers.
> 
> Kudos to Daniel Vetter for the idea of the new helpers.
> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>

This certainly looks like a reasonable change, but I wonder if we could take
it one step further and add milisecond based interfaces for some of those
functions that currently take a jiffies value, something like

int timer_set_msecs(struct timer_list *timer, unsigned long msecs)
{
	unsigned long j = msec_to_jiffies(msecs);
	return mod_timer(timer, min_t(msecs, MAX_JIFFY_OFFSET));
}

> +#define __define_time_to_jiffies_timeout(tname, ttype)                 \
> +unsigned long tname ## _to_jiffies_timeout(const ttype v)              \
> +{                                                                      \
> +       unsigned long j = tname ## _to_jiffies(v);                      \
> +       return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);           \
> +}                                                                      \
> +EXPORT_SYMBOL(tname ## _to_jiffies_timeout);

The macro has a few disadvantages:

* It's impossible to grep for the function or use tags if you generate
  the identifier using the macro.

* msecs_to_jiffies is what puts MAX_JIFFY_OFFSET there in the first
  place, which means you add an extra comparison here that should
  not really be needed.

	Arnd
