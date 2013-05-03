Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797Ab3ECRHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:07:48 -0400
Received: from smtp29.i.mail.ru ([94.100.177.89]:43288 "EHLO smtp29.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab3ECRHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:07:47 -0400
X-Greylist: delayed 10987 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 13:07:47 EDT
Message-ID: <5183FC83.8090602@list.ru>
Date: Fri, 03 May 2013 22:05:55 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jarkko Huijts <jarkko.huijts@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: ftdi_sio is slow (since Wed Oct 10 15:05:06 2012)
References: <5183D196.2080305@list.ru> <20130503163008.GA30699@kroah.com> <5183F62A.1020801@list.ru> <20130503165231.GA1966@kroah.com>
In-Reply-To: <20130503165231.GA1966@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.05.2013 20:52, Greg KH пишет:
> On Fri, May 03, 2013 at 09:38:50PM +0400, Stas Sergeev wrote:
>> 03.05.2013 20:30, Greg KH пишет:
>>> We need some way to check the chars in the buffer, is the device you are
>>> using just very slow to respond to this request?  How slow?  Do you have
>>> a test case that we can see how it is affected?
>> Greg, unfortunately, I do have nothing.
>> The customer is in CC list, so maybe he will
>> provide the test-case, but I doubt.
>>
>> Please, what are your concerns here?
>> The patch in question does this:
>> ---
>> + ret = usb_control_msg(port->serial->dev,
>> + usb_rcvctrlpipe(port->serial->dev, 0),
>> + FTDI_SIO_GET_MODEM_STATUS_REQUEST,
>> + FTDI_SIO_GET_MODEM_STATUS_REQUEST_TYPE,
>> + 0, priv->interface,
>> + buf, 2, WDR_TIMEOUT);
>> ---
>> Obviously, this is too expensive to call too frequently,
>> or am I missing something?
> Why do you think that is too expensive to call?  Does it somehow stop
> the data being sent to the device through the serial endpoints?  Is
> userspace calling this function too much slowing something else down?
No, it doesn't slow down the data transfer.
But it makes a select() call to take much longer to complete,
and the same goes to TIOCOUTQ ioctl. Yes, the app calls select()
quite too much, and it is single-threaded, too. :)

>> I asked the customer to comment out
>> tty_chars_in_buffer(tty) < WAKEUP_CHARS
>> line in n_tty.c, and he said that cured his problems,
>> so I think my guess was right.
> What exactly is the "problem" being seen?
No idea.
Well, I can make a test-case that does 1000000 select() calls
in a loop and time it. This is probably the best I can do.

>> The patch claims it only affects tcdrain() and close().
>> Its trivial to see it also affects poll(), select() and TIOCOUTQ
>> ioctl, so even from that it is already broken.
>> Why do you need a test-case for this?
> Because I don't know what the problem really is :)
Slow select() call (and other calls).
Can we just use usb_serial_generic_chars_in_buffer()
in ftdi_sio? What was the reason behind the patch at all,
why it is so importand to query TEMT? I can write some
test-case, but it would be better if I at least understand
why the patch was needed at all. I don't understand why
quering TEMT is that important.

I can code up the patch that will just stop quering TEMT,
test it with the customer and send it to you (basically, a revert
of the patch in question).
