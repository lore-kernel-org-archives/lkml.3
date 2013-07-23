Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394Ab3GWXxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:53:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab3GWXxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:53:53 -0400
Date: Tue, 23 Jul 2013 16:53:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2 00/16] lockless tty flip buffers
Message-ID: <20130723235352.GA25770@kroah.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 09:36:00AM -0400, Peter Hurley wrote:
> ** v2 changes **
> - Rebased on v4 of 'lockless n_tty receive path'
> 
> This 2nd of 4 patchsets implements lockless receive from the tty driver.
> By lockless, I'm referring to the 'lock' spin lock formerly used to
> serialize access to the flip buffer list.
> 
> Since the driver-side flip buffer usage is already single-threaded and
> line discipline receiving is already single-threaded, implementing
> a lockless flip buffer list was the primary hurdle. [The only 2 flip
> buffer consumers, flush_to_ldisc() and tty_buffer_flush() were already
> mutually exclusive and this exclusion remains although the mechanism
> is changed.]
> 
> Since the flip buffer consumers, flush_to_ldisc() and tty_buffer_flush(),
> already leave the last-consumed flip buffer on the list, and since the
> existing flip buffer api is already divided into an add/commit interface,
> most of the requirement for a lockless algorithm was already
> in-place. The main differences are;
> 1) the initial state of the flip buffer list points head and tail
>    to a 0-sized sentinel flip buffer. This eliminates head & tail NULL
>    testing and assigning the head ptr from the driver-side thread. This
>    sentinel is 'consumed' on the first iteration of ldisc receiving and
>    does not require special-case logic.
> 2) the free list uses the atomic singly-linked llist interface. While
>    this guarantees safe concurrent usage by both producer and consumer,
>    it's not optimal. Both producer and consumer unnecessarily contend
>    over the free list head ptr; a better approach would be to maintain
>    an unconsumed buffer in the same way the flip buffer list works.
>    Light testing has shown this contention accounts for roughly 5% of
>    total cpu time in end-to-end copying.
> 3) The mutual exclusion between consumers is reimplemented as a mutex;
>    this eliminates the need to drop the lock across the ldisc
>    receive_buf() method. This mutual exclusion is extended to a public
>    interface which the vt driver now uses to safely utilize the ldisc
>    receive_buf() interface when pasting a selection.

All applied, thanks.

greg k-h
