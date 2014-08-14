Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaHNCdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:33:22 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:47068 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaHNCdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:33:21 -0400
Message-ID: <53EC1FEA.5070907@gmail.com>
Date: Wed, 13 Aug 2014 19:33:14 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH to be tested] serial: msm_serial: add missing sysrq handling
References: <53E2C573.7090709@gmail.com> <53EAB01B.5030102@codeaurora.org>
In-Reply-To: <53EAB01B.5030102@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/2014 5:23 PM, Stephen Boyd wrote:
> On 08/06/14 17:16, Frank Rowand wrote:
>> Stephen,
>>
>> Can you test this patch on v 1.3 hardware?  It works on my v 1.4.
>>
>> If you use kdmx2, the way to send a break is '~B'.  The previous
>> key pressed must be <enter> for the '~' escape to be recognized.
>>
>> Thanks!
>>
>> -Frank
>>
>>
>>
>> From: Frank Rowand <frank.rowand@sonymobile.com>
>>
>> Add missing sysrq handling to msm_serial.
>>
>> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
>>
>> ---
> 
> It works but I have questions.
> 
>>  drivers/tty/serial/msm_serial.c |   26 +++++++++++++++++++++-----
>>  1 file changed, 21 insertions(+), 5 deletions(-)
>>
>> Index: b/drivers/tty/serial/msm_serial.c
>> ===================================================================
>> --- a/drivers/tty/serial/msm_serial.c
>> +++ b/drivers/tty/serial/msm_serial.c
>> @@ -126,6 +126,8 @@ static void handle_rx_dm(struct uart_por
>>  
>>  	while (count > 0) {
>>  		unsigned int c;
>> +		unsigned char *cp;
>> +		int res;
>>  
>>  		sr = msm_read(port, UART_SR);
>>  		if ((sr & UART_SR_RX_READY) == 0) {
>> @@ -135,15 +137,29 @@ static void handle_rx_dm(struct uart_por
>>  		c = msm_read(port, UARTDM_RF);
>>  		if (sr & UART_SR_RX_BREAK) {
>>  			port->icount.brk++;
>> -			if (uart_handle_break(port))
>> +			if (uart_handle_break(port)) {
>> +				count -= 1;
>>  				continue;
>> +			}
> 
> This looks wrong. If it's a break then I think the fifo takes in a break
> character indicated by all zeros. We could possibly have 3 other
> characters after it in the fifo, or maybe 2 characters in front of it,
> or it could be 30 characters in. We can change this behavior by setting
> a bit in the MR2 register so that the all zero character doesn't enter
> the fifo. The same goes for the parity and frame error conditions, we
> can drop those characters too.
> 
> I asked the designers how we're supposed to deal with a break in the
> middle of the fifo and they recommended using the start/stop rx break
> interrupts. Unfortunately, I don't think we can rely on the interrupts
> being distinct so that might not work (but see attached patch). There's
> also a break interrupt that triggers on the start and stop rx break
> events. I don't know how this is useful either because we might get two
> interrupts or we might get one.
> 
> So perhaps we need to scan through the 4 characters for a zero character
> when the SR_RX_BREAK bit it set? The second diff does that.
> 
> Add another twist with port->read_status_mask. I guess that's there to
> make it so that break characters still enter the tty layer? Is there any
> documentation on this stuff? I'm lost on what the tty layer expects.

< snip >

Yep, the whole break in the middle of a fifo is interesting.  If I understand
correctly, there is not enough information to determine where in the byte
stream the break actually occurred.  If interrupts were not disabled for any
length of time, then it was probably after all of the characters in the fifo.
But I don't like to depend on winning races.  As you noted, finding a \0 in
the fifo is likely the location in the byte stream where the break occurred.
But \0 is also valid data.

I read through the two alternate patches that you attached and read some tty
layer stuff.  Your patches look like better code than my original code, and
also leave less cruft in the input stream when stress tested.  One stress
test that I have not attempted to create is to hold off processing the break
until after more character have entered the fifo.

The patches you sent are a little hard to read since they modify further code
that my patch modified.  So I have redone your patches, as if my patch was
not previously applied.  Hopefully I did not make any mistakes there.  I will
reply to this email with each of your redone patches.

I do not have a strong preference between the two alternatives you provided,
without digging deeper into the tty layer, which I won't have time for in
the next week.  Both alternatives improve the break handling (leave less
cruft in the input stream when stress tested than before applying the
patches).  Both alternatives support sysrq in my testing.

If you do not want to submit either of your alternatives, I can dig into
this again in a couple weeks.

Thanks!

-Frank

