Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaFYBuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:50:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbaFYBuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:50:50 -0400
Date: Wed, 25 Jun 2014 03:50:48 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Casey Leedom <leedom@chelsio.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, tiwai@suse.de,
        chunkeey@googlemail.com, cocci@systeme.lip6.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Philip Oswald <poswald@suse.com>,
        Santosh Rastapur <santosh@chelsio.com>,
        Jeffrey Cheung <jcheung@suse.com>, David Chang <dchang@suse.com>,
        Hariprasad Shenai <hariprasad@chelsio.com>
Subject: Re: [PATCH 2/3] cxgb4: make configuration load use
	request_firmware_direct()
Message-ID: <20140625015048.GI27687@wotan.suse.de>
References: <1403649583-12707-1-git-send-email-mcgrof@do-not-panic.com> <1403649583-12707-3-git-send-email-mcgrof@do-not-panic.com> <D46B557B-AF4A-4E60-8D83-6181D406C64F@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D46B557B-AF4A-4E60-8D83-6181D406C64F@chelsio.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 03:54:44PM -0700, Casey Leedom wrote:
> [[ Hopefully this makes it through to the kernel.org lists -- I’m using the
>   Mac OS/X Mailer and it’s not clear how to force it not to use HTML format.
>   -- Casey ]]
> 
>   So does request_firmware_direct() only fail if the requested file is not
>   present on the file system or does it fail in other cases as well?

Same as before they are the same exact call with the only difference
being udev is not used as an extra helper, so it saves the extra
delay caused by udev. That's all.

>   If it’s the former, then the change to cxgb4 is fine.
> 
>   But if it’s the latter, then it’s definitely not okay.  While the driver
>   _can_ continue running without the local on-disk Firmware Configuration
>   File, that file can be used to significantly change the behavior and
>   capabilities of the adapter and is user-customizable.  If a user makes
>   changes to the local on-disk Firmware Configuration File and these are
>   randomly silently ignored this will lead to highly annoying support issues.

This just avoids udev, the request goes directly to the filesystem. The
failure will happen when the file is not present just as before, the
only difference here is skipping udev, it doesn't suffer from the extra 
60 second timeout. There's another possible failure, when
usermodehelper_read_trylock() fails but that is just as the code was before
so this change doesn't introduce that as a new false check. When that
triggers yout get a nasty WARN_ON() just as before.

One thing to note though is that the kernel firmware loader does not
log any failure to the kernel ring buffer if the firmware is not on the
filesystem, while the udev loader is a bit more chatty:

[ 2463.666120] platform fake-dev.0: Direct firmware load failed with error -2
[ 2463.666129] platform fake-dev.0: Falling back to user helper

Stuffing a print into the non-udev approach upstream seems a bit excessive
though (unless folks disagree), so if you want the driver to be a bit more
informative I think its best to place this feedback on the driver for now.

I see the driver does provide this information already though so is any
additional prints really desirable ?

        dev_info(adapter->pdev_dev, "Successfully configured using Firmware "\  
                 "Configuration File \"%s\", version %#x, computed checksum %#x\n",
                 config_name, finiver, cfcsum);   

  Luis
