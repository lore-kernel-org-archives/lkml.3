Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab3EDIjD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 04:39:03 -0400
Received: from smtp32.i.mail.ru ([94.100.177.92]:60451 "EHLO smtp32.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab3EDIi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 04:38:58 -0400
Message-ID: <5184D6BF.5040701@list.ru>
Date: Sat, 04 May 2013 13:37:03 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jarkko Huijts <jarkko.huijts@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: ftdi_sio is slow (since Wed Oct 10 15:05:06 2012)
References: <5183D196.2080305@list.ru> <20130503163008.GA30699@kroah.com> <5183F62A.1020801@list.ru> <20130503165231.GA1966@kroah.com> <5183FC83.8090602@list.ru> <20130503171618.GA16686@kroah.com> <51840186.7000608@list.ru> <20130503203419.GA25932@kroah.com>
In-Reply-To: <20130503203419.GA25932@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

04.05.2013 00:34, Greg KH пишет:
> Don't call select for every character :)
OK, let me draw an approximate workflow of the
setup in question.
Lets say we have 3 tty devices, A, B and C.
A and B are blazingly fast, while C is a casual usb-serial
chip.
The app must establish a bidirectional relay between
A and C, making sure that the output queue on C never
exceeds some margin M. B is used for acknowledges: the
next char from A will arrive only after an acknowledge is
sent via B.

Here's what the app approximately does:
1. select() on A and C for _input only_.
2. relay the char
3. if the char was from A, send ack to B and increment
an ack counter (call that counter Q).
4. If Q>N (N is a threshold value that should be below M,
currently 14), do TIOCOUTQ ioctl to make sure C is not
overflowing, set Q to the value returned by TIOCOUTQ. If
Q still above N, stop sending acks to B and do TIOCOUTQ
periodically, until Q is below N, then resume the normal
operations.
5. goto 1

So that's the workflow, and it used to work perfectly in the
past. Now even on step 1, when select returns, there is
already a big delay. Not to speak about TIOCOUTQ, a very
funny way to query the buffer: the buffer is now entirely
flushed while we query it.
What exactly is so horrible here that it was deserved to break?
How to improve the algo? And no, we can't improve the protocol.
For instance, we can't send multiple acks and hope that multiple
chars will be received from A - the protocol cannot be changed.
Any suggestions?
