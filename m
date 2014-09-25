Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaIYNLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:11:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:33495 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaIYNLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:11:43 -0400
Date: Thu, 25 Sep 2014 15:11:37 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Frans Klaver <frans.klaver@xsens.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140925131137.GG19396@linutronix.de>
References: <20140912094010.GE28458@ci00147.xsens-tech.local>
 <5412C21A.8020203@linutronix.de>
 <20140912102816.GF28458@ci00147.xsens-tech.local>
 <541716DC.9020904@linutronix.de>
 <20140917102812.GA20438@ci00147.xsens-tech.local>
 <20140921204100.GA10111@linutronix.de>
 <5421A7F7.3070109@hurleysoftware.com>
 <20140924075346.GB19565@linutronix.de>
 <20140925104208.GE19396@linutronix.de>
 <5423FD14.9060604@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5423FD14.9060604@hurleysoftware.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Hurley | 2014-09-25 07:31:32 [-0400]:

>I just verified that GNU readline6 uses ioctl(TCSETSW, ...) to do the set_termios
>(which is the ioctl that libc should use for tcsetattr(TCSADRAIN)).
>
>Maybe this userspace is using a readline()-alike that has a bug by not using the
>correct tcsetattr() action?

set_termios() has an opt argument. While doing ":n" in vi I see two invocations
with "opt == 8" which stands for TCSETS.
browsing through vi's code I stumbled upon 

|static void rawmode(void)
|{
…
|    tcsetattr_stdin_TCSANOW(&term_vi);
|}
|int FAST_FUNC tcsetattr_stdin_TCSANOW(const struct termios *tp)
|{
|    return tcsetattr(STDIN_FILENO, TCSANOW, tp);
|}

and this is probably what you meant. There is also
| static void cookmode(void)
| {
|     fflush_all();
|     tcsetattr_stdin_TCSANOW(&term_orig);
| }

However I don't see __tty_perform_flush() in kernel invoked.

>Or maybe the glibc-equivalent has the bug, and tcsetattr(TCSADRAIN) is not using
>ioctl(TCSETSW)?

libc is "GNU C Library 2.20". 

>Regards,
>Peter Hurley

Sebastian
