Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbaDJDCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:02:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59105 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaDJDB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:01:58 -0400
Date: Thu, 10 Apr 2014 04:01:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: core: Fix Sparse incompatible types warning
Message-ID: <20140410030150.GC18016@ZenIV.linux.org.uk>
References: <1397028108-10976-1-git-send-email-k.kozlowski@samsung.com>
 <5345279F.6070005@metafoo.de>
 <1397041934.11424.2.camel@AMDC1943>
 <53452F67.3060400@metafoo.de>
 <20140409202520.GQ6518@sirena.org.uk>
 <5345AD8B.5050306@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5345AD8B.5050306@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:28:59PM +0200, Lars-Peter Clausen wrote:

> I had a look at the sparse code and the problem is that it sets the
> default return type of sizeof according to the type of the host it
> was compiled on (either unsigned int or unsigned long). It can be
> overwritten by switches like -m32, but of course wont work when
> cross compiling. So if your host system is 64bit, but your target
> system is 32bit you'll get that warning.

Not that simple.  First of all, you *need* to tell sparse what target
to expect; size_t is the least of your troubles - sizeof(long) has
far more widespread impact.  If you don't get -m64 or -m32 in CFLAGS
(and on quite a few cross-builds you get it, simply because the target
is biarch and gcc itself needs to know what to generate), you need
to set it in CHECKFLAGS, along with other target-specific things.
Example:
arch/ia64/Makefile:21:CHECKFLAGS        += -m64 -D__ia64=1 -D__ia64__=1 -D_LP64 -D__LP64__

With the defaults being what they are (since commit 7aa79f "Adding default for
m64/m32 handle"), we probably need explicit -m32 in CHECKFLAGS for a bunch
of 32bit targets.  Defaults are iffy, BTW - it's not even "do as host does",
it's "64bit if the host is amd64, 32bit otherwise" ;-/

Again, CHECKFLAGS need to be set; that's normally done in arch/*/Makefile.

