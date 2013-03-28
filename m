Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3C1AWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:22:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41830 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382Ab3C1AWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:22:32 -0400
X-Sasl-enc: Bs/zdyxBjkfDleUK9cyWlgC6CEUgbmMsp+t06qnoAnsl 1364430151
Date: Thu, 28 Mar 2013 11:22:31 +1100
From: Robert Norris <robn@opera.com>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: All CPUs in soft lockup
Message-ID: <20130328002231.GA21119@pyro.melbourne.osa>
References: <20130327015540.GA27623@pyro.melbourne.osa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327015540.GA27623@pyro.melbourne.osa>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:55:41PM +1100, Robert Norris wrote:
> The console shows a new "BUG: soft lockup" line every few seconds

Looking closer, the whole thing starts with a _hard_ lockup.

  2013-03-26T08:33:39.921834-04:00 imap30 kernel: [185090.090328] Watchdog detected hard LOCKUP on cpu 3

(also in the logs of the other two servers I mentioned).

Looking down to where the watchdog interrupt comes in:

  2013-03-26T08:33:39.921870-04:00 imap30 kernel: [185090.090426] <<EOE>>  <IRQ>  [<ffffffff8112a5b1>] ? end_buffer_async_read+0x79/0xff

Disassembling:

  0xffffffff8112a57a <+66>:    mov    %rbx,%rdi
  0xffffffff8112a57d <+69>:    callq  0xffffffff81129265 <buffer_io_error>
  0xffffffff8112a582 <+74>:    lock orb $0x2,0x0(%rbp)
  0xffffffff8112a587 <+79>:    mov    0x0(%rbp),%rax
  0xffffffff8112a58b <+83>:    test   $0x8,%ah
  0xffffffff8112a58e <+86>:    jne    0xffffffff8112a594 <end_buffer_async_read+92>
  0xffffffff8112a590 <+88>:    ud2    
  0xffffffff8112a592 <+90>:    jmp    0xffffffff8112a592 <end_buffer_async_read+90>

That lock at +74 is presumably the offender here. Which is line 275 of fs/buffer.c:

  275                 SetPageError(page);

So another CPU has these page flags locked right now, and isn't keen to
release that lock?

I don't know how to debug this further. What's the next step?

Thanks,
Rob.
