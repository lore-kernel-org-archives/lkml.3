Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3F0CSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 22:18:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:8412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab3F0CSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 22:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,948,1363158000"; 
   d="scan'208";a="356386549"
Subject: Re: [PATCH] TTY: memory leakage in tty_buffer_find()
From: channing <chao.bi@intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
In-Reply-To: <51CAE1DD.8070301@hurleysoftware.com>
References: <1372236670.2390.12.camel@bichao>
	 <51CAE1DD.8070301@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jun 2013 10:37:18 +0800
Message-ID: <1372300638.2390.103.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 08:43 -0400, Peter Hurley wrote:
> On 06/26/2013 04:51 AM, channing wrote:
> >
> > In tty_buffer_find(), it scans all tty buffers in
> > free buffer queue, if it finds matched one,
> > tty->buf.free will point to matched one's next buffer,
> > so tty buffers that ahead of matched one are removed
> > from free queue, they will never be used but they
> > are not released, then memory leak happen.
> 
> Actually, the whole scan loop is wrong: only tty buffers of
> size 256 are added to the free list.
> 
Agree that currently all tty buffers of free list are with size
of 256, but are we sure that the scan loop in tty_buffer_find()
is wrong and should abandon? From the purpose of tty_buffer_find(), 
I understand it shall scan the free list, but now it doesn't make 
sense because tty_buffer_free() makes all the free list buffers
with size of 256:

tty_buffer_free()
{
	if (b->size >= 512)
		kfree(b);
}

I don't know why it's 512? looks like a hard configuration?
Can we make it configurable instead of a fixed value?

I understand, although no memory leak, there is logic mess between 
tty_buffer_find() and tty_buffer_free(), either one shall make 
change to keep accordance? 
which one to make change might depends on original purpose of 
creating the free list. I tried to find the history of tty_buffer_free(),
but "512" is here since 2.6.32.61, I didn't find older version.

> So this can't leak because a buffer will never be found
> mid-list.
> 
> Greg has a patch series from me that reduces this but it's not
> yet in next.
> 
> Regards,
> Peter Hurley
> 


