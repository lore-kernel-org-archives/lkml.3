Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbaD2Sfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:35:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:40158 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbaD2Sfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:35:38 -0400
Date: Tue, 29 Apr 2014 14:35:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Marian Marinov <mm@1h.com>
Cc: containers@lists.linux-foundation.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
Message-ID: <20140429183534.GB19325@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Marian Marinov <mm@1h.com>,
	containers@lists.linux-foundation.org,
	LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <535FADDA.2070803@1h.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535FADDA.2070803@1h.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 04:49:14PM +0300, Marian Marinov wrote:
> 
> I'm proposing a fix to this, by replacing the capable(CAP_LINUX_IMMUTABLE)
> check with ns_capable(current_cred()->user_ns, CAP_LINUX_IMMUTABLE).

Um, wouldn't it be better to simply fix the capable() function?

/**
 * capable - Determine if the current task has a superior capability in effect
 * @cap: The capability to be tested for
 *
 * Return true if the current task has the given superior capability currently
 * available for use, false if not.
 *
 * This sets PF_SUPERPRIV on the task if the capability is available on the
 * assumption that it's about to be used.
 */
bool capable(int cap)
{
	return ns_capable(&init_user_ns, cap);
}
EXPORT_SYMBOL(capable);

The documentation states that it is for "the current task", and I
can't imagine any use case, where user namespaces are in effect, where
using init_user_ns would ever make sense.

No?  Otherwise, pretty much every single use of capable() would be
broken, not just this once instances in ext4/ioctl.c.

					- Ted
