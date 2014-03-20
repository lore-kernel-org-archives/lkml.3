Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaCTCyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:54:14 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53186 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbaCTCyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:54:13 -0400
X-Sasl-enc: lWB5BPEXaF0HYGBI1hpk+L9u/QHM1F8UfFGSnf2WSwBn 1395284049
Date: Wed, 19 Mar 2014 19:55:30 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kristian =?iso-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>,
        john.stultz@linaro.org, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, dri-devel@lists.freedesktop.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
Message-ID: <20140320025530.GA25469@kroah.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 08:06:45PM +0100, David Herrmann wrote:
> Hi
> 
> This series introduces the concept of "file sealing". Sealing a file restricts
> the set of allowed operations on the file in question. Multiple seals are
> defined and each seal will cause a different set of operations to return EPERM
> if it is set. The following seals are introduced:
> 
>  * SEAL_SHRINK: If set, the inode size cannot be reduced
>  * SEAL_GROW: If set, the inode size cannot be increased
>  * SEAL_WRITE: If set, the file content cannot be modified
> 
> Unlike existing techniques that provide similar protection, sealing allows
> file-sharing without any trust-relationship. This is enforced by rejecting seal
> modifications if you don't own an exclusive reference to the given file. So if
> you own a file-descriptor, you can be sure that no-one besides you can modify
> the seals on the given file. This allows mapping shared files from untrusted
> parties without the fear of the file getting truncated or modified by an
> attacker.
> 
> Several use-cases exist that could make great use of sealing:
> 
>   1) Graphics Compositors
>      If a graphics client creates a memory-backed render-buffer and passes a
>      file-decsriptor to it to the graphics server for display, the server
>      _has_ to setup SIGBUS handlers whenever mapping the given file. Otherwise,
>      the client might run ftruncate() or O_TRUNC on the on file in parallel,
>      thus crashing the server.
>      With sealing, a compositor can reject any incoming file-descriptor that
>      does _not_ have SEAL_SHRINK set. This way, any memory-mappings are
>      guaranteed to stay accessible. Furthermore, we still allow clients to
>      increase the buffer-size in case they want to resize the render-buffer for
>      the next frame. We also allow parallel writes so the client can render new
>      frames into the same buffer (client is responsible of never rendering into
>      a front-buffer if you want to avoid artifacts).
> 
>      Real use-case: Wayland wl_shm buffers can be transparently converted

Very nice, the Enlightenment developers have been asking for something
like this for a while, it should help them out a lot as well.

And thanks for the man pages and test code, if only all new apis came
with that already...

greg k-h
