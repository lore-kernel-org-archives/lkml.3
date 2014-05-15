Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaEOLGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:06:42 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56649 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaEOLGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:06:39 -0400
Message-ID: <53749FB2.3000206@linaro.org>
Date: Thu, 15 May 2014 12:06:26 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
CC: patches@linaro.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, Jiri Slaby <jslaby@suse.cz>,
        Kumar Gala <galak@kernel.crashing.org>,
        Pantelis Antoniou <panto@intracom.gr>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Joe Schultz <jschultz@xes-inc.com>,
        Loic Poulain <loic.poulain@intel.com>,
        Kyle McMartin <kyle@infradead.org>,
        Stephen Warren <swarren@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 1/4] serial: core: Consistent LF handling for poll_put_char
References: <1400079335-32125-1-git-send-email-daniel.thompson@linaro.org> <1400079335-32125-2-git-send-email-daniel.thompson@linaro.org> <537386D7.4060407@windriver.com>
In-Reply-To: <537386D7.4060407@windriver.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/14 16:08, Jason Wessel wrote:
> On 05/14/2014 09:55 AM, Daniel Thompson wrote:
>> The behaviour of the UART poll_put_char infrastructure is inconsistent
>> with respect to linefeed conversions. This in turn leads to difficulty
>> using kdb on serial ports that are not also consoles
>> (e.g. console=ttyAMA0,115200 kgdboc=ttyAMA1,115200).
>>
>> The following drivers automatically convert '\n' to '\r\n' inside their
>> own poll functions but the remaining seventeen do not:
>>
>>     serial8250, cpm, pch_uart, serial_pxa, serial_txx9,
>>
>> This can be made fully consistent but performing the conversion in
>> uart_poll_put_char(). A similar conversion is already made inside
>> uart_console_write() but it is optional for drivers to use this
>> function. Fortunately we can be confident the translation is safe
>> because the (very common) 8250 already does this translation.
> 
> 
> I'll have to take a look at some of the other drivers. If all the
> instances of the function calls are going to coded per driver, it might
> make more sense to add variable to struct uart_port, vs changing the
> number of arguments to uart_poll_put_char. And then the default can
> simply be coded in the struct initialization to the most common need.

I'm proposing a very simply approach: unconditionally make all serial
drivers behave like the 8250.

Detailed reasoning is:

1. Making the polled serial drivers behave consistently is good for
   transferring mainstream testing to less commonly used UARTs,

2. The 8250 gets best test coverage so it is probably the best
   behaviour to standardize on,

3. kdb normally sends characters to the user using console I/O
   rather than polled I/O and almost all serial drivers automatically
   convert linefeeds in the console I/O,

4. kgdb never generates a linefeed character. If it did kgdb would not
   currently work on 8250 UARTs (its true that I have assumed, whilst
   reasoning about potential regressions, that is does).

To be absolutely sure of #4 I did a full code review this morning and
confirmed that all code that sends arbitrary data to the gdbserver
converts the raw data to hex first. Note also that if, in the future,
kgdb does ever implement the "modern" gdbserver commands that utilize
raw 8-bit data it would still be possible for kgdb to escape linefeeds
to ensure arbitrary binary data can be safely transferred.


Daniel.

