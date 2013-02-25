Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab3BYKU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:20:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51128 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806Ab3BYKUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:20:54 -0500
Date: Mon, 25 Feb 2013 11:20:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130225102049.GA12067@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Zhang Rui <rui.zhang@intel.com>, Peter Feuerer <peter@piie.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
	Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
 <20130224120952.GB19609@pd.tnic>
 <1361761600.2303.12.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1361761600.2303.12.camel@rzhang1-mobl4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:06:40AM +0800, Zhang Rui wrote:
> when the temperature goes up to 50C, will the fan be turned on or not?

Right, let's first clarify this:

so we want the fan to go on when it reaches and/or exceeds the 'fanon'
temperature and to go off after it goes under the 'fanoff' temperature.
It is supposed to remain on in the [fanoff,fanon] interval.

Now, my observation from yesterday was that, if we don't do the
flattening of the abovementioned interval in acerhdf_set_cur_state() but
we simply turn on the fan if we receive state=1 and turn it off when
state=0, the fan gets turned on only for short bursts when the governor
decides it is time to throttle, i.e. the temperature in the zone is
rising and turns it off when the temperature starts to fall again. And
it would turn on the fan at lower temperatures than fanon.

But this is annoying. The main reason why this acerhdf thing was added
in the first place was to do a better fan control on those machines
because the fans are noisy. Basically, enable the fan only when really
needed - and leave it off when not because it is really annoying.

When enabled, however, leave it on longer until a safe, 'fanoff'
temperature is reached.

Am I making more sense now? Peter?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
