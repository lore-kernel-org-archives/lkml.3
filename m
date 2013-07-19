Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965302Ab3GSORM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:17:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50790 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760711Ab3GSORH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:17:07 -0400
Date: Fri, 19 Jul 2013 10:17:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: backports@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Julia Lawall <julia.lawall@lip6.fr>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] backports: backport drvdata = NULL core driver fixes
In-Reply-To: <1374191339-10124-1-git-send-email-mcgrof@do-not-panic.com>
Message-ID: <Pine.LNX.4.44L0.1307191012330.1055-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013, Luis R. Rodriguez wrote:

> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> The Linux kernel had tons of code which at times cleared the
> drvdata upon probe failure or release. There are however a bunch
> of drivers that didn't clear this.
> 
> Commit 0998d063 implmented clearing this upon device_release_driver()
> and dealt with probe failure on driver_probe_device(). After this the
> kernel was cleaned up separately with *tons* of patches to remove all
> these driver specific settings given that the clearing is now done
> internally by the device core.
> 
> Instead of ifdef'ing code back in for older code where it was properly
> in place backport this by piggy backing the new required code upon the
> calls used in place. There is a small race here upon device_release_driver()
> but we can live with that theoretical race.
> 
> Due to the way we hack this backport we can't use a separate namespace
> as we have with other symbols.
> 
> mcgrof@frijol ~/linux-stable (git::master)$ git describe --contains \
> 	0998d0631001288a5974afc0b2a5f568bcdecb4d
> v3.6-rc1~99^2~14^2~17
> 
> commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> Author: Hans de Goede <hdegoede@redhat.com>
> Date:   Wed May 23 00:09:34 2012 +0200
> 
>     device-core: Ensure drvdata = NULL when no driver is bound
> 
>     1) drvdata is for a driver to store a pointer to driver specific data
>     2) If no driver is bound, there is no driver specific data associated with
>        the device
>     3) Thus logically drvdata should be NULL if no driver is bound.
> 
>     But many drivers don't clear drvdata on device_release, or set drvdata
>     early on in probe and leave it set on probe error. Both of which results
>     in a dangling pointer in drvdata.
> 
>     This patch enforce for drvdata to be NULL after device_release or on probe
>     failure.
> 
>     Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is not a very good idea.  Although setting drvdata to NULL allowed
a lot of code to be removed, it also exposed a bunch of hidden bugs --
drivers were using the drvdata value even after their remove function
returned.

Several commits have been applied to fix those bugs.  Finding and
backporting them and their dependencies will not be easy.

I suggest this patch not be applied.

Alan Stern

