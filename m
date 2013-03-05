Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3CEWjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:39:55 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55315 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3CEWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:39:52 -0500
Message-ID: <51367433.4060408@suse.cz>
Date: Tue, 05 Mar 2013 23:39:47 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ilya Zykov <ilya@ilyx.ru>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 00/23] ldisc fixes
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>  <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>  <20130305205033.GA5771@linutronix.de> <1362522029.18799.145.camel@thor.lan>
In-Reply-To: <1362522029.18799.145.camel@thor.lan>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 11:20 PM, Peter Hurley wrote:
> [--cc Alan Cox]
> 
> On Tue, 2013-03-05 at 21:50 +0100, Sebastian Andrzej Siewior wrote:
>> * Peter Hurley | 2013-02-05 15:20:15 [-0500]:
>>
>>>  Please re-test with your dummy_hcd/g_nokia testcase, although
>>>  I'm not convinced that usb gadget is using tty_hangup() appropriately.
>>>  tty drivers use this for async carrier loss coming from an IRQ
>>>  which will be disabled if the tty has been shutdown. Does gserial
>>>  prevent async hangup to a dead tty in a similar fashion?
>>
>> Not sure I understood. tty_hangup() is only called from within
>> gserial_disconnect() which calls right after usb_ep_disable(). After
>> usb_ep_disable() no further serial packets can be received until the
>> endpoints are re-enabled. This happens in gserial_connect().
> 
> That's why I asked. There are two potential issues:
> 
> First, tty_hangup() is asynchronous -- ie., it returns immediately. It
> does not wait for the tty device to actually perform the hangup. So if
> the gadget layers start cleanup immediately after, expecting that they
> won't get a flurry of tty calls, that would be bad.

Sorry, I missed what driver is this?

> tty_vhangup() is synchronous -- ie., you wait while it cleans up. This
> is what the usb serial core does on it's disconnect() method. But I
> didn't research further if the circumstances were the same.

Even when tty_vhangup returns, it does not guarantee a closed tty. And
it also does not guarantee that any of tty->ops won't be called. The
latter is true only for devices that can be consoles. (For those,
file->ops are not redirected.) In that case one needs to wait for
port->count to become 0.

-- 
js
suse labs
