Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab3GZQrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:47:41 -0400
Received: from www.sr71.net ([198.145.64.142]:44727 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107Ab3GZQri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:47:38 -0400
Message-ID: <51F2A81E.5050500@sr71.net>
Date: Fri, 26 Jul 2013 09:47:26 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/2] vmsplice unmap gifted pages for recipient
References: <1374772906-21511-1-git-send-email-rcj@linux.vnet.ibm.com> <1374772906-21511-2-git-send-email-rcj@linux.vnet.ibm.com> <51F160A5.2040004@sr71.net> <20130726151621.GA5037@linux.vnet.ibm.com>
In-Reply-To: <20130726151621.GA5037@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 08:16 AM, Robert Jennings wrote:
>>> > > +				if ((spd->flags & SPLICE_F_MOVE) &&
>>> > > +				    !buf->offset && (buf->len == PAGE_SIZE))
>>> > > +					/* Can move page aligned buf */
>>> > > +					zap_buf_page(useraddr);
>>> > >  				buf->flags |= PIPE_BUF_FLAG_GIFT;
>>> > > +			}
>> > 
>> > There isn't quite enough context here, but is it going to do this
>> > zap_buf_page() very often?  Seems a bit wasteful to do the up/down and
>> > find_vma() every trip through the loop.
> The call to zap_buf_page() is in a loop where each pipe buffer is being
> processed, but in that loop we have a pipe_wait() where we schedule().
> So as things are structured I don't have the ability to hold mmap_sem
> for multiple find_vma() calls.

You can hold a semaphore over a schedule(). :)

You could also theoretically hold mmap_sem and only drop it on actual
cases when you reschedule if you were afraid of holding mmap_sem for
long periods of time (even though it's a read).


