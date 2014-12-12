Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968049AbaLLNnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:43:31 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:44868 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967866AbaLLNna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:43:30 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: soc-dapm: Fix comparison of pointers
Organization: D03
References: <1418162021-32229-1-git-send-email-linux@rasmusvillemoes.dk>
	<20141212132109.GH11764@sirena.org.uk>
X-Hashcash: 1:20:141212:broonie@kernel.org::MgKX7KZBQhd64qqS:00000000000000000000000000000000000000000000SE6
X-Hashcash: 1:20:141212:alsa-devel@alsa-project.org::4cHLVnleEPhXMQ+r:00000000000000000000000000000000003cx0
X-Hashcash: 1:20:141212:tiwai@suse.de::2JQ0iIe2p0U9fk8o:000041Qg
X-Hashcash: 1:20:141212:linux-kernel@vger.kernel.org::TIVMXpLl0yi0+wpj:000000000000000000000000000000000AXcv
Date: Fri, 12 Dec 2014 14:43:27 +0100
In-Reply-To: <20141212132109.GH11764@sirena.org.uk> (Mark Brown's message of
	"Fri, 12 Dec 2014 13:21:09 +0000")
Message-ID: <87h9x10yrk.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12 2014, Mark Brown <broonie@kernel.org> wrote:

> On Tue, Dec 09, 2014 at 10:53:41PM +0100, Rasmus Villemoes wrote:
>
>>  	if (a->reg != b->reg)
>>  		return a->reg - b->reg;
>> -	if (a->dapm != b->dapm)
>> -		return (unsigned long)a->dapm - (unsigned long)b->dapm;
>> +	if (a->dapm < b->dapm)
>> +		return -1;
>> +	if (a->dapm > b->dapm)
>> +		return 1;
>
> If we're worrying about standards conformance type stuff here this is
> also buggy since it's out of spec to compare pointers that are not part
> of the same array like this.  Casting to uintptr_t is a better fix here.

I'm not worrying about standards conformance. Casting pointers to and
from [unsigned] long is done everywhere in the kernel, and that's
fine. But subtracting ints or longs and using the sign of the result for
comparison is simply wrong. See acbbe6fbb2 (kcmp: fix standard
comparison bug) for the long story. In this case the narrowing (when
BITS_PER_LONG==64) of the result from long to int just makes it even
more wrong.

Rasmus

