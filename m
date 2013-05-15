Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3EOTsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:48:40 -0400
Received: from 8bytes.org ([85.214.48.195]:53372 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab3EOTsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:48:38 -0400
Date: Wed, 15 May 2013 21:48:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add missing lock in n_tty_write()
Message-ID: <20130515194835.GK24440@8bytes.org>
References: <20130515105656.GI24440@8bytes.org>
 <5193A3B5.7010400@suse.cz>
 <20130515154753.GJ24440@8bytes.org>
 <5193D7E0.5010803@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5193D7E0.5010803@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 15 21:48:36 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5193e69423671695166302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(also adding Konrad)

On Wed, May 15, 2013 at 02:45:52PM -0400, Peter Hurley wrote:
> "space left" is not honored when OPOST is clear, so it is not protected
> in this case. IOW, tty->ops->write_room() is not called, so by-definition
> there is "space left".

Okay, so "space left" has to do with something tty-layer internal and
does not mean potential output-buffers handled by the console-drivers.

> Are you certain your stack trace takes you through this particular
> invocation of tty->ops->write()?  Could it be that the compiler has
> inlined process_output_block() into n_tty_write() and that's what your
> seeing?

I am sure that the backtrace pointed to that invocation. I looked up the
return-address from the stack-trace in the objdump and it pointed to
that line after that invocation.

> Can you attach the BUG report?
> Are you certain OPOST is cleared? (output of stty -a -F </dev/xxxx>)

Havn't checked OPOST. It is also hard to do because all I have is the
BUG and the kernel binary. I have no direct access to the machine.

> Is CONFIG_CONSOLE_POLL=y?

Will check.

> Is this happening during boot or much later?

Much later. It actually happened on a 3.2 kernel on a machine that ran
for several 100 days already. After that happened the box just rebooted
into a new kernel. I also checked the git-log from 3.2 to now and didn't
found a fix, also the code looks pretty similar so I guess the bug is
still there.

> But not the only path to __write_console().
> 
> For example, what serializes hvc_console_print() with hvc_write()
> for the same console index?

You are right, that does not look to be protected from each other. The
hvc_write() function has a spin_lock. But that does not prevent
hvc_console_print() from calling the put_chars function too.

I'll look something more into that. There is definitly a problem when
__write_console is called concurrently. I have one question about the
tty-layer: Do the console drivers have to expect parallel calls to
ops->write()?

Thanks,

	Joerg


