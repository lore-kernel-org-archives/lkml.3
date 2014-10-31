Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbaJaJnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:43:21 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59433 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbaJaJnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:43:18 -0400
Message-ID: <545359AB.8070503@linaro.org>
Date: Fri, 31 Oct 2014 09:43:07 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Frank Rowand <frank.rowand@sonymobile.com>
Subject: Re: [PATCH 2/2] tty: serial: msm: Support sysrq on uartDM devices
References: <1414606478-13709-1-git-send-email-sboyd@codeaurora.org> <1414606478-13709-3-git-send-email-sboyd@codeaurora.org> <54522163.8030408@linaro.org> <20141031064130.GG12469@codeaurora.org>
In-Reply-To: <20141031064130.GG12469@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/14 06:41, Stephen Boyd wrote:
> On 10/30, Daniel Thompson wrote:
>> On 29/10/14 18:14, Stephen Boyd wrote:
>>> +		r_count = min_t(int, count, sizeof(buf));
>>> +
>>> +		for (i = 0; i < r_count; i++) {
>>> +			char flag = TTY_NORMAL;
>>>  
>>> -		/* TODO: handle sysrq */
>>> -		tty_insert_flip_string(tport, buf, min(count, 4));
>>> -		count -= 4;
>>> +			if (msm_port->break_detected && buf[i] == 0) {
>>> +				port->icount.brk++;
>>> +				flag = TTY_BREAK;
>>> +				msm_port->break_detected = false;
>>> +				if (uart_handle_break(port))
>>> +					continue;
>>> +			}
>>> +
>>> +			if (!(port->read_status_mask & UART_SR_RX_BREAK))
>>> +				flag = TTY_NORMAL;
>>
>> flag is already known to be TTY_NORMAL.
> 
> Huh? If we detected a break we would set the flag to TTY_BREAK
> and if uart_handle_break() returned 0 (perhaps sysrq config is
> diasbled) then we would get down here, and then we want to reset
> the flag to TTY_NORMAL if the read_status_mask bits indicate that
> we want to skip checking for breaks. Otherwise we want to
> indicate to the tty layer that it's a break character.

Agreed. Sorry for noise.

It now reaches the level of silly quibble (meaning I won't bother to
raise the issue again if there is a v2 patch) but perhaps updating the
flag after the continue would be easier to read.


>>> +
>>> +			spin_unlock(&port->lock);
>>
>> Is it safe to unlock at this point? count may no longer be valid when we
>> return.
> 
> Can you explain further? If it actually isn't valid something
> needs to be done. I believe other serial drivers are doing this
> sort of thing though so it doesn't seem that uncommon (of course
> those drivers could also be broken I suppose).

Calling spin_unlock() means we are allow code to alter the state of the
UART. In particular the subsequent call to uart_handle_sysrq_char() can
make significant changes to the FIFO state (by calling the poll_char
functions). Given count is shadowing the FIFO state, when we retake the
lock I think it is possible for count to no longer be valid.


> 
>>
>>
>>> +			sysrq = uart_handle_sysrq_char(port, buf[i]);
>>> +			spin_lock(&port->lock);
>>> +			if (!sysrq)
>>> +				tty_insert_flip_char(tport, buf[i], flag);
>>
>> flag has a constant value here.
>>
> 

