Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab3APE0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 23:26:10 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:64980 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758411Ab3APE0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 23:26:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsGAG6Zu08Y1OVO/2dsb2JhbABEDoFtshaBCIIVAQEFOB4GHAEQCwsNCRYPCQMCAQIBERYeBgoDAQcCh3sBDQGnXogCChmBC4h7iwmFOwOIQoIWikOFT4ohgjBXgUE
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="212667199"
Message-ID: <50F62BEC.4060602@gmail.com>
Date: Tue, 15 Jan 2013 23:26:20 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:18.0) Gecko/20100101 Firefox/18.0 SeaMonkey/2.15
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andreas Mohr <andi@lisas.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
References: <Pine.LNX.4.44L0.1301121237570.32458-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301121237570.32458-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sat, 12 Jan 2013, Andreas Mohr wrote:
>
>> There's of course the EHCI vs. UHCI(/OHCI) duality
>> (EHCI host controller responsible for high speed transfers,
>> the other for 1.1 full speed, both serving the same port connectors).
>> So if the coordination between the two is a problem,
>> you might end up with merely full speed on a 2.0 port.
>>
>> And with drivers builtin vs. module, the init sequence/timing
>> might possibly be affected - right?
>> Perhaps this got worsened by semi-recent driver init kernel changes?
>> (AFAIR the kernel was changed to init more things in parallel,
>> for faster bootup). So maybe that affected EHCI vs. UHCI coordination timing.
> Another important change is that the EHCI driver is now split into two
> modules.  That can slow down loading and affect the timing.
>
> Alan Stern
>
My testcase is a live initramfs + squash root.
The boot logic is as stable as can be - unchanged since 2.6.2x kernels.
And it was working fine till 3.8-rc1.

The modules are insmoded in a fixed order:
usb-common, usbcore, xhci-hcd, ehci-hcd, uhci-hcd, ohci-hcd, usbhid, 
usb_storage,...

If all USB is built as modules - I get read errors from USB drives when 
accessing squash image, boot fails.
If usb-common and usbcore are built in, system seems to crawl with a 
very slow USB, but boots. That could be caused by timing between hcd 
modules.
If usb-common, usbcore and ehci-hcd are built-in, all works OK like 
"before 3.8".
I was testing on machines  without xhci or ohci hardware, so these 
drivers probably are not playing any role.
I have retried initramfs with a 1s sleep between insmods to verify if it 
is timing - still the same read errors - so the main issue is _not_ timing.
The read errors problem is 100% reproducible for me, the blocks where 
read fails are not fixed - every (failed) boot errors start appearing in 
a bit different location.
Just selecting a differently - configured  kernel image makes the boot 
work, so it is not a problem of squash image, USB drive, squashfs driver.

Scratching my head loudly,
Woody

