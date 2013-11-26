Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab3KZVy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 16:54:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab3KZVy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 16:54:56 -0500
Date: Tue, 26 Nov 2013 13:54:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Mayatskikh <v.mayatskih@gmail.com>
Subject: Re: copy_from_user_*() and buffer zeroing
Message-Id: <20131126135454.b5e9597a998509f1ab43cee4@linux-foundation.org>
In-Reply-To: <52950D7B.304@zytor.com>
References: <52950D7B.304@zytor.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013 13:07:07 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> I just started looking into the horribly confused state of buffer
> zeroing for the various copy_from_user variants.  This came up after we
> did some minor tuning last week.
> 
> copy_from_user_inatomic() seems to be documented to not zero the buffer.
>  This is definitely *NOT* true on x86-64, although it does seem to be
> true on i386 -- on x86-64, we carry along a "zerorest" flag but in all
> possible codepaths it will be set to true unless the remaining byte
> count is zero anyway.
> 
> Furthermore, on at least x86-64, if we do an early bailout, we don't
> zero the entire buffer in the case of a hard-coded 10- or 16-byte buffer
> (why only those sizes is anybody's guess.)  See lines 71-88 of uaccess_64.h.
> 
> I'd like to figure out what is the required and what is the desirable
> behavior here, and then fix the code accordingly.
> 

Nine years ago:

commit 7079f897164cb14f616c785d3d01629fd6a97719
Author: mingo <mingo>
Date:   Fri Aug 27 17:33:18 2004 +0000

    [PATCH] Add a few might_sleep() checks
    
    Add a whole bunch more might_sleep() checks.  We also enable might_sleep()
    checking in copy_*_user().  This was non-trivial because of the "copy_*_user()
    in atomic regions" trick would generate false positives.  Fix that up by
    adding a new __copy_*_user_inatomic(), which avoids the might_sleep() check.
    
    Only i386 is supported in this patch.


I can't think of any reason why __copy_from_user_inatomic() should be
non-zeroing.  But maybe I'm missing something - this would pretty
easily permit uninitialised data to appear in pagecache and someone
surely would have noticed..

