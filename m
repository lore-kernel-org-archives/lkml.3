Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaGFSys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:54:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51263 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaGFSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:54:46 -0400
Message-ID: <53B99B7F.2080602@lwfinger.net>
Date: Sun, 06 Jul 2014 13:54:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [patch] iwlwifi: fix Kconfig option continuity
References: <53B9833D.4000600@lwfinger.net> <53B997D5.1060001@infradead.org>
In-Reply-To: <53B997D5.1060001@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2014 01:39 PM, Randy Dunlap wrote:
> Hi,
>
> Please use a newline every 70-72 characters.  Some email clients don't do automatic
> line wrapping -- they just make the user scroll to the right to see very long lines.
>
>
> On 07/06/2014 10:11 AM, Larry Finger wrote:
>> A problem with configuration of IWLWIFI has been bisected to commit 48e2934, where a new section was added to drivers/net/wireless/iwlwifi/Kconfig with the following code:
>>
>> # don't call it _MODULE -- will confuse Kconfig/fixdep/...
>> config IWLWIFI_OPMODE_MODULAR
>>          bool
>>          default y if IWLDVM=m
>>          default y if IWLMVM=m
>>
>> When the above section is present, 'make xconfig' fails to show a "Debugging options" menu' even though 'make menuconfig' displays correctly. despite the incorrect on-screen display, xconfig does not delete the affected info in .config after it was set by menuconfig, thus the bug only seems to affect the display in xconfig.
>>
>> Is there anything wrong with that section in iwlwifi's Kconfig, or is it a bug in xconfig?
>
> in menuconfig or nconfig:
> Notice that 'Debugging options' is not indented under iwlwifi, but listed at the
> same indent level.  That is a huge clue.
>
>
> in xconfig:
> The 'Debugging options' menu is displayed, but it's not where you expect or want
> it to be found.  Look under 'Wireless LAN' and immediately under 'Atheros Wireless Cards'
> and it says 'Debugging options' (on the left panel).  Then the debugging options are
> displayed in the right hand panel.
>
> This is a common problem.  I have made Kconfig patches for it several times.
> Here is another one.  Works for me.
>
> ---
> Fix iwlwifi options so that they all depend on IWLWIFI and are
> displayed under the iwlwifi driver instead of in other unexpected
> places.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/iwlwifi/Kconfig |   17 ++++++++---------
>   1 file changed, 8 insertions(+), 9 deletions(-)
>
> Index: lnx-316-rc3/drivers/net/wireless/iwlwifi/Kconfig
> ===================================================================
> --- lnx-316-rc3.orig/drivers/net/wireless/iwlwifi/Kconfig
> +++ lnx-316-rc3/drivers/net/wireless/iwlwifi/Kconfig
> @@ -39,9 +39,10 @@ config IWLWIFI
>   	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
>   	  module will be called iwlwifi.
>
> +if IWLWIFI
> +
>   config IWLWIFI_LEDS
>   	bool
> -	depends on IWLWIFI
>   	depends on LEDS_CLASS=y || LEDS_CLASS=IWLWIFI
>   	select LEDS_TRIGGERS
>   	select MAC80211_LEDS
> @@ -49,7 +50,6 @@ config IWLWIFI_LEDS
>
>   config IWLDVM
>   	tristate "Intel Wireless WiFi DVM Firmware support"
> -	depends on IWLWIFI
>   	default IWLWIFI
>   	help
>   	  This is the driver that supports the DVM firmware which is
> @@ -58,7 +58,6 @@ config IWLDVM
>
>   config IWLMVM
>   	tristate "Intel Wireless WiFi MVM Firmware support"
> -	depends on IWLWIFI
>   	help
>   	  This is the driver that supports the MVM firmware which is
>   	  currently only available for 7260 and 3160 devices.
> @@ -70,7 +69,7 @@ config IWLWIFI_OPMODE_MODULAR
>   	default y if IWLMVM=m
>
>   comment "WARNING: iwlwifi is useless without IWLDVM or IWLMVM"
> -	depends on IWLWIFI && IWLDVM=n && IWLMVM=n
> +	depends on IWLDVM=n && IWLMVM=n
>
>   config IWLWIFI_BCAST_FILTERING
>   	bool "Enable broadcast filtering"
> @@ -86,11 +85,9 @@ config IWLWIFI_BCAST_FILTERING
>   	  expect incoming broadcasts for their normal operations.
>
>   menu "Debugging Options"
> -	depends on IWLWIFI
>
>   config IWLWIFI_DEBUG
>   	bool "Enable full debugging output in the iwlwifi driver"
> -	depends on IWLWIFI
>   	---help---
>   	  This option will enable debug tracing output for the iwlwifi drivers
>
> @@ -115,7 +112,7 @@ config IWLWIFI_DEBUG
>
>   config IWLWIFI_DEBUGFS
>           bool "iwlwifi debugfs support"
> -        depends on IWLWIFI && MAC80211_DEBUGFS
> +        depends on MAC80211_DEBUGFS
>           ---help---
>   	  Enable creation of debugfs files for the iwlwifi drivers. This
>   	  is a low-impact option that allows getting insight into the
> @@ -123,13 +120,12 @@ config IWLWIFI_DEBUGFS
>
>   config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
>           bool "Experimental uCode support"
> -        depends on IWLWIFI && IWLWIFI_DEBUG
> +        depends on IWLWIFI_DEBUG
>           ---help---
>   	  Enable use of experimental ucode for testing and debugging.
>
>   config IWLWIFI_DEVICE_TRACING
>   	bool "iwlwifi device access tracing"
> -	depends on IWLWIFI
>   	depends on EVENT_TRACING
>   	help
>   	  Say Y here to trace all commands, including TX frames and IO
> @@ -144,4 +140,7 @@ config IWLWIFI_DEVICE_TRACING
>
>   	  If unsure, say Y so we can help you better when problems
>   	  occur.
> +
>   endmenu
> +
> +endif
>

Rabdy,

Sorry about the long lines. I thought Thunderbird was inserting a newline after 
72 characters. At least, that is what shows on my screen.

I can report that your fix does take care of the problem for me.

Thanks,

Larry


