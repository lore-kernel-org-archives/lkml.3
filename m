Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3EOXKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 19:10:48 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:41974 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567Ab3EOXKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 19:10:47 -0400
Message-ID: <519415F3.6060103@hurleysoftware.com>
Date: Wed, 15 May 2013 19:10:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add missing lock in n_tty_write()
References: <20130515105656.GI24440@8bytes.org> <5193A3B5.7010400@suse.cz> <20130515154753.GJ24440@8bytes.org> <5193D7E0.5010803@hurleysoftware.com> <20130515194835.GK24440@8bytes.org>
In-Reply-To: <20130515194835.GK24440@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 03:48 PM, Joerg Roedel wrote:
> (also adding Konrad)
>
> On Wed, May 15, 2013 at 02:45:52PM -0400, Peter Hurley wrote:
>> "space left" is not honored when OPOST is clear, so it is not protected
>> in this case. IOW, tty->ops->write_room() is not called, so by-definition
>> there is "space left".
>
> Okay, so "space left" has to do with something tty-layer internal and
> does not mean potential output-buffers handled by the console-drivers.

Well, "space left" does mean 'potential output-buffers'.  However,
without OPOST, there is no output flow control as implemented through
the write_room() method. The driver is expected to write as much as
it can and return how much it wrote.

>> Are you certain your stack trace takes you through this particular
>> invocation of tty->ops->write()?  Could it be that the compiler has
>> inlined process_output_block() into n_tty_write() and that's what your
>> seeing?
>
> I am sure that the backtrace pointed to that invocation. I looked up the
> return-address from the stack-trace in the objdump and it pointed to
> that line after that invocation.

Ok.

But that implies that OPOST has been cleared (termios changed) which
doesn't really make sense for a console, which is why I asked.

>> Can you attach the BUG report?
>> Are you certain OPOST is cleared? (output of stty -a -F </dev/xxxx>)
>
> Havn't checked OPOST. It is also hard to do because all I have is the
> BUG and the kernel binary. I have no direct access to the machine.
>
>> Is CONFIG_CONSOLE_POLL=y?
>
> Will check.
>
>> Is this happening during boot or much later?
>
> Much later. It actually happened on a 3.2 kernel on a machine that ran
> for several 100 days already. After that happened the box just rebooted
> into a new kernel. I also checked the git-log from 3.2 to now and didn't
> found a fix, also the code looks pretty similar so I guess the bug is
> still there.
>
>> But not the only path to __write_console().
>>
>> For example, what serializes hvc_console_print() with hvc_write()
>> for the same console index?
>
> You are right, that does not look to be protected from each other. The
> hvc_write() function has a spin_lock. But that does not prevent
> hvc_console_print() from calling the put_chars function too.
>
> I'll look something more into that. There is definitly a problem when
> __write_console is called concurrently.

Agreed. Those functions look written for single-producer/single-consumer
i/o model. (That's why I asked about CONFIG_CONSOLE_POLL=y as well because
that doesn't look thread-safe either).

> I have one question about the
> tty-layer: Do the console drivers have to expect parallel calls to
> ops->write()?

Just to be clear here: there's a difference between a console driver
and a tty driver.

The console driver's write() method is serialized with the global
console_lock() so parallel console writes are not possible.

No such guarantee exists for the tty driver write() method, although it
probably wouldn't be difficult to provide that guarantee (since the
line discipline write() is already serialized by tty->atomic_write_lock).

Regards,
Peter Hurley



