Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935657Ab3DKNtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:49:19 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44153 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab3DKNtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:49:17 -0400
Date: Thu, 11 Apr 2013 15:49:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
Message-ID: <20130411134915.GH16732@two.firstfloor.org>
References: <51662D5B.3050001@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51662D5B.3050001@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As a result, if the dirty cache includes user data, the data is lost,
> and data corruption occurs if an application uses old data.

The application cannot use old data, the kernel code kills it if it
would do that. And if it's IO data there is an EIO triggered.

iirc the only concern in the past was that the application may miss
the asynchronous EIO because it's cleared on any fd access. 

This is a general problem not specific to memory error handling, 
as these asynchronous IO errors can happen due to other reason
(bad disk etc.) 

If you're really concerned about this case I think the solution
is to make the EIO more sticky so that there is a higher chance
than it gets returned.  This will make your data much more safe,
as it will cover all kinds of IO errors, not just the obscure memory
errors.

Or maybe have a panic knob on any IO error for any case if you don't
trust your application to check IO syscalls. But I would rather
have better EIO reporting than just giving up like this.

The problem of tying it just to any dirty data for memory errors
is that most anonymous data is dirty and it doesn't have this problem
at all (because the signals handle this and they cannot be lost)

And that is a far more common case than this relatively unlikely
case of dirty IO data.

So just doing it for "dirty" is not the right knob.

Basically I'm saying if you worry about unreliable IO error reporting
fix IO error reporting, don't add random unnecessary panics to
the memory error handling.

BTW my suspicion is that if you approach this from a data driven
perspective: that is measure how much such dirty data is typically
around in comparison to other data it will be unlikely. Such
a study can be done with the "page-types" program in tools/vm

-Andi
