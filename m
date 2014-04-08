Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbaDIAMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:12:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:2011 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbaDIAMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:12:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,820,1389772800"; 
   d="scan'208";a="489493839"
Message-ID: <53446C57.5000504@intel.com>
Date: Tue, 08 Apr 2014 14:38:31 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        jslaby@suse.cz
Subject: Re: post 3.14 serial regression
References: <5343416F.8010201@sr71.net> <20140408122726.227f3da8@alan.etchedpixels.co.uk> <5344642A.2020703@sr71.net>
In-Reply-To: <5344642A.2020703@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 02:03 PM, Dave Hansen wrote:
> On 04/08/2014 04:27 AM, One Thousand Gnomes wrote:
>>> At the end, you can see that init is somehow dying.  If I revert this
>>> patch, init is happy again and doesn't die, and the serial console works
>>> like before.
>>
>> Can you check if init is getting a SIGHUP - possibly its opening the
>> device and when it goes away gets a hangup which it isn't catching ?
> 
> I do see plenty of SIGCHLDs and a heap of SIGTERMs to 'systemd-udevd',
> but no SIGHUP.  I do see a "Warning: unable to open an initial console."
> now, though.  (details far below)
> 
> I instrumented uart_remove_one_port().  It *looks* like while searching
> for a uart_port for 0x1008 (my actual port),
> serial8250_find_match_or_unused() finds 0x3e8 since 0x3e8 is
> PORT_UNKNOWN.  The new code unregisters the 0x1008 console since it
> _thinks_ it is about to re-register it.

<sigh>

Looks like this just changed the detection order so my device went from
ttyS2 to ttyS4:

# cat /proc/tty/driver/serial
serinfo:1.0 driver revision:
0: uart:16550A port:000003F8 irq:4 tx:0 rx:0 CTS|DSR|CD
1: uart:16550A port:000002F8 irq:3 tx:0 rx:0
2: uart:unknown port:000003E8 irq:4
3: uart:unknown port:000002E8 irq:3
4: uart:ST16650V2 port:00001008 irq:18 tx:0 rx:0
5: uart:ST16650V2 port:00001000 irq:19 tx:0 rx:0


