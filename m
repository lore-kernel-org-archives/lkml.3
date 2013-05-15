Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3EOFAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 01:00:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52596 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3EOFAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 01:00:02 -0400
Message-ID: <5193164E.6050400@wwwdotorg.org>
Date: Tue, 14 May 2013 22:59:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jongsung Kim <neidhard.kim@lge.com>
CC: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: PL011: add support for extended FIFO-size of PL011-r1p5
References: <007301ce375e$bcf6d6b0$36e48410$@lge.com> <5191D200.3040604@wwwdotorg.org> <01fd01ce5072$d6b9fcd0$842df670$@lge.com> <5192A692.4010700@wwwdotorg.org> <022d01ce5107$8bc668e0$a3533aa0$@lge.com>
In-Reply-To: <022d01ce5107$8bc668e0$a3533aa0$@lge.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 07:00 PM, Jongsung Kim wrote:
> Stephen Warren <swarren@wwwdotorg.org> :
>> Looking at BCM2835-ARM-Peripherals.pdf (i.e. the public documentation for
>> the BCM2835 chip), I see:
>>
>> =====
>> The UART provides:
>> * Separate 16x8 transmit and 16x12 receive FIFO memory.
>> ...
>> For the in-depth UART overview, please, refer to the ARM PrimeCell UART
>> (PL011) Revision: r1p5 Technical Reference Manual.
>> =====
>>
>> That seems to imply that not all r1p5 PL011s actually have a depth-32 FIFO.
>> Perhaps this is a configurable property of the IP block, not something that
>> all r1p5 have?
> 
> All r1p5 have 32-byte FIFO depth and it's not configurable. From the PL011
> TRM:
> 
> r1p4-r1p5	Contains the following differences in functionality:
> 		* The receive and transmit FIFOs are increased to a depth of 32.
> 		* The Revision field in the UARTPeriphID2 Register on page 3-24
> 		  bits [7:4] now reads back as 0x3.

Well, that certainly isn't true in practice. I think we should revert
this commit until we can determine what the problem is.

I validated that the periphid register in HW contains the r1p5 revision
(3), and the pcellid register does indeed contain the expected
0xb105f00d value. However, if I run the following hacky code in U-Boot
to determine the FIFO depth, it comes out as 16, which explains the
symptoms I'm seeing:

void find_fifo_depth(void)
{
	volatile u8 *uart = 0x20201000;
	int depth = 0;

	/* Wait for TX FIFO empty */
	while (!(uart[0x18] & 0x80))
		;

	/* Disable UART */
	uart[0x30] &= ~1;

	/* Push chars into TX FIFO until full */
	for (;;) {
		uart[0] = 'A' + depth;
		depth++;
		/* Done if FIFO full */
		if (uart[0x18] & 0x20)
			break;
		if (depth > 64) {
			depth = -1;
			break;
		}
	}

	/* Re-enable UART */
	uart[0x30] |= 1;

	printf("FIFO depth: %d\n", depth);
}
