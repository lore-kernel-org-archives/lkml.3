Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaAIHIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:08:38 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42714 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaAIHIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:08:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAJjB1q+0cMqGRX8e5ssvvvo1pSw4KY7n38vWOh-PnE8GRC2Pug@mail.gmail.com>
References: <CAJjB1qLBoXA_XeEV+qU6pi0JVS+==kVA7mEDuAufrYup3htU2g@mail.gmail.com>
 <1389176916-6114-1-git-send-email-nicolas.ferre@atmel.com> <CAJjB1q+0cMqGRX8e5ssvvvo1pSw4KY7n38vWOh-PnE8GRC2Pug@mail.gmail.com>
From: Mark Roszko <mark.roszko@gmail.com>
Date: Thu, 9 Jan 2014 02:08:14 -0500
Message-ID: <CAJjB1qJez363RAaNg1bzE3QTsaGDFfAqOJux=VttNXCyaQTy3A@mail.gmail.com>
Subject: Re: [RFC PATCH] tty/serial: at91: disable uart timer at start of shutdown
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Zhao, Leilei" <leilei.zhao@atmel.com>,
        Mark Deneen <mdeneen@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to sumarize the bug after poking before the patch:
   systemd calls open/close on /dev/ttyS0 per line
   atmel_shutdown executes on close
   uart_timer_callback may fire during shutdown before timer is killed
   tasklet gets scheduled after tasklet_kill
   atmel_shutdown returns back to uart_close
dice roll:
   if the tasklet executes before uart_close kills the tty references,
the kernel is fine           <--- I saw this happening more often than
panics, around once every 3 resets
   if the tasklet executes after uart_close kills the tty references, it panics

I tested the patch by old fashion way of manual board resets with a
total of 70 resets each on two individual SAMA5D34-EK boards I have in
my possession programmed with the same patched kernel image and
rootfs. They did not panic once with the patch applied. Typically
before the patch the panic would occur around once every 10 resets if
not more often to the point it occured for 4 resets straight.

I have been trying to automate the testing, even If I make sure
nothing is using ttyS0 and then run a program that spams open()
writev() and close() (systemd uses the syscalls) to print messages, it
will never panic so I'm possibly misunderstanding how the driver
startup/shutdown ops get triggered(which should just be open/close
respectively) or variable length of messages from systemd and timing
between messages contributes to being unlucky and having the timer
fire at the wrong time.

But from manual testing I'm pretty confident the bug is fixed.
