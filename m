Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3CRPZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:25:20 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:44129 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3CRPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:25:16 -0400
Date: Mon, 18 Mar 2013 08:26:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Arnd Bergmann <arnd@arndb.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [rttest] WARNING: at drivers/base/core.c:569 device_create_file()
Message-ID: <20130318152631.GC3249@kroah.com>
References: <20130318135234.GA31564@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318135234.GA31564@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:52:34PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is

Adding the owners of the kernel/rtmutext-tester.c file.

> 
> commit 8f46baaa7ec6cd0851794020b31958e64679dd26
> Author: Felipe Balbi <balbi@ti.com>
> Date:   Wed Feb 20 10:31:42 2013 +0200
> 
>     base: core: WARN() about bogus permissions on device attributes
>     
>     Whenever a struct device_attribute is registered
>     with mismatched permissions - read permission without
>     a show routine or write permission without store
>     routine - we will issue a big warning so we catch
>     those early enough.
>     
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Judging from the dmesg, CC the rttest developers for possible fixes.
> 
> [   11.581068] bus: 'rttest': add device rttest0
> [   11.581813] ------------[ cut here ]------------
> [   11.582568] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:569 device_create_file+0x5a/0xa0()
> [   11.584035] Write permission without 'store'
> [   11.584793] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc2-next-20130318 #21
> [   11.585902] Call Trace:
> [   11.586318]  [<8102d888>] warn_slowpath_common+0x68/0xa0
> [   11.587146]  [<8151b77a>] ? device_create_file+0x5a/0xa0
> [   11.587982]  [<8151b77a>] ? device_create_file+0x5a/0xa0
> [   11.588820]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
> [   11.589618]  [<8151b77a>] device_create_file+0x5a/0xa0
> [   11.590523]  [<81081faa>] init_rttest+0xaa/0x150

Turns out that the sysfs attributes this function (init_rttest()) is
creating, isn't correct.  The "command" file is mode 0600, yet has no
read function, and the "status" file is the same mode, with no write
function.  These should be fixed, which is what the patch from Felipe is
pointing out.

Don't shoot the messenger :)

thanks,

greg k-h
