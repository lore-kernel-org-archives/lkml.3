Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935Ab3EOSp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:45:57 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:53865 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759800Ab3EOSp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:45:56 -0400
Message-ID: <5193D7E0.5010803@hurleysoftware.com>
Date: Wed, 15 May 2013 14:45:52 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add missing lock in n_tty_write()
References: <20130515105656.GI24440@8bytes.org> <5193A3B5.7010400@suse.cz> <20130515154753.GJ24440@8bytes.org>
In-Reply-To: <20130515154753.GJ24440@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 11:47 AM, Joerg Roedel wrote:
> On Wed, May 15, 2013 at 05:03:17PM +0200, Jiri Slaby wrote:
>> On 05/15/2013 12:56 PM, Joerg Roedel wrote:
>
>> Are you fixing any bug here? output_lock does not protect
>> tty->ops->write on the other places, not tty->ops->write.
>
> Yes, I am trying to fix a BUG_ON that triggered in
> drivers/tty/hvc/hvc_xen.c in function __write_console().  This function
> was called from the place I am patching in this fix. My current
> explanation for that BUG_ON is a race condition that comes
> from concurrent calls to that function.
>
> That is also the only explanation that makes sense because the
> __write_console() function itself makes sure that the condition can not
> hit.
>
> In the comment for the n_tty_write function there is this remark:
>
>   *      Locking: output_lock to protect column state and space left
>   *               (note that the process_output*() functions take this
>   *                lock themselves)
>
> So the space left is managed in the ->write callback and needs
> protection.

nack.

"space left" is not honored when OPOST is clear, so it is not protected
in this case. IOW, tty->ops->write_room() is not called, so by-definition
there is "space left".

Are you certain your stack trace takes you through this particular
invocation of tty->ops->write()?  Could it be that the compiler has
inlined process_output_block() into n_tty_write() and that's what your
seeing?

Can you attach the BUG report?
Are you certain OPOST is cleared? (output of stty -a -F </dev/xxxx>)
Is CONFIG_CONSOLE_POLL=y?
Is this happening during boot or much later?

> The process_output*() functions all (unless I am missing something)
> take the output_lock before calling the tty->ops->write (directly or
> indirectly).
>
> The place I patched here is the only place in n_tty_write where the
> ->write call-back is invoked directly, and it happens without taking the
> lock. I think this is a problem.

But not the only path to __write_console().

For example, what serializes hvc_console_print() with hvc_write()
for the same console index?

Regards,
Peter Hurley

