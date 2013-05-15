Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab3EOPr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:47:57 -0400
Received: from 8bytes.org ([85.214.48.195]:53120 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111Ab3EOPr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:47:56 -0400
Date: Wed, 15 May 2013 17:47:53 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add missing lock in n_tty_write()
Message-ID: <20130515154753.GJ24440@8bytes.org>
References: <20130515105656.GI24440@8bytes.org>
 <5193A3B5.7010400@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5193A3B5.7010400@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 15 17:47:54 2013
X-DSPAM-Confidence: 0.9984
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5193ae2a23671844720689
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 05:03:17PM +0200, Jiri Slaby wrote:
> On 05/15/2013 12:56 PM, Joerg Roedel wrote:

> Are you fixing any bug here? output_lock does not protect
> tty->ops->write on the other places, not tty->ops->write.

Yes, I am trying to fix a BUG_ON that triggered in
drivers/tty/hvc/hvc_xen.c in function __write_console().  This function
was called from the place I am patching in this fix. My current
explanation for that BUG_ON is a race condition that comes
from concurrent calls to that function.

That is also the only explanation that makes sense because the
__write_console() function itself makes sure that the condition can not
hit.

In the comment for the n_tty_write function there is this remark:

 *      Locking: output_lock to protect column state and space left
 *               (note that the process_output*() functions take this
 *                lock themselves)

So the space left is managed in the ->write callback and needs
protection.

The process_output*() functions all (unless I am missing something)
take the output_lock before calling the tty->ops->write (directly or
indirectly).

The place I patched here is the only place in n_tty_write where the
->write call-back is invoked directly, and it happens without taking the
lock. I think this is a problem.


	Joerg


